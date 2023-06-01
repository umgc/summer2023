import 'package:flutter/cupertino.dart';

import '../models/conversation.dart';

final List<Conversation> sampleData = [
  Conversation(
      title: 'restaurant order',
      recordedDate: DateTime.now(),
      duration: Duration(),
      content: '',
      audioFilePath: ''),
  Conversation(
      title: 'doctor appointment',
      recordedDate: DateTime.now().add(const Duration(minutes: -120)),
      duration: Duration(),
      content: '',
      audioFilePath: ''),
  Conversation(
      title: 'dinner with friend',
      recordedDate: DateTime.now().add(const Duration(days: -120)),
      duration: Duration(),
      content: '',
      audioFilePath: ''),
  Conversation(
      title: 'a very loooooooooonnnnnng title',
      recordedDate: DateTime.now().add(const Duration(days: -220)),
      duration: Duration(),
      content: '',
      audioFilePath: ''),
  Conversation(
      title: 'order 1',
      recordedDate: DateTime.now().add(const Duration(minutes: -120)),
      duration: Duration(),
      content: '',
      audioFilePath: ''),
  Conversation(
      title: 'order 2',
      recordedDate: DateTime.now().add(const Duration(days: -120)),
      duration: Duration(),
      content: '',
      audioFilePath: ''),
  Conversation(
      title: 'date',
      recordedDate: DateTime.now().add(const Duration(days: -220)),
      duration: Duration(),
      content: '',
      audioFilePath: ''),
  Conversation(
      title: 'birthday party',
      recordedDate: DateTime.now().add(const Duration(minutes: -120)),
      duration: Duration(),
      content: '',
      audioFilePath: ''),
  Conversation(
      title: 'work meeting',
      recordedDate: DateTime.now().add(const Duration(days: -120)),
      duration: Duration(),
      content: '',
      audioFilePath: ''),
  Conversation(
      title: 'anniversary',
      recordedDate: DateTime.now().add(const Duration(days: -220)),
      duration: Duration(),
      content: '',
      audioFilePath: ''),
  Conversation(
      title: 'dentist',
      recordedDate: DateTime.now().add(const Duration(minutes: -120)),
      duration: Duration(),
      content: '',
      audioFilePath: ''),
  Conversation(
      title: 'grocery list',
      recordedDate: DateTime.now().add(const Duration(days: -120)),
      duration: Duration(),
      content: '',
      audioFilePath: ''),
  Conversation(
      title: 'therapist',
      recordedDate: DateTime.now().add(const Duration(days: -220)),
      duration: Duration(),
      content: '',
      audioFilePath: ''),
];

class ConversationsProvider with ChangeNotifier {
  final List<Conversation> _conversations = sampleData;

  List<Conversation> get conversations => _conversations;

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
    return filteredConversations.isEmpty
        ? conversations
        : filteredConversations;
  }
}
