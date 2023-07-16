class Reminder {
  final int reminderId;
  final DateTime createTimestamp;
  final DateTime notifyTimestamp;
  late String reminderDescription;
  late String userId;

  Reminder(this.reminderId, this.createTimestamp, this.notifyTimestamp, this.reminderDescription, this.userId);

  Reminder.fromJson(Map<String, dynamic> json)
      : reminderId = json['reminderId'] as int,
        createTimestamp = DateTime.parse(json['createTimestamp']),
        notifyTimestamp = DateTime.parse(json['notifyTimestamp']),
        reminderDescription = json['reminderDescription'] as String,
        userId = json['userId'] as String;

  Map<String, dynamic> toJson() => {
        'reminderId': reminderId,
        'createTimestamp': createTimestamp.toIso8601String(),
        'notifyTimestamp': notifyTimestamp.toIso8601String(),
        'reminderDescription': reminderDescription,
        'userId': userId,
      };
}