class Reminder {
  final int reminderId;
  final int createTimestamp;
  final int notifyTimestamp;
  late String reminderDescription;
  late String userId;

  Reminder(this.reminderId, this.createTimestamp, this.notifyTimestamp, this.reminderDescription, this.userId);

  Reminder.fromJson(Map<String, dynamic> json)
      : reminderId = json['reminderId'] as int,
        createTimestamp = json['createTimestamp'] as int,
        notifyTimestamp = json['notifyTimestamp'] as int,
        reminderDescription = json['reminderDescription'] as String,
        userId = json['userId'] as String;

  Map<String, dynamic> toJson() => {
        'reminderId': reminderId,
        'createTimestamp': createTimestamp,
        'notifyTimestamp': notifyTimestamp,
        'reminderDescription': reminderDescription,
        'userId': userId,
      };
}