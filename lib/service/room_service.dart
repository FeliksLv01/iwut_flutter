import 'package:dio/dio.dart';
import 'package:iwut_flutter/config/log/log.dart';
import 'package:iwut_flutter/http/http_request.dart';
import 'package:iwut_flutter/http/server_url.dart';
import 'package:iwut_flutter/model/room/room_model.dart';
import 'package:iwut_flutter/utils/date_util.dart';
import 'package:iwut_flutter/utils/device_util.dart';

class RoomService {
  static Future getRoomList(List<int> sections, OnSuccessList onSuccess, OnFail onFail) async {
    try {
      // 1. 获取请求所需要的相关参数
      final deviceID = await DeviceUtil.getDeviceId();
      final weekIndex = DateUtil().getWeekIndex();
      final dayIndex = DateUtil.getDayIndex();
      Log.debug("deviceID:$deviceID", tag: '网络');
      final Options options = Options(headers: {"DeviceID": deviceID});
      // 2. 对传入的section列表中的每一个section都进行一次请求，将请求得到的自习室列表放入一个列表当中
      var sectionRoomList = List<List<RoomData>?>.filled(0, null, growable: true);
      for (final section in sections) {
        final Map<String, dynamic> param = {"week": weekIndex, "day": dayIndex, "section": section};
        final res = await HttpRequest.instance!.get(ServerUrl.ROOM_URL, parameters: param, options: options);
        // 2.1. 处理请求返回结果
        if (res["code"] != 0) {
          onFail("网络请求异常");
        } else {
          final roomRes = RoomResponse.fromJson(res);
          sectionRoomList.add(roomRes.data);
        }
      }
      // 3. 合并列表，只保留那些存在于所有列表的自习室
      final usableRoomList = sectionRoomList.reduce((current, forward) {
        current!.removeWhere((element) => !forward!.contains(element));
        return current;
      });
      onSuccess(usableRoomList);
    } catch (e) {
      Log.error(e.toString(), tag: '网络');
      onFail("网络请求异常");
    }
  }
}
