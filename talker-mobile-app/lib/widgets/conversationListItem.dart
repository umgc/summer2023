import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../models/conversation.dart';

class ConversationListItem extends StatelessWidget {
  const ConversationListItem(
      {required this.conversation, required this.onTap, Key? key})
      : super(key: key);

  final Conversation conversation;
  final Function() onTap;

  String getFormattedDuration() {
    final minutes = conversation.duration.inMinutes;
    final seconds = conversation.duration.inSeconds % 60;
    final minutesString = '$minutes'.padLeft(2, '0');
    final secondsString = '$seconds'.padLeft(2, '0');
    return '$minutesString:$secondsString';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      clipBehavior: Clip.hardEdge,
      decoration: const BoxDecoration(
          color: Color(0xFF262626),
          borderRadius: BorderRadius.all(Radius.circular(30))),
      margin: const EdgeInsets.only(top: 10, bottom: 5),
      child: TextButton(
        onPressed: onTap,
        child: Container(
          padding: const EdgeInsets.all(10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(conversation.title,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 20)),
                  Text(
                    '${DateFormat('MM/dd/yyyy').format(conversation.recordedDate)}  ${DateFormat.jm().format(conversation.recordedDate)}',
                    style: const TextStyle(fontSize: 13, color: Colors.white),
                  )
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    getFormattedDuration(),
                    style: const TextStyle(fontSize: 13, color: Colors.white),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
