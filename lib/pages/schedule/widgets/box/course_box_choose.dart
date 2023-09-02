import 'package:flutter/material.dart';
import 'package:iwut_flutter/config/color.dart';
import 'package:iwut_flutter/model/course/course.dart';
import 'package:iwut_flutter/pages/schedule/widgets/box/course_box.dart';
import 'package:iwut_flutter/pages/schedule/widgets/box/course_list_box.dart';
import 'package:iwut_flutter/pages/schedule/widgets/box/no_course_box.dart';
import 'package:iwut_flutter/pages/schedule/widgets/column_data_widget.dart';
import 'package:iwut_flutter/provider/course_provider.dart';
import 'package:iwut_flutter/utils/course_util.dart';
import 'package:provider/provider.dart';

class CourseBoxChoose extends StatefulWidget {
  /// 使用dynamic的话，会出现类型转换问题
  final dynamic courseBoxModel;

  /// 最多是两大节还是三大节
  final int courseIndex;
  final bool hasBackGroundImage;

  CourseBoxChoose(this.courseIndex, {this.courseBoxModel, this.hasBackGroundImage = false});

  @override
  _CourseBoxChooseState createState() => _CourseBoxChooseState();
}

class _CourseBoxChooseState extends State<CourseBoxChoose> {
  @override
  Widget build(BuildContext context) {
    /// 几节课
    int? flexData = CourseUtil.getFlexData(widget.courseIndex);
    if (widget.courseBoxModel == null) {
      var weekDay = ColumnDataWidget.of(context)!.weekDay;
      return Expanded(
        flex: flexData!,
        child: NoCourseBox(weekDay, widget.courseIndex, hasBackGroundImage: widget.hasBackGroundImage),
      );
    }
    var provider = Provider.of<CourseProvider>(context);
    int? weekIndex = provider.weekIndex;
    // 判断颜色是否应该为灰色
    bool isThisWeek = CourseUtil.isThisWeek(widget.courseBoxModel, weekIndex);
    bool hasBackGroundImage = widget.hasBackGroundImage;

    if (isThisWeek) {
      var courseData = CourseUtil.getWeekCourses(widget.courseBoxModel, weekIndex);
      bool isList = courseData is List;
      Widget child = isList
          ? CourseListBox(
              Course.fromDynamicList(courseData),
              flexData,
              hasBackGroundImage: hasBackGroundImage,
              isThieWeek: true,
            )
          : CourseBox(AppColor(context).getCourseColor(courseData.boxColor), courseData, flexData, hasBackGroundImage: hasBackGroundImage);
      return Expanded(flex: flexData!, child: child);
    } else {
      var courseData = widget.courseBoxModel;
      bool isList = courseData is List;
      Widget child = isList
          ? CourseListBox(Course.fromDynamicList(courseData), flexData,
              color: AppColor(context).courseBoxNoCourse, textColor: AppColor(context).courseBoxNoCourseText, hasBackGroundImage: hasBackGroundImage)
          : CourseBox(
              AppColor(context).courseBoxNoCourse,
              courseData,
              flexData,
              textColor: AppColor(context).courseBoxNoCourseText,
              hasBackGroundImage: hasBackGroundImage,
            );
      return Expanded(flex: flexData!, child: child);
    }
  }
}
