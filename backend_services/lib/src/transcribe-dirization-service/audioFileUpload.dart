import 'package:path/path.dart';
import 'package:async/async.dart';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:dio/dio.dart';
import 'dart:convert';






Future <String> audioFileUpload(File audioFile) async {
Dio dio = new Dio();


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


///define filename path for uri
String fileName = audioFile.path.split('/').last;
String apiURL = "https://7wgrq8myd7.execute-api.us-east-1.amazonaws.com";
String uri = '$apiURL/dev/testrecordingsswenv2/$fileName';

File uploadFile = File(audioFile.path);

var response = await dio.put(
uri, 
data: uploadFile.openRead(),
options: Options(contentType:"application/mp3"));
print(response);
if(response.statusCode == 200){
  return "It uploaded";
}
return "ran the function";

} catch (e){
 //return {"errorMessage":e.toString()};
 print(e.toString());
}
return "ran the function";
//return true;
}

