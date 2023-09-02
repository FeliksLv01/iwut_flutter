import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iwut_flutter/config/color.dart';
import 'package:iwut_flutter/model/room/campus.dart';
import 'package:iwut_flutter/pages/room/bottom_selector.dart';
import 'package:iwut_flutter/pages/room/room_content.dart';
import 'package:iwut_flutter/provider/room_provider.dart';
import 'package:iwut_flutter/routers/navigator.dart';
import 'package:iwut_flutter/utils/utils.dart';
import 'package:provider/provider.dart';

class RoomPage extends StatefulWidget {
  @override
  _RoomPageState createState() => _RoomPageState();
}

class _RoomPageState extends State<RoomPage> {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<RoomProvider>(
      create: (_) => RoomProvider(),
      builder: (context, _) => Consumer<RoomProvider>(
        builder: (context, vm, _) => WillPopScope(
          onWillPop: () => Future.value(!vm.backUp()),
          child: Scaffold(
            appBar: _buildAppBar(vm),
            backgroundColor: AppColor(context).roomBGColor,
            body: Column(
              children: [_buildSelectorBar(), Expanded(child: RoomContent())],
            ),
          ),
        ),
      ),
    );
  }

  /// 构建顶部APPBar
  AppBar _buildAppBar(RoomProvider vm) {
    return AppBar(
      title: Text(
        "自习室",
        style: TextStyle(
          fontSize: 60.sp,
          color: AppColor(context).white,
        ),
      ),
      centerTitle: true,
      leading: IconButton(
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
        icon: Icon(Icons.arrow_back_ios),
        iconSize: 60.sp,
        color: AppColor(context).white,
        onPressed: () {
          if (!vm.backUp()) {
            IwutNavigator.goBack(context);
          }
        },
      ),
      actions: [
        IconButton(
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
          icon: Icon(Icons.close),
          iconSize: 70.sp,
          color: AppColor(context).white,
          onPressed: () {
            IwutNavigator.goBack(context);
          },
        )
      ],
      backgroundColor: AppColor(context).roomNavigatorColor,
      elevation: 0,
      // bottom: _buildSelectorBar(),
    );
  }

  /// 构建APPBar下方用于选择校区和时间的选择条
  PreferredSize _buildSelectorBar() {
    // 局部函数，用于构建选择条中单个的下拉按钮
    Widget _buildSelectorItem(String title, bool isActive, Function() onTap) {
      // 文字以及箭头显示的颜色
      final elementColor = isActive ? AppColor(context).element2 : AppColor(context).element3;
      final double arrowAngle = isActive ? pi / 2 : 0;
      return GestureDetector(
        onTap: onTap,
        behavior: HitTestBehavior.opaque,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(title, style: TextStyle(fontSize: 46.sp, color: elementColor)),
            SizedBox(width: 6.w),
            Transform.rotate(
              angle: arrowAngle,
              child: Icon(
                Icons.play_arrow,
                size: 46.sp,
                color: elementColor,
              ),
            ),
          ],
        ),
      );
    }

    // 局部函数，用于构建整个选择条
    Widget _selectorBarBuilder(BuildContext context, RoomProvider vm, Widget? child) {
      return Container(
        height: 124.h,
        color: AppColor(context).pickerPanelBGColor,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: _buildSelectorItem(whutCampusShortTitle(vm.curCampus), vm.activeSelector == 0, () {
                modalCampusPicker(context, vm,
                    selectorIndex: 0,
                    onSubmit: (WHUTCampus campus) => vm.updateCampus(campus),
                    initCampus: vm.curCampus);
              }),
            ),
            Expanded(
              child: _buildSelectorItem(vm.startTimeText, vm.activeSelector == 1, () {
                modalTimePicker(
                  context,
                  vm,
                  selectorIndex: 1,
                  onSubmit: (int hour, int minute) => vm.updateStartTime(hour, minute),
                  initHour: vm.startHour,
                  initMinute: vm.startMinute,
                );
              }),
            ),
            Expanded(
              child: _buildSelectorItem(vm.endTimeText, vm.activeSelector == 2, () {
                modalTimePicker(
                  context,
                  vm,
                  selectorIndex: 2,
                  onSubmit: (int hour, int minute) => vm.updateEndTime(hour, minute),
                  initHour: vm.startHour,
                  initMinute: vm.startMinute,
                );
              }),
            )
          ],
        ),
      );
    }

    return PreferredSize(
      preferredSize: Size(ScreenUtil().screenWidth, 124.h),
      child: Consumer<RoomProvider>(builder: _selectorBarBuilder),
    );
  }
}
