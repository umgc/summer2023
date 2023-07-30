import 'package:backend_services/backend_services_exports.dart';
import 'package:flutter/material.dart';
import 'package:panara_dialogs/panara_dialogs.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:talker_mobile_app/services/ConversationSelectionActivator.dart';

import '../globals.dart';
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
  void initState() {
    super.initState();
    _getFirstLoadSetting();
    getIt<Agent>().initialize(ConversationSelectionActivator(context));
  }

  Future<void> _getFirstLoadSetting() async {
    final prefs = await SharedPreferences.getInstance();
    var agreedToEula = prefs.getBool('agreedToEula');
    if (agreedToEula != null && agreedToEula == true) {
      return;
    } else {
      PanaraConfirmDialog.show(context,
          imagePath: 'assets/warning.png',
          barrierDismissible: false,
          message:
              "You are responsible for following all laws of the jurisdictions that you are in.",
          color: const Color(0xFF8900F8),
          confirmButtonText: "OK",
          cancelButtonText: "View EULA", onTapConfirm: () {
        prefs.setBool('agreedToEula', true);
        Navigator.pop(context);
      }, onTapCancel: () {
        Navigator.pop(context);
        Navigator.pushNamed(context, '/eula');
      }, panaraDialogType: PanaraDialogType.custom);
    }
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

    void clearSearchText() {
      controller.clear();
      setState(() {
        searchText = "";
      });
    }

    void onRecordPress() async {
      PermissionStatus permissionStatus = await Permission.microphone.request();
      if (permissionStatus.isGranted) {
        Navigator.pushNamed(context, '/recording');
      } else if (permissionStatus.isDenied) {
        return;
      } else if (permissionStatus.isPermanentlyDenied) {
        openAppSettings();
      }
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('ConvoBuddy'),
        centerTitle: true,
        backgroundColor: Colors.black,
        actions: <Widget>[
          IconButton(
              key: const Key('btnInfo'),
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
            Container(
              margin: const EdgeInsets.only(top: 10),
              child: ElevatedButton.icon(
                  key: const Key('btnRecord'),
                  onPressed: () {
                    onRecordPress();
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
