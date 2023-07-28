class BERequest {
  final String pin; // required
  final dynamic form; // optional, either form or formHtml should be defined
  final String? formHtml; // optional, as above
  final bool shouldExtractFromHtml; // optional, defaults to false
  BERequest(this.pin, this.form,
      {this.formHtml, this.shouldExtractFromHtml = false});

  BERequest.withFormHtml(String pin, String formHtml)
      : this(pin, null, formHtml: formHtml, shouldExtractFromHtml: true);

  BERequest.fromJson(Map<String, dynamic> json)
      : pin = json['pin'],
        form = json['form'],
        formHtml = json['formHtml'],
        shouldExtractFromHtml = json['shouldExtractFromHtml'] ?? false;

  Map<String, dynamic> toJson() => {
        'pin': pin,
        'form': form,
        'formHtml': formHtml,
        'shouldExtractFromHtml': shouldExtractFromHtml
      };
}
