import 'package:flutter/material.dart';
import 'package:iwut_flutter/config/color.dart';
import 'package:iwut_flutter/provider/course_provider.dart';
import 'package:iwut_flutter/utils/utils.dart';
import 'package:provider/provider.dart';

class SideBanner extends StatefulWidget {
  final bool hasBackGroundImage;
  SideBanner({this.hasBackGroundImage = false});
  @override
  _SideBannerState createState() => _SideBannerState();
}

class _SideBannerState extends State<SideBanner> {
  @override
  Widget build(BuildContext context) {
    var provider = Provider.of<CourseProvider>(context);
    int weekIndex = provider.weekIndex!;
    int month = DateUtil().getMondayMonth(weekIndex);
    bool hasBackGroundImage = widget.hasBackGroundImage;
    return Container(
      color: hasBackGroundImage ? Colors.transparent : AppColor(context).courseSideBannerBGColor,
      width: 121.w,
      child: DefaultTextStyle(
        style: TextStyle(
          color: AppColor(context).courseTextColor,
          fontSize: 38.sp,
        ),
        child: Flex(
          direction: Axis.vertical,
          children: [
            Container(
              height: 121.h,
              color: hasBackGroundImage ? Colors.transparent : AppColor(context).courseHeadBannerBGColor,
              child: Container(
                child: Center(
                  child: Text(
                    "$month月",
                    style: TextStyle(
                      color: DateUtil.getMonthNow() == month
                          ? AppColor(context).element2
                          : AppColor(context).courseTextColor,
                    ),
                  ),
                ),
              ),
            ),
            Divider(height: 3.h, color: Colors.grey),
            Expanded(
              flex: 605,
              child: Container(
                constraints: BoxConstraints(
                  minHeight: 634.h,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [Text('上'), Text('午')],
                ),
              ),
            ),
            Divider(height: 3.h, color: Colors.grey),
            Expanded(
              flex: 605,
              child: Container(
                constraints: BoxConstraints(minHeight: 634.h),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [Text('下'), Text('午')],
                ),
              ),
            ),
            Divider(height: 1, color: Colors.grey),
            Expanded(
              flex: 346,
              child: Container(
                constraints: BoxConstraints(
                  minHeight: 634.h,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [Text('晚'), Text('上')],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
