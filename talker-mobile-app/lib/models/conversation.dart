class Conversation {
  final String title;
  final DateTime recordedDate;
  final Duration duration;
  final String content;
  final String audioFilePath;

  Conversation(
      {required this.title,
      required this.recordedDate,
      required this.duration,
      required this.content,
      required this.audioFilePath});
}
