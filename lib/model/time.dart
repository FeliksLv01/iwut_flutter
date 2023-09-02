import 'dart:convert';

class Time {
  Time({
    this.week,
    this.monday,
    this.termStart,
  });

  /// 第几周
  int? week;

  /// 本周周一日期
  DateTime? monday;

  /// 第一周周一日期
  DateTime? termStart;

  factory Time.fromRawJson(String str) => Time.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Time.fromJson(Map<String, dynamic> json) => Time(
        week: json["week"],
        monday: DateTime.parse(json["monday"]),
        termStart: DateTime.parse(json["termStart"]),
      );

  Map<String, dynamic> toJson() => {
        "week": week,
        "monday":
            "${monday!.year.toString().padLeft(4, '0')}-${monday!.month.toString().padLeft(2, '0')}-${monday!.day.toString().padLeft(2, '0')}",
        "termStart":
            "${termStart!.year.toString().padLeft(4, '0')}-${termStart!.month.toString().padLeft(2, '0')}-${termStart!.day.toString().padLeft(2, '0')}",
      };
}
