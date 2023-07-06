import 'dart:io';
import 'dart:convert';
import 'package:backend_services/src/recording-service/GptCalls.dart';

import 'model/recording.dart';
import 'model/reminder.dart';
import 'package:uuid/uuid.dart';
import 'package:path/path.dart' as Path;
import 'model/user.dart';
import 'package:path_provider/path_provider.dart';



enum SortType { oldestFirst, newestFirst, aDescription, zDescription }

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
<<<<<<< Updated upstream
    var recordingFile = File('/path/to/recording/guid.json');
    if (recordingFile.existsSync()){
        var content = recordingFile.readAsStringSync();
        if (content.contains(guid)) {
            recordingFile.deleteSync();
        }  else{
=======
    var recordingFile = getRecordingFile(guid);
    if (recordingFile.existsSync()) {
      var content = recordingFile.readAsStringSync();
      if (content.contains(guid)) {
        recordingFile.deleteSync();
      } else {
>>>>>>> Stashed changes
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

  Future<String> loadSampleRecordingData() async {

    //Sample Data - Method will load literals into memory as recordingFile

        String transcript1 = """{"jobName":"test-interview-sample","accountId":"375374704108","results":{"transcripts":[{"transcript":"Hey, but I'm going into this very humble, smart, smart, I mean, I don't think I have that high of a pain tolerance. Well, I guess we'll find out today. Are you ready to get started? Yeah. Sure. Oh, we're going right to the left. Yeah, that's very important. Ok."}],"speaker_labels":{"channel_label":"ch_0","speakers":2,"segments":[{"start_time":"0.0","speaker_label":"spk_0","end_time":"7.71","items":[{"start_time":"0.009","speaker_label":"spk_0","end_time":"0.579"},{"start_time":"0.589","speaker_label":"spk_0","end_time":"0.8"},{"start_time":"0.81","speaker_label":"spk_0","end_time":"0.99"},{"start_time":"1.0","speaker_label":"spk_0","end_time":"1.269"},{"start_time":"1.279","speaker_label":"spk_0","end_time":"1.46"},{"start_time":"1.47","speaker_label":"spk_0","end_time":"1.779"},{"start_time":"1.789","speaker_label":"spk_0","end_time":"2.569"},{"start_time":"2.579","speaker_label":"spk_0","end_time":"3.24"},{"start_time":"3.349","speaker_label":"spk_0","end_time":"4.119"},{"start_time":"4.13","speaker_label":"spk_0","end_time":"4.78"},{"start_time":"5.07","speaker_label":"spk_0","end_time":"5.619"},{"start_time":"5.63","speaker_label":"spk_0","end_time":"6.07"},{"start_time":"6.079","speaker_label":"spk_0","end_time":"6.09"},{"start_time":"6.099","speaker_label":"spk_0","end_time":"6.309"},{"start_time":"6.32","speaker_label":"spk_0","end_time":"6.429"},{"start_time":"6.44","speaker_label":"spk_0","end_time":"6.449"},{"start_time":"6.46","speaker_label":"spk_0","end_time":"6.769"},{"start_time":"6.78","speaker_label":"spk_0","end_time":"7.079"},{"start_time":"7.09","speaker_label":"spk_0","end_time":"7.289"},{"start_time":"7.3","speaker_label":"spk_0","end_time":"7.46"},{"start_time":"7.469","speaker_label":"spk_0","end_time":"7.48"},{"start_time":"7.489","speaker_label":"spk_0","end_time":"7.71"}]},{"start_time":"7.719","speaker_label":"spk_1","end_time":"11.939","items":[{"start_time":"7.719","speaker_label":"spk_1","end_time":"8.329"},{"start_time":"8.56","speaker_label":"spk_1","end_time":"8.77"},{"start_time":"8.779","speaker_label":"spk_1","end_time":"8.8"},{"start_time":"8.81","speaker_label":"spk_1","end_time":"9.05"},{"start_time":"9.06","speaker_label":"spk_1","end_time":"9.25"},{"start_time":"9.26","speaker_label":"spk_1","end_time":"9.56"},{"start_time":"9.569","speaker_label":"spk_1","end_time":"9.789"},{"start_time":"9.8","speaker_label":"spk_1","end_time":"10.34"},{"start_time":"10.35","speaker_label":"spk_1","end_time":"10.77"},{"start_time":"10.779","speaker_label":"spk_1","end_time":"10.85"},{"start_time":"10.859","speaker_label":"spk_1","end_time":"11.069"},{"start_time":"11.079","speaker_label":"spk_1","end_time":"11.149"},{"start_time":"11.159","speaker_label":"spk_1","end_time":"11.31"},{"start_time":"11.319","speaker_label":"spk_1","end_time":"11.939"}]},{"start_time":"11.949","speaker_label":"spk_0","end_time":"12.829","items":[{"start_time":"11.949","speaker_label":"spk_0","end_time":"12.119"},{"start_time":"12.13","speaker_label":"spk_0","end_time":"12.739"}]},{"start_time":"20.079","speaker_label":"spk_0","end_time":"21.12","items":[{"start_time":"20.09","speaker_label":"spk_0","end_time":"20.139"},{"start_time":"20.149","speaker_label":"spk_0","end_time":"20.409"},{"start_time":"20.42","speaker_label":"spk_0","end_time":"20.7"},{"start_time":"20.709","speaker_label":"spk_0","end_time":"20.959"},{"start_time":"20.969","speaker_label":"spk_0","end_time":"21.12"}]},{"start_time":"21.129","speaker_label":"spk_1","end_time":"22.84","items":[{"start_time":"21.129","speaker_label":"spk_1","end_time":"21.149"},{"start_time":"21.159","speaker_label":"spk_1","end_time":"21.579"},{"start_time":"21.59","speaker_label":"spk_1","end_time":"21.729"},{"start_time":"21.739","speaker_label":"spk_1","end_time":"21.969"},{"start_time":"21.979","speaker_label":"spk_1","end_time":"22.19"},{"start_time":"22.2","speaker_label":"spk_1","end_time":"22.84"}]},{"start_time":"24.77","speaker_label":"spk_0","end_time":"25.35","items":[{"start_time":"24.77","speaker_label":"spk_0","end_time":"25.25"}]}]},"items":[{"start_time":"0.009","speaker_label":"spk_0","end_time":"0.579","alternatives":[{"confidence":"0.995","content":"Hey"}],"type":"pronunciation"},{"speaker_label":"spk_0","alternatives":[{"confidence":"0.0","content":","}],"type":"punctuation"},{"start_time":"0.589","speaker_label":"spk_0","end_time":"0.8","alternatives":[{"confidence":"0.997","content":"but"}],"type":"pronunciation"},{"start_time":"0.81","speaker_label":"spk_0","end_time":"0.99","alternatives":[{"confidence":"0.997","content":"I'm"}],"type":"pronunciation"},{"start_time":"1.0","speaker_label":"spk_0","end_time":"1.269","alternatives":[{"confidence":"0.999","content":"going"}],"type":"pronunciation"},{"start_time":"1.279","speaker_label":"spk_0","end_time":"1.46","alternatives":[{"confidence":"0.997","content":"into"}],"type":"pronunciation"},{"start_time":"1.47","speaker_label":"spk_0","end_time":"1.779","alternatives":[{"confidence":"0.997","content":"this"}],"type":"pronunciation"},{"start_time":"1.789","speaker_label":"spk_0","end_time":"2.569","alternatives":[{"confidence":"0.997","content":"very"}],"type":"pronunciation"},{"start_time":"2.579","speaker_label":"spk_0","end_time":"3.24","alternatives":[{"confidence":"0.997","content":"humble"}],"type":"pronunciation"},{"speaker_label":"spk_0","alternatives":[{"confidence":"0.0","content":","}],"type":"punctuation"},{"start_time":"3.349","speaker_label":"spk_0","end_time":"4.119","alternatives":[{"confidence":"0.998","content":"smart"}],"type":"pronunciation"},{"speaker_label":"spk_0","alternatives":[{"confidence":"0.0","content":","}],"type":"punctuation"},{"start_time":"4.13","speaker_label":"spk_0","end_time":"4.78","alternatives":[{"confidence":"0.998","content":"smart"}],"type":"pronunciation"},{"speaker_label":"spk_0","alternatives":[{"confidence":"0.0","content":","}],"type":"punctuation"},{"start_time":"5.07","speaker_label":"spk_0","end_time":"5.619","alternatives":[{"confidence":"0.507","content":"I"}],"type":"pronunciation"},{"start_time":"5.63","speaker_label":"spk_0","end_time":"6.07","alternatives":[{"confidence":"0.997","content":"mean"}],"type":"pronunciation"},{"speaker_label":"spk_0","alternatives":[{"confidence":"0.0","content":","}],"type":"punctuation"},{"start_time":"6.079","speaker_label":"spk_0","end_time":"6.09","alternatives":[{"confidence":"0.998","content":"I"}],"type":"pronunciation"},{"start_time":"6.099","speaker_label":"spk_0","end_time":"6.309","alternatives":[{"confidence":"0.998","content":"don't"}],"type":"pronunciation"},{"start_time":"6.32","speaker_label":"spk_0","end_time":"6.429","alternatives":[{"confidence":"0.999","content":"think"}],"type":"pronunciation"},{"start_time":"6.44","speaker_label":"spk_0","end_time":"6.449","alternatives":[{"confidence":"0.999","content":"I"}],"type":"pronunciation"},{"start_time":"6.46","speaker_label":"spk_0","end_time":"6.769","alternatives":[{"confidence":"0.998","content":"have"}],"type":"pronunciation"},{"start_time":"6.78","speaker_label":"spk_0","end_time":"7.079","alternatives":[{"confidence":"0.998","content":"that"}],"type":"pronunciation"},{"start_time":"7.09","speaker_label":"spk_0","end_time":"7.289","alternatives":[{"confidence":"0.996","content":"high"}],"type":"pronunciation"},{"start_time":"7.3","speaker_label":"spk_0","end_time":"7.46","alternatives":[{"confidence":"0.996","content":"of"}],"type":"pronunciation"},{"start_time":"7.469","speaker_label":"spk_0","end_time":"7.48","alternatives":[{"confidence":"0.996","content":"a"}],"type":"pronunciation"},{"start_time":"7.489","speaker_label":"spk_0","end_time":"7.71","alternatives":[{"confidence":"0.995","content":"pain"}],"type":"pronunciation"},{"start_time":"7.719","speaker_label":"spk_1","end_time":"8.329","alternatives":[{"confidence":"0.996","content":"tolerance"}],"type":"pronunciation"},{"speaker_label":"spk_1","alternatives":[{"confidence":"0.0","content":"."}],"type":"punctuation"},{"start_time":"8.56","speaker_label":"spk_1","end_time":"8.77","alternatives":[{"confidence":"0.995","content":"Well"}],"type":"pronunciation"},{"speaker_label":"spk_1","alternatives":[{"confidence":"0.0","content":","}],"type":"punctuation"},{"start_time":"8.779","speaker_label":"spk_1","end_time":"8.8","alternatives":[{"confidence":"0.998","content":"I"}],"type":"pronunciation"},{"start_time":"8.81","speaker_label":"spk_1","end_time":"9.05","alternatives":[{"confidence":"0.999","content":"guess"}],"type":"pronunciation"},{"start_time":"9.06","speaker_label":"spk_1","end_time":"9.25","alternatives":[{"confidence":"0.996","content":"we'll"}],"type":"pronunciation"},{"start_time":"9.26","speaker_label":"spk_1","end_time":"9.56","alternatives":[{"confidence":"0.999","content":"find"}],"type":"pronunciation"},{"start_time":"9.569","speaker_label":"spk_1","end_time":"9.789","alternatives":[{"confidence":"0.999","content":"out"}],"type":"pronunciation"},{"start_time":"9.8","speaker_label":"spk_1","end_time":"10.34","alternatives":[{"confidence":"0.998","content":"today"}],"type":"pronunciation"},{"speaker_label":"spk_1","alternatives":[{"confidence":"0.0","content":"."}],"type":"punctuation"},{"start_time":"10.35","speaker_label":"spk_1","end_time":"10.77","alternatives":[{"confidence":"0.996","content":"Are"}],"type":"pronunciation"},{"start_time":"10.779","speaker_label":"spk_1","end_time":"10.85","alternatives":[{"confidence":"0.997","content":"you"}],"type":"pronunciation"},{"start_time":"10.859","speaker_label":"spk_1","end_time":"11.069","alternatives":[{"confidence":"0.999","content":"ready"}],"type":"pronunciation"},{"start_time":"11.079","speaker_label":"spk_1","end_time":"11.149","alternatives":[{"confidence":"0.997","content":"to"}],"type":"pronunciation"},{"start_time":"11.159","speaker_label":"spk_1","end_time":"11.31","alternatives":[{"confidence":"0.999","content":"get"}],"type":"pronunciation"},{"start_time":"11.319","speaker_label":"spk_1","end_time":"11.939","alternatives":[{"confidence":"0.999","content":"started"}],"type":"pronunciation"},{"speaker_label":"spk_1","alternatives":[{"confidence":"0.0","content":"?"}],"type":"punctuation"},{"start_time":"11.949","speaker_label":"spk_0","end_time":"12.119","alternatives":[{"confidence":"0.974","content":"Yeah"}],"type":"pronunciation"},{"speaker_label":"spk_0","alternatives":[{"confidence":"0.0","content":"."}],"type":"punctuation"},{"start_time":"12.13","speaker_label":"spk_0","end_time":"12.739","alternatives":[{"confidence":"0.995","content":"Sure"}],"type":"pronunciation"},{"speaker_label":"spk_0","alternatives":[{"confidence":"0.0","content":"."}],"type":"punctuation"},{"start_time":"20.09","speaker_label":"spk_0","end_time":"20.139","alternatives":[{"confidence":"0.918","content":"Oh"}],"type":"pronunciation"},{"speaker_label":"spk_0","alternatives":[{"confidence":"0.0","content":","}],"type":"punctuation"},{"start_time":"20.149","speaker_label":"spk_0","end_time":"20.409","alternatives":[{"confidence":"0.985","content":"we're"}],"type":"pronunciation"},{"start_time":"20.42","speaker_label":"spk_0","end_time":"20.7","alternatives":[{"confidence":"0.996","content":"going"}],"type":"pronunciation"},{"start_time":"20.709","speaker_label":"spk_0","end_time":"20.959","alternatives":[{"confidence":"0.996","content":"right"}],"type":"pronunciation"},{"start_time":"20.969","speaker_label":"spk_0","end_time":"21.12","alternatives":[{"confidence":"0.996","content":"to"}],"type":"pronunciation"},{"start_time":"21.129","speaker_label":"spk_1","end_time":"21.149","alternatives":[{"confidence":"0.461","content":"the"}],"type":"pronunciation"},{"start_time":"21.159","speaker_label":"spk_1","end_time":"21.579","alternatives":[{"confidence":"0.995","content":"left"}],"type":"pronunciation"},{"speaker_label":"spk_1","alternatives":[{"confidence":"0.0","content":"."}],"type":"punctuation"},{"start_time":"21.59","speaker_label":"spk_1","end_time":"21.729","alternatives":[{"confidence":"0.995","content":"Yeah"}],"type":"pronunciation"},{"speaker_label":"spk_1","alternatives":[{"confidence":"0.0","content":","}],"type":"punctuation"},{"start_time":"21.739","speaker_label":"spk_1","end_time":"21.969","alternatives":[{"confidence":"0.99","content":"that's"}],"type":"pronunciation"},{"start_time":"21.979","speaker_label":"spk_1","end_time":"22.19","alternatives":[{"confidence":"0.995","content":"very"}],"type":"pronunciation"},{"start_time":"22.2","speaker_label":"spk_1","end_time":"22.84","alternatives":[{"confidence":"0.996","content":"important"}],"type":"pronunciation"},{"speaker_label":"spk_1","alternatives":[{"confidence":"0.0","content":"."}],"type":"punctuation"},{"start_time":"24.77","speaker_label":"spk_0","end_time":"25.25","alternatives":[{"confidence":"0.99","content":"Ok"}],"type":"pronunciation"},{"speaker_label":"spk_0","alternatives":[{"confidence":"0.0","content":"."}],"type":"punctuation"}]},"status":"COMPLETED"}""";



    Recording recording1 = Recording('c74dcec0-6fb7-45a9-98da-472e13413dd8', 1, 'path', transcript1, 'Description B', 'Description', 'User', 'location');
    Recording recording2 = Recording('0a60bf00-a057-4ad7-87fd-534c7d407160', 2, 'path', 'asdf', 'Description B', 'Description', 'User', 'location');
    Recording recording3 = Recording('e3bc7acc-3b20-4056-94b6-6199fdba5870', 3, 'path', 'asdf', 'Description C', 'Description', 'User', 'location');
    Recording recording4 = Recording('866731c8-a9cd-408c-ae04-886f31a42493', 4, 'path', 'asdf', 'Description D', 'Description', 'User', 'location');
    Recording recording5 = Recording('e7cb2be9-75f2-44a0-9976-df7dfc0e1363', 5, 'path', 'asdf', 'Description E', 'Description', 'User', 'location');
    List<Recording> sampleRecordingList = [recording1, recording2, recording3, recording4, recording5];

    recordingList = sampleRecordingList;

    return recordingList.toString();

  }


  
  Future<String> writeRecordingsToFile() async {

    //Writes all data stored in recordingList to individual files named <guid>.json

    for (Recording rec in recordingList) {  //Iterate over list of all recordings and write
    var file = await getRecordingFile(rec.guid);
    await file.writeAsString(json.encode(rec));
    }
    return recordingList.toString();

  }


  void loadSampleReminderData() async {  //Generate sample reminder data from literals

    //Sample Data
    Reminder reminder1 = Reminder(1, 1, 1, 'Description A', 'User');
    Reminder reminder2 = Reminder(2, 1, 1, 'Description B', 'User');
    Reminder reminder3 = Reminder(3, 1, 1, 'Description C', 'User');
    Reminder reminder4 = Reminder(4, 1, 1, 'Description D', 'User');
    Reminder reminder5 = Reminder(5, 1, 1, 'Description E', 'User');
    List<Reminder> sampleReminderList = [reminder1, reminder2, reminder3, reminder4, reminder5];

    reminderList = sampleReminderList;
  }

    void writeRemindersToFile() async { //Write List to file 'reminders.json'

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


  Future<String?> getOpenAiSummary(String guid) async {
    String requestTranscript = '';

    for (Recording rec in recordingList) {
      if (rec.guid == guid) {
        requestTranscript = rec.transcript!;
      }
    }
    GptCalls newGpt = new GptCalls();
    final completion = await newGpt.getOpenAiSummary(requestTranscript, 'This Profile'); //Todo implement user profile argument if desired

    //Todo parse this output "content: <THIS_IS_THE_INTERESTING_CONTENT>, ), finishReason: stop)"

    //Todo save this GPT Summary to recording and write to file - call method with GUID and GPTsummary arguments

    return completion;
     


    }

    
}