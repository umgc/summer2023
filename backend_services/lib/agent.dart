import 'dart:convert';
import 'dart:io';

import 'package:backend_services/model/be_request.dart';
import 'package:backend_services/model/be_response.dart';
import 'package:backend_services/src/be-service/be_service.dart';
import 'package:backend_services/src/environment_vars.dart';
import 'package:backend_services/src/gpt-service/GptCalls.dart';
import 'package:backend_services/src/state-management/conversations_provider.dart';
import 'package:backend_services/src/websocket-client/websocket_client.dart';
import 'package:backend_services/src/websocket-client/websocket_listener.dart';
import 'package:collection/collection.dart';
import 'package:logger/logger.dart';

import 'interfaces/recording_selection_activator.dart';
import 'model/conversation.dart';
import 'model/reminder.dart';

// enum SortType { oldestFirst, newestFirst, aDescription, zDescription }

class Agent {
  final String userId;
  String _instanceCode = '';
  final Logger _logger = Logger();
  late String? profile;
  late String? browserRequest;
  // late List<Conversation> recordingList = [];
  late List<Reminder> reminderList = [];
  final BEService _beService = BEService();

  WebSocketClient? _webSocketClient;
  late RecordingSelectionActivator? _recordingSelectionActivator;
  late final Directory _appDirectory;

  late final ConversationsProvider conversationsProvider;

  Agent(this.userId, Directory appDirectory) {
    _appDirectory = appDirectory;
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

  // Future<File> getRecordingFile(String guid) async {
  //   final path = path_package.join(await _directoryPath, '${guid}.json');
  //   return File(path);
  // }

  Future<List> listFilesInPath() async {
    try {
      var dir = Directory(_appDirectory.path);
      List contents = await dir.listSync(recursive: true, followLinks: true);
      return contents;
    } catch (e) {
      print(e);
      return [];
    }
  }

  //#region User Profile

  String? getProfile() {
    return profile;
  }

  void setProfile(String newProfile) {
    profile = newProfile;
  }

  void writeUserToFile() {
    //;
  }

  Future<String?> readUserFromFile() async {
    //;
    return '';
  }

  //#endregion

  //#region Browser Extension API

  String getInstanceCode() {
    if (_instanceCode.isEmpty) {
      throw 'Instance code has not been initialized yet.';
    }
    return _instanceCode;
  }

  String generateInstanceCode() {
    //Some code to generate a new InstanceCode
    _instanceCode = '8736';
    return _instanceCode;
  }

  Future<void> receiveFormValuesRequest(BERequest request) async {
    if (request.pin != _instanceCode) {
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

  // String createRecording(String filename) {
  //   //Insantiate a new recording object given a particular file
  //   //generate a new GUID
  //   String guid = 'abc37428-e345-492f-8a32-bbbb183d763f';
  //   return guid;
  // }

  // List<Conversation> listRecordings(String sortOption) {
  //   //sort based on sort type, return full list of recording objects
  //   return recordingList;
  // }

  // void deleteRecording(String guid) {
  //   //Delete recording from memory and filesystem
  //   // Use the guid to identify the recording in question and the filepath to it and remove it from the system
  //   var recordingFile = File('/path/to/recording/guid.json');
  //   if (recordingFile.existsSync()) {
  //     var content = recordingFile.readAsStringSync();
  //     if (content.contains(guid)) {
  //       recordingFile.deleteSync();
  //     } else {
  //       print('Not the right recording');
  //     }
  //   } else {
  //     print('Recording file does not exist');
  //   }
  // }

  // List<Conversation> searchRecordings(String searchTerm) {
  //   //Search through recordings, return subset of recording objects
  //   return recordingList;
  // }

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

  //To Do: set up file IO for loading recording and reminder JSON from file/save to file

  // Future<String> writeRecordingsToFile() async {
  //   //Writes all data stored in recordingList to individual files named <guid>.json

  //   for (Conversation rec in recordingList) {
  //     //Iterate over list of all recordings and write
  //     var file = await getRecordingFile(rec.id);
  //     await file.writeAsString(json.encode(rec));
  //   }
  //   return recordingList.toString();
  // }

  void loadSampleReminderData() async {
    //Generate sample reminder data from literals

    //Sample Data
    Reminder reminder1 = Reminder(1, 1, 1, 'Description A', 'User');
    Reminder reminder2 = Reminder(2, 1, 1, 'Description B', 'User');
    Reminder reminder3 = Reminder(3, 1, 1, 'Description C', 'User');
    Reminder reminder4 = Reminder(4, 1, 1, 'Description D', 'User');
    Reminder reminder5 = Reminder(5, 1, 1, 'Description E', 'User');
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

  // Future<String?> readRecordingsFile() async {
  //   List<Conversation> newRecordingList = [];
  //   List allFiles = await listFilesInPath();
  //   //Obtain a list of Valid GUID.json recording values - length == 41
  //   //Perform logic to split paths using slash / and look for results of proper length
  //   List validRecordingFiles = [];
  //   for (var filePath in allFiles) {
  //     var fileComponents = filePath.toString().split('/');
  //     for (String subString in fileComponents) {
  //       if (subString.toString().length == 42) {
  //         // Look for length 42 - includes trailing quote
  //         //Drop trailing quote character
  //         validRecordingFiles.add(subString.toString().substring(0, 41));
  //       }
  //     }
  //   }
  //
  //   //Loop over valid JSON files, read, append
  //   //String returnValue = '';
  //   for (String jsonFile in validRecordingFiles) {
  //     try {
  //       final file =
  //           await getRecordingFile(jsonFile.toString().substring(0, 36));
  //       final fileContent = await file.readAsString();
  //       newRecordingList.add(Conversation.fromJson(jsonDecode(fileContent)));
  //     } catch (e) {
  //       print(e);
  //     }
  //   }
  //   this.recordingList = newRecordingList;

  //   return recordingList.toString();
  // }

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
