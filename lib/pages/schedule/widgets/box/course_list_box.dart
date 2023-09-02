import 'package:flutter/material.dart';
import 'package:flutter_swiper_null_safety/flutter_swiper_null_safety.dart';
import 'package:iwut_flutter/config/color.dart';
import 'package:iwut_flutter/dao/course_dao.dart';
import 'package:iwut_flutter/global.dart';
import 'package:iwut_flutter/model/course/course.dart';
import 'package:iwut_flutter/pages/schedule/widgets/box/background_clipper.dart';
import 'package:iwut_flutter/pages/schedule/widgets/box/my_painter.dart';
import 'package:iwut_flutter/pages/schedule/widgets/dialog/add_info_dialog.dart';
import 'package:iwut_flutter/pages/schedule/widgets/dialog/course_list_dialog.dart';
import 'package:iwut_flutter/pages/schedule/widgets/dialog/delete_dialog.dart';
import 'package:iwut_flutter/provider/course_provider.dart';
import 'package:iwut_flutter/service/database_service.dart';
import 'package:iwut_flutter/utils/utils.dart';
import 'package:provider/provider.dart';

class CourseListBox extends StatefulWidget {
  final int? type;
  final List<Course> courseModel;
  final Color? color;
  final Color textColor;
  final bool hasBackGroundImage;
  final bool isThieWeek;
  CourseListBox(
    this.courseModel,
    this.type, {
    this.color,
    this.hasBackGroundImage = false,
    this.textColor = Colors.white,
    this.isThieWeek = false,
  });

  @override
  _CourseListBoxState createState() => _CourseListBoxState();
}

class _CourseListBoxState extends State<CourseListBox> {
  @override
  Widget build(BuildContext context) {
    List<Course> courseList = widget.courseModel;
    Course course = CourseUtil.getMaxPriorityCourse(courseList);
    var courseProvider = Provider.of<CourseProvider>(context);
    Color? color = widget.color == null ? AppColor(context).getCourseColor(course.boxColor) : widget.color;
    Color textColor = widget.textColor;
    int? type = widget.type;
    return Opacity(
      opacity: widget.hasBackGroundImage == false ? 1.0 : 0.8,
      child: Container(
        width: (ScreenUtil().screenWidth - 118.w) / 5,
        margin: EdgeInsets.only(
          top: 12.h,
          left: 12.w,
        ),
        child: Flex(
          direction: Axis.vertical,
          children: _buildChildren(color, textColor, course, courseProvider, type),
        ),
      ),
    );
  }

  Widget _buildCourseBox(Color? color, Color textColor, Course course, CourseProvider courseProvider) {
    String name = course.name!;
    String room = course.room!;
    int sections = course.sectionEnd! - course.sectionStart! + 1;
    int? nameLine = sections == 2 ? Global.courseTwoConfig!.sectionTwoName : Global.courseThreeConfig!.sectionThreeName;
    int? roomLine =
        sections == 2 ? Global.courseTwoConfig!.sectionTwoPosition : Global.courseThreeConfig!.sectionThreePosition;
    return Expanded(
      flex: 259,
      child: Container(
        width: (ScreenUtil().screenWidth - 118.w) / 5,
        child: ClipPath(
          clipper: widget.isThieWeek ? BackgroundClipper() : null,
          child: InkWell(
            onLongPress: () {
              showIwutDialog(
                  context: context,
                  routeSettings: RouteSettings(name: 'deleteCourseDialog'),
                  builder: (context) {
                    return DeleteDialog(() async {
                      var list = courseProvider.courseList;
                      for (var item in list) {
                        if (item == course) {
                          list.remove(item);
                          break;
                        }
                      }
                      courseProvider.updateCourses(list);
                      CourseDao courseDao = await dbService.getCourseDao();
                      courseDao.deleteCourse(course);
                      HomeWidgetUtil.updateWidget(name: "widget.CourseWidgetProvider");
                    });
                  });
            },
            onTap: () {
              showIwutDialog(
                context: context,
                routeSettings: RouteSettings(name: 'courseDialog'),
                builder: (context) {
                  List<Widget> widgetList = [
                    CourseListDialog(color, textColor, widget.courseModel),
                    AddInfoDialog(
                      Course.init(
                        course.weekDay,
                        course.sectionStart,
                        course.sectionEnd,
                      ),
                    )
                  ];
                  return GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Swiper(
                      loop: false,
                      itemBuilder: (context, index) {
                        return widgetList[index];
                      },
                      itemCount: 2,
                      pagination: SwiperPagination(
                        alignment: Alignment.bottomCenter,
                        margin: EdgeInsets.only(bottom: 50),
                        builder: DotSwiperPaginationBuilder(
                          space: 5,
                          color: AppColor(context).swiperDefaultColor,
                          activeColor: AppColor(context).swiperActiveColor,
                        ),
                      ),
                    ),
                  );
                },
              ).then((value) {
                setState(() {
                  course = CourseUtil.getMaxPriorityCourse(widget.courseModel);
                });
              });
            },
            child: Container(
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.all(
                  Radius.circular(5.0),
                ),
              ),
              child: CustomPaint(
                painter: widget.isThieWeek ? MyPainter() : null,
                child: Container(
                  padding: EdgeInsets.only(left: 12.w, right: 12.w),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Text(
                          name,
                          maxLines: nameLine,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(color: textColor, fontSize: 34.sp),
                        ),
                      ),
                      Text(
                        room,
                        maxLines: roomLine,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(color: textColor, fontSize: 34.sp),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  List<Widget> _buildChildren(Color? color, Color textColor, Course course, CourseProvider courseProvider, int? type) {
    List<Widget> children = [];
    Widget courseBox = _buildCourseBox(color, textColor, course, courseProvider);
    children.add(courseBox);
    int courseType = course.sectionEnd! - course.sectionStart!;
    if (type == CourseUtil.twoSections || courseType != 1) {
      return children;
    } else {
      Widget blankBox = Expanded(
        flex: 87,
        child: Container(),
      );
      if (CourseUtil.isStrangeCourse(course)) {
        children.insert(0, blankBox);
      } else {
        children.add(blankBox);
      }
    }
    return children;
  }
}
