import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iwut_flutter/config/color.dart';
import 'package:iwut_flutter/config/storage_key.dart';
import 'package:iwut_flutter/dao/course_dao.dart';
import 'package:iwut_flutter/global.dart';
import 'package:iwut_flutter/model/course/course.dart';
import 'package:iwut_flutter/model/course/course_config.dart';
import 'package:iwut_flutter/model/course/course_model.dart';
import 'package:iwut_flutter/provider/course_provider.dart';
import 'package:iwut_flutter/service/database_service.dart';
import 'package:iwut_flutter/utils/date_util.dart';
import 'package:iwut_flutter/utils/storage_util.dart';
import 'package:provider/provider.dart';

class CourseUtil {
  /// 第一大节课
  static const int courseOne = 1;

  /// 第二大节课
  static const int courseTwo = 2;

  /// 第三大节课
  static const int courseThree = 3;

  /// 第四大节课
  static const int courseFour = 4;

  /// 第五大节课
  static const int courseFive = 5;

  static const int twoSections = 259;

  static const int threeSections = 346;

  static Future<void> queryCourseData(context) async {
    var courseProvider = Provider.of<CourseProvider>(context, listen: false);
    CourseDao courseDao = await dbService.getCourseDao();
    var list = await courseDao.findAllCourses();
    courseProvider.updateCourses(list);
  }

  static Future<List<Course>> queryCourse() async {
    CourseDao courseDao = await dbService.getCourseDao();
    var list = await courseDao.findAllCourses();
    return list;
  }

  static void updateCourses(BuildContext context, List<Course> courses) {
    var courseProvider = Provider.of<CourseProvider>(context, listen: false);
    courseProvider.courseList = courses;
  }

  ///  [courseIndex] 当前课程是第几大节
  /// 返回默认的sectionStart
  static int getSectionStart(int? courseIndex) {
    int sectionStart = 0;
    switch (courseIndex) {
      case 1:
        sectionStart = 1;
        break;
      case 2:
        sectionStart = 3;
        break;
      case 3:
        sectionStart = 6;
        break;
      case 4:
        sectionStart = 9;
        break;
      case 5:
        sectionStart = 11;
        break;
    }
    return sectionStart;
  }

  static int getSectionEnd(int? courseIndex) {
    int sectionEnd = 0;
    switch (courseIndex) {
      case 1:
        sectionEnd = 2;
        break;
      case 2:
        sectionEnd = 4;
        break;
      case 3:
        sectionEnd = 7;
        break;
      case 4:
        sectionEnd = 10;
        break;
      case 5:
        sectionEnd = 12;
        break;
    }
    return sectionEnd;
  }

  /// 第几大节课，返回box比例
  static int? getFlexData(int courseIndex) {
    int? flexData;
    switch (courseIndex) {
      case 1:
        flexData = twoSections;
        break;
      case 2:
        flexData = threeSections;
        break;
      case 3:
        flexData = threeSections;
        break;
      case 4:
        flexData = twoSections;
        break;
      case 5:
        flexData = threeSections;
        break;
    }
    return flexData;
  }

  /// 返回上课时间
  static String getCourseTime(int? sectionStart, int? sectionEnd) {
    Map<int, String> start = {
      1: "08:00",
      3: "09:55",
      4: "10:45",
      6: "14:00",
      7: "14:50",
      9: "16:45",
      11: "19:00",
      12: "19:50",
    };
    Map<int, String> end = {2: "09:35", 4: "11:30", 5: "12:20", 7: "15:35", 8: "16:25", 10: "18:20", 12: "20:35", 13: "21:25"};
    String time = start[sectionStart!]! + "-" + end[sectionEnd!]!;
    return time;
  }

  /// 将后端返回的数据类型转换成用于显示的类型
  static List<Course> typeChange(List<CourseModel> courseList) {
    List<Course> modelList = [];
    for (var item in courseList) {
      modelList.add(Course.fromData(item));
    }
    return modelList;
  }

  // static List<String> toJsonList(List<Course> courses) {
  //   List<String> list = [];
  //   if (courses == null) return list;
  //   for (var item in courses) {
  //     list.add(item.toRawJson());
  //   }
  //   return list;
  // }

  static List<Course> colorAllocate(List<Course> courseList) {
    int i = 0;
    var list = [];
    for (int i = 0; i < AppColor.courseColorList.length; i++) {
      list.add(i);
    }
    list.shuffle();
    Map<String?, int> colorMap = Map();
    for (var item in courseList) {
      if (colorMap[item.name] == null) {
        if (i > 7) i = 0;
        colorMap[item.name] = list[i];
        i++;
      }
      item.color = colorMap[item.name];
    }
    return courseList;
  }

  /// 将课表数据分配到每一天
  static Map<int, List<Course>> getColumnData(List<Course> courseList) {
    Map<int, List<Course>> columnMap = Map();
    courseList.sort((a, b) => a.weekDay!.compareTo(b.weekDay!));
    for (int i = 1; i <= 7; i++) {
      List<Course> list = [];
      for (var item in courseList) {
        // 确保所有课程都是本周有的
        if (item.weekDay == i) {
          list.add(item);
        }
      }
      columnMap[i] = list;
    }
    return columnMap;
  }

  /// 对给到column的数据进行再处理，Map的key是节数,从1~5
  static Map<int, dynamic> getDayCourse(List<Course>? courseList) {
    var start = [1, 3, 6, 9, 11];
    Map<int, dynamic> dayCourse = Map();
    if (courseList == null) return dayCourse;
    courseList.forEach((element) {
      for (int i = 0; i < 5; i++) {
        int index = start[i];
        if (element.sectionStart != index && element.sectionStart != (index + 1)) {
          continue;
        }
        if (dayCourse[index] == null) {
          dayCourse[index] = element;
          break;
        } else if (dayCourse[index] is List) {
          var list = dayCourse[index];
          list.add(element);
          dayCourse.update(index, (value) => list);
          break;
        } else {
          dayCourse.update(index, (value) => [value, element]);
          break;
        }
      }
    });
    return dayCourse;
  }

  /// 是否为奇异课程
  static isStrangeCourse(Course courseBoxModel) {
    var start = [1, 3, 6, 9, 11];
    if (start.contains(courseBoxModel.sectionStart)) {
      return false;
    } else {
      return true;
    }
  }

  /// CourseModel的话，就是判断是否是本周的课，List就是判断是否有本周的课
  static isThisWeek(dynamic courseBoxModel, int? weekIndex) {
    if (courseBoxModel == null) return false;
    if (courseBoxModel is List) {
      for (var item in courseBoxModel) {
        if (item.weekStart > weekIndex || item.weekEnd < weekIndex) {
          continue;
        }
        return true;
      }
      return false;
    }
    if (courseBoxModel.weekStart > weekIndex || courseBoxModel.weekEnd < weekIndex) {
      return false;
    }
    return true;
  }

  /// 获取本周课表，需要先对[courseData]进行[isThisWeek]方法判断一下
  static getWeekCourses(dynamic courseData, int? weekIndex) {
    if (courseData == null) return null;

    if (courseData is List) {
      List<Course> res = [];
      for (var item in courseData) {
        if (item.weekStart > weekIndex || item.weekEnd < weekIndex) {
          continue;
        }
        res.add(item);
      }
      if (res.length == 1) {
        return res[0];
      }
      return res;
    }
    return courseData;
  }

  static Course getMaxPriorityCourse(List<Course> courseList) {
    int? max = 0;
    Course res = courseList[0];
    for (var item in courseList) {
      if (item.priority! > max!) {
        max = item.priority;
        res = item;
      }
    }
    return res;
  }

  /// 获取本地存储的课表数据，将在[courseModelList]进行调换
  /// 调换后的顺序应和[courseModelList]一样
  /// 对应操作，拖动改变顺序
  static void changeIndex(List<Course> courseList, BuildContext context) async {
    var dao = await dbService.getCourseDao();
    for (int i = 0; i < courseList.length; i++) {
      courseList[i].priority = courseList.length - i - 1;
    }
    dao.updateCourses(courseList);
    var courseProvider = Provider.of<CourseProvider>(context, listen: false);
    List<Course> courses = await dao.findAllCourses();
    courseProvider.updateCourses(courses);
  }

  /// 根据传入的[sectionStart]，返回节数选择器的可选内容
  static List<String>? getSectionScope(int? sectionStart) {
    List<int> start = [1, 3, 6, 9, 11];
    List<String>? result;
    // 表示第几大节
    int? sectionIndex;
    for (int i = 0; i < start.length; i++) {
      int index = start[i];
      if (sectionStart == index || sectionStart == (index + 1)) {
        sectionIndex = i + 1;
        break;
      }
    }
    switch (sectionIndex) {
      case 1:
        result = ['第1-2节'];
        break;
      case 2:
        result = ['第3-4节', '第3-5节', '第4-5节'];
        break;
      case 3:
        result = ['第6-7节', '第6-8节', '第7-8节'];
        break;
      case 4:
        result = ['第9-10节'];
        break;
      case 5:
        result = ['第11-12节', '第11-13节', '第12-13节'];
        break;
    }
    return result;
  }

  /// [time]形如 [第1-3节] 或者 [第1-3周]
  /// 返回[1,3]
  static List<int> getStringData(String time) {
    RegExp regExp = RegExp(r"(\d+)-(\d+)");
    int start = int.parse(regExp.firstMatch(time)!.group(1)!);
    int end = int.parse(regExp.firstMatch(time)!.group(2)!);
    var list = [start, end];
    return list;
  }

  static bool judgeWeekIndex(int start, int end) {
    if (start > end) {
      return false;
    }
    return true;
  }

  /// 返回课程名和上课地点的最大行数
  static void configMaxLines(BuildContext context) {
    if (Global.courseThreeConfig == null) {
      configSectionThreeMaxLines(context);
    }

    if (Global.courseTwoConfig == null) {
      configSectionTwoMaxLines(context);
    }
  }

  /// 返回三节课 对应的课程名和
  static void configSectionThreeMaxLines(BuildContext context) {
    int sum = (MediaQuery.of(context).size.height * ScreenUtil().pixelRatio * 0.206 - 12.h * 5) ~/ (34.sp * 1.5) ~/ ScreenUtil().pixelRatio;
    int nameLines = 0;
    int roomLines = 0;
    if (sum % 2 == 0) {
      nameLines = sum ~/ 2;
      roomLines = nameLines;
    } else {
      nameLines = sum ~/ 2;
      roomLines = sum ~/ 2 + 1;
    }
    CourseThreeConfig config = CourseThreeConfig(sectionThreeName: nameLines, sectionThreePosition: roomLines);
    StorageUtil().setJSON(StorageKey.COURSE_THREE_CONFIG, config.toJson());
    Global.courseThreeConfig = config;
  }

  static void configSectionTwoMaxLines(BuildContext context) {
    int sum = (MediaQuery.of(context).size.height * ScreenUtil().pixelRatio * 0.155 - 12.h * 5) ~/ (34.sp * 1.5) ~/ ScreenUtil().pixelRatio;
    int nameLines = 0;
    int roomLines = 0;
    if (sum % 2 == 0) {
      if (sum > 6) sum = 6;
      nameLines = sum ~/ 2;
      roomLines = nameLines;
    } else {
      if (sum > 6) {
        nameLines = 3;
        roomLines = nameLines;
      } else {
        nameLines = sum ~/ 2;
        roomLines = sum ~/ 2 + 1;
      }
    }
    CourseTwoConfig config = CourseTwoConfig(sectionTwoName: nameLines, sectionTwoPosition: roomLines);
    StorageUtil().setJSON(StorageKey.COURSE_TWO_CONFIG, config.toJson());
    Global.courseTwoConfig = config;
  }

  /// 给桌面小组件提供课程数据
  static List<Course> getTodayCourses(List<Course> courses, int weekIndex) {
    var todayCourses = [];
    int dayIndex = DateUtil.getDayIndex();
    for (var item in courses) {
      if (item.weekDay == dayIndex) {
        if (item.weekStart! <= weekIndex && item.weekEnd! >= weekIndex) {
          todayCourses.add(item);
        }
      }
    }
    return todayCourses as List<Course>;
  }

  /// 星期数字转中文
  static String getChineseWeekDay(int dayIndex) {
    var list = ["周一", "周二", "周三", "周四", "周五", "周六", "周日"];
    return list[dayIndex - 1];
  }

  static String getChineseSections(int sectionStart, int sectionEnd) {
    return '第$sectionStart-$sectionEnd节';
  }

  /// 传入开始时间与结束时间（小时、分钟），计算该时间段应该属于的大节
  /// 如果返回为null，说明输入的数据有问题
  /// 如果返回为空列表，说明输入的时间段不包含任何课程时间
  /// 正常返回为输入的时间段中包含的课程列表（大节）
  static List<int>? getBigSections(int? startHour, int? startMinute, int? endHour, int? endMinute) {
    if (startHour == null || startMinute == null || endHour == null || endMinute == null) return null;
    // 定义五大节课开始与结束的时间：小时和分钟
    final startHours = [8, 9, 14, 16, 19];
    final startMinutes = [0, 55, 0, 45, 0];

    final endHours = [9, 12, 16, 18, 21];
    final endMinutes = [35, 20, 25, 20, 25];
    // 如果开始的时间超过了前一个大节的结束时间，则属于下一个大节
    int startSection = 1;
    for (var i = 0; i < 5; i++) {
      if (startHour > endHours[i] || (startHour == endHours[i] && startMinute > endMinutes[i])) {
        startSection++;
      } else {
        break;
      }
    }
    // 如果结束时间早于当前大节的开始时间，则属于上一个大节
    int endSection = 5;
    for (var i = 4; i >= 0; i--) {
      if (endHour < startHours[i] || (endHour == startHours[i] && endMinute < startMinutes[i])) {
        endSection--;
      } else {
        break;
      }
    }
    // 如果计算出来发现endSection小于startSection说明用户选择的时间段内没有包含任何课程时间
    if (endSection < startSection) return [];

    final sections = List.generate(endSection - startSection + 1, (index) => startSection + index);
    return sections;
  }
}
