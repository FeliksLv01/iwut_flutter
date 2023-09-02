import 'package:flutter/material.dart';
import 'package:flutter_swiper_null_safety/flutter_swiper_null_safety.dart';
import 'package:iwut_flutter/config/color.dart';
import 'package:iwut_flutter/dao/course_dao.dart';
import 'package:iwut_flutter/global.dart';
import 'package:iwut_flutter/model/course/course.dart';
import 'package:iwut_flutter/pages/schedule/widgets/dialog/add_info_dialog.dart';
import 'package:iwut_flutter/pages/schedule/widgets/dialog/course_dialog.dart';
import 'package:iwut_flutter/pages/schedule/widgets/dialog/delete_dialog.dart';
import 'package:iwut_flutter/provider/course_provider.dart';
import 'package:iwut_flutter/service/database_service.dart';
import 'package:iwut_flutter/utils/utils.dart';
import 'package:provider/provider.dart';

class CourseBox extends StatefulWidget {
  /// 格子颜色
  final Color color;

  /// 课程数据
  final Course? courseBoxModel;

  /// 文字颜色
  final Color textColor;

  /// 是否有背景图片
  final bool hasBackGroundImage;

  final Function? gotoAddPage;

  /// 课程类型
  final int? type;
  CourseBox(this.color, this.courseBoxModel, this.type,
      {this.textColor = Colors.white, this.hasBackGroundImage = false, this.gotoAddPage});

  @override
  _CourseBoxState createState() => _CourseBoxState();
}

class _CourseBoxState extends State<CourseBox> {
  @override
  Widget build(BuildContext context) {
    Color color = widget.color;
    Course courseBoxModel = widget.courseBoxModel!;
    Color textColor = widget.textColor;
    bool hasBackGroundImage = widget.hasBackGroundImage;
    var courseProvider = Provider.of<CourseProvider>(context);
    int? type = widget.type;
    return Opacity(
      opacity: hasBackGroundImage == false ? 1.0 : 0.8,
      child: Container(
        width: (ScreenUtil().screenWidth - 118.w) / 5,
        margin: EdgeInsets.only(
          top: 12.h,
          left: 12.w,
        ),
        child: Flex(
          direction: Axis.vertical,
          children: _buildChildren(color, textColor, courseProvider, courseBoxModel, type),
        ),
      ),
    );
  }

  Widget _buildCourseBox(Color color, Color textColor, CourseProvider courseProvider, Course courseBoxModel) {
    int sections = courseBoxModel.sectionEnd! - courseBoxModel.sectionStart! + 1;
    int? nameLine = sections == 2 ? Global.courseTwoConfig!.sectionTwoName : Global.courseThreeConfig!.sectionThreeName;
    int? roomLine =
        sections == 2 ? Global.courseTwoConfig!.sectionTwoPosition : Global.courseThreeConfig!.sectionThreePosition;
    return Expanded(
      flex: 259,
      child: Container(
        width: (ScreenUtil().screenWidth - 118.w) / 5,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.all(
              Radius.circular(5.0),
            ),
            color: color,
            border: Border.all(color: color)),
        padding: EdgeInsets.only(left: 12.w, right: 12.w),
        child: InkWell(
          onLongPress: () {
            showIwutDialog(
                context: context,
                routeSettings: RouteSettings(name: 'deleteCourseDialog'),
                builder: (context) {
                  return DeleteDialog(() async {
                    var list = courseProvider.courseList;
                    for (var item in list) {
                      if (item == courseBoxModel) {
                        list.remove(item);
                        break;
                      }
                    }
                    courseProvider.updateCourses(list);
                    CourseDao courseDao = await dbService.getCourseDao();
                    courseDao.deleteCourse(courseBoxModel);
                    HomeWidgetUtil.updateWidget(name: "widget.CourseWidgetProvider");
                  });
                });
          },
          onTap: () {
            showIwutDialog(
              context: context,
              routeSettings: RouteSettings(name: 'courseDialog'),
              builder: (context) {
                return Swiper.children(
                  children: [
                    CourseDialog(color, courseBoxModel, textColor: textColor),
                    AddInfoDialog(
                      Course.init(
                        courseBoxModel.weekDay,
                        courseBoxModel.sectionStart,
                        courseBoxModel.sectionEnd,
                      ),
                    )
                  ],
                  loop: false,
                  onTap: (index) => Navigator.pop(context),
                  pagination: SwiperPagination(
                    alignment: Alignment.bottomCenter,
                    margin: EdgeInsets.only(bottom: 50),
                    builder: DotSwiperPaginationBuilder(
                      space: 5,
                      color: AppColor(context).swiperDefaultColor,
                      activeColor: AppColor(context).swiperActiveColor,
                    ),
                  ),
                );
              },
            );
          },
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Text(
                  courseBoxModel.name!,
                  maxLines: nameLine,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(color: textColor, fontSize: 34.sp),
                ),
              ),
              Text(
                courseBoxModel.room!,
                maxLines: roomLine,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(color: textColor, fontSize: 34.sp),
              ),
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> _buildChildren(
      Color color, Color textColor, CourseProvider courseProvider, Course courseBoxModel, int? type) {
    List<Widget> children = [];
    Widget courseBox = _buildCourseBox(color, textColor, courseProvider, courseBoxModel);
    children.add(courseBox);
    int courseType = courseBoxModel.sectionEnd! - courseBoxModel.sectionStart!;
    if (type == CourseUtil.twoSections || courseType != 1) {
      return children;
    } else {
      Widget blankBox = Expanded(
        flex: 87,
        child: Container(),
      );
      if (CourseUtil.isStrangeCourse(courseBoxModel)) {
        children.insert(0, blankBox);
      } else {
        children.add(blankBox);
      }
    }
    return children;
  }
}
