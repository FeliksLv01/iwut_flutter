import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:iwut_flutter/config/image_path.dart';
import 'package:iwut_flutter/global.dart';
import 'package:iwut_flutter/pages/home/permission_dialog.dart';
import 'package:iwut_flutter/pages/home/privacy_dialog.dart';
import 'package:iwut_flutter/provider/message_provider.dart';
import 'package:iwut_flutter/routers/navigator.dart';
import 'package:iwut_flutter/service/course_service.dart';
import 'package:iwut_flutter/utils/course_util.dart';
import 'package:iwut_flutter/utils/date_util.dart';
import 'package:iwut_flutter/utils/storage_util.dart';
import 'package:iwut_flutter/utils/toast_util.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(milliseconds: 500), () async {
      if (Global.isFirstOpen) {
        var messageProvider = Provider.of<MessageProvider>(context, listen: false);
        messageProvider.addMessage();
      }
      if (await Permission.storage.isGranted == false) {
        Future.delayed(Duration(seconds: 2), () {
          if (Global.isFirstOpen) {
            _showFirstDialog();
          } else {
            _permissionRequest();
          }
        });
      } else {
        String? time = StorageUtil().getTermStart();
        if (time == null) {
          CourseService.getTime((time) async {
            DateUtil.init(time.termStart);
            await CourseUtil.queryCourseData(context);
            IwutNavigator.goSchedulePage(context);
          }, (message) => showToast(message));
        } else {
          DateUtil.init(DateTime.parse(time));
          await CourseUtil.queryCourseData(context);
          IwutNavigator.goSchedulePage(context);
          //IwutNavigator.go(context, Routes.detail);
        }
      }
    });
  }

  @override
  void didChangeDependencies() async {
    super.didChangeDependencies();
    // 预加载下一张图片
    if (StorageUtil().getTermStart() != null) {
      String? path = StorageUtil().getBackgroundImage();
      if (path != null) {
        precacheImage(FileImage(File(path)), context);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    CourseUtil.configMaxLines(context);
    return Scaffold(
      body: Container(
        child: Image.asset(
          ImagePath.HOME_IMAGE,
          fit: BoxFit.fill,
          width: double.infinity,
          height: double.infinity,
        ),
      ),
    );
  }

  _showFirstDialog() {
    showIwutDialog(
        context: context,
        builder: (context) {
          return PrivacyDialog();
        }).then((value) {
      _showPermissionDialog();
    });
  }

  _showPermissionDialog() {
    Future.delayed(Duration(milliseconds: 800), () {
      showIwutDialog(
          context: context,
          builder: (context) {
            return PermissionDialog();
          }).then((value) => _permissionRequest());
    });
  }

  _permissionRequest() {
    Future.delayed(Duration(seconds: 1), () async {
      await [Permission.storage].request();
      if (await Permission.storage.isGranted) {
        // 没有存储开学时间
        String? time = StorageUtil().getTermStart();
        if (time == null) {
          CourseService.getTime((time) {
            DateUtil.init(time.termStart);
            IwutNavigator.goSchedulePage(context);
          }, (message) => showToast(message));
        } else {
          DateUtil.init(DateTime.parse(time));
          IwutNavigator.goSchedulePage(context);
        }
      } else {
        SystemNavigator.pop();
      }
    });
  }
}
