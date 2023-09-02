import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iwut_flutter/config/color.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class CustomRefreshHeader extends StatefulWidget {
  @override
  _CustomRefreshHeaderState createState() => _CustomRefreshHeaderState();
}

class _CustomRefreshHeaderState extends State<CustomRefreshHeader> {
  double _offset = 0.0;

  Widget _buildHeader(BuildContext context, RefreshStatus? mode) {
    Widget? child;
    if (mode == RefreshStatus.idle || mode == RefreshStatus.canRefresh) {
      child = Container(
        width: 50.w,
        height: 50.w,
        child: CircularProgressIndicator(
          strokeWidth: 5.w,
          value: _offset / 80.0,
          valueColor: AlwaysStoppedAnimation(
            AppColor.themeColor,
          ),
        ),
      );
    }
    if (mode == RefreshStatus.refreshing) {
      child = Container(
        width: 50.w,
        height: 50.w,
        child: CircularProgressIndicator(
          strokeWidth: 5.w,
          valueColor: AlwaysStoppedAnimation(
            AppColor.themeColor,
          ),
        ),
      );
    }
    if (mode == RefreshStatus.completed) {
      child = Container(
        width: 50.w,
        height: 50.w,
        decoration: BoxDecoration(
          border: Border.all(
            color: AppColor.themeColor,
            width: 5.w,
          ),
          borderRadius: BorderRadius.all(Radius.circular(10.w)),
        ),
        alignment: Alignment.center,
        child: Icon(
          Icons.check,
          color: AppColor.themeColor,
          size: 15.w,
        ),
      );
    }
    if (mode == RefreshStatus.failed) {
      child = Text(
        '刷新失败',
        style: TextStyle(
          color: AppColor(context).loadingText,
          fontSize: 35.w,
        ),
      );
    }
    return Container(
      height: 80,
      alignment: Alignment.center,
      child: child,
    );
  }

  @override
  Widget build(BuildContext context) {
    return CustomHeader(
      builder: _buildHeader,
      onOffsetChange: (offset) {
        setState(() {
          _offset = offset;
        });
      },
    );
  }
}

class CustomRefreshFooter extends StatefulWidget {
  @override
  _CustomRefreshFooterState createState() => _CustomRefreshFooterState();
}

class _CustomRefreshFooterState extends State<CustomRefreshFooter> {
  double _offset = 0.0;

  Widget _buildFooter(BuildContext context, LoadStatus? mode) {
    Widget? child;
    if (mode == LoadStatus.idle || mode == LoadStatus.canLoading) {
      child = Container(
        width: 50.w,
        height: 50.w,
        child: CircularProgressIndicator(
          strokeWidth: 5.w,
          value: _offset / 80.0,
          valueColor: AlwaysStoppedAnimation(AppColor.themeColor),
        ),
      );
    }
    if (mode == LoadStatus.loading) {
      child = Container(
        width: 50.w,
        height: 50.w,
        child: CircularProgressIndicator(
          strokeWidth: 5.w,
          valueColor: AlwaysStoppedAnimation(AppColor.themeColor),
        ),
      );
    }
    if (mode == LoadStatus.failed || mode == LoadStatus.noMore) {
      child = Text(
        //mode == LoadStatus.failed ? '加载失败' : '没有更多了',
        '没有更多了',
        style: TextStyle(
          color: AppColor(context).loadingText,
          fontSize: 35.w,
        ),
      );
    }
    return Container(
      height: 80,
      alignment: Alignment.center,
      child: child,
    );
  }

  @override
  Widget build(BuildContext context) {
    return CustomFooter(
      builder: _buildFooter,
      onOffsetChange: (offset) {
        setState(() {
          _offset = offset;
        });
      },
    );
  }
}
