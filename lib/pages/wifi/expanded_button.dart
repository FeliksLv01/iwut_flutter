import 'package:flutter/material.dart';

class ExpandedButton extends StatelessWidget {
  ExpandedButton({required this.button, Key? key, this.horizontalPadding = 0}) : super(key: key);

  final double horizontalPadding;
  final Widget button;

  @override
  Widget build(BuildContext context) {
    return Flex(
      direction: Axis.horizontal,
      children: [
        Expanded(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
            child: button,
          ),
        )
      ],
    );
  }
}
