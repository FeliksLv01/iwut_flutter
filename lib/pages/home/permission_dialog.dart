import 'package:flutter/material.dart';
import 'package:iwut_flutter/config/color.dart';
import 'package:iwut_flutter/utils/utils.dart';

class PermissionDialog extends StatelessWidget {
  const PermissionDialog({Key? key}) : super(key: key);

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
            '掌上吾理APP权限说明',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
      ),
      contentPadding: EdgeInsets.symmetric(horizontal: 16),
      children: [
        Center(child: Text('为了您能正常使用，需要开启以下权限')),
        ListTile(
          leading: Icon(Icons.sd_storage),
          title: Text('文件存储'),
          subtitle: Text('用于保存课表等用户数据'),
        ),
        ListTile(
          leading: Icon(Icons.phone_android),
          title: Text('电话状态'),
          subtitle: Text('用于使用一键登录功能'),
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
