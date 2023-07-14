import 'package:http/http.dart' as http;
import 'dart:io';
import 'dart:core';

Future<Map<String, String>> audioFileUpload(File audioFile) async {
//define messages for responses
  var successMessage = {
    'message': "audio file is uploaded for transcription",
    'statusCode': '200'
  };
  // ignore: unused_local_variable
  var fourHundredMessage = {
    'message': 'you do not have access to upload your conversation'
  };
  // ignore: unused_local_variable
  var fiveHundredMessage = {
    'message': 'there was an issue with uploading your conversation'
  };

  try {
    // ignore: unnecessary_null_comparison
    if (audioFile == null) {
      print("please select audio file");
    }

//TODO: Updated with .env variables
    var url = Uri.https('7wgrq8myd7.execute-api.us-east-1.amazonaws.com',
        '/dev/testrecordingsswenv2/test-dart.txt');
//var req = await http.put(url,body: File('./testfile/test-dart.txt').readAsBytesSync());
    var req = await http.put(url, body: audioFile.readAsBytesSync());
    if (req.statusCode == 200) {
      print(successMessage.toString());
      return successMessage;
    }
  } catch (e) {
    return {"errorMessage": e.toString()};
  }
  return {"message": "upload file function"};
}
