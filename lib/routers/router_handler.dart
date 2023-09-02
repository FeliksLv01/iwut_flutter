import 'package:fluro/fluro.dart';
import 'package:iwut_flutter/pages/home/home_page.dart';
import 'package:iwut_flutter/pages/more/more_page.dart';
import 'package:iwut_flutter/pages/news/news_content_page.dart';
import 'package:iwut_flutter/pages/news/news_list_page.dart';
import 'package:iwut_flutter/pages/room/room_page.dart';
import 'package:iwut_flutter/pages/schedule/schedule_page.dart';
import 'package:iwut_flutter/pages/webview/jwc_schedule.dart';
import 'package:iwut_flutter/pages/webview/webview_page.dart';
import 'package:iwut_flutter/pages/wifi/wifi_login_page.dart';
import 'package:iwut_flutter/routers/arguments.dart';

Handler homePageHandler = Handler(handlerFunc: (context, parameters) => HomePage());

Handler scheduleHandler = Handler(handlerFunc: (context, parameters) => SchedulePage());

Handler jwcScheduleHandler = Handler(handlerFunc: (context, parameters) => JwcSchedulePage());

///网页加载
Handler webViewHandler = Handler(handlerFunc: (context, parameters) {
  //路径
  final args = context!.settings!.arguments as WebviewArguments;
  var url = args.url;
  var title = args.title;
  return WebViewPage(initUrl: url, title: title);
});

Handler moreHandler = Handler(handlerFunc: (context, parameters) => MorePage());

Handler roomHandler = Handler(handlerFunc: (context, parameters) => RoomPage());

Handler newsHandler = Handler(handlerFunc: (context, params) => NewsListPage());

Handler newsContentHandler = Handler(handlerFunc: (context, parameters) {
  final postId = context!.settings!.arguments as String?;
  return NewsContentPage(postId: postId);
});

Handler wifiLoginHandler = Handler(handlerFunc: (context, parameters) => WifiLoginPage());
