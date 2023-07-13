import 'package:backend_services/model/conversation.dart';
import 'package:backend_services/src/state-management/sorting_type.dart';
import 'package:flutter/foundation.dart';

class ConversationsProvider with ChangeNotifier {
  final List<Conversation> _conversations;

  ConversationsProvider(this._conversations);

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
