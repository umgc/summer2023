import 'dart:io';

import 'package:audio_waveforms/audio_waveforms.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:stop_watch_timer/stop_watch_timer.dart';

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
  bool isRecording = false;
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
      isRecording = true;
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
      isRecording = true;
    });
  }

  void _stopRecording() async {
    //todo: add back in later: await recorderController.stop();
    _stopWatchTimer.onStopTimer();
    setState(() {
      isRecording = false;
      isPaused = false;
    });
  }

  Widget _buildPauseAndResumeButton() {
    if (!isPaused) {
      return TextButton(
          onPressed: () {
            _pauseRecording();
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.white,
            shape: const CircleBorder(),
            padding: const EdgeInsets.all(5),
          ),
          child: const Icon(Icons.pause, color: Colors.black, size: 25));
    } else {
      return Padding(
        padding: const EdgeInsets.only(left: 20, right: 20),
        child: TextButton(
            onPressed: () {
              _resumeRecording();
            },
            style: TextButton.styleFrom(
                backgroundColor: const Color(0xFF8900F8),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                )),
            child: const Text(
              'Resume',
              style: TextStyle(fontSize: 20),
            )),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Record Conversation'),
        centerTitle: true,
        backgroundColor: Colors.black,
      ),
      body: Container(
        color: Colors.black,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const ClipRRect(
                borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(20),
                    bottomRight: Radius.circular(20)),
                child: Image(
                    image: AssetImage('assets/microphone_Background.jpg'))),
            if (isRecording)
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
            if (isRecording)
              StreamBuilder(
                  stream: _stopWatchTimer.secondTime,
                  initialData: 0,
                  builder: (context, snap) {
                    final value = snap.data!;
                    return Center(
                      child: Text(
                        '${'${(value / 60).floor()}'.padLeft(2, '0')}:${'${value % 60}'.padLeft(2, '0')}',
                        style:
                            const TextStyle(color: Colors.white, fontSize: 30),
                      ),
                    );
                  }),
            if (isRecording) _buildPauseAndResumeButton(),
            TextButton(
              onPressed: () {
                _stopRecording();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                shape: const CircleBorder(),
                padding: const EdgeInsets.all(15),
              ),
              child: const Icon(Icons.stop, color: Colors.white, size: 30),
            ),
          ],
        ),
      ),
    );
  }
}
