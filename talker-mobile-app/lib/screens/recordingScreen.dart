import 'package:flutter/material.dart';

class RecordingScreen extends StatefulWidget {
  const RecordingScreen({Key? key}) : super(key: key);

  @override
  State<RecordingScreen> createState() => _RecordingScreenState();
}

class _RecordingScreenState extends State<RecordingScreen> {
  bool isRecording = false;
  bool isPaused = false;
  String currentDuration = '0:00';

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
          children: [
            const ClipRRect(
                borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(20),
                    bottomRight: Radius.circular(20)),
                child: Image(
                    image: AssetImage('assets/microphone_Background.jpg'))),
            if (isRecording)
              const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.graphic_eq, color: Colors.white, size: 70),
                  Icon(Icons.graphic_eq, color: Colors.white, size: 70),
                  Icon(Icons.graphic_eq, color: Colors.white, size: 70),
                ],
              ),
            if (isRecording)
              Text(
                currentDuration,
                style: TextStyle(color: Colors.white, fontSize: 30),
              ),
            if (isRecording)
              TextButton(
                  onPressed: () {
                    setState(() {
                      isPaused = true;
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    shape: const CircleBorder(),
                    padding: const EdgeInsets.all(5),
                  ),
                  child:
                      const Icon(Icons.pause, color: Colors.black, size: 25)),
            TextButton(
              onPressed: () {
                setState(() {
                  isRecording = !isRecording;
                });
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                shape: const CircleBorder(),
                padding: const EdgeInsets.all(15),
              ),
              child: isRecording
                  ? const Icon(Icons.stop, color: Colors.white, size: 30)
                  : const Icon(Icons.mic, color: Colors.white, size: 30),
            ),
          ],
        ),
      ),
    );
  }
}
