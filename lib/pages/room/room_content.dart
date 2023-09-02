import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:iwut_flutter/config/color.dart';
import 'package:iwut_flutter/config/image_path.dart';
import 'package:iwut_flutter/pages/room/room_picker_list.dart';
import 'package:iwut_flutter/provider/room_provider.dart';
import 'package:iwut_flutter/utils/utils.dart';
import 'package:provider/provider.dart';

class RoomContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<RoomProvider>(
      builder: _mainContentBuilder,
    );
  }

  Widget _mainContentBuilder(BuildContext context, RoomProvider vm, Widget? child) {
    final stage = vm.curStage;
    if (stage == 0) {
      return _selectorUnreadyContent(context);
    } else if (stage == 1) {
      return _loadingContent(context);
    } else if (stage == 2) {
      return _shouldRefreshContent(context, vm.loadingError!, vm);
    } else if (stage == 3) {
      return _shouldRefreshContent(context, "未能成功加载自习室数据", vm);
    } else if (stage == 4) {
      return _shouldRefreshContent(context, "发生未知错误", vm);
    } else {
      return RoomPickerList();
    }
  }

  /// 构建选择器未选择完成时的页面：提示用户选择自习信息
  Widget _selectorUnreadyContent(BuildContext context) {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image.asset(
            ImagePath.Filter,
            width: 58.w,
            height: 58.w,
          ),
          SizedBox(
            width: 26.w,
          ),
          Text(
            "请选择自习信息",
            style: TextStyle(
              fontSize: 52.sp,
              color: AppColor(context).element4,
            ),
          ),
        ],
      ),
    );
  }

  /// 由于某种原因不得不刷新
  Widget _shouldRefreshContent(BuildContext context, String message, RoomProvider vm) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () => vm.loadRoomData(),
      child: Container(
        height: double.infinity,
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(
              Icons.refresh,
              size: 120.sp,
              color: AppColor(context).element6,
            ),
            SizedBox(
              height: 50.h,
            ),
            Text(message,
                style: TextStyle(
                  fontSize: 52.sp,
                  color: AppColor(context).element4,
                )),
            SizedBox(
              height: 10.h,
            ),
            Text(
              "点击刷新数据",
              style: TextStyle(
                fontSize: 52.sp,
                color: AppColor(context).element4,
              ),
            ),
            SizedBox(
              height: 120.h,
            )
          ],
        ),
      ),
    );
  }

  /// 加载中页面
  Widget _loadingContent(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          CupertinoActivityIndicator(
            radius: 50.sp,
          ),
          SizedBox(
            height: 30.h,
          ),
          Text(
            "加载中",
            style: TextStyle(
              fontSize: 52.sp,
              color: AppColor(context).element4,
            ),
          ),
          SizedBox(
            height: 120.h,
          ),
        ],
      ),
    );
  }
}
