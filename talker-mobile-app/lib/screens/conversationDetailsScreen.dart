import 'dart:async';
import 'dart:ui';

import 'package:audio_waveforms/audio_waveforms.dart';
import 'package:backend_services/backend_services_exports.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:panara_dialogs/panara_dialogs.dart';
import 'package:provider/provider.dart';

import '../globals.dart';
import '../widgets/transmogListItem.dart';

class ConversationDetailsScreen extends StatefulWidget {
  const ConversationDetailsScreen({Key? key}) : super(key: key);

  @override
  State<ConversationDetailsScreen> createState() =>
      _ConversationDetailsScreenState();
}

class _ConversationDetailsScreenState extends State<ConversationDetailsScreen> {
  final controller = TextEditingController();
  late ConversationsProvider conversationsProvider;
  int selectedIndex = 0;
  bool isEditing = false;
  late String audioPath;
  late PlayerController playerController;
  late StreamSubscription<PlayerState> playerStateSubscription;

  final playerWaveStyle = const PlayerWaveStyle(
      scaleFactor: 125,
      fixedWaveColor: Colors.grey,
      liveWaveColor: Colors.white);

  @override
  void initState() {
    super.initState();
    conversationsProvider =
        Provider.of<ConversationsProvider>(context, listen: false);
    controller.text = conversationsProvider.selectedConversation!.title;
    var path =
        "${conversationsProvider.appDirectory.path}/${conversationsProvider.selectedConversation?.id}.m4a";
    playerController = PlayerController();
    _preparePlayer(path);
    playerStateSubscription = playerController.onPlayerStateChanged.listen((_) {
      setState(() {});
    });
  }

  void _preparePlayer(String path) async {
    var screenWidth =
        (window.physicalSize.shortestSide / window.devicePixelRatio);
    playerController.preparePlayer(
        path: path,
        shouldExtractWaveform: true,
        noOfSamples: playerWaveStyle.getSamplesForWidth(screenWidth - 150),
        volume: 3.0);
  }

  void _playOrPauseAudio() async {
    if (playerController.playerState == PlayerState.playing) {
      await playerController.pausePlayer();
    } else {
      await playerController.startPlayer(finishMode: FinishMode.pause);
    }
  }

  Future<void> updateConversationTitle() async {
    if (controller.text.trim().isEmpty) {
      controller.text = conversationsProvider.selectedConversation!.title;
    }
    conversationsProvider.updateConversationTitle(
        conversationsProvider.selectedConversation!.id, controller.text.trim());
    setState(() {
      isEditing = false;
    });
  }

  @override
  void dispose() {
    playerStateSubscription.cancel();
    playerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Conversation? conversation =
        conversationsProvider.selectedConversation;

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

    String getResultsToShow() {
      String transmogResult = "";
      if (selectedIndex == 0) {
        transmogResult =
            conversationsProvider.selectedConversation!.transcript.isEmpty
                ? "Transmogrifying..."
                : conversationsProvider.selectedConversation!.transcript;
      } else if (selectedIndex == 1) {
        transmogResult =
            conversationsProvider.selectedConversation!.gptDescription.isEmpty
                ? "Transmogrifying..."
                : conversationsProvider.selectedConversation!.gptDescription;
      } else if (selectedIndex == 2) {
        transmogResult = 
            conversationsProvider.selectedConversation!.gptReminders.isEmpty
                ? "Transmogrifying..."
                : conversationsProvider.selectedConversation!.gptReminders;
      } else {
        transmogResult = 
            conversationsProvider.selectedConversation!.gptFoodOrder.isEmpty
                ? "Transmogrifying..."
                : conversationsProvider.selectedConversation!.gptFoodOrder;
      }

      return transmogResult;
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
                onTap: () {
                  if (conversationsProvider.selectedConversation!.gptDescription.isEmpty) {
                  getIt<Agent>().getOpenAiSummary(conversationsProvider.selectedConversation!.id);
                  }
                  onTransmogPress(1);
                }
                ),
            TransmogListItem(
                icon: Icons.notifications_active,
                title: "Reminders",
                showHighlight: selectedIndex == 2,
                onTap: () {
                if (conversationsProvider.selectedConversation!.gptReminders.isEmpty) {
                  getIt<Agent>().getOpenAiReminders(conversationsProvider.selectedConversation!.id);
                  }
                onTransmogPress(2);
                }
                ),
            TransmogListItem(
                icon: Icons.restaurant,
                title: "Food Order",
                showHighlight: selectedIndex == 3,
                onTap: () {
                  if (conversationsProvider.selectedConversation!.gptFoodOrder.isEmpty) {
                  getIt<Agent>().getOpenAiFoodOrder(conversationsProvider.selectedConversation!.id);
                  }
                  onTransmogPress(3);
                }
                )
          ],
        ),
      );
    }

    Future<void> onDeletePress() async {
      PanaraConfirmDialog.show(context,
          message:
              "Are you sure you want to permanently delete this conversation?",
          color: const Color(0xFF8900F8),
          confirmButtonText: "OK",
          cancelButtonText: "Cancel", onTapConfirm: () async {
        conversationsProvider.removeConversation(conversation!);
        Navigator.of(context).popUntil((route) => route.isFirst);
      }, onTapCancel: () {
        Navigator.of(context).pop();
      }, panaraDialogType: PanaraDialogType.custom);
    }

    void clearTitleText() {
      controller.clear();
    }

    Widget buildTitleWidget() {
      if (isEditing) {
        return TextField(
            onTapOutside: (event) {
              FocusManager.instance.primaryFocus?.unfocus();
              updateConversationTitle();
            },
            textInputAction: TextInputAction.done,
            onSubmitted: (value) {
              updateConversationTitle();
            },
            controller: controller,
            textAlignVertical: TextAlignVertical.center,
            cursorColor: Colors.white,
            decoration: InputDecoration(
                filled: true,
                fillColor: const Color(0xFF262626),
                enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: const BorderSide(color: Colors.transparent)),
                contentPadding: const EdgeInsets.all(0),
                hintStyle: const TextStyle(color: Colors.grey),
                suffixIcon: IconButton(
                  onPressed: () => clearTitleText(),
                  icon: const Icon(Icons.clear),
                  color: Colors.white,
                ),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: const BorderSide(color: Colors.transparent)),
                focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: const BorderSide(color: Colors.transparent))),
            textAlign: TextAlign.center,
            style: const TextStyle(color: Colors.white));
      }

      return TextButton(
          onPressed: () {
            setState(() {
              isEditing = true;
            });
          },
          onLongPress: () {
            setState(() {
              isEditing = true;
            });
          },
          child: Text(
            conversation!.title,
            style: const TextStyle(
                color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
          ));
    }

    return Consumer<ConversationsProvider>(
      builder: (context, provider, child) {
        return Scaffold(
          backgroundColor: Colors.black,
          appBar: AppBar(
            title: buildTitleWidget(),
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white),
              key: const Key('btnBack'),
              onPressed: () => Navigator.of(context).pop(),
            ),
            centerTitle: true,
            backgroundColor: Colors.black,
            actions: <Widget>[
              IconButton(
                  key: const Key('btnDelete'),
                  onPressed: onDeletePress,
                  icon: const Icon(
                    Icons.delete,
                    color: Colors.white,
                  ))
            ],
          ),
          body: Container(
            margin: const EdgeInsets.only(left: 10, top: 25, right: 10),
            child: Column(
              key: const Key('ctnrColumns'),
              children: [
                renderDateAndDuration(),
                renderTransmogRow(),
                Expanded(
                  child: SingleChildScrollView(
                  child: Column(
                    key: const Key('colResults'),
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        width: double.infinity,
                        margin: const EdgeInsets.only(top: 25),
                        padding: const EdgeInsets.all(15),
                        decoration: const BoxDecoration(
                            color: Color(0xFF262626),
                            borderRadius:
                                BorderRadius.all(Radius.circular(30))),
                        child: Text(getResultsToShow(),
                            key: const Key('txtResults'),
                            style: const TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                height: 1.5)),
                      ),
                      Container(
                        width: double.infinity,
                        height: 70,
                        margin: const EdgeInsets.only(bottom: 10),
                        decoration: const BoxDecoration(
                            color: Color(0xFF8900F8),
                            borderRadius:
                                BorderRadius.all(Radius.circular(10))),
                        child: Row(
                          key: const Key('audioPlayer'),
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            IconButton(
                                key: const Key('btnPlayPause'),
                                onPressed: _playOrPauseAudio,
                                icon: Icon(
                                    playerController.playerState.isPlaying
                                        ? Icons.pause
                                        : Icons.play_arrow_rounded,
                                    color: Colors.white,
                                    size: 40)),
                            Expanded(
                              child: AudioFileWaveforms(
                                key: const Key('audioWave'),
                                enableSeekGesture: true,
                                waveformType: WaveformType.fitWidth,
                                size: Size(
                                    MediaQuery.of(context).size.width - 100,
                                    90),
                                playerController: playerController,
                                continuousWaveform: true,
                                playerWaveStyle: playerWaveStyle,
                              ),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
