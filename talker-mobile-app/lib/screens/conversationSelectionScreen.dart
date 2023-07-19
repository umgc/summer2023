import 'package:backend_services/backend_services_exports.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../globals.dart';
import '../widgets/conversationListItem.dart';

class ConversationSelectionScreen extends StatefulWidget {
  const ConversationSelectionScreen({Key? key}) : super(key: key);

  @override
  State<ConversationSelectionScreen> createState() =>
      _ConversationSelectionScreenState();
}

class _ConversationSelectionScreenState
    extends State<ConversationSelectionScreen> {
  final controller = TextEditingController();
  String searchText = "";

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final conversationsProvider = Provider.of<ConversationsProvider>(context);
    final sortingType = Provider.of<ConversationsProvider>(context).sortingType;

    List<Conversation> filteredConversations =
        conversationsProvider.filterConversations(searchText);

    if (sortingType == SortingType.dateNewToOld) {
      sortByDate(filteredConversations, true);
    } else if (sortingType == SortingType.dateOldToNew) {
      sortByDate(filteredConversations, false);
    } else if (sortingType == SortingType.titleAToZ) {
      sortByTitle(filteredConversations, true);
    } else if (sortingType == SortingType.titleZToA) {
      sortByTitle(filteredConversations, false);
    } else if (sortingType == SortingType.durationShortToLong) {
      sortByDuration(filteredConversations, true);
    } else {
      sortByDuration(filteredConversations, false);
    }

    Widget buildConversationList() {
      if (filteredConversations.isEmpty) {
        return const Expanded(
          child: Align(
            alignment: Alignment.center,
            child: Text("No Conversations Found",
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 20)),
          ),
        );
      }
      return Expanded(
        child: ListView(
          physics: const BouncingScrollPhysics(),
          children: filteredConversations.map((conversation) {
            return ConversationListItem(
                conversation: conversation,
                onTap: () {
                  getIt<Agent>().extractFormValues(conversation.id);
                  Navigator.pop(context);
                });
          }).toList(),
        ),
      );
    }

    void clearSearchText() {
      controller.clear();
      setState(() {
        searchText = "";
      });
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Select a Conversation'),
        centerTitle: true,
        backgroundColor: Colors.black,
      ),
      body: Container(
        color: Colors.black,
        padding: const EdgeInsets.only(top: 10, left: 10, right: 10),
        child: Column(
          key: const Key('ctnrColumns'),
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              margin: const EdgeInsets.only(bottom: 20),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: const Color(0xFF262626)),
              height: 45,
              child: Row(
                key: const Key('rowConversation'),
                children: [
                  PopupMenuButton(
                    key: const Key('btnSort'),
                    shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(15.0))),
                    color: const Color(0xFF262626),
                    initialValue: sortingType,
                    onSelected: (SortingType sortType) {
                      setState(() {
                        conversationsProvider.setSortingType(sortType);
                      });
                    },
                    itemBuilder: (BuildContext context) =>
                        <PopupMenuEntry<SortingType>>[
                      const PopupMenuItem<SortingType>(
                        key: Key('btnSort_DateNewToOld'),
                        value: SortingType.dateNewToOld,
                        child: Text(
                          'Date (New ➔ Old)',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                      const PopupMenuItem<SortingType>(
                        key: Key('btnSort_DateOldToNew'),
                        value: SortingType.dateOldToNew,
                        child: Text(
                          'Date (Old ➔ New)',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                      const PopupMenuItem<SortingType>(
                        key: Key('btnSort_TitleAToZ'),
                        value: SortingType.titleAToZ,
                        child: Text(
                          'Title (A ➔ Z)',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                      const PopupMenuItem<SortingType>(
                        key: Key('btnSort_TitleZToA'),
                        value: SortingType.titleZToA,
                        child: Text(
                          'Title (Z ➔ A)',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                      const PopupMenuItem<SortingType>(
                        key: Key('btnSort_DurationShortToLong'),
                        value: SortingType.durationShortToLong,
                        child: Text(
                          'Duration (Short ➔ Long)',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                      const PopupMenuItem<SortingType>(
                        key: Key('btnSort_DurationLongToShort'),
                        value: SortingType.durationLongToShort,
                        child: Text(
                          'Duration (Long ➔ Short)',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ],
                    icon: const Icon(
                      key: Key('btnSortIcon'),
                      Icons.sort,
                      color: Colors.white,
                    ),
                  ),
                  Expanded(
                    child: TextField(
                      key: const Key('txtSearch'),
                      controller: controller,
                      textAlignVertical: TextAlignVertical.center,
                      style: const TextStyle(color: Colors.white),
                      cursorColor: Colors.white,
                      decoration: InputDecoration(
                          filled: true,
                          fillColor: const Color(0xFF262626),
                          enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                              borderSide:
                                  const BorderSide(color: Colors.transparent)),
                          contentPadding: const EdgeInsets.all(0),
                          prefixIcon: const Icon(Icons.search),
                          prefixIconColor: searchText.isEmpty
                              ? Colors.white
                              : Colors.transparent,
                          hintText: 'Search Conversations',
                          hintStyle: const TextStyle(color: Colors.grey),
                          suffixIcon: IconButton(
                            key: const Key('btnSearchClear'),
                            onPressed: () => clearSearchText(),
                            icon: const Icon(Icons.clear),
                            color: searchText.isNotEmpty
                                ? Colors.white
                                : Colors.transparent,
                          ),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                              borderSide:
                                  const BorderSide(color: Colors.transparent)),
                          focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                              borderSide:
                                  const BorderSide(color: Colors.transparent))),
                      onChanged: (value) => setState(() {
                        searchText = value;
                      }),
                    ),
                  ),
                ],
              ),
            ),
            buildConversationList(),
          ],
        ),
      ),
    );
  }

  void sortByDate(List<Conversation> conversations, bool newestFirst) {
    if (newestFirst) {
      conversations.sort((a, b) => b.recordedDate.compareTo(a.recordedDate));
      return;
    }
    conversations.sort((a, b) => a.recordedDate.compareTo(b.recordedDate));
  }

  void sortByTitle(List<Conversation> conversations, bool aToZ) {
    if (aToZ) {
      conversations.sort(
          (a, b) => a.title.toLowerCase().compareTo(b.title.toLowerCase()));
      return;
    }
    conversations
        .sort((a, b) => b.title.toLowerCase().compareTo(a.title.toLowerCase()));
  }

  void sortByDuration(List<Conversation> conversations, bool shortestFirst) {
    if (shortestFirst) {
      conversations.sort((a, b) => a.duration.compareTo(b.duration));
      return;
    }
    conversations.sort((a, b) => b.duration.compareTo(a.duration));
  }
}
