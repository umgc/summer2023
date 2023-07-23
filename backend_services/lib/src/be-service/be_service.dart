import 'dart:convert';

import 'package:backend_services/model/be_request.dart';
import 'package:backend_services/src/be-service/app_instance_code.dart';
import 'package:stomp_dart_client/stomp_frame.dart';

import '../../interfaces/json_storage.dart';
import '../ambients.dart';
import '../utilities/json_util.dart';

class BEService {
  final JsonStorage _storage;
  static const String _appInstanceCodeFileName = 'appInstanceCode.json';

  BEService(this._storage);

  BERequest? _request;

  void handleRequestFrame(StompFrame frame, Function(BERequest) handleRequest) {
    if (frame.body == null || frame.body!.isEmpty) {
      log.w("Received empty body on form fill request");
      return;
    }
    log.d("Received form fill request, processing request");
    var request = parseRequestFromFrame(frame);
    if (request != null) {
      try {
        handleRequest(request);
      } catch (error) {
        log.e("Error handling brower extension request.", error);
      }
    }
  }

  void storeRequest(BERequest request) {
    _request = request;
  }

  BERequest? getLastRequest() {
    return _request;
  }

  BERequest? parseRequestFromFrame(StompFrame frame) {
    try {
      var body = jsonDecode(frame.body!);
      var request = BERequest.fromJson(jsonDecode(body["content"]));
      log.i(
          "Parsed incoming form-fill request: ${jsonUtil.toJsonPretty(request)}");
      return request;
    } catch (error) {
      log.e("Malformed brower extension request: ${frame.body}", error);
    }
    return null;
  }

  Future<void> saveAppInstanceCode(String instanceCode) async {
    var appInstanceCode = AppInstanceCode(instanceCode);
    await _storage.saveToPath(_appInstanceCodeFileName, appInstanceCode);
  }

  Future<String> loadAppInstanceCode() async {
    if (!await _storage.doesExist(_appInstanceCodeFileName)) {
      return '';
    }

    var appInstanceCode = await _storage.loadFromPath(
        _appInstanceCodeFileName, AppInstanceCode.fromJson);
    return appInstanceCode.value;
  }
}
