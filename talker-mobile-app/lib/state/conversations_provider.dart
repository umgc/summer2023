import 'package:flutter/cupertino.dart';

import '../models/conversation.dart';

final List<Conversation> test = [
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
];

class ConversationsProvider with ChangeNotifier {
  final List<Conversation> _conversations = test;

  List<Conversation> get conversations => _conversations;

  void addConversation(Conversation conversation) {
    _conversations.add(conversation);
    notifyListeners();
  }

  void removeConversation(Conversation conversation) {
    _conversations.remove(conversation);
    notifyListeners();
  }
}
