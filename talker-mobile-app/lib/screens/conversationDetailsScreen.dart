import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:talker_mobile_app/models/conversation.dart';
import 'package:talker_mobile_app/state/conversations_provider.dart';

class ConversationDetailsScreen extends StatefulWidget {
  const ConversationDetailsScreen({Key? key}) : super(key: key);

  @override
  State<ConversationDetailsScreen> createState() =>
      _ConversationDetailsScreenState();
}

class _ConversationDetailsScreenState extends State<ConversationDetailsScreen> {
  @override
  Widget build(BuildContext context) {
    final conversationsProvider = Provider.of<ConversationsProvider>(context);
    final Conversation? conversation =
        conversationsProvider.selectedConversation;

    String getFormattedDuration() {
      final minutes = conversation?.duration.inMinutes;
      final seconds = conversation!.duration.inSeconds % 60;
      final minutesString = '$minutes'.padLeft(2, '0');
      final secondsString = '$seconds'.padLeft(2, '0');
      return '$minutesString:$secondsString';
    }

    Widget renderDateAndDuration() {
      return Container(
        margin: const EdgeInsets.only(left: 10, top: 25, right: 10),
        padding:
            const EdgeInsets.only(left: 10, top: 33, right: 10, bottom: 33),
        clipBehavior: Clip.hardEdge,
        decoration: const BoxDecoration(
            color: Color(0xFF262626),
            borderRadius: BorderRadius.all(Radius.circular(25))),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '${DateFormat('MM/dd/yyyy').format(conversation!.recordedDate)}  ${DateFormat.jm().format(conversation.recordedDate)}',
              style: const TextStyle(fontSize: 14, color: Colors.white),
            ),
            Text(
              getFormattedDuration(),
              style: const TextStyle(fontSize: 14, color: Colors.white),
            ),
          ],
        ),
      );
    }

    Widget renderTransmogRow() {
      return ListView(
        scrollDirection: Axis.horizontal,
      );
    }

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text(conversation!.title),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        centerTitle: true,
        backgroundColor: Colors.black,
        actions: const <Widget>[
          IconButton(
              onPressed: null,
              icon: Icon(
                Icons.delete,
                color: Colors.white,
              ))
        ],
      ),
      body: Column(
        children: [
          renderDateAndDuration(),
        ],
      ),
    );
  }
}
