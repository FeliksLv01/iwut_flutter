import 'dart:async';
import 'package:flutter/material.dart';

class LoadingDialog extends StatefulWidget {
  final bool outsideDismiss;
  final Function? dismissCallback;
  final Future<dynamic>? requestCallBack;

  LoadingDialog({Key? key, this.outsideDismiss = true, this.dismissCallback, this.requestCallBack}) : super(key: key);

  @override
  State<LoadingDialog> createState() => _LoadingDialog();
}

class _LoadingDialog extends State<LoadingDialog> with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<int> _animation;

  _dismissDialog() {
    if (widget.dismissCallback != null) {
      widget.dismissCallback!();
    }
    Navigator.of(context).pop();
  }

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: Duration(seconds: 2))..repeat();
    _animation = IntTween(begin: 1, end: 18).animate(_controller);
    if (widget.requestCallBack != null) {
      widget.requestCallBack!.then((_) {
        Navigator.pop(context);
      });
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.outsideDismiss ? _dismissDialog : null,
      child: Material(
        type: MaterialType.transparency,
        child: Center(
          child: AnimatedBuilder(
            animation: _animation,
            builder: (context, _) {
              int index = _animation.value;
              return Image.asset(
                'assets/images/loading/loading-$index.png',
                // 避免闪烁
                gaplessPlayback: true,
                width: 150,
                height: 150,
              );
            },
          ),
        ),
      ),
    );
  }
}
