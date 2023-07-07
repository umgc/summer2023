import 'dart:convert';

import 'package:backend_services/model/be_request.dart';
import 'package:logger/logger.dart';
import 'package:stomp_dart_client/stomp_frame.dart';

import '../utilities/json_util.dart';

class BEService {
  BEService();

  final Logger _logger = Logger();
  BERequest? _request;

  void handleRequestFrame(StompFrame frame, Function(BERequest) handleRequest) {
    if(frame.body == null || frame.body!.isEmpty) {
      _logger.w("Received empty body on form fill request");
      return;
    }
    _logger.d("Received form fill request, processing request");
    var request = parseRequestFromFrame(frame);
    if(request != null) {
      _storeRequest(request);
      try {
        handleRequest(request);
      } catch(error) {
        _logger.e("Error handling brower extension request.", error);
      }
    }
  }

  void _storeRequest(BERequest request) {
    _request = request;
  }

  BERequest? getLastRequest() {
    return _request;
  }
  
  BERequest? parseRequestFromFrame(StompFrame frame) {      
    try {
      var body = jsonDecode(frame.body!);
      var request = BERequest.fromJson(jsonDecode(body["content"]));
      _logger.i("Parsed incoming form-fill request: ${jsonUtil.toJsonPretty(request)}");
      return request;
    } catch(error) {
      _logger.e("Malformed brower extension request: ${frame.body}", error);
    }
    return null;
  }
}