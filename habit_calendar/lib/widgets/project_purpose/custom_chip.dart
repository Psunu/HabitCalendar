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
    this.width,
    this.height,
    this.elevation = 0.0,
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
  final double width;
  final double height;
  final double elevation;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: color,
      borderRadius: borderRadius,
      elevation: elevation,
      child: Container(
        width: width,
        height: height,
        child: Padding(
          padding: padding,
          child: Align(
            alignment: Alignment.centerLeft,
            child: child,
          ),
        ),
      ),
    );
  }
}
