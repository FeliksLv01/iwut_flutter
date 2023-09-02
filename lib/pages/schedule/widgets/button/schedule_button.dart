import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:iwut_flutter/config/color.dart';
import 'package:iwut_flutter/routers/navigator.dart';
import 'package:iwut_flutter/utils/utils.dart';

class ScheduleButton extends StatelessWidget {
  const ScheduleButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: 0.56,
      child: FloatingActionButton(
        child: Icon(Icons.add),
        backgroundColor: AppColor(context).scheduleAddButton,
        onPressed: () {
          showCupertinoModalPopup(
            context: context,
            routeSettings: RouteSettings(name: 'InputCourseSheet'),
            builder: (context) {
              return CupertinoActionSheet(
                title: Text(
                  '课表自动导入',
                  style: TextStyle(fontSize: 22),
                ),
                message: Text('请选择您的身份'),
                actions: <Widget>[
                  CupertinoActionSheetAction(
                    onPressed: () {
                      Navigator.pop(context);
                      IwutNavigator.goJwcSchedulePage(context);
                    },
                    child: Text('本科生', style: TextStyle(fontSize: 45.sp)),
                  ),
                ],
              );
            },
          );
        },
      ),
    );
  }
}
