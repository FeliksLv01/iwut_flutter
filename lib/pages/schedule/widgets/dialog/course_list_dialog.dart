import 'package:flutter/material.dart';
import 'package:iwut_flutter/config/color.dart';
import 'package:iwut_flutter/model/course/course.dart';
import 'package:iwut_flutter/pages/schedule/widgets/dialog/course_dialog.dart';
import 'package:iwut_flutter/utils/utils.dart';
import 'package:iwut_flutter/widgets/my_behavior.dart';

class CourseListDialog extends StatefulWidget {
  final Color? color;
  final Color titleColor;
  final List<Course> courseModel;
  CourseListDialog(this.color, this.titleColor, this.courseModel);

  @override
  _CourseListDialogState createState() => _CourseListDialogState();
}

class _CourseListDialogState extends State<CourseListDialog> {
  @override
  Widget build(BuildContext context) {
    Color? color = widget.color;
    Color titleColor = widget.titleColor;
    List<Course> courseModel = widget.courseModel;
    courseModel.sort((a, b) => b.priority!.compareTo(a.priority!));
    List<ListTile> list = [];
    for (var item in courseModel) {
      ListTile listTile = ListTile(
        key: ValueKey(item.id),
        title: Text(item.name!),
        subtitle: Text(
          item.room! +
              '  第' +
              item.weekStart.toString() +
              '-' +
              item.weekEnd.toString() +
              '周  ' +
              CourseUtil.getCourseTime(item.sectionStart, item.sectionEnd),
          softWrap: false,
          overflow: TextOverflow.ellipsis,
        ),
        trailing: Icon(Icons.sort),
        onTap: () {
          showIwutDialog(
            context: context,
            routeSettings: RouteSettings(name: 'courseDialog'),
            builder: (context) {
              return CourseDialog(color, item, textColor: titleColor);
            },
          );
        },
      );
      list.add(listTile);
    }

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
                      "该时间段有多门课程" "\n" "长按拖动可更改顺序",
                      style: TextStyle(color: titleColor, fontSize: 40.sp),
                    ),
                  ),
                ),
                Container(
                  height: 850.h,
                  decoration: BoxDecoration(color: AppColor(context).addBGColor),
                  child: ScrollConfiguration(
                    behavior: MyBehavior(),
                    child: ReorderableListView(
                      children: list,
                      onReorder: (int oldIndex, int newIndex) {
                        setState(() {
                          if (newIndex == list.length) {
                            newIndex = list.length - 1;
                          }
                          var item = list.removeAt(oldIndex);
                          var course = courseModel.removeAt(oldIndex);
                          courseModel.insert(newIndex, course);
                          list.insert(newIndex, item);
                        });
                        CourseUtil.changeIndex(courseModel, context);
                      },
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
