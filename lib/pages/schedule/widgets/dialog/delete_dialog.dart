import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class DeleteDialog extends StatelessWidget {
  final String title;
  final String content;
  final Function() onSure;
  const DeleteDialog(this.onSure, {this.title = '提示', this.content = '确定要删除选中课程吗？'});

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
            Navigator.pop(context);
          },
          textStyle: TextStyle(color: Colors.blueAccent),
          child: Text('取消', textScaleFactor: 1.2),
        ),
        CupertinoDialogAction(
          onPressed: () {
            onSure();
            Navigator.pop(context);
          },
          textStyle: TextStyle(color: Colors.redAccent),
          child: Text('确定', textScaleFactor: 1.2),
        ),
      ],
    );
  }
}
