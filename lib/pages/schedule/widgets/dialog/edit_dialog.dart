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

class EditDialog extends StatefulWidget {
  final Color? color;
  final Course course;
  final Color textColor;
  EditDialog(this.color, this.course, this.textColor);

  @override
  _EditDialogState createState() => _EditDialogState();
}

class _EditDialogState extends State<EditDialog> {
  Color? color;
  Course? course;
  Color? textColor;
  TextEditingController nameController = TextEditingController();
  TextEditingController timeController = TextEditingController();
  TextEditingController weekController = TextEditingController();
  TextEditingController teacherController = TextEditingController();
  TextEditingController roomController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    color = widget.color;
    course = widget.course;
    textColor = widget.textColor;
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
                  decoration: BoxDecoration(
                    color: color,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: _buildHeader(context),
                  ),
                ),
                Container(
                  height: 850.h,
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
          child: Icon(Icons.close, color: textColor),
        ),
      ),
      Text(
        '修改课程信息',
        style: TextStyle(color: textColor, fontSize: 46.sp),
      ),
      GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () async {
          await _doSubmit();
        },
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 18),
          child: Icon(Icons.check, color: textColor),
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
    var dao = await dbService.getCourseDao();
    await dao.updateCourse(course!);
    var courseProvider = Provider.of<CourseProvider>(context, listen: false);
    var list = await dao.findAllCourses();
    courseProvider.updateCourses(list);
    HomeWidgetUtil.updateWidget(name: "widget.CourseWidgetProvider");
    IwutNavigator.goBack(context);
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
            },
          );
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
            },
          );
        },
      ),
    ];
  }
}
