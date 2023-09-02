import 'package:flutter/material.dart';
import 'package:iwut_flutter/config/color.dart';
import 'package:iwut_flutter/config/icon_font.dart';
import 'package:iwut_flutter/model/course/course.dart';
import 'package:iwut_flutter/pages/schedule/widgets/dialog/add_dialog.dart';
import 'package:iwut_flutter/utils/utils.dart';

class AddInfoDialog extends StatelessWidget {
  final Course course;
  const AddInfoDialog(this.course);
  @override
  Widget build(BuildContext context) {
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
                  decoration: BoxDecoration(color: AppColor(context).addDialogHeader),
                ),
                GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () {
                    Navigator.pop(context);
                    showIwutDialog(
                      context: context,
                      routeSettings: RouteSettings(name: 'AddCourseDialog'),
                      builder: (context) {
                        return AddDialog(course);
                      },
                    );
                  },
                  child: Container(
                    height: 850.h,
                    decoration: BoxDecoration(color: AppColor(context).addBGColor),
                    child: Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            '新增课程',
                            style: TextStyle(color: AppColor(context).addDialogHeader, fontSize: 40.sp),
                          ),
                          SizedBox(width: 8),
                          Icon(
                            IconFont.edit,
                            color: AppColor(context).addDialogHeader,
                            size: 40.sp,
                          )
                        ],
                      ),
                    ),
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
