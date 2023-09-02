import 'package:flutter/material.dart';
import 'package:iwut_flutter/config/color.dart';
import 'package:iwut_flutter/model/room/campus.dart';
import 'package:iwut_flutter/pages/room/campus_selector.dart';
import 'package:iwut_flutter/pages/room/time_selector.dart';
import 'package:iwut_flutter/provider/room_provider.dart';
import 'package:iwut_flutter/utils/utils.dart';

/// 弹出校区选择器的方法
modalCampusPicker(
  BuildContext context,
  RoomProvider vm, {
  WHUTCampus? initCampus,
  int? selectorIndex,
  Function(WHUTCampus)? onSubmit,
}) async {
  vm.activeSelector = selectorIndex;
  await showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      routeSettings: RouteSettings(name: 'RoomCampusSelector'),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      builder: (context) {
        return RoomCampusSelector(
          initCampus: initCampus,
          onSubmit: onSubmit,
        );
      });
  vm.activeSelector = null;
}

/// 弹出时间选择器的方法
modalTimePicker(BuildContext context, RoomProvider vm,
    {int selectorIndex = 0,
    int minHour = 8,
    int minMinute = 0,
    int maxHour = 21,
    int maxMinute = 25,
    int? initHour = 8,
    int? initMinute = 0,
    Function(int hour, int minute)? onSubmit}) async {
//  final roomProvider = Provider.of<RoomProvider>(context);
//  roomProvider.activeSelector = selectorIndex;
  vm.activeSelector = selectorIndex;
  await showModalBottomSheet(
      context: context,
      backgroundColor: Colors.black54,
      routeSettings: RouteSettings(name: 'RoomTimeSelector'),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      builder: (context) {
        return RoomTimeSelector(
          minHour: minHour,
          minMinute: minMinute,
          maxHour: maxHour,
          maxMinute: maxMinute,
          initHour: initHour,
          initMinute: initMinute,
          onSubmit: onSubmit,
        );
      });
  vm.activeSelector = null;
}

/// 快速构建选择器的帮助方法
/// child：选择器本体，onSubmit：点击确定按钮要执行的闭包
Widget buildSelector(BuildContext context, Widget child, Function() onSubmit) {
  return Container(
    height: 605.h,
    decoration: BoxDecoration(borderRadius: BorderRadius.vertical(top: Radius.circular(10))),
    clipBehavior: Clip.antiAlias,
    child: Column(
      children: [_buildSelectorHeader(context, onSubmit), _buildSelectorBottom(context, child)],
    ),
  );
}

/// 构建选择器上方的取消、确定按钮
/// onSubmit：点击确定按钮之后执行的闭包
Widget _buildSelectorHeader(BuildContext context, Function() onSubmit) {
  Widget _buildButton(String title, Color textColor, Function() onClick) {
    return GestureDetector(
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 26.h, horizontal: 66.w),
        child: Text(
          title,
          style: TextStyle(
            fontSize: 46.sp,
            color: textColor,
          ),
        ),
      ),
      onTap: () {
        onClick();
      },
    );
  }

  return Container(
    height: 124.h,
    width: double.infinity,
    decoration: BoxDecoration(
      border: Border(bottom: BorderSide(color: AppColor(context).element1)),
      color: AppColor(context).pickerPanelBGColor,
    ),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _buildButton("取消", AppColor(context).element1, () {
          Navigator.pop(context);
        }),
        _buildButton("确定", AppColor(context).element2, () {
          onSubmit();
          Navigator.pop(context);
        }),
      ],
    ),
  );
}

/// 构建选择器下方的容器
Widget _buildSelectorBottom(BuildContext context, Widget child) {
  return Container(
      height: 475.h,
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(165.w, 20.h, 170.w, 58.h),
      color: AppColor(context).pickerPanelBGColor,
      child: child);
}
