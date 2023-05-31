import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../models/conversation.dart';

class ConversationListItem extends StatelessWidget {
  ConversationListItem(
      {required this.conversation, required this.onTap, Key? key})
      : super(key: key);

  final Conversation conversation;
  final Function() onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      clipBehavior: Clip.hardEdge,
      decoration: const BoxDecoration(
          color: Color(0xFF262626),
          borderRadius: BorderRadius.all(Radius.circular(30))),
      margin: const EdgeInsets.all(10),
      child: TextButton(
        onPressed: onTap,
        child: Container(
          padding: const EdgeInsets.all(10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TextButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF8900F8),
                  shape: const CircleBorder(),
                  padding: const EdgeInsets.all(18),
                ),
                child: const Icon(
                  Icons.play_circle,
                  color: Colors.white,
                ),
              ),
              Expanded(
                child: Container(
                  margin: const EdgeInsets.only(left: 15),
                  child: Text(conversation.title,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 18)),
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    DateFormat('MM/dd/yyyy').format(conversation.recordedDate),
                    style: const TextStyle(fontSize: 10, color: Colors.white),
                  ),
                  Text(DateFormat.jm().format(conversation.recordedDate),
                      style:
                          const TextStyle(fontSize: 10, color: Colors.white)),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
