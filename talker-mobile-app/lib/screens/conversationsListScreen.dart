import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
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
  void removeConversation(BuildContext context, Conversation conversation) {
    context.read<ConversationsProvider>().removeConversation(conversation);
  }

  @override
  Widget build(BuildContext context) {
    var conversations = context.watch<ConversationsProvider>().conversations;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('Conversations List Screen'),
        centerTitle: true,
        backgroundColor: Colors.black,
      ),
      body: Container(
          alignment: Alignment.center,
          child: ListView(
            physics: const BouncingScrollPhysics(),
            children: conversations.map((conversation) {
              return ConversationListItem(
                  conversation: conversation,
                  onTap: () => removeConversation(context, conversation));
            }).toList(),
          )),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, '/home');
        }, //_speechToText.isNotListening ? _startListening : _stopListening,
        child: Text('Home'),
        backgroundColor: Colors.green,
      ),
    );
  }
}
