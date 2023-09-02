import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:iwut_flutter/config/log/log.dart';
import 'package:iwut_flutter/pages/webview/webview_page.dart';
import 'package:iwut_flutter/routers/navigator.dart';
import 'package:iwut_flutter/service/course_service.dart';
import 'package:iwut_flutter/utils/utils.dart';
import 'package:iwut_flutter/widgets/loading_dialog.dart';

class JwcSchedulePage extends StatefulWidget {
  JwcSchedulePage({Key? key}) : super(key: key);

  @override
  _JwcSchedulePageState createState() => _JwcSchedulePageState();
}

class _JwcSchedulePageState extends State<JwcSchedulePage> {
  final String initUrl =
      'http://zhlgd.whut.edu.cn/tpass/login?service=http%3A%2F%2Fsso.jwc.whut.edu.cn%2FCertification%2Findex2.jsp';
  final isLoading = ValueNotifier<bool>(false);

  @override
  void initState() {
    super.initState();
    CourseService.getTime((time) {
      DateUtil.init(time.termStart);
    }, (message) => showToast(message));
  }

  @override
  Widget build(BuildContext context) {
    Log.debug("webview build");
    return Stack(
      children: [
        WebViewPage(
          initUrl: initUrl,
          title: '保存课表文件',
          onLoadStop: (controller, path) async {
            await CourseService.getCourseListByHtml("", (courseList) {}, (message) => showToast(message));
            await CourseUtil.queryCourseData(context);
            IwutNavigator.goBack(context);
          },
        ),
        ValueListenableBuilder(
          valueListenable: isLoading,
          builder: (context, dynamic loadingValue, _) {
            return Visibility(
              visible: loadingValue,
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(color: Color(0x72000000)),
              ),
            );
          },
        ),
        ValueListenableBuilder(
          valueListenable: isLoading,
          builder: (context, dynamic loadingValue, _) {
            return Visibility(
              visible: loadingValue,
              child: LoadingDialog(),
            );
          },
        ),
      ],
    );
  }
}
