import 'package:iwut_flutter/utils/storage_util.dart';

class DateUtil {
  static DateUtil? _instance;
  static const List<String> weekDayList = [
    "周一",
    "周二",
    "周三",
    "周四",
    "周五",
    "周六",
    "周日",
  ];

  DateTime? termStart = DateTime.parse('2021-08-30');

  DateUtil._();

  factory DateUtil() {
    return _instance!;
  }

  /// 初始化开学时间
  static void init(DateTime? termStart) {
    if (_instance == null) {
      _instance = DateUtil._();
    }
    _instance!.termStart = termStart;
  }

  static DateTime now() {
    return DateTime.parse('2021-08-30');
  }

  /// 返回学年学期 2020-2021-2
  static String getXnxq() {
    final now = DateUtil.now();
    final termStart = DateTime.parse(StorageUtil().getTermStart()!);
    int month = now.month;
    int year = now.year;
    String xnxq;
    if (termStart.isAfter(now)) {
      month = termStart.month;
      year = termStart.year;
    }
    if (month <= 7 && month >= 2) {
      xnxq = "${year - 1}-$year-2";
    } else {
      xnxq = "$year-${year + 1}-1";
    }
    return xnxq;
  }

  /// 生成一周日期字符串，供顶部时间组件显示
  static List<String> getDayList(DateTime? monday) {
    List<String> dayList = [];
    for (int i = 0; i < 7; i++) {
      var dateTime = monday!.add(Duration(days: i));
      var day = dateTime.day;
      var month = dateTime.month;
      dayList.add("$month-$day");
    }
    return dayList;
  }

  /// 获取当前是第几周
  int getWeekIndex() {
    DateTime now = DateUtil.now();
    // 当前时间减开学时间
    int dur = now.difference(termStart!).inDays;
    int weekIndex;
    if (dur < 0) {
      weekIndex = 1;
    } else {
      weekIndex = 1 + dur ~/ 7;
      if (weekIndex > 20) {
        weekIndex = 20;
      }
    }
    return weekIndex;
  }

  /// 获取某一周周一是哪天
  DateTime? getMonday(int weekIndex) {
    if (weekIndex <= 0) {
      return null;
    }
    int days = (weekIndex - 1) * 7;
    DateTime monday = termStart!.add(Duration(days: days));
    return monday;
  }

  int getMondayMonth(int weekIndex) {
    DateTime monday = getMonday(weekIndex)!;
    int month = monday.month;
    return month;
  }

  /// 返回今天的日期
  static String getToday() {
    DateTime now = DateUtil.now();
    int day = now.day;
    int month = now.month;
    String today = "$month-$day";
    return today;
  }

  /// 返回当前月份
  static int getMonthNow() {
    DateTime now = DateUtil.now();
    int month = now.month;
    return month;
  }

  /// 返回今天周几
  static int getDayIndex() {
    return DateUtil.now().weekday;
  }

  /// 获取一个月有多少天
  static int getMonthDayNumber(int monthIndex) {
    int day;
    switch (monthIndex) {
      case 1:
      case 3:
      case 5:
      case 7:
      case 8:
      case 10:
      case 12:
        day = 31;
        break;
      case 2:
        day = 29;
        break;
      default:
        day = 30;
        break;
    }
    return day;
  }
}
