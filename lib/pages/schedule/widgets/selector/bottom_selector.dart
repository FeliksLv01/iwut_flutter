import 'package:flutter/material.dart';
import 'package:iwut_flutter/config/color.dart';
import 'package:iwut_flutter/utils/utils.dart';

class BottomSelector extends StatefulWidget {
  final Function onSubmit;
  final Widget content;
  BottomSelector(this.content, this.onSubmit);

  @override
  _BottomSelectorState createState() => _BottomSelectorState();
}

class _BottomSelectorState extends State<BottomSelector> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 605.h,
      decoration: BoxDecoration(borderRadius: BorderRadius.vertical(top: Radius.circular(30.w))),
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: [_buildHeader(context, widget.onSubmit as dynamic Function()), widget.content],
      ),
    );
  }

  Widget _buildHeader(BuildContext context, Function() onSubmit) {
    Widget _buildButton(String title, Color textColor, Function() onClick) {
      return GestureDetector(
        behavior: HitTestBehavior.opaque,
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
}
