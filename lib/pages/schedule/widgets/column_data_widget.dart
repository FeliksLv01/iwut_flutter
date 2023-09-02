/*
 * @Author: FeliksLv 
 * @Date: 2021-04-05 10:18:24 
 * @Last Modified by: FeliksLv
 * @Last Modified time: 2021-04-05 10:29:10
 * @Message: 给column下面的课表格子，提供基本信息
 * 主要用于空白格子确认位置
 */
import 'package:flutter/material.dart';

class ColumnDataWidget extends InheritedWidget {
  final int weekDay;

  ColumnDataWidget({required this.weekDay, required Widget child}) : super(child: child);

  static ColumnDataWidget? of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<ColumnDataWidget>();
  }

  @override
  bool updateShouldNotify(ColumnDataWidget old) {
    return old.weekDay != weekDay;
  }
}
