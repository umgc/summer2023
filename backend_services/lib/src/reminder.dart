class Reminder {
  final int reminderId;
  final int createTimestamp;
  final int notifyTimestamp;
  late String reminderDescription;
  late String userId;

  Reminder(this.reminderId, this.createTimestamp, this.notifyTimestamp);

  Reminder.fromJson(Map<String, dynamic> json)
      : reminderId = json['reminderId'],
        createTimestamp = json['createTimestamp'],
        notifyTimestamp = json['notifyTimestamp'],
        reminderDescription = json['reminderDescription'],
        userId = json['userId'];

  Map<String, dynamic> toJson() => {
        'reminderId': reminderId,
        'createTimestamp': createTimestamp,
        'notifyTimestamp': notifyTimestamp,
        'reminderDescription': reminderDescription,
        'userId': userId,
      };
}
