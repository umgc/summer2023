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
  SortingType sortingType = SortingType.dateNewToOld;

  @override
  Widget build(BuildContext context) {
    final conversationsProvider = Provider.of<ConversationsProvider>(context);
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

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Conversations'),
        centerTitle: true,
        backgroundColor: Colors.black,
      ),
      body: Container(
        color: Colors.black,
        padding: const EdgeInsets.only(top: 10, left: 10, right: 10),
        child: Column(
          children: [
            Container(
              height: 45,
              child: Row(
                children: [
                  PopupMenuButton(
                    initialValue: sortingType,
                    onSelected: (SortingType sortType) {
                      setState(() {
                        sortingType = sortType;
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
                      style: TextStyle(color: Colors.white),
                      cursorColor: Colors.white,
                      decoration: InputDecoration(
                          enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                              borderSide:
                                  const BorderSide(color: Colors.white)),
                          contentPadding: const EdgeInsets.all(0),
                          prefixIcon: const Icon(Icons.search),
                          prefixIconColor: Colors.white,
                          hintText: 'Conversation Title',
                          hintStyle: TextStyle(color: Colors.grey),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                              borderSide:
                                  const BorderSide(color: Colors.white)),
                          focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                              borderSide:
                                  const BorderSide(color: Colors.white))),
                      onChanged: (value) => setState(() {
                        searchText = value;
                      }),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView(
                physics: const BouncingScrollPhysics(),
                children: filteredConversations.map((conversation) {
                  return ConversationListItem(
                      conversation: conversation, onTap: () => {});
                }).toList(),
              ),
            ),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, '/recording');
        },
        backgroundColor: Colors.red,
        child: const Icon(Icons.mic),
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
