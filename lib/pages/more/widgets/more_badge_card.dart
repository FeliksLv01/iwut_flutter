import 'package:flutter/material.dart';
import 'package:iwut_flutter/config/color.dart';
import 'package:iwut_flutter/utils/utils.dart';

class MoreBadgeCard extends StatefulWidget {
  /// icon
  final Widget icon;

  /// 标题
  final String title;

  final Function function;
  final bool showNext;

  MoreBadgeCard(this.icon, this.title, this.function, {this.showNext = false});

  @override
  _MoreBadgeCardState createState() => _MoreBadgeCardState();
}

class _MoreBadgeCardState extends State<MoreBadgeCard> {
  @override
  Widget build(BuildContext context) {
    Widget icon = widget.icon;
    String title = widget.title;
    Function function = widget.function;
    return GestureDetector(
      onTap: function as void Function()?,
      child: AspectRatio(
        aspectRatio: 5.6,
        child: Container(
          margin: EdgeInsets.only(
            top: 24.h,
            left: 31.w,
            right: 31.w,
          ),
          decoration: BoxDecoration(
            color: AppColor(context).moreCellBGColor,
            borderRadius: BorderRadius.circular(17.w),
            boxShadow: [BoxShadow(blurRadius: 2, spreadRadius: 1, color: Color.fromARGB(23, 0, 0, 0))],
          ),
          child: Row(
            children: [
              Padding(
                padding: EdgeInsets.only(left: 74.w),
              ),
              icon,
              Padding(
                padding: EdgeInsets.only(left: 85.w),
              ),
              Text(
                title,
                style: TextStyle(
                  color: AppColor(context).moreText,
                  fontSize: 50.sp,
                ),
              ),
              Spacer(),
              Visibility(
                visible: widget.showNext,
                child: Container(
                  margin: EdgeInsets.only(right: 74.w),
                  child: Icon(Icons.navigate_next_rounded, color: AppColor(context).element2),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
