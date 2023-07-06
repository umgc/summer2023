class Recording {
  final String guid;
  final int timestamp;
  late String? filePath;
  late String? transcript;
  late String? customDescription;
  late String? gptDescription;
  final String userId;
  late String? location;

  Recording(this.guid, this.timestamp, this.filePath, this.transcript, this.customDescription, this.gptDescription, this.userId, this.location);

  Recording.fromJson(Map<String, dynamic> json)
      : guid = json['guid'] as String,
        timestamp = json['timestamp'] as int,
        filePath = json['filePath'] as String?,
        transcript = json['transcript'] as String?,
        customDescription = json['customDescription'] as String?,
        gptDescription = json['gptDescription'] as String?,
        userId = json['userId'] as String,
        location = json['location'] as String?;

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