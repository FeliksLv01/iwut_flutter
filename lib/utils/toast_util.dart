import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:iwut_flutter/config/color.dart';
import 'package:iwut_flutter/global.dart';

//Toast提示组件显示工具
showToast(String message) {
  Fluttertoast.showToast(
    //提示消息
    msg: message,
    toastLength: Toast.LENGTH_SHORT,
    //居中
    gravity: ToastGravity.BOTTOM,
    timeInSecForIosWeb: 3,
    //背景色
    backgroundColor: AppColor.toastBgColor,
    //文本颜色
    textColor: AppColor.toastTextColor,
    fontSize: 40.0.sp,
  );
}

Future<T?> showIwutDialog<T>({
  required BuildContext context,
  required WidgetBuilder builder,
  RouteSettings? routeSettings,
}) {
  return showCupertinoDialog<T>(
    context: context,
    builder: builder,
    routeSettings: routeSettings,
    barrierDismissible: true,
    useRootNavigator: !Global.openDialogObserver,
  );
}
