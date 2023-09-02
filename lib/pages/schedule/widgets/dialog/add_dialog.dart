import 'dart:math';

import 'package:flutter/material.dart';
import 'package:iwut_flutter/config/color.dart';
import 'package:iwut_flutter/model/course/course.dart';
import 'package:iwut_flutter/pages/schedule/widgets/dialog/edit_text_field.dart';
import 'package:iwut_flutter/pages/schedule/widgets/selector/section_selector.dart';
import 'package:iwut_flutter/pages/schedule/widgets/selector/week_scope_selector.dart';
import 'package:iwut_flutter/provider/course_provider.dart';
import 'package:iwut_flutter/routers/navigator.dart';
import 'package:iwut_flutter/service/database_service.dart';
import 'package:iwut_flutter/utils/utils.dart';
import 'package:provider/provider.dart';

class AddDialog extends StatefulWidget {
  final Course course;
  AddDialog(this.course);

  @override
  _AddDialogState createState() => _AddDialogState();
}

class _AddDialogState extends State<AddDialog> {
  Course? course;
  TextEditingController nameController = TextEditingController();
  TextEditingController timeController = TextEditingController();
  TextEditingController weekController = TextEditingController();
  TextEditingController teacherController = TextEditingController();
  TextEditingController roomController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    course = widget.course;
    return Material(
      type: MaterialType.transparency,
      child: Center(
        child: ClipRRect(
          borderRadius: BorderRadius.all(
            Radius.circular(10.0),
          ),
          child: Container(
            width: 800.w,
            height: 1005.h,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  height: 150.h,
                  decoration: BoxDecoration(
                    color: AppColor(context).courseBoxNoCourse,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: _buildHeader(context),
                  ),
                ),
                Container(
                  height: 855.h,
                  decoration: BoxDecoration(color: AppColor(context).addBGColor),
                  padding: EdgeInsets.only(top: 12, bottom: 0),
                  child: Column(
                    children: _buildChildren(course!),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  List<Widget> _buildHeader(BuildContext context) {
    return [
      GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () => IwutNavigator.goBack(context),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 18),
          child: Icon(
            Icons.close,
            color: AppColor(context).courseBoxNoCourseText,
          ),
        ),
      ),
      Text(
        '新增课程',
        style: TextStyle(color: AppColor(context).courseBoxNoCourseText, fontSize: 46.sp),
      ),
      GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () async {
          await _doSubmit();
        },
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 18),
          child: Icon(Icons.check, color: AppColor(context).courseBoxNoCourseText),
        ),
      ),
    ];
  }

  Future<void> _doSubmit() async {
    course!.name = nameController.text.trim();
    course!.teacher = teacherController.text.trim();
    course!.room = roomController.text.trim();
    var weekList = CourseUtil.getStringData(weekController.text.trim());
    var sectionList = CourseUtil.getStringData(timeController.text.trim());
    course!.weekStart = weekList[0];
    course!.weekEnd = weekList[1];
    course!.sectionStart = sectionList[0];
    course!.sectionEnd = sectionList[1];
    if (course!.isValid()) {
      var dao = await dbService.getCourseDao();
      Course? temp = await dao.findCourseByName(course!.name ?? 'test');
      course!.boxColor = temp?.boxColor ?? Random().nextInt(8);
      await dao.insertCourse(course!);
      var courseProvider = Provider.of<CourseProvider>(context, listen: false);
      var list = await dao.findAllCourses();
      courseProvider.updateCourses(list);
      HomeWidgetUtil.updateWidget(name: "widget.CourseWidgetProvider");
      IwutNavigator.goBack(context);
    } else {
      showToast('请将课程信息填写完整');
    }
  }

  List<Widget> _buildChildren(Course course) {
    String? name = course.name;
    String? teacher = course.teacher;
    String week = '第' + course.weekStart.toString() + '-' + course.weekEnd.toString() + '周';
    String? room = course.room;
    String time = '第' + course.sectionStart.toString() + '-' + course.sectionEnd.toString() + '节';
    List<String>? sectionList = CourseUtil.getSectionScope(course.sectionStart);
    return [
      EditTextField(Icon(Icons.sort, color: Colors.greenAccent), name, nameController, hintText: '课程名称'),
      EditTextField(
        Icon(Icons.person, color: Colors.blueAccent),
        teacher,
        teacherController,
        hintText: '授课老师',
      ),
      EditTextField(
        Icon(Icons.date_range, color: Colors.greenAccent),
        week,
        weekController,
        isSelector: true,
        onTab: () {
          showModalBottomSheet(
              context: context,
              backgroundColor: Colors.transparent,
              builder: (BuildContext buildContext) {
                return WeekScopeSelector(course.weekStart, course.weekEnd, weekController);
              });
        },
      ),
      EditTextField(Icon(Icons.place, color: Colors.redAccent), room, roomController, hintText: '上课地点'),
      EditTextField(
        Icon(Icons.access_time, color: Colors.orangeAccent),
        time,
        timeController,
        isSelector: true,
        onTab: () {
          showModalBottomSheet(
              context: context,
              backgroundColor: Colors.transparent,
              builder: (BuildContext buildContext) {
                return SectionSelector(time, sectionList, timeController);
              });
        },
      ),
    ];
  }
}
