/*
 * @Author: FeliksLv 
 * @Date: 2020-08-28 19:14:51 
 * @Last Modified by: FeliksLv
 * @Last Modified time: 2020-08-28 19:18:35
 * @message 去除滚动的蓝色回弹
 */

import 'dart:io';

import 'package:flutter/material.dart';

class MyBehavior extends ScrollBehavior {
  @override
  Widget buildOverscrollIndicator(BuildContext context, Widget child, ScrollableDetails details) {
    if (Platform.isAndroid) {
      return child;
    } else {
      return super.buildOverscrollIndicator(context, child, details);
    }
  }
}
