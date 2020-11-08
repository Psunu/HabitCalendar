import 'package:flutter/material.dart';
import 'package:habit_calendar/constants/constants.dart';

class CustomChip extends StatelessWidget {
  CustomChip({
    Key key,
    this.color = Colors.white,
    this.padding = const EdgeInsets.symmetric(
      vertical: 8.0,
      horizontal: 16.0,
    ),
    BorderRadius borderRadius,
    this.child,
  })  : assert(color != null),
        assert(padding != null),
        assert(child != null),
        borderRadius = borderRadius ??
            BorderRadius.circular(
              Constants.smallBorderRadius,
            ),
        super(key: key);

  final Color color;
  final EdgeInsets padding;
  final BorderRadius borderRadius;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: color,
        borderRadius: borderRadius,
      ),
      child: Padding(
        padding: padding,
        child: child,
      ),
    );
  }
}
