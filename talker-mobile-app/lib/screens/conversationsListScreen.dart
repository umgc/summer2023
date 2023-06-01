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
  final controller = TextEditingController();
  List<Conversation> filteredConversations = [];

  @override
  Widget build(BuildContext context) {
    final conversationsProvider = Provider.of<ConversationsProvider>(context);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('Conversations List Screen'),
        centerTitle: true,
        backgroundColor: Colors.black,
      ),
      body: Column(
        children: [
          TextField(
            controller: controller,
            decoration: InputDecoration(
                prefixIcon: const Icon(Icons.search),
                hintText: 'Conversation Title',
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: const BorderSide(color: Colors.blue))),
            onChanged: (value) => setState(() {
              filteredConversations =
                  conversationsProvider.filterConversations(value);
            }),
          ),
          Expanded(
            child: ListView(
              physics: const BouncingScrollPhysics(),
              children: filteredConversations.map((conversation) {
                return ConversationListItem(
                    conversation: conversation,
                    onTap: () => removeConversation(context, conversation));
              }).toList(),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, '/home');
        }, //_speechToText.isNotListening ? _startListening : _stopListening,
        child: Text('Home'),
        backgroundColor: Colors.green,
      ),
    );
  }

  void removeConversation(BuildContext context, Conversation conversation) {
    context.read<ConversationsProvider>().removeConversation(conversation);
  }
}
