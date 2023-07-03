import 'dart:io';
import 'dart:convert';
import 'model/recording.dart';
import 'model/reminder.dart';
import 'package:uuid/uuid.dart';
import 'package:path/path.dart' as Path;
import 'model/user.dart';
import 'package:path_provider/path_provider.dart';



enum SortType { oldestFirst, newestFirst, aDescription, zDescription }

extension E on String {
  String lastChars(int n) => substring(length - n);
}

class Agent {
  final String userId;
  String _instanceCode = '';
  late String? profile;
  late String? browserRequest;
  late List<Recording> recordingList = [];
  late List<Reminder> reminderList = [];

  Agent(this.userId);

  Future<String> get _directoryPath async {
    Directory directory = Platform.isAndroid
        ? await getApplicationSupportDirectory() //Should be universal? https://pub.dev/packages/path_provider
        : await getApplicationDocumentsDirectory(); //For IOS
    return directory.path;
  }

  Future<File> get _remindersFile async {
  final path = await _directoryPath;
  return File('$path/reminders.json');
  }

  Future<File> getRecordingFile(String guid) async {
  final path = Path.join(await _directoryPath, '${guid}.json');
  return File(path);
  }

  Future<List> listFilesInPath() async {
    try {
    var dir = new Directory(await _directoryPath);
    List contents = await dir.listSync(recursive: true, followLinks: true);
    return contents;
    } catch (e) {
        print(e);
        return [];
      }
  }

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

  String createRecording(String filename) {
    //Insantiate a new recording object given a particular file
    //generate a new GUID
    String guid = 'abc37428-e345-492f-8a32-bbbb183d763f';
    return guid;
  }

  List<Recording> listRecordings(String sortOption) {
    //sort based on sort type, return full list of recording objects
    return recordingList;
  }

  void deleteRecording(String guid) {
    //Delete recording from memory and filesystem
    // Use the guid to identify the recording in question and the filepath to it and remove it from the system
    var recordingFile = File('/path/to/recording/guid.json');
    if (recordingFile.existsSync()){
        var content = recordingFile.readAsStringSync();
        if (content.contains(guid)) {
            recordingFile.deleteSync();
        }  else{
        print('Not the right recording');
        }
    } else {
      print('Recording file does not exist');
      }
  }

  List<Recording> searchRecordings(String searchTerm) {
    //Search through recordings, return subset of recording objects
    return recordingList;
  }

  void convertSpeechToText(String guid) {
    //send API call to STT provider, store results to Recording Object, save
  }

  Map<String, String> extractFormValues(String instanceCode, List formFields) {
    //send to chatgpt
    return <String, String>{};
  }

  String processFoodOrder(String guid) {
    //Send to ChatGPT, return a string
    return 'Hamburger';
  }

  String processReminders(String guid) {
    //Send to ChatGPT, create reminders, return a string to UI
    return 'Lunch 1200 Wednesday, Birthday party 1000 Saturday';
  }

  List<Recording> globalSearch(String searchTerm) {
    //Search recordings, return subset of recordings to UI based on search term
    return recordingList;
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

  Future<String> writeRecordingsToFile() async {

    //Sample Data
    
    Recording recording1 = Recording('c74dcec0-6fb7-45a9-98da-472e13413dd8', 1, 'path', 'asdf', 'Description B', 'Description', 'User', 'location');
    Recording recording2 = Recording('0a60bf00-a057-4ad7-87fd-534c7d407160', 2, 'path', 'asdf', 'Description B', 'Description', 'User', 'location');
    Recording recording3 = Recording('e3bc7acc-3b20-4056-94b6-6199fdba5870', 3, 'path', 'asdf', 'Description C', 'Description', 'User', 'location');
    Recording recording4 = Recording('866731c8-a9cd-408c-ae04-886f31a42493', 4, 'path', 'asdf', 'Description D', 'Description', 'User', 'location');
    Recording recording5 = Recording('e7cb2be9-75f2-44a0-9976-df7dfc0e1363', 5, 'path', 'asdf', 'Description E', 'Description', 'User', 'location');
    List<Recording> sampleRecordingList = [];
    sampleRecordingList.add(recording1);
    sampleRecordingList.add(recording2);
    sampleRecordingList.add(recording3);
    sampleRecordingList.add(recording4);
    sampleRecordingList.add(recording5);

    for (Recording rec in sampleRecordingList) {
    var file = await getRecordingFile(rec.guid);
    await file.writeAsString(json.encode(rec));
    }

    return sampleRecordingList.toString();

  }


  void writeRemindersToFile() async {

    //Sample Data
    Reminder reminder1 = Reminder(1, 1, 1, 'Description A', 'User');
    Reminder reminder2 = Reminder(2, 1, 1, 'Description B', 'User');
    Reminder reminder3 = Reminder(3, 1, 1, 'Description C', 'User');
    Reminder reminder4 = Reminder(4, 1, 1, 'Description D', 'User');
    Reminder reminder5 = Reminder(5, 1, 1, 'Description E', 'User');
    List<Reminder> reminderList = [];
    reminderList.add(reminder1);
    reminderList.add(reminder2);
    reminderList.add(reminder3);
    reminderList.add(reminder4);
    reminderList.add(reminder5);
    final File file = await _remindersFile;
    await file.writeAsString(json.encode(reminderList));
  }

  

  Future<List<Reminder>> readRemindersFile() async {
  try {
  final file = await _remindersFile;
  // Read the file
  final fileContent = await file.readAsString();
  var reminderObjectsJson = jsonDecode(fileContent!) as List;
    List<Reminder> reminderList = reminderObjectsJson.map((reminderJson) => Reminder.fromJson(reminderJson)).toList();
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

  Future<String?> readRecordingsFile() async {
  List<Recording> newRecordingList = [];
  List allFiles = await listFilesInPath();
  //Obtain a list of Valid GUID.json recording values - length == 41
  //Perform logic to split paths using slash / and look for results of proper length
  List validRecordingFiles = [];
  for (var filePath in allFiles) {
    var fileComponents = filePath.toString().split('/');
    for (String subString in fileComponents){
      if (subString.toString().length == 42) { // Look for length 42 - includes trailing quote
        //Drop trailing quote character
        validRecordingFiles.add(subString.toString().substring(0, 41));
      }
    }
  }

  //Loop over valid JSON files, read, append
  //String returnValue = '';
  for (String jsonFile in validRecordingFiles) {
    try {
      final file = await getRecordingFile(jsonFile.toString().substring(0, 36));
      final fileContent = await file.readAsString();
      newRecordingList.add(Recording.fromJson(jsonDecode(fileContent)));
    } catch (e) {
      print (e);
    }


  }
    this.recordingList = newRecordingList;

    return recordingList.toString();

    }

  }
