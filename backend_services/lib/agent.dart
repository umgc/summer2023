import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:backend_services/backend_services_exports.dart';
import 'package:backend_services/interfaces/json_storage.dart';
import 'package:backend_services/model/be_request.dart';
import 'package:backend_services/model/be_response.dart';
import 'package:backend_services/src/be-service/be_service.dart';
import 'package:backend_services/src/gpt-service/GptCalls.dart';
import 'package:backend_services/src/local-storage/index.dart';
import 'package:backend_services/src/websocket-client/websocket_client.dart';
import 'package:backend_services/src/websocket-client/websocket_listener.dart';
import 'package:collection/collection.dart';
import 'package:logger/logger.dart';

import 'interfaces/recording_selection_activator.dart';
import 'model/reminder.dart';
import 'model/user.dart';

// enum SortType { oldestFirst, newestFirst, aDescription, zDescription }

class Agent {
  String userId;
  final Logger _logger = Logger();
  String? profile = '';
  // late List<Conversation> recordingList = [];
  late List<Reminder> reminderList = [];
  late BEService _beService;

  WebSocketClient? _webSocketClient;
  late RecordingSelectionActivator? _recordingSelectionActivator;
  late final Directory _appDirectory;

  late final ConversationsProvider conversationsProvider;

  Agent(this.userId, Directory appDirectory) {
    _appDirectory = appDirectory;
    _beService = BEService(LocalStorageService(_appDirectory.path));
    conversationsProvider = ConversationsProvider(_appDirectory);
  }

  // RecordingSelectionActivator object with callback is required to initialize the Agent.
  // See the README.md for details.
  initialize(RecordingSelectionActivator recordingSelectionActivator) {
    setRecordingSelector(recordingSelectionActivator);

    List<WebSocketListener> listeners = [
      WebSocketListener(
          EnvironmentVars.formFillRequestTopic,
          (frame) =>
              _beService.handleRequestFrame(frame, receiveFormValuesRequest))
    ];
    _webSocketClient = WebSocketClient(EnvironmentVars.wsUrl,
        int.parse(EnvironmentVars.wsConnectionTimeoutMs), listeners);
    _webSocketClient!.connect();
  }

  setBeStorageService(JsonStorage storageService) {
    _beService = BEService(storageService);
  }

  shutdown() {
    _logger.i("Shutdown called on Agent");
    if (_webSocketClient != null) {
      _webSocketClient!.disconnect();
      _webSocketClient = null;
    }
  }

  void setRecordingSelector(
      RecordingSelectionActivator recordingSelectionActivator) {
    _recordingSelectionActivator = recordingSelectionActivator;
  }

  Future<File> get _remindersFile async {
    final path = _appDirectory.path;
    return File('$path/reminders.json');
  }

  Future<File> get _userFile async {
    final path = _appDirectory.path;
    return File('$path/user.json');
  }

  List<FileSystemEntity> listFilesInPath() {
    try {
      var dir = Directory(_appDirectory.path);
      var contents = dir.listSync(recursive: true, followLinks: true);
      return contents;
    } catch (e) {
      print(e);
      return [];
    }
  }

  void loadSampleConversations() {
    for (var convo in TestConversations.sampleConversations) {
      conversationsProvider.addConversation(convo);
    }
  }

  //#region User Profile

  String? getProfile() {
    return profile;
  }

  void setProfile(String newProfile) {
    profile = newProfile;
  }

  void writeUserToFile() async {
    //Write Data to file 'user.json'

    final File file = await _userFile;
    final String appCode = await _beService.loadAppInstanceCode();
    await file.writeAsString(json.encode(User(userId, appCode, profile)));
  }

  Future<User?> readUserFromFile() async {
    try {
      final file = await _userFile;
      // Read the file
      final fileContent = await file.readAsString();
      final userJson = jsonDecode(fileContent);
      final User userObject = User.fromJson(userJson);
      userId = userObject.userId;
      profile = userObject.profile;
      await _beService.saveAppInstanceCode(userObject.instanceCode);
      return userObject;
      //return fileContent;
    } catch (e) {
      print(e);
      return null;
    }
  }

  //#endregion

  //#region Browser Extension API

  Future<String> getInstanceCode() async {
    final instanceCode = await _beService.loadAppInstanceCode();
    if (instanceCode.isEmpty) {
      throw 'Instance code has not been initialized yet.';
    }
    return instanceCode;
  }

  Future<String> generateInstanceCodeIfNone() async {
    var appCode = await _beService.loadAppInstanceCode();

    if (appCode.isEmpty) {
      //Some code to generate a new InstanceCode
      final random = Random();
      final number = random.nextInt(9000) + 1000;
      appCode = number.toString().padLeft(4, '0');
      await _beService.saveAppInstanceCode(appCode);
    }

    return appCode;
  }

  Future<void> resetAppInstanceCode() async {
    await _beService.saveAppInstanceCode('');
  }

  Future<void> receiveFormValuesRequest(BERequest request) async {
    final appCode = await _beService.loadAppInstanceCode();
    if (request.pin != appCode) {
      _logger.i(
          "Ignoring browser extension request with pin of '${request.pin}'.");
      return;
    }
    _beService.storeRequest(request);

    // trigger recording selection UI
    var callback = _recordingSelectionActivator!.getSelectorCallback();
    return callback();
  }

  Future<void> extractFormValues(String recordingGuid) async {
    var request = _beService.getLastRequest();
    if (request == null) {
      throw "No request for form values has been received.";
    }

    final recordingTranscript = getRecordingTranscript(recordingGuid);

    // send to chatgpt
    final gpt = GptCalls(EnvironmentVars.openAIApiKey);
    final completion = await gpt.extractFormValuesFromTranscript(
        recordingTranscript,
        'This Profile',
        request.form); //Todo implement user profile argument if desired

    var json = jsonDecode(completion);
    _logger.d("Form filler completion JSON:\n$json");

    sendFormValueResponse(BEResponse(json));
  }

  String getRecordingTranscript(String recordingGuid) {
    var recording = conversationsProvider.conversations
        .firstWhereOrNull((rec) => rec.id == recordingGuid);
    if (recording == null) {
      throw "Recording with guid $recordingGuid not found.";
    }
    if (recording.transcript == "") {
      throw "Recording with guid $recordingGuid does not have a transcript.";
    }
    return recording.transcript;
  }

  void sendFormValueResponse(BEResponse response) {
    if (_webSocketClient != null) {
      _webSocketClient!
          .send(EnvironmentVars.formFillResponseTopic, jsonEncode(response));
    }
  }

  //#endregion
  /*
  void convertSpeechToText(String guid) {
    //send API call to STT provider, store results to Recording Object, save
  }

  String processFoodOrder(String guid) {
    //Send to ChatGPT, return a string
    return 'Hamburger';
  }

  String processReminders(String guid) {
    //Send to ChatGPT, create reminders, return a string to UI
    return 'Lunch 1200 Wednesday, Birthday party 1000 Saturday';
  }
  */

  List<Conversation> globalSearch(String searchTerm) {
    //Search recordings, return subset of recordings to UI based on search term
    return conversationsProvider.conversations;
  }

  List<Reminder> getReminders() {
    //return reminders
    return reminderList;
  }

  void deleteReminder(int reminderId) {
    //delete a reminder from list and from file storage
  }

  void addReminder(Reminder newReminder) {
    //add a reminder to the list and file storage
  }

  void loadSampleReminderData() async {
    //Generate sample reminder data from literals

    //Sample Data
    Reminder reminder1 = Reminder(1, DateTime.now().add(-Duration(hours: 1)),
        DateTime.now().add(Duration(hours: 1)), 'Description A', 'User');
    Reminder reminder2 = Reminder(2, DateTime.now().add(-Duration(hours: 4)),
        DateTime.now().add(Duration(hours: 4)), 'Description B', 'User');
    Reminder reminder3 = Reminder(3, DateTime.now().add(-Duration(hours: 34)),
        DateTime.now().add(Duration(hours: 36)), 'Description C', 'User');
    Reminder reminder4 = Reminder(4, DateTime.now().add(-Duration(hours: 72)),
        DateTime.now().add(Duration(hours: 72)), 'Description D', 'User');
    Reminder reminder5 = Reminder(5, DateTime.now().add(-Duration(hours: 168)),
        DateTime.now().add(Duration(hours: 168)), 'Description E', 'User');
    List<Reminder> sampleReminderList = [
      reminder1,
      reminder2,
      reminder3,
      reminder4,
      reminder5
    ];

    reminderList = sampleReminderList;
  }

  void writeRemindersToFile() async {
    //Write List to file 'reminders.json'

    final File file = await _remindersFile;
    await file.writeAsString(json.encode(reminderList));
  }

  Future<List<Reminder>> readRemindersFile() async {
    try {
      final file = await _remindersFile;
      // Read the file
      final fileContent = await file.readAsString();
      var reminderObjectsJson = jsonDecode(fileContent) as List;
      List<Reminder> reminderList = reminderObjectsJson
          .map((reminderJson) => Reminder.fromJson(reminderJson))
          .toList();
      this.reminderList = reminderList;
      return reminderList;
      //return fileContent;
    } catch (e) {
      print(e);
      return [];
    }
  }

  Future<String?> readRemindersFileJSON() async {
    try {
      final file = await _remindersFile;
      // Read the file
      final fileContent = await file.readAsString();
      return fileContent;
    } catch (e) {
      print(e);
      return '';
    }
  }

  Future<String?> getOpenAiSummary(String guid) async {
    String requestTranscript = getRecordingTranscript(guid);

    GptCalls newGpt = GptCalls(EnvironmentVars.openAIApiKey);
    final completion = await newGpt.getOpenAiSummary(requestTranscript,
        'This Profile'); //Todo implement user profile argument if desired

    //Todo parse this output "content: <THIS_IS_THE_INTERESTING_CONTENT>, ), finishReason: stop)"

    //Todo save this GPT Summary to recording and write to file - call method with GUID and GPTsummary arguments

    return completion;
  }
}
