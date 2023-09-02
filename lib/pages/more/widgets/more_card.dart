import 'package:flutter/material.dart';
import 'package:iwut_flutter/config/color.dart';
import 'package:iwut_flutter/utils/utils.dart';

class MoreCard extends StatelessWidget {
  /// icon
  final IconData? iconData;
  final String? imagePath;

  /// 标题
  final String? title;

  final Function? onTap;
  final bool showNext;
  final bool isActivity;

  MoreCard({
    this.iconData,
    this.imagePath,
    this.title,
    this.onTap,
    this.showNext = false,
    this.isActivity = false,
  });

  Widget get IconBox {
    if (iconData != null) {
      return Icon(iconData, size: 70.sp, color: isActivity ? AppColor.activityColor : AppColor.themeColor);
    } else if (imagePath != null) {
      return Image.asset(imagePath!, width: 70.w, height: 70.w);
    } else {
      return Container();
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap as void Function()?,
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
              IconBox,
              Padding(
                padding: EdgeInsets.only(left: 85.w),
              ),
              Text(
                title!,
                style: TextStyle(
                  color: isActivity ? AppColor.activityColor : AppColor(context).moreText,
                  fontSize: 50.sp,
                ),
              ),
              Spacer(),
              Visibility(
                visible: showNext,
                child: Container(
                  margin: EdgeInsets.only(right: 74.w),
                  child: Icon(
                    Icons.navigate_next_rounded,
                    color: isActivity ? AppColor.activityColor : AppColor(context).element2,
                    size: 70.sp,
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
