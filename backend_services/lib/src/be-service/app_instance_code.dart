class AppInstanceCode {
  AppInstanceCode(this.value);
  AppInstanceCode.fromJson(Map<String, dynamic> json) : value = json['value'];

  String value;

  Map<String, dynamic> toJson() => {'value': value};
}
