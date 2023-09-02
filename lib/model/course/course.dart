import 'dart:convert';

import 'package:floor/floor.dart';
import 'package:iwut_flutter/model/course/course_model.dart';

/// 用于显示
@entity
class Course {
  /// 主键
  @primaryKey
  int? id;

  /// 课程名
  String? name;

  /// 授课教师
  String? teacher;

  /// 上课地点
  String? room;

  /// 开始周
  int? weekStart;

  /// 结束周
  int? weekEnd;

  /// 开始节
  int? sectionStart;

  /// 结束节
  int? sectionEnd;

  /// 星期
  int? weekDay;

  /// 方格颜色Index
  int? boxColor;

  /// 多课程格子的优先展示顺序
  int? priority;

  Course({
    this.id,
    this.name,
    this.teacher,
    this.room,
    this.weekStart,
    this.weekEnd,
    this.sectionStart,
    this.sectionEnd,
    this.weekDay,
    this.boxColor = -1,
    this.priority = 0,
  });

  int? get color => boxColor;

  set color(int? setColorIndex) {
    this.boxColor = setColorIndex;
  }

  static Course fromData(CourseModel courseModel) {
    return Course(
      name: courseModel.name,
      teacher: courseModel.teacher,
      room: courseModel.room,
      weekStart: courseModel.weekStart,
      weekEnd: courseModel.weekEnd,
      sectionStart: courseModel.sectionStart,
      sectionEnd: courseModel.sectionEnd,
      weekDay: courseModel.weekDay,
    );
  }

  factory Course.fromRawJson(String str) => Course.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Course.fromJson(Map<String, dynamic> json) => Course(
        name: json["name"],
        teacher: json["teacher"],
        room: json["room"],
        weekStart: json["weekStart"],
        weekEnd: json["weekEnd"],
        sectionStart: json["sectionStart"],
        sectionEnd: json["sectionEnd"],
        weekDay: json["weekDay"],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "teacher": teacher,
        "room": room,
        "weekStart": weekStart,
        "weekEnd": weekEnd,
        "sectionStart": sectionStart,
        "sectionEnd": sectionEnd,
        "weekDay": weekDay,
      };

  static Course fromDynamic(dynamic courseModel) {
    if (courseModel.priority == null) courseModel.priority = 0;
    return Course(
      id: courseModel.id,
      name: courseModel.name,
      teacher: courseModel.teacher,
      room: courseModel.room,
      weekStart: courseModel.weekStart,
      weekEnd: courseModel.weekEnd,
      sectionStart: courseModel.sectionStart,
      sectionEnd: courseModel.sectionEnd,
      weekDay: courseModel.weekDay,
      boxColor: courseModel.boxColor,
      priority: courseModel.priority,
    );
  }

  static List<Course> fromDynamicList(List<dynamic> courseModel) {
    List<Course> result = [];
    courseModel.forEach((element) {
      result.add(fromDynamic(element));
    });
    return result;
  }

  static Course init(int? weekDay, int? sectionStart, int? sectionEnd) {
    return Course(
      name: '',
      teacher: '',
      room: '',
      weekStart: 1,
      weekEnd: 1,
      sectionStart: sectionStart,
      sectionEnd: sectionEnd,
      weekDay: weekDay,
    );
  }

  @override
  bool operator ==(dynamic other) {
    if (other is! Course) return false;
    if (this.id == other.id) {
      return true;
    }
    return false;
  }

  @override
  int get hashCode => super.hashCode;

  bool isValid() {
    if (name == null || name!.isEmpty || weekStart == null || sectionStart == null) {
      return false;
    }
    return true;
  }
}
