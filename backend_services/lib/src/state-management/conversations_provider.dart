import 'dart:convert';
import 'dart:io';

import 'package:backend_services/model/conversation.dart';
import 'package:backend_services/model/reminder.dart';
import 'package:backend_services/src/state-management/sorting_type.dart';
import 'package:collection/collection.dart';
import 'package:flutter/foundation.dart';

class ConversationsProvider with ChangeNotifier {
  late final List<Conversation> _conversations;
  late final Directory _appDirectory;
  late final String _conversationsJsonPath;
  late final List<Reminder> _reminders;
  late final String _remindersJsonPath;

  ConversationsProvider(Directory appDirectory) {
    _appDirectory = appDirectory;
    _conversationsJsonPath = "${_appDirectory.path}/conversations.json";
    _conversations = getConversationsFromJsonFile();
    _remindersJsonPath = "${_appDirectory.path}/reminders.json";
    _reminders = getRemindersFromJsonFile();
  }

  SortingType _sortingType = SortingType.dateNewToOld;
  Conversation? _selectedConversation;

  List<Conversation> get conversations => _conversations;
  Conversation? get selectedConversation => _selectedConversation;
  SortingType get sortingType => _sortingType;
  Directory get appDirectory => _appDirectory;
  String get conversationsJsonPath => _conversationsJsonPath;
  List<Reminder> get reminders => _reminders;

  Future<void> addConversation(Conversation conversation) {
    _conversations.add(conversation);
    notifyListeners();
    return writeConversationsToJsonFile();
  }

  Future<void> removeConversation(Conversation conversation) {
    _conversations.remove(conversation);
    notifyListeners();
    deleteAudioFile(conversation.id);
    return writeConversationsToJsonFile();
  }

  Future<void> removeAllConversations() {
    _conversations.clear();
    notifyListeners();
    return writeConversationsToJsonFile();
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

  void updateGptReminders(String id, String newGptReminders) {
    Conversation? conversation =
        conversations.firstWhereOrNull((convo) => convo.id == id);
    if (conversation == null) {
      return;
    }
    conversation.gptReminders = newGptReminders;
    notifyListeners();
    writeConversationsToJsonFile();
  }

  void updateGptFoodOrder(String id, String newGptFoodOrder) {
    Conversation? conversation =
        conversations.firstWhereOrNull((convo) => convo.id == id);
    if (conversation == null) {
      return;
    }
    conversation.gptFoodOrder = newGptFoodOrder;
    notifyListeners();
    writeConversationsToJsonFile();
  }

  void updateGptTranscript(String id, String newGptTranscript) {
    Conversation? conversation =
        conversations.firstWhereOrNull((convo) => convo.id == id);
    if (conversation == null) {
      return;
    }
    conversation.gptTranscript = newGptTranscript;
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

  Future<void> deleteAudioFile(String id) async {
    final File audioFile =
        File("${appDirectory.path}/${selectedConversation?.id}.m4a");
    if (audioFile.existsSync()) {
      audioFile.deleteSync();
    }
  }

  void addReminder(Reminder reminder) {
    _reminders.add(reminder);
    notifyListeners();
    writeRemindersToJsonFile();
  }

  void removeReminder(Reminder reminder) {
    _reminders.remove(reminder);
    notifyListeners();
    writeRemindersToJsonFile();
  }

  void removeAllReminders() {
    _reminders.clear();
    notifyListeners();
    writeRemindersToJsonFile();
  }

  List<Reminder> getRemindersFromJsonFile() {
    var fileExists = File(_remindersJsonPath).existsSync();
    if (fileExists) {
      final File jsonFile = File(_remindersJsonPath);
      String contents = jsonFile.readAsStringSync();
      var jsonResponse = jsonDecode(contents);
      var jsonAsList = jsonResponse as List;
      List<Reminder> reminders =
          jsonAsList.map<Reminder>((json) => Reminder.fromJson(json)).toList();
      return reminders;
    } else {
      return [];
    }
  }

  Future<void> writeRemindersToJsonFile() async {
    var json = jsonEncode(reminders.map((c) => c.toJson()).toList());
    final File jsonFile = File(_remindersJsonPath);
    await jsonFile.writeAsString(json, mode: FileMode.writeOnly);
  }
}
