import 'package:flutter/cupertino.dart';
import 'package:talker_mobile_app/enums/sorting_type.dart';

import '../models/conversation.dart';

final List<Conversation> sampleData = [
  Conversation(
      title: 'restaurant order',
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
      title: 'dinner with friend',
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
      title: 'order 1',
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
      title: 'date',
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
      title: 'work meeting',
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
      title: 'dentist',
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
      title: 'therapist',
      recordedDate: DateTime.now().add(const Duration(days: -121)),
      duration: const Duration(minutes: 3, seconds: 30),
      content: '',
      audioFilePath: '',
      id: ''),
];

class ConversationsProvider with ChangeNotifier {
  final List<Conversation> _conversations = sampleData;
  SortingType _sortingType = SortingType.dateNewToOld;

  List<Conversation> get conversations => _conversations;
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

  void setSortingType(SortingType type) {
    _sortingType = type;
    notifyListeners();
  }
}
