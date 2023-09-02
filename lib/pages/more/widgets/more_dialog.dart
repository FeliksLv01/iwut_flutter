import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MoreDialog extends StatelessWidget {
  final String title;
  final String content;
  final TextStyle? cancelStyle;
  final TextStyle? sureStyle;
  final Function? onCancel;
  final Function onSure;
  const MoreDialog(
    this.content,
    this.onSure, {
    this.title = '提示',
    this.onCancel,
    this.sureStyle,
    this.cancelStyle,
  });

  @override
  Widget build(BuildContext context) {
    return CupertinoAlertDialog(
      title: Text(
        title,
        style: TextStyle(fontWeight: FontWeight.bold),
        textScaleFactor: 1.2,
      ),
      content: Text(
        content,
        textScaleFactor: 1.1,
        textAlign: TextAlign.center,
      ),
      actions: <Widget>[
        //操作控件
        CupertinoDialogAction(
          onPressed: () {
            onCancel ?? Navigator.pop(context);
          },
          textStyle: cancelStyle ?? TextStyle(color: Colors.blueAccent),
          child: Text('取消', textScaleFactor: 1.2),
        ),
        CupertinoDialogAction(
          onPressed: () {
            onSure();
            Navigator.pop(context);
          },
          textStyle: sureStyle ?? TextStyle(color: Colors.redAccent),
          child: Text('确定', textScaleFactor: 1.2),
        ),
      ],
    );
  }
}
