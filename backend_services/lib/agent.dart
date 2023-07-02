import 'dart:io';
import 'dart:convert';
import 'model/recording.dart';
import 'model/reminder.dart';
import 'model/user.dart';
import 'package:path_provider/path_provider.dart';



enum SortType { oldestFirst, newestFirst, aDescription, zDescription }

class Agent {
  final String userId;
  String _instanceCode = '';
  late String? profile;
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

  }
