import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iwut_flutter/config/color.dart';

class EditTextField extends StatefulWidget {
  /// icon
  final Widget icon;
  final String? hintText;

  /// 标题
  final String? text;
  final bool isSelector;
  final Function? onTab;
  final TextEditingController controller;

  EditTextField(this.icon, this.text, this.controller, {this.isSelector = false, this.hintText, this.onTab});

  @override
  _EditTextFieldState createState() => _EditTextFieldState();
}

class _EditTextFieldState extends State<EditTextField> {
  @override
  Widget build(BuildContext context) {
    Widget icon = widget.icon;
    String text = widget.text!;
    String? hintText = widget.hintText;
    TextEditingController controller = widget.controller;
    Function? function = widget.onTab;
    bool isSelector = widget.isSelector;
    controller.text = text;
    return Container(
      height: 140.h,
      margin: EdgeInsets.only(
        left: 31.w,
        right: 31.w,
        bottom: 24.h,
      ),
      decoration: BoxDecoration(
        color: AppColor(context).moreCellBGColor,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          Padding(
            padding: EdgeInsets.only(left: 50.w),
          ),
          icon,
          Padding(
            padding: EdgeInsets.only(left: 40.w),
          ),
          Expanded(
            child: TextField(
              readOnly: isSelector,
              showCursor: !isSelector,
              cursorColor: Colors.grey,
              controller: controller,
              decoration: InputDecoration(
                hintText: hintText,
                border: InputBorder.none,
              ),
              onTap: function as void Function()?,
              style: TextStyle(
                color: AppColor(context).moreText,
                fontSize: 50.sp,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
