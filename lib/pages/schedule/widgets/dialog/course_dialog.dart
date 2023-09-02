import 'package:flutter/material.dart';
import 'package:iwut_flutter/config/color.dart';
import 'package:iwut_flutter/config/icon_font.dart';
import 'package:iwut_flutter/model/course/course.dart';
import 'package:iwut_flutter/utils/utils.dart';

import 'edit_dialog.dart';

class CourseDialog extends StatelessWidget {
  final Color? color;
  final Course courseBoxModel;
  final Color textColor;

  CourseDialog(this.color, this.courseBoxModel, {this.textColor = Colors.white});

  @override
  Widget build(BuildContext context) {
    String name = courseBoxModel.name!;
    String? teacher = courseBoxModel.teacher;
    String week = '第' + courseBoxModel.weekStart.toString() + '-' + courseBoxModel.weekEnd.toString() + '周';
    String? room = courseBoxModel.room;
    String time = CourseUtil.getCourseTime(courseBoxModel.sectionStart, courseBoxModel.sectionEnd);

    return Material(
      type: MaterialType.transparency,
      child: Center(
        child: ClipRRect(
          borderRadius: BorderRadius.all(
            Radius.circular(10.0),
          ),
          child: Container(
            width: 800.w,
            height: 1000.h,
            child: Column(
              children: [
                Container(
                  height: 150.h,
                  decoration: BoxDecoration(color: color),
                  child: Center(
                    child: Text(
                      name,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(color: textColor, fontSize: 46.sp),
                    ),
                  ),
                ),
                Container(
                  height: 850.h,
                  padding: EdgeInsets.only(top: 12),
                  decoration: BoxDecoration(color: AppColor(context).addBGColor),
                  child: Column(
                    children: [
                      CourseDialogItem(Icon(Icons.person, color: Colors.blueAccent), teacher),
                      CourseDialogItem(Icon(Icons.date_range, color: Colors.greenAccent), week),
                      CourseDialogItem(Icon(Icons.place, color: Colors.redAccent), room),
                      CourseDialogItem(Icon(Icons.access_time, color: Colors.orangeAccent), time),
                      Spacer(),
                      GestureDetector(
                        behavior: HitTestBehavior.opaque,
                        onTap: () {
                          showIwutDialog(
                            context: context,
                            routeSettings: RouteSettings(name: 'editCourseDialog'),
                            builder: (context) {
                              return EditDialog(color, courseBoxModel, textColor);
                            },
                          ).then((value) => Navigator.pop(context));
                        },
                        child: Container(
                          padding: EdgeInsets.only(bottom: 45.h),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                '修改课程',
                                style: TextStyle(color: AppColor(context).addDialogHeader, fontSize: 38.sp),
                              ),
                              SizedBox(width: 8),
                              Icon(
                                IconFont.edit,
                                color: AppColor(context).addDialogHeader,
                                size: 38.sp,
                              )
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class CourseDialogItem extends StatelessWidget {
  final Widget icon;
  final String? text;
  const CourseDialogItem(this.icon, this.text);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 147.h,
      margin: EdgeInsets.only(
        left: 27.w,
        right: 27.w,
        bottom: 32.w,
      ),
      child: Row(
        children: [
          Padding(
            padding: EdgeInsets.only(left: 70.w),
          ),
          icon,
          Padding(
            padding: EdgeInsets.only(left: 40.w),
          ),
          Expanded(
            child: Text(
              text!,
              style: TextStyle(
                color: AppColor(context).moreText,
                fontSize: 50.sp,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
