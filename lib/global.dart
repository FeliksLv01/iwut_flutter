import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:iwut_flutter/config/storage_key.dart';
import 'package:iwut_flutter/model/course/course_config.dart';
import 'package:iwut_flutter/model/info/push_info.dart';
import 'package:iwut_flutter/provider/theme_provider.dart';
import 'package:iwut_flutter/utils/utils.dart';
import 'package:provider/provider.dart';

import 'provider/message_provider.dart';
import 'service/info_service.dart';

class Global {
  /// 是否第一次打开
  static bool isFirstOpen = false;

  static String? currentVersion;

  static bool hasStoragePermission = true;
  static bool openDialogObserver = false;

  static AppTheme theme = AppTheme.System;

  static CourseTwoConfig? courseTwoConfig;
  static CourseThreeConfig? courseThreeConfig;

  /// init
  static Future init() async {
    // 运行初始
    WidgetsFlutterBinding.ensureInitialized();
    //设置状态栏颜色
    SystemUiOverlayStyle systemUiOverlayStyle = SystemUiOverlayStyle(
      statusBarColor: Colors.transparent, //设置为透明
    );
    SystemChrome.setSystemUIOverlayStyle(systemUiOverlayStyle);
    // 强制竖屏
    SystemChrome.setPreferredOrientations(
      [
        DeviceOrientation.portraitUp,
        DeviceOrientation.portraitDown,
      ],
    );

    // 工具初始
    await StorageUtil.init();

    // 获取版本
    currentVersion = await DeviceUtil.getVersion();
    // 读取设备第一次打开
    isFirstOpen = StorageUtil().getVersion() != currentVersion;
    if (isFirstOpen) {
      StorageUtil().setVersion(currentVersion!);
    }
    loadTheme();
    configCourse();
    HomeWidgetUtil.updateWidget(name: "widget.CourseWidgetProvider");
  }

  static void loadTheme() {
    int index = StorageUtil().getInt(StorageKey.THEME, defaultValue: AppTheme.System.index)!;
    theme = AppTheme.values[index];
  }

  static void configCourse() {
    var twoConfig = StorageUtil().getJSON(StorageKey.COURSE_TWO_CONFIG);
    var threeConfig = StorageUtil().getJSON(StorageKey.COURSE_THREE_CONFIG);
    courseTwoConfig = twoConfig == null ? null : CourseTwoConfig.fromJson(twoConfig);
    courseThreeConfig = twoConfig == null ? null : CourseThreeConfig.fromJson(threeConfig);
  }

  static void appStartTask(BuildContext context) {
    /// 版本检测
    doAppUpdate(BuildContext context) {
      InfoService.getUpdateInfo((updateInfo) {
        if (Global.currentVersion!.compareTo(updateInfo.latestRelease) == -1) {
          var messageProvider = Provider.of<MessageProvider>(context, listen: false);
          // 更多页标志出现红点
          messageProvider.versionMessage = true;
          messageProvider.updateInfo = updateInfo;
        }
      });
    }

    doGetPush(BuildContext context) {
      InfoService.getPushInfo((value) {
        PushInfo data = value;
        if (data.startTime!.isBefore(DateTime.now())) {
          var messageProvider = Provider.of<MessageProvider>(context, listen: false);
          messageProvider.activityMessage = true;
          messageProvider.pushInfo = data;
        }
      });
    }

    doAppUpdate(context);
    doGetPush(context);
  }
}
