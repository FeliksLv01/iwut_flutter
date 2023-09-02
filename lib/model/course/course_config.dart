import 'dart:convert';

class CourseThreeConfig {
  CourseThreeConfig({
    this.sectionThreeName,
    this.sectionThreePosition,
  });

  int? sectionThreeName;
  int? sectionThreePosition;

  factory CourseThreeConfig.fromRawJson(String str) => CourseThreeConfig.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory CourseThreeConfig.fromJson(Map<String, dynamic> json) => CourseThreeConfig(
        sectionThreeName: json["sectionThreeName"],
        sectionThreePosition: json["sectionThreePosition"],
      );

  Map<String, dynamic> toJson() => {
        "sectionThreeName": sectionThreeName,
        "sectionThreePosition": sectionThreePosition,
      };
}

class CourseTwoConfig {
  CourseTwoConfig({
    this.sectionTwoName,
    this.sectionTwoPosition,
  });

  int? sectionTwoName;
  int? sectionTwoPosition;

  factory CourseTwoConfig.fromRawJson(String str) => CourseTwoConfig.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory CourseTwoConfig.fromJson(Map<String, dynamic> json) => CourseTwoConfig(
        sectionTwoName: json["sectionTwoName"],
        sectionTwoPosition: json["sectionTwoPosition"],
      );

  Map<String, dynamic> toJson() => {
        "sectionTwoName": sectionTwoName,
        "sectionTwoPosition": sectionTwoPosition,
      };
}
