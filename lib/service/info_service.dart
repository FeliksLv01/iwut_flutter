import 'package:iwut_flutter/config/log/log.dart';
import 'package:iwut_flutter/http/http_request.dart';
import 'package:iwut_flutter/http/server_url.dart';
import 'package:iwut_flutter/model/info/push_info.dart';
import 'package:iwut_flutter/model/info/update_info.dart';

class InfoService {
  static Future getUpdateInfo(OnSuccess onSuccess) async {
    try {
      var response = await HttpRequest.instance!.get(ServerUrl.UPDATE_INFO);
      if (response['code'] == 0) {
        UpdateInfo updateInfo = UpdateInfo.fromJson(response['data']);
        onSuccess(updateInfo);
      }
    } catch (e) {
      Log.error(e.toString(), tag: '网络');
    }
  }

  static Future getPushInfo(OnSuccess onSuccess) async {
    try {
      var response = await HttpRequest.instance!.get(ServerUrl.TEST_PUSH);
      if (response['code'] == 0) {
        if (response['data'].length == 0) return;
        List<dynamic> pushInfoList = response['data'].map((e) => PushInfo.fromJson(e)).toList();
        PushInfo? result = pushInfoList.firstWhere((it) => it.type == PushType.Banner.index);
        if (result != null) {
          onSuccess(result);
        }
      } else {
        Log.error('网络请求异常', tag: '网络');
      }
    } catch (e) {
      Log.error(e.toString(), tag: '网络');
    }
  }
}
