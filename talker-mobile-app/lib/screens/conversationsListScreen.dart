import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:talker_mobile_app/enums/sorting_type.dart';
import 'package:talker_mobile_app/models/conversation.dart';
import 'package:talker_mobile_app/state/conversations_provider.dart';

import '../widgets/conversationListItem.dart';

class ConversationsListScreen extends StatefulWidget {
  const ConversationsListScreen({Key? key}) : super(key: key);

  @override
  State<ConversationsListScreen> createState() =>
      _ConversationsListScreenState();
}

class _ConversationsListScreenState extends State<ConversationsListScreen> {
  final controller = TextEditingController();
  String searchText = "";

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
        return const Text("No Conversations Found",
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 20));
      }
      return Expanded(
        child: ListView(
          physics: const BouncingScrollPhysics(),
          children: filteredConversations.map((conversation) {
            return ConversationListItem(
                conversation: conversation,
                onTap: () => {
                      conversationsProvider
                          .setSelectedConversation(conversation),
                      Navigator.pushNamed(context, '/conversationDetailsScreen')
                    });
          }).toList(),
        ),
      );
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('ConvoBuddy'),
        centerTitle: true,
        backgroundColor: Colors.black,
        actions: <Widget>[
          IconButton(
              onPressed: () => Navigator.pushNamed(context, '/information'),
              icon: const Icon(
                Icons.info_outline,
                color: Colors.white,
              ))
        ],
      ),
      body: Container(
        color: Colors.black,
        padding: const EdgeInsets.only(top: 10, left: 10, right: 10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              margin: const EdgeInsets.only(bottom: 20),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: const Color(0xFF262626)),
              height: 45,
              child: Row(
                children: [
                  PopupMenuButton(
                    initialValue: sortingType,
                    onSelected: (SortingType sortType) {
                      setState(() {
                        conversationsProvider.setSortingType(sortType);
                      });
                    },
                    itemBuilder: (BuildContext context) =>
                        <PopupMenuEntry<SortingType>>[
                      const PopupMenuItem<SortingType>(
                        value: SortingType.dateNewToOld,
                        child: Text('Date (New -> Old)'),
                      ),
                      const PopupMenuItem<SortingType>(
                        value: SortingType.dateOldToNew,
                        child: Text('Date (Old -> New)'),
                      ),
                      const PopupMenuItem<SortingType>(
                        value: SortingType.titleAToZ,
                        child: Text('Tag (A -> Z)'),
                      ),
                      const PopupMenuItem<SortingType>(
                        value: SortingType.titleZToA,
                        child: Text('Tag (Z -> A)'),
                      ),
                      const PopupMenuItem<SortingType>(
                        value: SortingType.durationShortToLong,
                        child: Text('Duration (Short -> Long)'),
                      ),
                      const PopupMenuItem<SortingType>(
                        value: SortingType.durationLongToShort,
                        child: Text('Duration (Long -> Short)'),
                      ),
                    ],
                    icon: const Icon(
                      Icons.sort,
                      color: Colors.white,
                    ),
                  ),
                  Expanded(
                    child: TextField(
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
            Container(
              margin: const EdgeInsets.only(top: 10),
              child: ElevatedButton.icon(
                  onPressed: () {
                    null;
                  },
                  style: ElevatedButton.styleFrom(
                      minimumSize: const Size.fromHeight(50),
                      backgroundColor: const Color(0xFF8900F8),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      )),
                  icon: const Icon(
                    Icons.mic_none,
                    color: Colors.white,
                  ),
                  label: const Text(
                    'Record',
                    style: TextStyle(fontSize: 20),
                  )),
            ),
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
      conversations.sort((a, b) => a.title.compareTo(b.title));
      return;
    }
    conversations.sort((a, b) => b.title.compareTo(a.title));
  }

  void sortByDuration(List<Conversation> conversations, bool shortestFirst) {
    if (shortestFirst) {
      conversations.sort((a, b) => a.duration.compareTo(b.duration));
      return;
    }
    conversations.sort((a, b) => b.duration.compareTo(a.duration));
  }
}
