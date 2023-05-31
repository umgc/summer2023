import 'package:flutter/material.dart';

class ConversationsListScreen extends StatefulWidget {
  const ConversationsListScreen({Key? key}) : super(key: key);

  @override
  State<ConversationsListScreen> createState() =>
      _ConversationsListScreenState();
}

class _ConversationsListScreenState extends State<ConversationsListScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('Conversations List Screen'),
        centerTitle: true,
        backgroundColor: Colors.black,
      ),
      body:
          Center(child: Text('Insert Conversations List Screen Content Here')),
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
