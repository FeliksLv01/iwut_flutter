import 'package:flutter/material.dart';
import 'package:iwut_flutter/config/color.dart';
import 'package:iwut_flutter/model/course/course.dart';
import 'package:iwut_flutter/pages/schedule/widgets/dialog/add_info_dialog.dart';
import 'package:iwut_flutter/utils/utils.dart';

class NoCourseBox extends StatefulWidget {
  // 周几
  final int weekDay;
  // 第几节课
  final int courseIndex;
  final bool hasBackGroundImage;
  NoCourseBox(this.weekDay, this.courseIndex, {this.hasBackGroundImage = false});

  @override
  _NoCourseBoxState createState() => _NoCourseBoxState();
}

class _NoCourseBoxState extends State<NoCourseBox> {
  int? weekDay;
  int? courseIndex;

  @override
  Widget build(BuildContext context) {
    weekDay = widget.weekDay;
    courseIndex = widget.courseIndex;
    return Opacity(
      opacity: widget.hasBackGroundImage == false ? 1.0 : 0.8,
      child: InkWell(
        onTap: () => showIwutDialog(
          context: context,
          routeSettings: RouteSettings(name: 'AddCourseDialog'),
          builder: (context) {
            return AddInfoDialog(
              Course.init(
                weekDay,
                CourseUtil.getSectionStart(courseIndex),
                CourseUtil.getSectionEnd(courseIndex),
              ),
            );
          },
        ),
        child: Container(
          width: (ScreenUtil().screenWidth - 118.w) / 5,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(5.0)),
            color: AppColor(context).courseBoxNoCourse,
            border: Border.all(color: AppColor(context).courseBoxNoCourse),
          ),
          margin: EdgeInsets.only(
            top: 12.h,
            left: 12.w,
          ),
        ),
      ),
    );
  }
}
