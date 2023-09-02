import 'dart:math';

import 'package:flutter/material.dart';
import 'package:iwut_flutter/config/color.dart';
import 'package:iwut_flutter/pages/schedule/widgets/selector/single_week_selector.dart';
import 'package:iwut_flutter/provider/course_provider.dart';
import 'package:iwut_flutter/utils/utils.dart';
import 'package:provider/provider.dart';

class ScheduleTitle extends StatefulWidget {
  ScheduleTitle({Key? key}) : super(key: key);

  @override
  _ScheduleTitleState createState() => _ScheduleTitleState();
}

class _ScheduleTitleState extends State<ScheduleTitle> {
  double _arrowAngle = 0;

  @override
  Widget build(BuildContext context) {
    var provider = Provider.of<CourseProvider>(context);
    int? _weekIndex = provider.weekIndex;
    int _reallyWeekIndex = provider.reallyWeekIndex;
    return GestureDetector(
      onTap: () {
        setState(() {
          _arrowAngle = pi / 2;
        });
        showModalBottomSheet(
            context: context,
            backgroundColor: Colors.transparent,
            routeSettings: RouteSettings(name: 'SingleWeekSelector'),
            builder: (BuildContext buildContext) {
              return SingleWeekSelector(
                weekIndex: _weekIndex,
                reallyWeekIndex: _reallyWeekIndex,
              );
            }).then((value) {
          if (_arrowAngle != 0) {
            setState(() {
              _arrowAngle = 0;
            });
          }
        });
      },
      child: Container(
        padding: EdgeInsets.only(left: 24),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '第$_weekIndex周',
              style: TextStyle(
                color: AppColor(context).scheduleTitleText,
                fontSize: 51.sp,
              ),
            ),
            AnimatedContainer(
              duration: Duration(seconds: 1),
              child: Transform.rotate(
                angle: _arrowAngle,
                child: Icon(
                  Icons.chevron_right_rounded,
                  color: AppColor(context).scheduleTitleText,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
