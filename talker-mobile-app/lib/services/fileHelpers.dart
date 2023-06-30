import 'dart:convert';
import 'dart:io';

import '../models/conversation.dart';

List<Conversation> getConversationsFromJsonFile(String filePath) {
  var fileExists = File(filePath).existsSync();
  if (fileExists) {
    final File jsonFile = File(filePath);
    String contents = jsonFile.readAsStringSync();
    var jsonResponse = jsonDecode(contents);
    var jsonAsList = jsonResponse as List;
    List<Conversation> conversations = jsonAsList
        .map<Conversation>((json) => Conversation.fromJson(json))
        .toList();
    return conversations;
  } else {
    return [];
  }
}

Future<void> writeConversationsToJsonFile(
    List<Conversation> conversations, String filePath) async {
  var json = jsonEncode(conversations.map((c) => c.toJson()).toList());
  final File jsonFile = File(filePath);
  await jsonFile.writeAsString(json, mode: FileMode.writeOnly);
}
