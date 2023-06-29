class Conversation {
  final String id;
  final String title;
  final DateTime recordedDate;
  final Duration duration;
  final String content;
  final String audioFilePath;

  Conversation(
      {required this.id,
      required this.title,
      required this.recordedDate,
      required this.duration,
      required this.content,
      required this.audioFilePath});

  Conversation.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        title = json['title'],
        recordedDate = DateTime.parse(json['recordedDate']),
        duration = Duration(milliseconds: json['duration']),
        content = json['content'],
        audioFilePath = json['audioFilePath'];

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'recordedDate': recordedDate.toIso8601String(),
        'duration': duration.inMilliseconds,
        'content': content,
        'audioFilePath': audioFilePath
      };
}
