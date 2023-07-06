import 'dart:io';
import 'dart:convert';
import 'recording.dart';
import 'reminder.dart';

List<Recording> recordings = [];

enum SortType { oldestFirst, newestFirst, aDescription, zDescription }

class Agent {
  final String userId;
  String _instanceCode = '';
  late String profile;
  late List<Recording> recordingList;
  late List<Reminder> reminderList;

  Agent(this.userId);

  String getProfile() {
    return this.profile;
  }

  void setProfile(String newProfile) {
    profile = newProfile;
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
    var recordingFile = File('/path/to/recording/' + guid + '.json');
    var recordingAudio = File('/path/to/recording/' + guid + '.m4a');
    if (recordingFile.existsSync()){
        var content = recordingFile.readAsStringSync();
        if (content.contains(guid)) {
            recordingFile.deleteSync();
            recordingAudio.deleteSync();
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
    var reminderFile('/path/to/recording/' + reminderId + '.json')
    if (reminderFile.existsSync()){
      var content = reminderFile.readAsStringSync();
      if (content.contains(reminderId) {
        recordingFile.deleteSync();
      }  else{
        print('Not the right reminder.');
      }
    } else {
      print('Reminder file does not exist');
    }

  }

  void addReminder(Reminder newReminder) {
    //add a reminder to the list and file storage
  }

  //To Do: set up file IO for loading recording and reminder JSON from file/save to file

  void writeRemindersToFile() {
    //write list of reminders to local file
    final File reminderFile = File('/path/reminders.json'); //load JSON File
    //await readReminderData(reminderFile); //read data from json

    reminderList //convert list data  to json
        .map(
          (reminder) => reminder.toJson(),
        )
        .toList();

    reminderFile.writeAsStringSync(
        json.encode(reminderList)); //write (the whole list) to json file
  }
}
