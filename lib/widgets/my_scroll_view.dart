/*
 * @Author: FeliksLv 
 * @Date: 2021-01-12 15:40:30 
 * @Last Modified by: FeliksLv
 * @Last Modified time: 2021-01-12 15:57:41
 * @Message 通用页面布局
 */

import 'package:flutter/material.dart';

/// 本项目通用的布局（SingleChildScrollView）
/// 1.底部存在按钮
/// 2.底部没有按钮
class MyScrollView extends StatelessWidget {
  const MyScrollView({
    Key? key,
    required this.children,
    this.padding,
    this.physics = const BouncingScrollPhysics(),
    this.crossAxisAlignment = CrossAxisAlignment.center,
    this.bottomButton,
    this.scrollController,
  }) : super(key: key);

  final List<Widget> children;
  final EdgeInsetsGeometry? padding;
  final ScrollPhysics physics;
  final CrossAxisAlignment crossAxisAlignment;
  final Widget? bottomButton;
  final ScrollController? scrollController;

  @override
  Widget build(BuildContext context) {
    Widget contents = Column(
      crossAxisAlignment: crossAxisAlignment,
      children: children,
    );

    contents = SingleChildScrollView(
      controller: scrollController,
      padding: padding,
      physics: physics,
      child: contents,
    );

    if (bottomButton != null) {
      contents = Column(
        children: [
          Expanded(child: contents),
          SafeArea(child: bottomButton!),
        ],
      );
    }
    return contents;
  }
}
