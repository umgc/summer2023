// Ignore warnings for buildDialog/buildErrorDialog, as the check context.mounted, which should
// prevent issues with contexts unmounted during async gaps
// ignore_for_file: use_build_context_synchronously

import 'dart:io';

import 'package:audio_session/audio_session.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:flutter_sound_platform_interface/flutter_sound_recorder_platform_interface.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:test_recorder/dialog.dart';

void main() {
  runApp(const MyApp());
}

/// A constant that is true if the application was compiled to run on the web.
const bool kIsWeb = bool.fromEnvironment('dart.library.js_util');

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // TRY THIS: Try running your application with "flutter run". You'll see
        // the application has a blue toolbar. Then, without quitting the app,
        // try changing the seedColor in the colorScheme below to Colors.green
        // and then invoke "hot reload" (save your changes or press the "hot
        // reload" button in a Flutter-supported IDE, or press "r" if you used
        // the command line to start the app).
        //
        // Notice that the counter didn't reset back to zero; the application
        // state is not lost during the reload. To reset the state, use hot
        // restart instead.
        //
        // This works for code too, not just values: Most code changes can be
        // tested with just a hot reload.
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.yellow),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Test Recorder'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final _audioSource = AudioSource.microphone;
  String? _name;
  String? _filePath;
  Codec _codec = Codec.aacMP4;
  String _extension = ".mp4";
  FlutterSoundRecorder? _mRecorder = FlutterSoundRecorder();
  bool _isRecorderInited = false;
  bool _canStartRecording = false;
  bool _isRecording = false;
  bool _hasRecording = false;

  FlutterSoundPlayer? _mPlayer = FlutterSoundPlayer();
  bool _mPlayerIsInited = false;
  bool _mplaybackReady = true;
  bool _isPlaying = false;

  void _textChanged(value) {
    setState(() {
      _name = value;
      _canStartRecording = value != '';
      _hasRecording = false;
    });
  }

  Future<void> _startRecording() async {
    _stopRecording();
    try {
      // Request Microphone permission if needed
      final status = await Permission.microphone.request();
      if (status != PermissionStatus.granted) {
        throw RecordingPermissionException("Microphone permission not granted");
      }

      var dir = await getApplicationDocumentsDirectory();

      await _mRecorder?.startRecorder(
        toFile: _filePath,
        codec: _codec,
        audioSource: _audioSource,
      );
      setState(() {
        _filePath = '${dir.path}/$_name$_extension';
        _isRecording = true;
        _mplaybackReady = false;
      });
    } catch (error) {
      buildErrorDialog(context, error);
    }
  }

  Future<void> showFinished() async {
    if (!context.mounted) return;
    var file = File(_filePath!);
    var fileSize = await file.length();
    print('Wrote file: filePath: $_filePath, length: ${fileSize}');
    buildDialog(context, 'Recording Finished',
        'filePath: $_filePath, length: ${fileSize}');
    setState(() {
      _hasRecording = true;
      _mplaybackReady = true;
    });
  }

  Future<void> _stopRecording() async {
    try {
      if (_isRecorderInited && _isRecording) {
        await _mRecorder?.stopRecorder().then((value) => showFinished());
      }
      setState(() {
        _isRecording = false;
      });
    } catch (error) {
      buildErrorDialog(context, error);
    }
  }

  void _startPlayer() async {
    if (!_hasRecording) return;
    assert(_mPlayerIsInited &&
        _mplaybackReady &&
        _mRecorder!.isStopped &&
        _mPlayer!.isStopped);
    _mPlayer!
        .startPlayer(
            fromURI: _filePath,
            //codec: kIsWeb ? Codec.opusWebM : Codec.aacADTS,
            whenFinished: () {
              setState(() {
                _isPlaying = false;
              });
            })
        .then((value) {
      setState(() {
        _isPlaying = true;
      });
    });
  }

  void _stopPlayer() {
    _mPlayer!.stopPlayer().then((value) {
      setState(() {
        _isPlaying = false;
      });
    });
  }

  @override
  void initState() {
    _mPlayer!.openPlayer().then((value) {
      setState(() {
        _mPlayerIsInited = true;
      });
    });

    openTheRecorder().then((value) {
      setState(() {
        _isRecorderInited = true;
      });
    });
    super.initState();
  }

  Future<void> openTheRecorder() async {
    if (!kIsWeb) {
      var status = await Permission.microphone.request();
      if (status != PermissionStatus.granted) {
        throw RecordingPermissionException('Microphone permission not granted');
      }
    }
    await _mRecorder!.openRecorder();
    if (!await _mRecorder!.isEncoderSupported(_codec) && kIsWeb) {
      _codec = Codec.opusWebM;
      _extension = '.webm';
      if (!await _mRecorder!.isEncoderSupported(_codec) && kIsWeb) {
        _isRecorderInited = true;
        return;
      }
    }
    final session = await AudioSession.instance;
    await session.configure(AudioSessionConfiguration(
      avAudioSessionCategory: AVAudioSessionCategory.playAndRecord,
      avAudioSessionCategoryOptions:
          AVAudioSessionCategoryOptions.allowBluetooth |
              AVAudioSessionCategoryOptions.defaultToSpeaker,
      avAudioSessionMode: AVAudioSessionMode.spokenAudio,
      avAudioSessionRouteSharingPolicy:
          AVAudioSessionRouteSharingPolicy.defaultPolicy,
      avAudioSessionSetActiveOptions: AVAudioSessionSetActiveOptions.none,
      androidAudioAttributes: const AndroidAudioAttributes(
        contentType: AndroidAudioContentType.speech,
        flags: AndroidAudioFlags.none,
        usage: AndroidAudioUsage.voiceCommunication,
      ),
      androidAudioFocusGainType: AndroidAudioFocusGainType.gain,
      androidWillPauseWhenDucked: true,
    ));

    _isRecorderInited = true;
  }

  @override
  void dispose() {
    if (_mPlayer != null) {
      _mPlayer!.closePlayer();
      _mPlayer = null;
    }
    if (_mRecorder != null) {
      _stopRecording();
      _mRecorder?.closeRecorder();
      _mRecorder = null;
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // TRY THIS: Try changing the color here to a specific color (to
        // Colors.amber, perhaps?) and trigger a hot reload to see the AppBar
        // change color while the other colors stay the same.
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          // Column is also a layout widget. It takes a list of children and
          // arranges them vertically. By default, it sizes itself to fit its
          // children horizontally, and tries to be as tall as its parent.
          //
          // Column has various properties to control how it sizes itself and
          // how it positions its children. Here we use mainAxisAlignment to
          // center the children vertically; the main axis here is the vertical
          // axis because Columns are vertical (the cross axis would be
          // horizontal).
          //
          // TRY THIS: Invoke "debug painting" (choose the "Toggle Debug Paint"
          // action in the IDE, or press "p" in the console), to see the
          // wireframe for each widget.
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ListTile(
              leading: const Icon(Icons.list_alt_rounded),
              title: Row(
                children: <Widget>[
                  Expanded(
                    child: TextField(
                      decoration: const InputDecoration(
                        hintText: 'Name',
                        enabledBorder: UnderlineInputBorder(),
                      ),
                      onChanged: (value) => _textChanged(value),
                    ),
                  ),
                ],
              ),
            ),
            ListTile(
                leading: const Icon(Icons.save),
                title: Row(
                  children: [
                    const Text('File: '),
                    Expanded(child: Text(_filePath != null ? _filePath! : ''))
                  ],
                )),
            !_isRecorderInited
                ? const Text('Initializing recorder...')
                : const Text(''),
            const SizedBox(height: 40.0),
            !_isRecording
                ? ElevatedButton(
                    onPressed: _canStartRecording ? _startRecording : null,
                    style: ButtonStyle(
                      foregroundColor:
                          MaterialStateProperty.all<Color>(Colors.white),
                      backgroundColor: _canStartRecording
                          ? MaterialStateProperty.all<Color>(Colors.red)
                          : MaterialStateProperty.all<Color>(
                              Colors.red.shade200),
                      overlayColor: MaterialStateProperty.resolveWith<Color?>(
                        (Set<MaterialState> states) {
                          if (states.contains(MaterialState.hovered)) {
                            return Colors.white.withOpacity(0.2);
                          }
                          if (states.contains(MaterialState.focused) ||
                              states.contains(MaterialState.pressed)) {
                            return Colors.grey.withOpacity(0.3);
                          }
                          return null; // Defer to the widget's default.
                        },
                      ),
                    ),
                    child: const Padding(
                        padding: EdgeInsets.all(20.0),
                        child: Icon(Icons.record_voice_over)))
                : ElevatedButton(
                    onPressed: _stopRecording,
                    style: ButtonStyle(
                      foregroundColor:
                          MaterialStateProperty.all<Color>(Colors.white),
                      backgroundColor: _isRecorderInited && _canStartRecording
                          ? MaterialStateProperty.all<Color>(
                              Colors.grey.shade400)
                          : MaterialStateProperty.all<Color>(
                              Colors.red.shade200),
                      overlayColor: MaterialStateProperty.resolveWith<Color?>(
                        (Set<MaterialState> states) {
                          if (states.contains(MaterialState.hovered)) {
                            return Colors.white.withOpacity(0.2);
                          }
                          if (states.contains(MaterialState.focused) ||
                              states.contains(MaterialState.pressed)) {
                            return Colors.grey.withOpacity(0.3);
                          }
                          return null; // Defer to the widget's default.
                        },
                      ),
                    ),
                    child: const Padding(
                        padding: EdgeInsets.all(20.0),
                        child: Icon(Icons.voice_over_off))),
            const SizedBox(height: 20.0),
            !_isPlaying
                ? ElevatedButton(
                    onPressed: _startPlayer,
                    style: ButtonStyle(
                      foregroundColor:
                          MaterialStateProperty.all<Color>(Colors.white),
                      backgroundColor: !_hasRecording || !_mplaybackReady
                          ? MaterialStateProperty.all<Color>(
                              Colors.red.shade200)
                          : MaterialStateProperty.all<Color>(Colors.red),
                      overlayColor: MaterialStateProperty.resolveWith<Color?>(
                        (Set<MaterialState> states) {
                          if (states.contains(MaterialState.hovered)) {
                            return Colors.white.withOpacity(0.2);
                          }
                          if (states.contains(MaterialState.focused) ||
                              states.contains(MaterialState.pressed)) {
                            return Colors.grey.withOpacity(0.3);
                          }
                          return null; // Defer to the widget's default.
                        },
                      ),
                    ),
                    child: const Padding(
                        padding: EdgeInsets.all(20.0),
                        child: Icon(Icons
                            .play_arrow))) // This trailing comma makes auto-formatting nicer for build methods
                : ElevatedButton(
                    onPressed: _stopPlayer,
                    style: ButtonStyle(
                      foregroundColor:
                          MaterialStateProperty.all<Color>(Colors.white),
                      backgroundColor: MaterialStateProperty.all<Color>(
                          Colors.grey.shade200),
                      overlayColor: MaterialStateProperty.resolveWith<Color?>(
                        (Set<MaterialState> states) {
                          if (states.contains(MaterialState.hovered)) {
                            return Colors.white.withOpacity(0.2);
                          }
                          if (states.contains(MaterialState.focused) ||
                              states.contains(MaterialState.pressed)) {
                            return Colors.grey.withOpacity(0.3);
                          }
                          return null; // Defer to the widget's default.
                        },
                      ),
                    ),
                    child: const Padding(
                        padding: EdgeInsets.all(20.0), child: Icon(Icons.stop)))
          ],
        ),
      ),
    );
  }
}
