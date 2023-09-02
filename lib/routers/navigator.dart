import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:iwut_flutter/routers/application.dart';
import 'package:iwut_flutter/routers/arguments.dart';
import 'package:iwut_flutter/routers/routes.dart';

class IwutNavigator {
  static go(BuildContext context, String path) {
    Application.router.navigateTo(
      context,
      path,
      transition: TransitionType.cupertino,
    );
  }

  //跳转至网页页面
  static goWebView(BuildContext context, String url, {String title = ''}) {
    Application.router.navigateTo(
      context,
      Routes.webView,
      routeSettings: RouteSettings(arguments: WebviewArguments(url: url, title: title)),
      transition: TransitionType.cupertino,
    );
  }

  static goJwcSchedulePage(BuildContext context) {
    Application.router.navigateTo(
      context,
      Routes.jwcSchedule,
      transition: TransitionType.cupertino,
    );
  }

  static goSchedulePage(BuildContext context) {
    Application.router.navigateTo(
      context,
      Routes.schedule,
      transition: TransitionType.none,
      replace: true,
      clearStack: true,
    );
  }

  /// 返回上一个页面
  static goBack(BuildContext context) {
    Application.router.pop(context);
  }

  /// 跳转到更多页面
  static goMorePage(BuildContext context) {
    Application.router.navigateTo(
      context,
      Routes.more,
      transition: TransitionType.cupertino,
    );
  }

  static goRoomPage(BuildContext context) {
    Application.router.navigateTo(
      context,
      Routes.room,
      transition: TransitionType.cupertino,
    );
  }

  static goNewsContent(BuildContext context, String postId) {
    Application.router.navigateTo(
      context,
      Routes.newsContent,
      routeSettings: RouteSettings(arguments: postId),
      transition: TransitionType.cupertino,
    );
  }

  static goWifiLogin(BuildContext context) {
    Application.router.navigateTo(
      context,
      Routes.wifiLogin,
      transition: TransitionType.cupertino,
    );
  }
}
