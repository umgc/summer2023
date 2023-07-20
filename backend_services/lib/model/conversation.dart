class Conversation {
  final String id;
  final String audioFilePath;
  final DateTime recordedDate;
  final Duration duration;
  String title;
  String transcript;
  String customDescription;
  String gptDescription;
  String gptReminders;
  String gptFoodOrder;

  Conversation(
      {required this.id,
      required this.audioFilePath,
      required this.recordedDate,
      required this.duration,
      this.title = "NewConversation",
      this.transcript = "",
      this.customDescription = "",
      this.gptDescription = "",
      this.gptReminders = "",
      this.gptFoodOrder = ""});

  Conversation.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        audioFilePath = json['audioFilePath'],
        recordedDate = DateTime.parse(json['recordedDate']),
        duration = Duration(milliseconds: int.parse(json['duration'])),
        title = json['title'],
        transcript = json['transcript'] ?? '',
        customDescription = json['customDescription'] ?? '',
        gptDescription = json['gptDescription'] ?? '',
        gptReminders = json['gptReminders'] ?? '',
        gptFoodOrder = json['gptFoodOrder'] ?? '';

  Map<String, dynamic> toJson() => {
        'id': id,
        'audioFilePath': audioFilePath,
        'recordedDate': recordedDate.toIso8601String(),
        'duration': duration.inMilliseconds.toString(),
        'title': title,
        'transcript': transcript,
        'customDescription': customDescription,
        'gptDescription': gptDescription,
        'gptReminders': gptReminders,
        'gptFoodOrder': gptFoodOrder
      };
}
