import 'package:flutter/material.dart';
import 'package:iwut_flutter/config/color.dart';
import 'package:iwut_flutter/model/course/course.dart';
import 'package:iwut_flutter/pages/schedule/widgets/column_data_widget.dart';
import 'package:iwut_flutter/pages/schedule/widgets/time_container.dart';
import 'package:iwut_flutter/provider/transparent_provider.dart';
import 'package:iwut_flutter/utils/utils.dart';
import 'package:provider/provider.dart';

import '../box/course_box_choose.dart';

class OpacityTuesdayColumn extends StatefulWidget {
  final List<dynamic>? courseList;
  final bool hasBackGroundImage;
  OpacityTuesdayColumn({this.courseList, this.hasBackGroundImage = false});

  @override
  _OpacityTuesdayColumnState createState() => _OpacityTuesdayColumnState();
}

class _OpacityTuesdayColumnState extends State<OpacityTuesdayColumn> {
  @override
  Widget build(BuildContext context) {
    bool hasBackGroundImage = widget.hasBackGroundImage;
    Color? color = hasBackGroundImage ? null : AppColor(context).courseMainBGColor;
    Map<int, dynamic> courseMap = CourseUtil.getDayCourse(widget.courseList as List<Course>?);
    int index = 2;
    return Consumer<TransparentProvider>(
      builder: (context, value, child) {
        return Opacity(
          opacity: value.alphaTuesday,
          child: Container(
            color: color,
            width: (ScreenUtil().screenWidth - 118.w - 12.w) / 5,
            child: ColumnDataWidget(
              weekDay: DateTime.tuesday,
              child: Flex(
                direction: Axis.vertical,
                clipBehavior: Clip.none,
                children: [
                  TimeContainer(index, hasBackGroundImage: hasBackGroundImage),
                  Divider(height: 3.h, color: Colors.grey),
                  CourseBoxChoose(CourseUtil.courseOne,
                      courseBoxModel: courseMap[1], hasBackGroundImage: hasBackGroundImage),
                  CourseBoxChoose(CourseUtil.courseTwo,
                      courseBoxModel: courseMap[3], hasBackGroundImage: hasBackGroundImage),
                  CourseBoxChoose(CourseUtil.courseThree,
                      courseBoxModel: courseMap[6], hasBackGroundImage: hasBackGroundImage),
                  CourseBoxChoose(CourseUtil.courseFour,
                      courseBoxModel: courseMap[9], hasBackGroundImage: hasBackGroundImage),
                  CourseBoxChoose(CourseUtil.courseFive,
                      courseBoxModel: courseMap[11], hasBackGroundImage: hasBackGroundImage),
                  Padding(padding: EdgeInsets.only(bottom: 12.w)),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
