class BEResponse {
  final dynamic payload;
  BEResponse(this.payload);
  
  BEResponse.fromJson(Map<String, dynamic> json)
      : payload = json['payload'];

  Map<String, dynamic> toJson() => {
    'payload': payload
  };
}
