import 'package:flutter/cupertino.dart';
import 'package:talker_mobile_app/enums/sorting_type.dart';
import 'package:talker_mobile_app/services/fileHelpers.dart';

import '../globals.dart';
import '../models/conversation.dart';

/* final List<Conversation> sampleData = [
  Conversation(
      title: 'Restaurant order',
      recordedDate: DateTime.now(),
      duration: const Duration(minutes: 1, seconds: 20),
      content: '',
      audioFilePath: '',
      id: ''),
  Conversation(
      title: 'doctor appointment',
      recordedDate: DateTime.now().add(const Duration(minutes: -120)),
      duration: const Duration(minutes: 20, seconds: 23),
      content: '',
      audioFilePath: '',
      id: ''),
  Conversation(
      title: 'Dinner with friend',
      recordedDate: DateTime.now().add(const Duration(days: -120)),
      duration: const Duration(minutes: 22, seconds: 164),
      content: '',
      audioFilePath: '',
      id: ''),
  Conversation(
      title: 'a very loooooooooonnnnnng title',
      recordedDate: DateTime.now().add(const Duration(days: -220)),
      duration: const Duration(minutes: 1, seconds: 51),
      content: '',
      audioFilePath: '',
      id: ''),
  Conversation(
      title: 'Order 1',
      recordedDate: DateTime.now().add(const Duration(minutes: -2340)),
      duration: const Duration(minutes: 29, seconds: 59),
      content: '',
      audioFilePath: '',
      id: ''),
  Conversation(
      title: 'order 2',
      recordedDate: DateTime.now().add(const Duration(days: -1000)),
      duration: const Duration(minutes: 13, seconds: 42),
      content: '',
      audioFilePath: '',
      id: ''),
  Conversation(
      title: 'Date',
      recordedDate: DateTime.now().add(const Duration(days: -2000)),
      duration: const Duration(minutes: 1, seconds: 1),
      content: '',
      audioFilePath: '',
      id: ''),
  Conversation(
      title: 'birthday party',
      recordedDate: DateTime.now().add(const Duration(minutes: -52)),
      duration: const Duration(minutes: 0, seconds: 23),
      content: '',
      audioFilePath: '',
      id: ''),
  Conversation(
      title: 'Work meeting',
      recordedDate: DateTime.now().add(const Duration(days: -10000)),
      duration: const Duration(minutes: 0, seconds: 3),
      content: '',
      audioFilePath: '',
      id: ''),
  Conversation(
      title: 'anniversary',
      recordedDate: DateTime.now().add(const Duration(days: -2354)),
      duration: const Duration(minutes: 8, seconds: 20),
      content: '',
      audioFilePath: '',
      id: ''),
  Conversation(
      title: 'Dentist',
      recordedDate: DateTime.now().add(const Duration(minutes: -3)),
      duration: const Duration(minutes: 5, seconds: 56),
      content: '',
      audioFilePath: '',
      id: ''),
  Conversation(
      title: 'grocery list',
      recordedDate: DateTime.now().add(const Duration(days: -7)),
      duration: const Duration(minutes: 23, seconds: 11),
      content: '',
      audioFilePath: '',
      id: ''),
  Conversation(
      title: 'Therapist',
      recordedDate: DateTime.now().add(const Duration(days: -121)),
      duration: const Duration(minutes: 3, seconds: 30),
      content: '',
      audioFilePath: '',
      id: ''),
]; */

class ConversationsProvider with ChangeNotifier {
  final List<Conversation> _conversations = getConversationsFromJsonFile(
      "${Globals.appDirectory?.path}/conversations.json");
  SortingType _sortingType = SortingType.dateNewToOld;
  Conversation? _selectedConversation;

  List<Conversation> get conversations => _conversations;
  Conversation? get selectedConversation => _selectedConversation;
  SortingType get sortingType => _sortingType;

  void addConversation(Conversation conversation) {
    _conversations.add(conversation);
    notifyListeners();
  }

  void removeConversation(Conversation conversation) {
    _conversations.remove(conversation);
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

  void updateConversationTitle(String id, String newTitle) {
    var conversation = conversations.firstWhere((convo) => convo.id == id);
    conversation.title = newTitle;
    notifyListeners();
  }

  void setSelectedConversation(Conversation conversation) {
    _selectedConversation = conversation;
    notifyListeners();
  }

  void setSortingType(SortingType type) {
    _sortingType = type;
    notifyListeners();
  }
}
