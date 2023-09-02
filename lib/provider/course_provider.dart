import 'package:flutter/cupertino.dart';
import 'package:iwut_flutter/model/course/course.dart';
import 'package:iwut_flutter/utils/date_util.dart';

class CourseProvider extends ChangeNotifier {
  // 提前加载值
  CourseProvider(this.courseList);

  /// 课表数据
  List<Course> courseList = [];

  /// 是否有背景图片
  bool _hasBackGroundImage = false;

  /// 背景图片地址
  String? _imagePath;

  /// 当前课表显示的周数，随用户的选择而改变
  int? _weekIndex = DateUtil().getWeekIndex();

  /// 当前日期对应的周数，不随用户的选择而改变
  int _reallyWeekIndex = DateUtil().getWeekIndex();
  List<String> _dayList = DateUtil.getDayList(DateUtil().getMonday(DateUtil().getWeekIndex()));

  bool get hasBackground => _hasBackGroundImage;

  String? get imagePath => _imagePath;

  List<String> get dayList => _dayList;

  int? get weekIndex => _weekIndex;
  int get reallyWeekIndex => _reallyWeekIndex;

  set weekIndex(int? weekIndex) {
    _weekIndex = weekIndex;
    DateTime? monday = DateUtil().getMonday(_weekIndex!);
    _dayList = DateUtil.getDayList(monday);
    notifyListeners();
  }

  void setBGImage(String imagePath) {
    _hasBackGroundImage = true;
    _imagePath = imagePath;
    notifyListeners();
  }

  void deleteBGImage() {
    _hasBackGroundImage = false;
    _imagePath = null;
    notifyListeners();
  }

  void updateCourses(List<Course> courses) {
    courseList = courses;
    notifyListeners();
  }

  void loadData(List<Course> courses, String? imagePath) {
    if (imagePath != null) {
      _hasBackGroundImage = true;
      _imagePath = imagePath;
    }
    courseList = courses;
    notifyListeners();
  }
}
