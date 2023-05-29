import 'package:flutter/material.dart';

class RecordingScreen extends StatefulWidget {
  const RecordingScreen({Key? key}) : super(key: key);

  @override
  State<RecordingScreen> createState() => _RecordingScreenState();
}

class _RecordingScreenState extends State<RecordingScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('Recording Screen'),
        centerTitle: true,
        backgroundColor: Colors.black,
      ),
      body: Center(child: Text('Insert Recording Screen Content Here')),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, '/conversationsList');
        }, //_speechToText.isNotListening ? _startListening : _stopListening,
        child: Text('Conversations'),
        backgroundColor: Colors.green,
      ),
    );
  }
}
