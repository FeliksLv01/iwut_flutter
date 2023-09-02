import 'dart:convert';

class CourseListModel {
  List<CourseModel> courseList;

  CourseListModel(this.courseList);

  factory CourseListModel.fromJson(List<dynamic> parseJson) {
    List<CourseModel> courseList;
    courseList = parseJson.map((e) => CourseModel.fromJson(e)).toList();
    return CourseListModel(courseList);
  }
}

class CourseModel {
  // 课程ID
  String? courseId;

  // 学号
  String? sno;

  // 课程类型
  int? type;

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

  /// 学年学期
  String? xnXq;

  CourseModel(
    this.courseId,
    this.sno,
    this.type,
    this.name,
    this.teacher,
    this.room,
    this.weekStart,
    this.weekEnd,
    this.sectionStart,
    this.sectionEnd,
    this.weekDay,
    this.xnXq,
  );

  factory CourseModel.fromRawJson(String str) => CourseModel.fromJson(json.decode(str));

  factory CourseModel.fromJson(Map<String, dynamic> srcJson) => _$CourseModelFromJson(srcJson);

  Map<String, dynamic> toJson() => _$CourseModelToJson(this);
}

CourseModel _$CourseModelFromJson(Map<String, dynamic> json) {
  return CourseModel(
    json['courseId'] as String?,
    json['sno'] as String?,
    json['type'] as int?,
    json['name'] as String?,
    json['teacher'] as String?,
    json['room'] as String?,
    json['weekStart'] as int?,
    json['weekEnd'] as int?,
    json['sectionStart'] as int?,
    json['sectionEnd'] as int?,
    json['weekDay'] as int?,
    json['xnXq'] as String?,
  );
}

Map<String, dynamic> _$CourseModelToJson(CourseModel instance) => <String, dynamic>{
      'courseId': instance.courseId,
      'sno': instance.sno,
      'type': instance.type,
      'name': instance.name,
      'teacher': instance.teacher,
      'room': instance.room,
      'weekStart': instance.weekStart,
      'weekEnd': instance.weekEnd,
      'sectionStart': instance.sectionStart,
      'sectionEnd': instance.sectionEnd,
      'weekDay': instance.weekDay,
      'xnXq': instance.xnXq,
    };
