import 'dart:io';
import 'dart:core';
import 'audioFileUpload.dart';

void main() async {
  var uploadFile = File('./testfile/test-dart.txt');
  audioFileUpload(uploadFile);
}
