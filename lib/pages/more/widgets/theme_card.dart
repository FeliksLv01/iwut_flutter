import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iwut_flutter/config/color.dart';
import 'package:iwut_flutter/provider/theme_provider.dart';
import 'package:provider/provider.dart';

class ThemeCard extends StatelessWidget {
  const ThemeCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {},
      child: AspectRatio(
        aspectRatio: 4.74,
        child: Container(
          margin: EdgeInsets.only(top: 24.h, left: 31.w, right: 31.w),
          decoration: BoxDecoration(
            color: AppColor(context).moreCellBGColor,
            borderRadius: BorderRadius.circular(23.w),
            boxShadow: [BoxShadow(blurRadius: 2, spreadRadius: 1, color: Color.fromARGB(23, 0, 0, 0))],
          ),
          child: Row(
            children: [
              Padding(padding: EdgeInsets.only(left: 74.w)),
              Icon(Icons.settings, color: AppColor(context).element2),
              Padding(padding: EdgeInsets.only(left: 85.w)),
              Text('跟随系统深色模式', style: TextStyle(color: AppColor(context).moreText, fontSize: 50.sp)),
              Spacer(),
              Container(
                margin: EdgeInsets.only(right: 74.w),
                child: Consumer<ThemeProvider>(builder: (context, model, _) {
                  return CupertinoSwitch(
                    activeColor: AppColor(context).element2,
                    value: model.theme == AppTheme.System,
                    onChanged: (value) {
                      if (model.theme == AppTheme.System) {
                        if (Theme.of(context).brightness == Brightness.dark) {
                          model.updateTheme(AppTheme.Bright);
                        } else {
                          model.updateTheme(AppTheme.Dark);
                        }
                      } else {
                        model.updateTheme(AppTheme.System);
                      }
                    },
                  );
                }),
              )
            ],
          ),
        ),
      ),
    );
  }
}
