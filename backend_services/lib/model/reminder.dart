class Reminder {
  final String reminderId;
  final DateTime createTimestamp;
  final DateTime notifyTimestamp;
  late String reminderDescription;
  // JN: SM: recordingId?
  late String guid;

  Reminder(this.reminderId, this.createTimestamp, this.notifyTimestamp,
      this.reminderDescription, this.guid);

  Reminder.fromJson(Map<String, dynamic> json)
      : reminderId = json['reminderId'] as String,
        createTimestamp = DateTime.parse(json['createTimestamp']),
        notifyTimestamp = DateTime.parse(json['notifyTimestamp']),
        reminderDescription = json['reminderDescription'] as String,
        // JN: SM: This needs to be the same as property name in toJson()
        guid = json['guid'] ?? '';

  Map<String, dynamic> toJson() => {
        'reminderId': reminderId,
        'createTimestamp': createTimestamp.toIso8601String(),
        'notifyTimestamp': notifyTimestamp.toIso8601String(),
        'reminderDescription': reminderDescription,
        // JN: SM: looks like this should be recordingId
        'userId': guid,
      };
}
