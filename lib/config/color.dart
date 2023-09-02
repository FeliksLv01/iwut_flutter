import 'package:flutter/material.dart';

class AppColor {
  final BuildContext context;

  AppColor(this.context);

  bool get _isDark {
    return Theme.of(context).brightness == Brightness.dark;
  }

  /// 蓝湖复制过来的格式是rgba(xxx, xxx, xxx, x)，为了快速转换，写了这个方法
  static Color rgba(int r, int g, int b, double a) => Color.fromARGB((a * 255).toInt(), r, g, b);

  Color _darkModeColor(Color light, Color dark) {
    return _isDark ? dark : light;
  }

  static Color get themeColor => rgba(69, 200, 220, 1);
  Color get appBarBgColor => _darkModeColor(Colors.white, Colors.grey[900]!);

  Color get scaffoldBgColor => _darkModeColor(rgba(243, 244, 246, 1), rgba(28, 28, 28, 1));

  Color get textColor => _darkModeColor(rgba(0, 0, 0, 1), rgba(255, 255, 255, 1));

  Color get loadingText => _darkModeColor(Colors.black.withOpacity(0.3), rgba(204, 204, 204, 1));

  Color get loadingDialogTextColor => _darkModeColor(rgba(85, 85, 85, 1), rgba(204, 204, 204, 1));

  Color get loadingDialogBGColor => _darkModeColor(rgba(255, 255, 255, 1), rgba(18, 18, 18, 1));

  /// 自习室选择器面板的背景颜色
  Color get pickerPanelBGColor => _darkModeColor(rgba(255, 255, 255, 1), rgba(39, 40, 40, 1));

  /// 自习室导航栏颜色
  Color get roomNavigatorColor => _darkModeColor(rgba(69, 200, 220, 1), rgba(18, 18, 18, 1));

  /// 自习室的背景颜色
  Color get roomBGColor => _darkModeColor(rgba(243, 244, 246, 1), rgba(18, 18, 18, 1));

  Color get element1 => rgba(153, 153, 153, 1);

  Color get element2 => rgba(69, 200, 220, 1);

  Color get element3 => _darkModeColor(rgba(29, 35, 38, 1), rgba(255, 255, 255, 1));

  Color get element4 => _darkModeColor(rgba(102, 102, 102, 1), rgba(196, 196, 196, 1));

  Color get element5 => _darkModeColor(rgba(29, 35, 38, 1), rgba(255, 255, 255, 1));

  Color get element6 => _darkModeColor(rgba(69, 200, 220, 1), rgba(153, 153, 153, 1));

  Color get white => Colors.white;

  /// 课表右下角添加按钮
  Color get scheduleAddButton => _darkModeColor(rgba(69, 200, 220, 1), rgba(141, 141, 141, 1));

  /// 课表头部显示第几周的文字颜色
  Color get scheduleTitleText => _darkModeColor(rgba(3, 3, 3, 1), rgba(255, 255, 255, 1));

  /// 课表左边显示上下午晚上的背景颜色
  Color get courseSideBannerBGColor => _darkModeColor(rgba(248, 248, 248, 1), rgba(51, 51, 51, 1));

  /// 课表上面显示周与日期的背景颜色
  Color get courseHeadBannerBGColor => _darkModeColor(rgba(255, 255, 255, 1), rgba(51, 51, 51, 1));

  /// 课表页面一般文字的颜色
  Color get courseTextColor => _darkModeColor(rgba(85, 85, 85, 1), rgba(204, 204, 204, 1));

  /// 课表主体的背景颜色
  Color get courseMainBGColor => _darkModeColor(rgba(255, 255, 255, 1), rgba(18, 18, 18, 1));

  /// 没有课时的课表背景颜色
  Color get courseBoxNoCourse => _darkModeColor(rgba(235, 235, 235, 1), rgba(102, 102, 102, 1));

  /// 课不在本周时课的文字颜色
  Color get courseBoxNoCourseText => _darkModeColor(rgba(85, 85, 85, 1), rgba(204, 204, 204, 1));

  /// 课表详情页标题颜色
  Color get courseDetailTitle => _darkModeColor(rgba(85, 85, 85, 1), rgba(153, 153, 153, 1));

  /// 课表详情页内容文本颜色
  Color get courseDetailContent => _darkModeColor(Colors.black, rgba(204, 204, 204, 1));

  Color get addDialogHeader => _darkModeColor(rgba(69, 200, 220, 1), rgba(2, 137, 177, 1));

  /// 弹出对话框的背景颜色
  Color get dialogBGColor => pickerPanelBGColor;

  /// toast消息的背景以及文字颜色
  static Color get toastBgColor => Colors.grey.shade800;

  static Color get toastTextColor => Colors.white;

  /// 更多页一般文字颜色
  Color get moreText => _darkModeColor(rgba(62, 62, 62, 1), rgba(204, 204, 204, 1));

  /// 更多页背景颜色
  Color get moreBGColor => roomBGColor;

  /// 更多页Cell的背景颜色
  Color get moreCellBGColor => pickerPanelBGColor;

  /// 添加课程页背景颜色
  Color get addBGColor => roomBGColor;

  /// 添加课程页选择器中的文字颜色
  Color get addPickerText => moreText;

  /// 课表颜色列表
  static const List<Color> courseColorList = [
    Color.fromARGB(255, 255, 168, 64),
    Color.fromARGB(255, 57, 211, 169),
    Color.fromARGB(255, 254, 134, 147),
    Color.fromARGB(255, 111, 137, 226),
    Color.fromARGB(255, 239, 130, 109),
    Color.fromARGB(255, 99, 186, 255),
    Color.fromARGB(255, 254, 212, 64),
    Color.fromARGB(255, 184, 150, 230),
    Color.fromARGB(255, 169, 213, 59),
  ];

  Color darken(Color c, [int percent = 10]) {
    assert(1 <= percent && percent <= 100);
    var f = 1 - percent / 100;
    return Color.fromARGB(c.alpha, (c.red * f).round(), (c.green * f).round(), (c.blue * f).round());
  }

  Color getCourseColor(int? index) {
    if (index == null || index == -1) {
      return courseBoxNoCourse;
    }
    return _darkModeColor(courseColorList[index], darken(courseColorList[index], 15));
  }

  static Color get activityColor => Color.fromARGB(255, 255, 160, 123);

  Color get saveButtonColor => rgba(71, 199, 220, 1);

  Color get saveButtonTextColor => Colors.white;

  /// 登录页背景颜色
  Color get loginBGColor => _darkModeColor(rgba(243, 244, 246, 1), rgba(0, 0, 0, 1));

  /// 登录页中间标题颜色
  Color get loginTitleColor => _darkModeColor(rgba(112, 112, 112, 1), rgba(255, 255, 255, 1));

  /// 一键登录按钮背景颜色
  Color get loginButtonBGColor => rgba(71, 199, 220, 1);

  /// 一键登录文字颜色
  Color get loginButtonTextColor => Colors.white;

  /// 使用其他手机号按钮文字颜色
  Color get loginPhoneTextColor => _darkModeColor(rgba(166, 166, 166, 1), rgba(179, 179, 179, 1));

  Color get loginPhoneNumberColor => _darkModeColor(rgba(82, 82, 82, 1), rgba(212, 212, 212, 1));

  /// 绑定手机页面背景颜色
  Color get bindBGColor => loginBGColor;

  /// 绑定页标题颜色
  Color get bindTitleColor => _darkModeColor(rgba(17, 131, 168, 1), Colors.white);

  Color get bindHintText => rgba(173, 173, 173, 1);

  Color get bindButtonBGColor => loginButtonBGColor;

  Color get bindButtonTextColor => loginButtonTextColor;

  Color get bindTextFieldDefaultColor => rgba(222, 222, 222, 1);

  Color get bindTextFieldActiveColor => element2;

  Color get detailBGColor => loginBGColor;

  Color get detailTitleColor => _darkModeColor(rgba(29, 35, 38, 1), rgba(255, 255, 255, 1));

  Color get detailIgnoreTitle => _darkModeColor(rgba(69, 200, 220, 1), rgba(205, 205, 205, 1));

  static Color get detailHintColor => rgba(173, 173, 173, 1);

  Color get detailDividerColor => _darkModeColor(rgba(222, 222, 222, 1), rgba(128, 128, 128, 1));

  Color get academyAppBarColor => _darkModeColor(rgba(69, 200, 220, 1), rgba(18, 18, 18, 1));

  Color get academySearchFieldBGColor => _darkModeColor(rgba(235, 235, 235, 1), rgba(82, 82, 82, 1));

  static Color get academyHintColor => rgba(166, 166, 166, 1);

  Color get academyDividerColor => detailDividerColor;

  /// 轮播图默认颜色
  Color get swiperDefaultColor => Color.fromARGB(255, 69, 200, 220);

  Color get swiperActiveColor => Color.fromARGB(255, 255, 255, 255);

  Color get buttonBGColor => _darkModeColor(rgba(71, 199, 220, 1), rgba(64, 182, 200, 1));
}
