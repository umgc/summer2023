import 'dart:convert';

final JsonUtil jsonUtil = JsonUtil();

class JsonUtil {
  String toJson(Map<String, String> object) {
    JsonEncoder encoder = JsonEncoder.withIndent('  ');
    String prettyprint = encoder.convert(json);
    return prettyprint;
  }
}
