import 'package:flutter/material.dart';
import 'package:iwut_flutter/config/color.dart';
import 'package:iwut_flutter/provider/course_provider.dart';
import 'package:iwut_flutter/utils/utils.dart';
import 'package:provider/provider.dart';

class TimeContainer extends StatefulWidget {
  TimeContainer(this.weekIndex, {this.hasBackGroundImage = false});

  /// 今天周几
  final int weekIndex;

  final bool hasBackGroundImage;

  @override
  _TimeContainerState createState() => _TimeContainerState();
}

class _TimeContainerState extends State<TimeContainer> {
  @override
  Widget build(BuildContext context) {
    var provider = Provider.of<CourseProvider>(context);
    // 文字颜色
    String weekDay = DateUtil.weekDayList[widget.weekIndex - 1];
    String date = provider.dayList[widget.weekIndex - 1];
    Color color = DateUtil.getToday() == date ? AppColor(context).element2 : AppColor(context).courseTextColor;
    bool hasBackGroundImage = widget.hasBackGroundImage;
    return DefaultTextStyle(
      style: TextStyle(color: color, fontSize: 38.sp),
      child: Container(
        width: (ScreenUtil().screenWidth - 118.w) / 5,
        height: 121.h,
        decoration: BoxDecoration(
          color: hasBackGroundImage ? Colors.transparent : AppColor(context).courseHeadBannerBGColor,
          border:
              Border.all(color: hasBackGroundImage ? Colors.transparent : AppColor(context).courseHeadBannerBGColor),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              weekDay,
            ),
            SizedBox(height: 5.h),
            Text(
              date,
            ),
          ],
        ),
      ),
    );
  }
}
