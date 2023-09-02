// To parse this JSON data, do
//
//     final pushInfo = pushInfoFromJson(jsonString);

import 'dart:convert';

import 'package:iwut_flutter/http/server_url.dart';

enum PushType { Startup, Popup, NoticeBar, Banner }

class PushInfo {
  PushInfo({
    this.id,
    this.type,
    this.content,
    this.startTime,
  });

  String? id;
  int? type;
  String? content;
  DateTime? startTime;

  factory PushInfo.fromRawJson(String str) => PushInfo.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory PushInfo.fromJson(Map<String, dynamic> json) => PushInfo(
        id: json["id"] == null ? null : json["id"],
        type: json["type"] == null ? null : json["type"],
        content: json["content"] == null ? null : json["content"],
        startTime: json["startTime"] == null ? null : DateTime.parse(json["startTime"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id == null ? null : id,
        "type": type == null ? null : type,
        "content": content == null ? null : content,
        "startTime": startTime == null ? null : startTime!.toIso8601String(),
      };

  String getActivityUrl() {
    return ServerUrl.TEST_PUSH_CALLBACK + "?phone=13007142401&identityId=12345&appId=IWUT&pushId=$id";
  }
}
