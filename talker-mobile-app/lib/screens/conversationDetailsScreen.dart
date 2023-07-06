import 'package:audio_waveforms/audio_waveforms.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:talker_mobile_app/globals.dart';
import 'package:talker_mobile_app/models/conversation.dart';
import 'package:talker_mobile_app/state/conversations_provider.dart';

import '../widgets/transmogListItem.dart';

class ConversationDetailsScreen extends StatefulWidget {
  const ConversationDetailsScreen({Key? key}) : super(key: key);

  @override
  State<ConversationDetailsScreen> createState() =>
      _ConversationDetailsScreenState();
}

class _ConversationDetailsScreenState extends State<ConversationDetailsScreen> {
  int selectedIndex = 0;
  final String resultsText = "Transmogrifying...";

  late String audioPath;
  late PlayerController playerController = PlayerController();

  @override
  void initState() {
    super.initState();
  }

  void _playOrPauseAudio() async {
    playerController.playerState == PlayerState.playing
        ? await playerController.pausePlayer()
        : await playerController.startPlayer(finishMode: FinishMode.pause);
  }

  @override
  void dispose() {
    super.dispose();
    playerController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final conversationsProvider = Provider.of<ConversationsProvider>(context);
    final Conversation? conversation =
        conversationsProvider.selectedConversation;
    var path = "${Globals.appDirectory?.path}/${conversation?.id}";
    playerController = PlayerController();
    playerController.preparePlayer(
        path: path,
        shouldExtractWaveform: true,
        noOfSamples: const PlayerWaveStyle()
            .getSamplesForWidth(MediaQuery.of(context).size.width - 100),
        volume: 3.0);

    String getFormattedDuration() {
      final minutes = conversation?.duration.inMinutes;
      final seconds = conversation!.duration.inSeconds % 60;
      final minutesString = '$minutes'.padLeft(2, '0');
      final secondsString = '$seconds'.padLeft(2, '0');
      return '$minutesString:$secondsString';
    }

    Widget renderDateAndDuration() {
      return Container(
        padding:
            const EdgeInsets.only(left: 10, top: 33, right: 10, bottom: 33),
        clipBehavior: Clip.hardEdge,
        decoration: const BoxDecoration(
            color: Color(0xFF262626),
            borderRadius: BorderRadius.all(Radius.circular(25))),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '${DateFormat('MM/dd/yyyy').format(conversation!.recordedDate)}  ${DateFormat.jm().format(conversation.recordedDate)}',
              style: const TextStyle(fontSize: 14, color: Colors.white),
            ),
            Text(
              getFormattedDuration(),
              style: const TextStyle(fontSize: 14, color: Colors.white),
            ),
          ],
        ),
      );
    }

    void onTransmogPress(int index) {
      setState(() {
        selectedIndex = index;
      });
    }

    Widget renderTransmogRow() {
      return Container(
        margin: const EdgeInsets.only(top: 15),
        height: 115,
        child: ListView(
          scrollDirection: Axis.horizontal,
          physics: const BouncingScrollPhysics(),
          children: [
            TransmogListItem(
                icon: Icons.monitor,
                title: "Full Conversation",
                showHighlight: selectedIndex == 0,
                onTap: () => onTransmogPress(0)),
            TransmogListItem(
                icon: Icons.event_note_rounded,
                title: "Summary",
                showHighlight: selectedIndex == 1,
                onTap: () => onTransmogPress(1)),
            TransmogListItem(
                icon: Icons.notifications_active,
                title: "Reminders",
                showHighlight: selectedIndex == 2,
                onTap: () => onTransmogPress(2)),
            TransmogListItem(
                icon: Icons.restaurant,
                title: "Food Order",
                showHighlight: selectedIndex == 3,
                onTap: () => onTransmogPress(3))
          ],
        ),
      );
    }

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text(conversation!.title),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        centerTitle: true,
        backgroundColor: Colors.black,
        actions: const <Widget>[
          IconButton(
              onPressed: null,
              icon: Icon(
                Icons.delete,
                color: Colors.white,
              ))
        ],
      ),
      body: Container(
        margin: const EdgeInsets.only(left: 10, top: 25, right: 10),
        child: Column(
          children: [
            renderDateAndDuration(),
            renderTransmogRow(),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    width: double.infinity,
                    margin: const EdgeInsets.only(top: 25),
                    padding: const EdgeInsets.all(15),
                    decoration: const BoxDecoration(
                        color: Color(0xFF262626),
                        borderRadius: BorderRadius.all(Radius.circular(30))),
                    child: Text(resultsText,
                        style: const TextStyle(
                            color: Colors.white, fontSize: 16, height: 1.5)),
                  ),
                  Container(
                    width: double.infinity,
                    height: 70,
                    margin: const EdgeInsets.only(bottom: 10),
                    decoration: const BoxDecoration(
                        color: Color(0xFF8900F8),
                        borderRadius: BorderRadius.all(Radius.circular(10))),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        IconButton(
                            onPressed: _playOrPauseAudio,
                            icon: const Icon(Icons.play_arrow_rounded,
                                color: Colors.white, size: 40)),
                        Expanded(
                          child: AudioFileWaveforms(
                            enableSeekGesture: true,
                            waveformType: WaveformType.fitWidth,
                            size: Size(
                                MediaQuery.of(context).size.width - 100, 90),
                            playerController: playerController,
                            continuousWaveform: true,
                            playerWaveStyle: const PlayerWaveStyle(
                                scaleFactor: 200,
                                fixedWaveColor: Colors.grey,
                                liveWaveColor: Colors.white),
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
