import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:iwut_flutter/routers/router_handler.dart';

class Routes {
  static const String root = '/';

  static const String login = '/login';

  ///  个人信息填写页
  static const String detail = '/detail';

  /// 本科生教务处添加课表
  static const String jwcSchedule = '/jwcSchedule';

  /// 课表页
  static const String schedule = "/schedule";

  /// 引导页
  static const String introduction = "/introduction";

  /// 更多页
  static const String more = "/more";

  /// 自习室
  static const String room = "/room";

  static const String news = "/news";

  static const String newsContent = "/newsContent";

  static const String wifiLogin = "/wifiLogin";

  /// 网页加载路径
  static const String webView = "/webView";

  static void configureRoutes(FluroRouter router) {
    router.notFoundHandler = Handler(
      handlerFunc: (context, parameters) {
        return Text("not Found");
      },
    );

    router.define(root, handler: homePageHandler);
    router.define(jwcSchedule, handler: jwcScheduleHandler);
    router.define(schedule, handler: scheduleHandler);
    router.define(webView, handler: webViewHandler);
    router.define(more, handler: moreHandler);
    router.define(room, handler: roomHandler);
    router.define(news, handler: newsHandler);
    router.define(newsContent, handler: newsContentHandler);
    router.define(wifiLogin, handler: wifiLoginHandler);
  }
}
