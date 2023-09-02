import 'package:flutter/material.dart';
import 'package:iwut_flutter/config/log/log.dart';

class GlobalRouterObserver extends NavigatorObserver {
  @override
  void didPush(Route route, Route? previousRoute) {
    String message = '${previousRoute?.settings.name} didPush =====> ${route.settings.name}';
    if (route.settings.arguments != null) {
      message += ':${route.settings.arguments ?? ''}';
    }
    Log.info(message, tag: '路由');
    super.didPush(route, previousRoute);
  }

  @override
  void didPop(Route route, Route? previousRoute) {
    Log.info('${route.settings.name} didPop =====> ${previousRoute?.settings.name}', tag: '路由');
    super.didPop(route, previousRoute);
  }
}
