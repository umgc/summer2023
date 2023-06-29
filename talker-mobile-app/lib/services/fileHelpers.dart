import 'dart:convert';
import 'dart:io' as io;

import '../models/conversation.dart';

void getConversationsFromJsonFile(String filePath) async {
  var fileExists = await io.File(filePath).exists();
  if (fileExists) {}
}

void writeConversationsToJsonFile(
    List<Conversation> conversations, String filePath) {
  var json = jsonEncode(conversations.map((c) => c.toJson()).toList());
}
