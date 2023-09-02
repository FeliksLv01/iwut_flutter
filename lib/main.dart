import 'dart:async';

import 'package:fluro/fluro.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:iwut_flutter/config/log/log.dart';
import 'package:iwut_flutter/global.dart';
import 'package:iwut_flutter/model/course/course.dart';
import 'package:iwut_flutter/provider/course_provider.dart';
import 'package:iwut_flutter/provider/message_provider.dart';
import 'package:iwut_flutter/provider/theme_provider.dart';
import 'package:iwut_flutter/provider/transparent_provider.dart';
import 'package:iwut_flutter/routers/application.dart';
import 'package:iwut_flutter/routers/global_router_observer.dart';
import 'package:iwut_flutter/routers/routes.dart';
import 'package:iwut_flutter/utils/utils.dart';
import 'package:iwut_flutter/widgets/custom_refresh_header_footer.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

void main() {
  runZonedGuarded(
    () async {
      await Global.init();
      List<Course> courses = await CourseUtil.queryCourse();
      runApp(MyApp(courses: courses));
    },
    (error, stackTrace) {
      if (kDebugMode) {
        Log.error(error.toString());
        Log.error(stackTrace.toString());
      }
    },
  );
}

class MyApp extends StatelessWidget {
  final List<Course> courses;

  MyApp({required this.courses}) {
    final router = FluroRouter();
    Routes.configureRoutes(router);
    Application.router = router;
  }

  @override
  Widget build(BuildContext context) {
    String initialRoute;
    String? time = StorageUtil().getTermStart();
    if (time == null) {
      initialRoute = Routes.root;
    } else {
      DateUtil.init(DateTime.parse(time));
      initialRoute = Routes.schedule;
    }
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<ThemeProvider>(create: (_) => ThemeProvider()),
        ChangeNotifierProvider<CourseProvider>(create: (_) => CourseProvider(courses)),
        ChangeNotifierProvider<TransparentProvider>(create: (_) => TransparentProvider()),
        ChangeNotifierProvider<MessageProvider>(create: (_) => MessageProvider()),
      ],
      child: ScreenUtilInit(
        designSize: Size(1080, 1920),
        builder: () => Consumer<ThemeProvider>(
          builder: (context, themeProvider, _) {
            ThemeData? brightTheme = ThemeData(
              primaryColor: Colors.white,
              visualDensity: VisualDensity.adaptivePlatformDensity,
              brightness: Brightness.light,
              appBarTheme: AppBarTheme(actionsIconTheme: IconThemeData(color: Colors.black)),
            );
            ThemeData? darkTheme = ThemeData(
              brightness: Brightness.dark,
              appBarTheme: AppBarTheme(actionsIconTheme: IconThemeData(color: Colors.white)),
            );
            if (themeProvider.theme == AppTheme.Bright) {
              darkTheme = null;
            } else if (themeProvider.theme == AppTheme.Dark) {
              brightTheme = darkTheme;
            }
            if (initialRoute == Routes.schedule) Global.appStartTask(context);
            return RefreshConfiguration(
              headerBuilder: () => CustomRefreshHeader(),
              footerBuilder: () => CustomRefreshFooter(),
              headerTriggerDistance: 80.0,
              enableLoadingWhenFailed: true,
              enableLoadingWhenNoData: true,
              child: MaterialApp(
                localizationsDelegates: [
                  GlobalMaterialLocalizations.delegate,
                  GlobalWidgetsLocalizations.delegate,
                  GlobalCupertinoLocalizations.delegate,
                ],
                supportedLocales: [
                  const Locale('zh', 'CN'),
                  const Locale('en', 'US'),
                ],
                title: '掌上吾理',
                theme: brightTheme,
                darkTheme: darkTheme,
                initialRoute: initialRoute,
                onGenerateRoute: Application.router.generator,
                navigatorObservers: [GlobalRouterObserver()],
                builder: (context, widget) {
                  return MediaQuery(
                    //设置文字大小不随系统设置改变
                    data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
                    child: widget!,
                  );
                },
              ),
            );
          },
        ),
      ),
    );
  }
}
