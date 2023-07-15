import 'dart:convert';
import 'dart:io';

import 'package:backend_services/model/conversation.dart';
import 'package:backend_services/src/state-management/sorting_type.dart';
import 'package:collection/collection.dart';
import 'package:flutter/foundation.dart';

class ConversationsProvider with ChangeNotifier {
  late final List<Conversation> _conversations;
  late final Directory _appDirectory;
  late final String _conversationsJsonPath;

  ConversationsProvider(Directory appDirectory) {
    _appDirectory = appDirectory;
    _conversationsJsonPath = "${_appDirectory.path}/conversations.json";
    _conversations = getConversationsFromJsonFile();
  }

  SortingType _sortingType = SortingType.dateNewToOld;
  Conversation? _selectedConversation;

  List<Conversation> get conversations => _conversations;
  Conversation? get selectedConversation => _selectedConversation;
  SortingType get sortingType => _sortingType;
  Directory get appDirectory => _appDirectory;
  String get conversationsJsonPath => _conversationsJsonPath;

  void addConversation(Conversation conversation) {
    _conversations.add(conversation);
    notifyListeners();
    writeConversationsToJsonFile();
  }

  void removeConversation(Conversation conversation) {
    _conversations.remove(conversation);
    notifyListeners();
    writeConversationsToJsonFile();
  }

  void updateConversationTitle(String id, String newTitle) {
    Conversation? conversation =
        conversations.firstWhereOrNull((convo) => convo.id == id);
    if (conversation == null) {
      return;
    }
    conversation.title = newTitle;
    notifyListeners();
    writeConversationsToJsonFile();
  }

  void updateConversationTranscript(String id, String newTranscript) {
    Conversation? conversation =
        conversations.firstWhereOrNull((convo) => convo.id == id);
    if (conversation == null) {
      return;
    }
    conversation.transcript = newTranscript;
    notifyListeners();
    writeConversationsToJsonFile();
  }

  void updateCustomDescription(String id, String newCustomDescription) {
    Conversation? conversation =
        conversations.firstWhereOrNull((convo) => convo.id == id);
    if (conversation == null) {
      return;
    }
    conversation.customDescription = newCustomDescription;
    notifyListeners();
    writeConversationsToJsonFile();
  }

  void updateGptDescription(String id, String newGptDescription) {
    Conversation? conversation =
        conversations.firstWhereOrNull((convo) => convo.id == id);
    if (conversation == null) {
      return;
    }
    conversation.gptDescription = newGptDescription;
    notifyListeners();
    writeConversationsToJsonFile();
  }

  void setSelectedConversation(Conversation conversation) {
    _selectedConversation = conversation;
    notifyListeners();
  }

  List<Conversation> filterConversations(String searchText) {
    var filteredConversations = _conversations
        .where((conversation) => conversation.title
            .toLowerCase()
            .contains(searchText.toLowerCase().trim()))
        .toList();
    return filteredConversations;
  }

  void setSortingType(SortingType type) {
    _sortingType = type;
    notifyListeners();
  }

  List<Conversation> getConversationsFromJsonFile() {
    var fileExists = File(_conversationsJsonPath).existsSync();
    if (fileExists) {
      final File jsonFile = File(_conversationsJsonPath);
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

  Future<void> writeConversationsToJsonFile() async {
    var json = jsonEncode(conversations.map((c) => c.toJson()).toList());
    final File jsonFile = File(_conversationsJsonPath);
    await jsonFile.writeAsString(json, mode: FileMode.writeOnly);
  }
}
