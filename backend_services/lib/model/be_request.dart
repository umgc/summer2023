class BERequest {
  final String pin;
  final dynamic form;
  BERequest(this.pin, this.form);
  
  BERequest.fromJson(Map<String, dynamic> json)
      : pin = json['pin'],
        form = json['form'];

  Map<String, dynamic> toJson() => {
    'pin': pin,
    'form': form,
  };
}