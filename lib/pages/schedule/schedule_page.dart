import 'dart:io';

import 'package:badges/badges.dart' as badges;
import 'package:flutter/material.dart';
import 'package:iwut_flutter/config/color.dart';
import 'package:iwut_flutter/dao/course_dao.dart';
import 'package:iwut_flutter/global.dart';
import 'package:iwut_flutter/model/course/course.dart';
import 'package:iwut_flutter/pages/schedule/widgets/button/my_floating_button_location.dart';
import 'package:iwut_flutter/pages/schedule/widgets/button/schedule_button.dart';
import 'package:iwut_flutter/pages/schedule/widgets/column/opacity_monday_column.dart';
import 'package:iwut_flutter/pages/schedule/widgets/column/opacity_tuesday_column.dart';
import 'package:iwut_flutter/pages/schedule/widgets/column/schedule_column.dart';
import 'package:iwut_flutter/pages/schedule/widgets/schedule_title.dart';
import 'package:iwut_flutter/pages/schedule/widgets/side_banner.dart';
import 'package:iwut_flutter/provider/course_provider.dart';
import 'package:iwut_flutter/provider/message_provider.dart';
import 'package:iwut_flutter/provider/transparent_provider.dart';
import 'package:iwut_flutter/routers/navigator.dart';
import 'package:iwut_flutter/service/database_service.dart';
import 'package:iwut_flutter/utils/utils.dart';
import 'package:iwut_flutter/widgets/my_behavior.dart';
import 'package:provider/provider.dart';

class SchedulePage extends StatefulWidget {
  SchedulePage();

  @override
  _SchedulePageState createState() => _SchedulePageState();
}

class _SchedulePageState extends State<SchedulePage> {
  ScrollController? _scrollController;

  _loadData() async {
    var courseProvider = Provider.of<CourseProvider>(context, listen: false);
    CourseDao courseDao = await dbService.getCourseDao();
    var list = await courseDao.findAllCourses();
    String? path = StorageUtil().getBackgroundImage();
    courseProvider.loadData(list, path);
  }

  void _onScroll(offset) {
    var scrollProvider = Provider.of<TransparentProvider>(context, listen: false);
    double alpha = offset / ((ScreenUtil().screenWidth - 118.w) * 0.38);
    if (alpha < 0) {
      alpha = 0;
    } else if (alpha > 1) {
      alpha = 1;
    }
    if (alpha <= 0.5 && alpha >= 0) {
      scrollProvider.alphaMonday = 1 - alpha * 2;
      scrollProvider.alphaTuesday = 1;
    } else {
      scrollProvider.alphaMonday = 0;
      scrollProvider.alphaTuesday = 2 - alpha * 2;
    }
  }

  @override
  void initState() {
    super.initState();
    _loadData();
    if (DateUtil.getDayIndex() >= 6) {
      _scrollController = ScrollController(initialScrollOffset: (ScreenUtil().screenWidth - 130.w) / 5 * 2);
    }
  }

  @override
  Widget build(BuildContext context) {
    var courseProvider = Provider.of<CourseProvider>(context);
    List<Course> courseList = courseProvider.courseList;
    var dayMap = CourseUtil.getColumnData(courseList);
    bool hasBackGroundImage = courseProvider.hasBackground;
    String? imagePath = courseProvider.imagePath;
    Color? bgColor = hasBackGroundImage ? Colors.transparent : null;
    return Stack(
      children: [
        Container(
          decoration: BoxDecoration(
            image: imagePath == null
                ? null
                : DecorationImage(
                    image: FileImage(
                      File(imagePath),
                    ),
                    fit: BoxFit.cover,
                  ),
          ),
        ),
        Scaffold(
          backgroundColor: bgColor,
          resizeToAvoidBottomInset: false,
          appBar: AppBar(
            backgroundColor: bgColor ?? AppColor(context).appBarBgColor,
            title: ScheduleTitle(),
            centerTitle: true,
            elevation: 0,
            automaticallyImplyLeading: false,
            actions: [
              IconButton(
                splashColor: Colors.transparent,
                highlightColor: Colors.transparent,
                icon: Consumer<MessageProvider>(
                  builder: (context, messageProvider, child) {
                    return badges.Badge(
                      padding: EdgeInsets.all(2),
                      position: badges.BadgePosition(top: -8, end: -1),
                      showBadge: messageProvider.messageSum > 0 || Global.isFirstOpen,
                      badgeContent: Text(' '),
                      child: Icon(Icons.more_vert),
                    );
                  },
                ),
                onPressed: () {
                  IwutNavigator.goMorePage(context);
                },
              )
            ],
          ),
          floatingActionButtonLocation: MyFloatingButtonLocation(FloatingActionButtonLocation.endFloat, -8, -64),
          floatingActionButton: courseList.length > 0 ? null : ScheduleButton(),
          body: SafeArea(
            child: Stack(
              children: [
                NotificationListener(
                  onNotification: (dynamic notification) {
                    if (notification is ScrollUpdateNotification && notification.depth == 0) {
                      _onScroll(notification.metrics.pixels);
                    }
                    return false;
                  },
                  child: ScrollConfiguration(
                    behavior: MyBehavior(),
                    child: ListView(
                      physics: ClampingScrollPhysics(),
                      scrollDirection: Axis.horizontal,
                      controller: _scrollController,
                      children: [
                        Padding(padding: EdgeInsets.only(left: 118.w)),
                        OpacityMondayColumn(courseList: dayMap[1], hasBackGroundImage: hasBackGroundImage),
                        OpacityTuesdayColumn(courseList: dayMap[2], hasBackGroundImage: hasBackGroundImage),
                        ScheduleColumn(DateTime.wednesday,
                            courseList: dayMap[3], hasBackGroundImage: hasBackGroundImage),
                        ScheduleColumn(DateTime.thursday,
                            courseList: dayMap[4], hasBackGroundImage: hasBackGroundImage),
                        ScheduleColumn(DateTime.friday, courseList: dayMap[5], hasBackGroundImage: hasBackGroundImage),
                        ScheduleColumn(DateTime.saturday,
                            courseList: dayMap[6], hasBackGroundImage: hasBackGroundImage),
                        ScheduleColumn(DateTime.sunday, courseList: dayMap[7], hasBackGroundImage: hasBackGroundImage),
                        Container(
                          constraints: BoxConstraints(minWidth: 12.w),
                          child: Column(
                            children: [
                              Container(
                                constraints: BoxConstraints(
                                  minHeight: 121.h,
                                  minWidth: 12.w,
                                ),
                                color:
                                    hasBackGroundImage ? Colors.transparent : AppColor(context).courseHeadBannerBGColor,
                              ),
                              Expanded(
                                child: Container(
                                  width: 12.w,
                                  color: hasBackGroundImage ? Colors.transparent : AppColor(context).courseMainBGColor,
                                ),
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SideBanner(hasBackGroundImage: hasBackGroundImage)
              ],
            ),
          ),
        ),
      ],
    );
  }
}
