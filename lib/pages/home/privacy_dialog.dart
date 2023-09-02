import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:iwut_flutter/config/color.dart';
import 'package:iwut_flutter/http/server_url.dart';
import 'package:iwut_flutter/routers/navigator.dart';
import 'package:iwut_flutter/utils/utils.dart';

class PrivacyDialog extends StatelessWidget {
  const PrivacyDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      elevation: 10,
      backgroundColor: AppColor(context).dialogBGColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      titlePadding: EdgeInsets.all(0),
      titleTextStyle: TextStyle(fontSize: 46.sp),
      title: Container(
        height: 156.h,
        decoration: BoxDecoration(
          // color: AppColor(context).dialogBGColor,
          shape: BoxShape.rectangle,
          borderRadius: BorderRadius.only(topLeft: Radius.circular(10), topRight: Radius.circular(10)),
        ),
        child: Center(
          child: Text(
            '欢迎您使用掌上吾理',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
      ),
      contentPadding: EdgeInsets.symmetric(horizontal: 16),
      children: [
        Text.rich(
          TextSpan(
            children: [
              TextSpan(
                text: "尊敬的用户，在使用前，请您务必慎重阅读",
              ),
              TextSpan(
                text: "《隐私政策》",
                style: TextStyle(color: Colors.lightBlue),
                recognizer: TapGestureRecognizer()
                  ..onTap = () {
                    IwutNavigator.goWebView(context, ServerUrl.PRIVACY);
                  },
              ),
              TextSpan(
                text: "充分理解相关条款内容。\n \n",
              ),
              TextSpan(
                text: "点击同意即代表您已阅读并同意",
              ),
              TextSpan(
                text: "《隐私政策》",
                style: TextStyle(color: Colors.lightBlue),
                recognizer: TapGestureRecognizer()
                  ..onTap = () {
                    IwutNavigator.goWebView(context, ServerUrl.PRIVACY);
                  },
              ),
              TextSpan(
                text: "，如果您不同意隐私政策的内容，将无法使用我们提供的服务。我们会尽全力保护您的个人信息安全。",
              ),
            ],
          ),
          textAlign: TextAlign.start,
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 48, vertical: 10),
          child: ElevatedButton(
              onPressed: () => Navigator.pop(context),
              style: ElevatedButton.styleFrom(
                primary: AppColor(context).buttonBGColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                ),
              ),
              child: Text('好的', style: TextStyle(fontSize: 20, color: Colors.white))),
        )
      ],
    );
  }
}
