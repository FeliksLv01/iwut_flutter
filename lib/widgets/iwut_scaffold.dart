import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iwut_flutter/config/color.dart';
import 'package:iwut_flutter/routers/navigator.dart';

class IwutScaffold extends StatefulWidget {
  final String title;
  final Widget body;
  final Color? appBarColor;
  final Color? titleColor;

  IwutScaffold({
    Key? key,
    required this.title,
    required this.body,
    this.appBarColor,
    this.titleColor,
  }) : super(key: key);

  @override
  _IwutScaffoldState createState() => _IwutScaffoldState();
}

class _IwutScaffoldState extends State<IwutScaffold> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor(context).scaffoldBgColor,
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        backgroundColor: widget.appBarColor ?? AppColor(context).appBarBgColor,
        title: Text(
          widget.title,
          style: TextStyle(
            color: widget.titleColor ?? AppColor(context).moreText,
            fontSize: 57.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
        leading: IconButton(
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
          icon: Icon(Icons.arrow_back_ios, color: widget.titleColor ?? AppColor.themeColor),
          onPressed: () => IwutNavigator.goBack(context),
        ),
      ),
      body: SafeArea(
        child: widget.body,
      ),
    );
  }
}
