import 'dart:io';

import 'package:audio_waveforms/audio_waveforms.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:stop_watch_timer/stop_watch_timer.dart';
import 'package:talker_mobile_app/screens/conversationDetailsScreen.dart';

import '../models/conversation.dart';
import '../state/conversations_provider.dart';

class RecordingScreen extends StatefulWidget {
  const RecordingScreen({Key? key}) : super(key: key);

  @override
  State<RecordingScreen> createState() => _RecordingScreenState();
}

class _RecordingScreenState extends State<RecordingScreen> {
  late final RecorderController recorderController;
  late Directory appDirectory;
  final _stopWatchTimer = StopWatchTimer(mode: StopWatchMode.countUp);

  String? path;
  bool isPaused = false;

  @override
  void initState() {
    super.initState();
    _getDir();
    _initializeControllers();
    _startRecording();
  }

  void _getDir() async {
    appDirectory = await getApplicationDocumentsDirectory();
    path = "${appDirectory.path}/recording.m4a";
    setState(() {});
  }

  @override
  void dispose() {
    super.dispose();
    recorderController.dispose();
    _stopWatchTimer.dispose();
  }

  void _initializeControllers() {
    recorderController = RecorderController()
      ..androidEncoder = AndroidEncoder.aac
      ..androidOutputFormat = AndroidOutputFormat.mpeg4
      ..iosEncoder = IosEncoder.kAudioFormatMPEG4AAC
      ..sampleRate = 44100
      ..bitRate = 48000;
  }

  void _startRecording() async {
    //todo: add back in later: await recorderController.record(path: path);
    _stopWatchTimer.onStartTimer();
    setState(() {
      isPaused = false;
    });
  }

  void _pauseRecording() async {
    //todo: add back in later: await recorderController.pause();
    _stopWatchTimer.onStopTimer();
    setState(() {
      isPaused = true;
    });
  }

  void _resumeRecording() async {
    //todo: add back in later: await recorderController.record();
    _stopWatchTimer.onStartTimer();
    setState(() {
      isPaused = false;
    });
  }

  void _stopRecording(ConversationsProvider conversationsProvider) async {
    //todo: add back in later: await recorderController.stop();
    _stopWatchTimer.onStopTimer();
    setState(() {
      isPaused = false;
    });
    var seconds = _stopWatchTimer.secondTime;
    var recordedDate = DateTime.now();
    Conversation newConversation = Conversation(
        title: 'NewConversation',
        recordedDate: recordedDate,
        duration: Duration(seconds: seconds.value),
        content: '',
        audioFilePath: '',
        id: '');
    conversationsProvider.addConversation(newConversation);
    conversationsProvider.setSelectedConversation(newConversation);
    Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) => const ConversationDetailsScreen()));
  }

  Widget _buildPauseAndResumeButton() {
    if (!isPaused) {
      return Container(
        margin: const EdgeInsets.only(left: 20, right: 20),
        child: ElevatedButton.icon(
            onPressed: () {
              _pauseRecording();
            },
            style: ElevatedButton.styleFrom(
                minimumSize: const Size.fromHeight(50),
                backgroundColor: const Color(0xFF8900F8),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                )),
            icon: const Icon(
              Icons.pause,
              color: Colors.white,
              size: 40,
            ),
            label: const Text(
              'Pause',
              style: TextStyle(fontSize: 20),
            )),
      );
    } else {
      return Container(
        margin: const EdgeInsets.only(left: 20, right: 20),
        child: ElevatedButton.icon(
            onPressed: () {
              _resumeRecording();
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
              size: 40,
            ),
            label: const Text(
              'Resume',
              style: TextStyle(fontSize: 20),
            )),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final conversationsProvider = Provider.of<ConversationsProvider>(context);

    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        color: Colors.black,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              margin: EdgeInsets.only(top: 50),
              child: const ClipRRect(
                  borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(20),
                      bottomRight: Radius.circular(20)),
                  child: Image(
                      image: AssetImage('assets/microphone_Background.jpg'))),
            ),
            Center(
              child: AudioWaveforms(
                size: const Size(300, 45),
                recorderController: recorderController,
                waveStyle: const WaveStyle(
                  waveColor: Colors.white,
                  extendWaveform: true,
                ),
              ),
            ),
            StreamBuilder(
                stream: _stopWatchTimer.secondTime,
                initialData: 0,
                builder: (context, snap) {
                  final value = snap.data!;
                  return Center(
                    child: Text(
                      '${'${(value / 60).floor()}'.padLeft(2, '0')}:${'${value % 60}'.padLeft(2, '0')}',
                      style: const TextStyle(color: Colors.white, fontSize: 30),
                    ),
                  );
                }),
            Column(
              children: [
                _buildPauseAndResumeButton(),
                Container(
                  margin: const EdgeInsets.only(left: 20, right: 20, top: 15),
                  child: ElevatedButton.icon(
                      onPressed: () {
                        _stopRecording(conversationsProvider);
                      },
                      style: ElevatedButton.styleFrom(
                          minimumSize: const Size.fromHeight(50),
                          backgroundColor: const Color(0xFF8900F8),
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          )),
                      icon: const Icon(
                        Icons.stop,
                        color: Colors.white,
                        size: 40,
                      ),
                      label: const Text(
                        'Stop',
                        style: TextStyle(fontSize: 20),
                      )),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
