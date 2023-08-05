import 'dart:io';

import 'package:audio_waveforms/audio_waveforms.dart';
import 'package:backend_services/backend_services_exports.dart';
import 'package:flutter/material.dart';
import 'package:panara_dialogs/panara_dialogs.dart';
import 'package:provider/provider.dart';
import 'package:stop_watch_timer/stop_watch_timer.dart';
import 'package:talker_mobile_app/screens/conversationDetailsScreen.dart';
import 'package:uuid/uuid.dart';

import '../globals.dart';

class RecordingScreen extends StatefulWidget {
  const RecordingScreen({Key? key}) : super(key: key);

  @override
  State<RecordingScreen> createState() => _RecordingScreenState();
}

class _RecordingScreenState extends State<RecordingScreen> {
  late final RecorderController recorderController;
  final _stopWatchTimer = StopWatchTimer(mode: StopWatchMode.countUp);
  late String directoryPath;

  String id = const Uuid().v1();
  bool isPaused = false;

  @override
  void initState() {
    super.initState();
    _initializeControllers();
    directoryPath = Provider.of<ConversationsProvider>(context, listen: false)
        .appDirectory
        .path;
    _startRecording(directoryPath);
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

  void _startRecording(String directoryPath) async {
    await recorderController.record(path: "$directoryPath/$id.m4a");
    _stopWatchTimer.onStartTimer();
    setState(() {
      isPaused = false;
    });
  }

  void _pauseRecording() async {
    await recorderController.pause();
    _stopWatchTimer.onStopTimer();
    setState(() {
      isPaused = true;
    });
  }

  void _resumeRecording() async {
    await recorderController.record();
    _stopWatchTimer.onStartTimer();
    setState(() {
      isPaused = false;
    });
  }

  void _stopRecording(ConversationsProvider conversationsProvider) async {
    await recorderController.stop();
    _stopWatchTimer.onStopTimer();
    setState(() {
      isPaused = false;
    });
    var seconds = _stopWatchTimer.secondTime;
    var recordedDate = DateTime.now();
    Conversation newConversation = Conversation(
        recordedDate: recordedDate,
        duration: Duration(seconds: seconds.value),
        audioFilePath: "$directoryPath/$id.m4a",
        id: id);
    conversationsProvider.addConversation(newConversation);
    conversationsProvider.setSelectedConversation(newConversation);
    audioFileUpload(File("$directoryPath/$id.m4a"));
    getIt<Agent>().getOpenAiTranscript(id);
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
            key: const Key('btnPause'),
            onPressed: () {
              _pauseRecording();
            },
            style: ElevatedButton.styleFrom(
                minimumSize: const Size.fromHeight(50),
                side: const BorderSide(width: 1, color: Color(0xFF8900F8)),
                backgroundColor: Colors.black,
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
            key: const Key('btnResume'),
            onPressed: () {
              _resumeRecording();
            },
            style: ElevatedButton.styleFrom(
                minimumSize: const Size.fromHeight(50),
                side: const BorderSide(width: 1, color: Color(0xFF8900F8)),
                backgroundColor: Colors.black,
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

  Future<bool> _onBackPressed(
      ConversationsProvider conversationsProvider) async {
    bool shouldPop = false;
    PanaraConfirmDialog.show(context,
        message: "Do you want to stop the recording?",
        color: const Color(0xFF8900F8),
        confirmButtonText: "Stop",
        cancelButtonText: "Cancel", onTapConfirm: () {
      Navigator.pop(context);
      _stopRecording(conversationsProvider);
      shouldPop = true;
    }, onTapCancel: () {
      Navigator.pop(context);
      shouldPop = false;
    }, panaraDialogType: PanaraDialogType.custom);
    return shouldPop;
  }

  @override
  Widget build(BuildContext context) {
    final conversationsProvider = Provider.of<ConversationsProvider>(context);

    return WillPopScope(
      onWillPop: () {
        return _onBackPressed(conversationsProvider);
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Container(
          color: Colors.black,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Expanded(
                child: ClipRRect(
                    borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(20),
                        bottomRight: Radius.circular(20)),
                    child: Image(
                        fit: BoxFit.cover,
                        image: AssetImage('assets/microphone_Background.jpg'))),
              ),
              Center(
                child: Container(
                  margin: const EdgeInsets.only(top: 10, bottom: 10),
                  child: AudioWaveforms(
                    key: const Key('audoWave'),
                    size: const Size(300, 35),
                    recorderController: recorderController,
                    waveStyle: const WaveStyle(
                      waveColor: Colors.white,
                      extendWaveform: true,
                    ),
                  ),
                ),
              ),
              StreamBuilder(
                  stream: _stopWatchTimer.secondTime,
                  initialData: 0,
                  builder: (context, snap) {
                    final value = snap.data!;
                    return Center(
                      child: Container(
                        margin: const EdgeInsets.only(bottom: 10),
                        child: Text(
                          key: const Key('timerRecording'),
                          '${'${(value / 60).floor()}'.padLeft(2, '0')}:${'${value % 60}'.padLeft(2, '0')}',
                          style: const TextStyle(
                              color: Colors.white, fontSize: 30),
                        ),
                      ),
                    );
                  }),
              Column(
                children: [
                  _buildPauseAndResumeButton(),
                  Container(
                    margin: const EdgeInsets.only(left: 20, right: 20, top: 15),
                    child: ElevatedButton.icon(
                        key: const Key('btnStopRecording'),
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
      ),
    );
  }
}
