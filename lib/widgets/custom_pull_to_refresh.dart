import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iwut_flutter/config/color.dart';
import 'package:iwut_flutter/widgets/loading_dialog.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class CustomRefresherController extends RefreshController with ChangeNotifier {
  CustomRefresherController();

  bool _refFailed = false;
  bool refNoData = false;
  bool get refFailed => _refFailed;
  set refFailed(value) {
    _refFailed = value;
    notifyListeners();
  }

  @override
  void refreshFailed() {
    _refFailed = true;
    notifyListeners();
    super.refreshFailed();
  }

  @override
  void refreshCompleted({bool resetFooterState = false}) {
    _refFailed = false;
    refNoData = false;
    notifyListeners();
    super.refreshCompleted(resetFooterState: resetFooterState);
  }

  void refreshNoData() {
    refNoData = true;
    notifyListeners();
    refreshToIdle();
  }

  void finishRefresh(bool success, {bool noMore = false}) {
    if (success) {
      if (noMore) {
        refreshNoData();
      } else {
        refreshCompleted(resetFooterState: true);
      }
    } else {
      refreshFailed();
    }
  }

  void finishLoad(bool success, {bool noMore = false}) {
    if (success) {
      if (noMore) {
        loadNoData();
      } else {
        loadComplete();
      }
    } else {
      loadFailed();
    }
  }
}

class CustomRefresher extends StatefulWidget {
  final Widget child;
  final Widget? header;
  final Widget? footer;
  final bool enablePullUp;
  final bool enablePullDown;
  final VoidCallback? onRefresh;
  final VoidCallback? onLoading;
  final CustomRefresherController controller;
  final ScrollController? scrollController;

  /// 下拉刷新数据为空时
  final Widget? emptyView;
  final Widget? firstRefreshingView;
  final Widget? firstRefreshFailedView;

  CustomRefresher({
    required this.controller,
    required this.child,
    Key? key,
    this.enablePullDown = true,
    this.enablePullUp = false,
    this.header,
    this.footer,
    this.onRefresh,
    this.onLoading,
    this.emptyView,
    this.firstRefreshingView,
    this.firstRefreshFailedView,
    this.scrollController,
  }) : super(key: key);
  @override
  _CustomRefresherState createState() => _CustomRefresherState();
}

class _CustomRefresherState extends State<CustomRefresher> {
  bool _refreshSuccessBefore = false;

  Widget get failedView {
    return GestureDetector(
      onTap: () {
        widget.controller.requestRefresh(needMove: false);
        widget.controller.refFailed = false;
      },
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            widget.firstRefreshFailedView ?? Container(),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  '加载失败，点击重试',
                  style: TextStyle(
                    color: AppColor.themeColor,
                    fontSize: 35.w,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Icon(
                    Icons.refresh,
                    color: AppColor.themeColor,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget get emptyView {
    return Center(
      child: widget.emptyView ?? Container(),
    );
  }

  Widget get loadingView {
    return Center(
      child: widget.firstRefreshingView ?? createLoadingWidget(),
    );
  }

  Widget createLoadingWidget() {
    return Center(
      child: LoadingDialog(),
    );
  }

  void _updateView() {
    if (mounted) setState(() {});
  }

  @override
  void initState() {
    /// 加载后进入刷新
    /// 其实原始的RefreshController包含initialRefresh属性可以实现这一点
    /// 但顶部会自动下拉，与默认的刷新页面冲突
    /// 这里仿造一下将needMove置为false就行
    if (widget.enablePullDown) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) widget.controller.requestRefresh(needMove: false);
      });
      widget.controller.headerMode!.addListener(() {
        if (widget.controller.headerMode!.value == RefreshStatus.completed && mounted) {
          setState(() {
            _refreshSuccessBefore = true;
          });
        }
      });
    }
    widget.controller.addListener(_updateView);
    super.initState();
  }

  @override
  void dispose() {
    widget.controller.removeListener(_updateView);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SmartRefresher(
      controller: widget.controller,
      child: (() {
        if (!widget.enablePullDown) return widget.child;
        if (widget.controller.refNoData) return emptyView;
        if (_refreshSuccessBefore) {
          return widget.child;
        } else {
          if (widget.controller.refFailed) return failedView;
          return loadingView;
        }
      })(),
      header: widget.header,
      footer: widget.footer,
      enablePullUp: widget.enablePullUp,
      enablePullDown: widget.enablePullDown,
      onRefresh: widget.onRefresh,
      onLoading: widget.onLoading,
      scrollController: widget.scrollController,
    );
  }
}
