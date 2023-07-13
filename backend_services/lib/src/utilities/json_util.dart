import 'dart:convert';

final JsonUtil jsonUtil = JsonUtil();

class JsonUtil {
  String toJsonPretty(dynamic object) {
    JsonEncoder encoder = JsonEncoder.withIndent('  ');
    String prettyprint = encoder.convert(object);
    return prettyprint;
  }
}
