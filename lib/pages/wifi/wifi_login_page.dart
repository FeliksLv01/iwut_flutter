import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iwut_flutter/config/color.dart';
import 'package:iwut_flutter/config/icon_font.dart';
import 'package:iwut_flutter/config/image_path.dart';
import 'package:iwut_flutter/pages/wifi/expanded_button.dart';
import 'package:iwut_flutter/utils/storage_util.dart';
import 'package:iwut_flutter/widgets/iwut_scaffold.dart';

class WifiLoginPage extends StatefulWidget {
  WifiLoginPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _WifiLoginPageState();
}

class _WifiLoginPageState extends State<WifiLoginPage> {
  static const platform = MethodChannel('com.itoken.team.iwut.wifi_connect');
  static const doPortalMethod = "com.itoken.team.iwut.wifi_connect.wifiutil.doportal";
  static const createShortCutMethod = "com.itoken.team.iwut.wifi_connect.wifiutil.addShortCut";
  final TextEditingController _cardIdTextController = TextEditingController(text: StorageUtil().getCardId());
  final TextEditingController _pwdTextController = TextEditingController(text: StorageUtil().getCardPwd());
  final _showPassWord = ValueNotifier<bool>(false);
  bool _isConnecting = false;

  @override
  Widget build(BuildContext context) {
    return IwutScaffold(
      title: "校园网登录",
      body: Column(
        children: [
          GestureDetector(
            onTap: () async {
              await platform.invokeMethod(createShortCutMethod);
            },
            child: Container(
              margin: EdgeInsets.symmetric(vertical: 50),
              child: Text('创建桌面快捷方式', style: TextStyle(color: AppColor.themeColor, fontSize: 18)),
            ),
          ),
          Container(
            width: 480.w,
            height: 480.w,
            margin: EdgeInsets.only(bottom: 50),
            padding: EdgeInsets.all(25),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(150),
              boxShadow: [BoxShadow(color: Colors.grey, blurRadius: 5)],
            ),
            child: Image.asset(
              ImagePath.WIFI_ICON,
              fit: BoxFit.contain,
            ),
          ),
          Expanded(child: _loginBody(context)),
        ],
      ),
    );
  }

  Widget _loginBody(BuildContext context) {
    return Column(
      children: [
        ExpandedButton(
          horizontalPadding: 40,
          button: ElevatedButton(
              style: ElevatedButton.styleFrom(
                primary: MaterialStateColor.resolveWith((states) => _isConnecting ? Colors.grey : AppColor.themeColor),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                ),
              ),
              onPressed: () {
                if (!_isConnecting) _getDoPortalResult();
              },
              child: Text(_isConnecting ? "正在连接" : "一键连接", style: TextStyle(fontSize: 16))),
        ),
        SizedBox(height: 8),
        ExpandedButton(
          button: TextButton(
            onPressed: () {
              showLoginDialog(context);
            },
            child: Text(
              "设置校园网账号",
              style: TextStyle(color: Colors.grey, fontSize: 16),
            ),
          ),
        ),
      ],
    );
  }

  void showLoginDialog(BuildContext context) {
    showCupertinoDialog(
      routeSettings: RouteSettings(name: 'JwcLoginDialog'),
      context: context,
      builder: (context) {
        return CupertinoAlertDialog(
          title: Text('请输入账号密码'),
          content: Container(
            child: Column(
              children: [SnoField, PassWordField],
            ),
          ),
          actions: <Widget>[
            CupertinoDialogAction(
              child: Text('确认'),
              onPressed: () async {
                StorageUtil().setCardId(_cardIdTextController.text);
                StorageUtil().setCardPwd(_pwdTextController.text);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  /// 学号输入框
  Widget get SnoField {
    return Container(
      height: 100.h,
      margin: EdgeInsets.only(top: 10),
      decoration: BoxDecoration(
        color: AppColor(context).moreCellBGColor,
        borderRadius: BorderRadius.circular(10),
      ),
      child: CupertinoTextField(
        autofocus: true,
        cursorColor: Colors.grey,
        controller: _cardIdTextController,
        prefix: Padding(
          padding: EdgeInsets.only(left: 10),
          child: Icon(Icons.person, color: Colors.grey),
        ),
        placeholder: '请输入校园卡号',
        style: TextStyle(color: AppColor(context).moreText, fontSize: 42.sp),
      ),
    );
  }

  Widget get PassWordField {
    return Container(
      height: 100.h,
      margin: EdgeInsets.only(top: 10),
      decoration: BoxDecoration(
        color: AppColor(context).moreCellBGColor,
        borderRadius: BorderRadius.circular(10),
      ),
      child: ValueListenableBuilder<bool>(
        valueListenable: _showPassWord,
        builder: (context, isShowPasswd, _) {
          return CupertinoTextField(
            obscureText: !isShowPasswd,
            cursorColor: Colors.grey,
            controller: _pwdTextController,
            prefix: Padding(
              padding: EdgeInsets.only(left: 10),
              child: Icon(Icons.lock, color: Colors.grey),
            ),
            suffix: GestureDetector(
              onTap: () => _showPassWord.value = !_showPassWord.value,
              child: Padding(
                padding: EdgeInsets.only(right: 10),
                child: Icon(isShowPasswd ? IconFont.hide1 : IconFont.eye, color: Colors.grey),
              ),
            ),
            placeholder: '请输入密码',
            style: TextStyle(color: AppColor(context).moreText, fontSize: 42.sp),
          );
        },
      ),
    );
  }

  Future<void> _getDoPortalResult() async {
    setState(() {
      _isConnecting = true;
    });
    try {
      await platform.invokeMethod(doPortalMethod);
    } catch (e) {}
    setState(() {
      _isConnecting = false;
    });
  }
}
