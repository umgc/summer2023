class Recording {
  final String guid;
  int timestamp;
  late String filePath;
  late String transcript;
  late String customDescription;
  late String gptDescription;
  String userId;
  late String location;

  Recording(this.guid, this.timestamp, this.userId);

  Recording.fromJson(Map<String, dynamic> json)
      : guid = json['guid'],
        timestamp = json['timestamp'],
        filePath = json['filePath'],
        transcript = json['transcript'],
        customDescription = json['customDescription'],
        gptDescription = json['gptDescription'],
        userId = json['userId'],
        location = json['location'];

  Map<String, dynamic> toJson() => {
        'guid': guid,
        'timestamp': timestamp,
        'filePath': filePath,
        'transcript': transcript,
        'customDescription': customDescription,
        'gptDescription': gptDescription,
        'userId': userId,
        'location': location,
      };
}
