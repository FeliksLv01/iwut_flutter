import 'dart:async';
import 'dart:convert';

import 'package:flutter/services.dart' show rootBundle;
import 'package:iwut_flutter/http/server_url.dart';

///模拟数据
class MockRequest {
  Future<dynamic> get(String action, {Map? params}) async {
    return MockRequest.mock(action: getJsonName(action), params: params);
  }

  static Future<dynamic> post({String? action, Map? params}) async {
    return MockRequest.mock(action: action, params: params);
  }

  static Future<dynamic> mock({String? action, Map? params}) async {
    var responseStr = await rootBundle.loadString('mock/$action.json');
    var responseJson = json.decode(responseStr);
    return responseJson;
  }

  Map<String, String> map = {ServerUrl.UPLOAD_URL: 'course'};

  getJsonName(String action) {
    return map[action];
  }
}
