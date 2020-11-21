import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:habit_calendar/constants/constants.dart';

class ProgressBar extends StatelessWidget {
  ProgressBar({
    this.width,
    this.height = 15.0,
    this.layoutPadding = 0.0,
    this.borderRadius,
    this.backgroundColor,
    this.frontColor,
    @required this.percentage,
    this.duration = const Duration(
      milliseconds: Constants.mediumAnimationSpeed,
    ),
  }) : assert(percentage >= 0.0 || percentage <= 1.0);

  final double width;
  final double height;
  final double layoutPadding;
  final BorderRadius borderRadius;
  final Color backgroundColor;
  final Color frontColor;
  final double percentage;
  final Duration duration;

  double get _width => (width ?? Get.context.width) - layoutPadding;
  BorderRadius get _borderRadius =>
      borderRadius ?? BorderRadius.circular(Constants.smallBorderRadius);
  Color get _backgroundColor => backgroundColor ?? Colors.grey[200];
  Color get _frontColor => frontColor ?? Get.theme.accentColor;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          width: _width,
          height: height,
          decoration: BoxDecoration(
            color: _backgroundColor,
            borderRadius: _borderRadius,
          ),
        ),
        AnimatedContainer(
          width: _width * percentage,
          height: height,
          decoration: BoxDecoration(
            color: _frontColor,
            borderRadius: _borderRadius,
          ),
          duration: duration,
          curve: Curves.ease,
        ),
      ],
    );
  }
}
