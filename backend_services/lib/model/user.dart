class User {
  final String userId;
  final String? instanceCode;
  final String? profile;

  User(this.userId, this.instanceCode, this.profile);


  User.fromJson(Map<String, dynamic> json)
      : userId = json['userId'] as String,
        instanceCode = json['instanceCode'] as String?,
        profile = json['profile'] as String?;


  Map<String, dynamic> toJson() => {
        'userId': userId,
        'instanceCode': instanceCode,
        'profile': profile,
      };
}