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
    this.enableIndicator = false,
  }) : assert(percentage >= 0.0 || percentage <= 1.0);

  final double width;
  final double height;
  final double layoutPadding;
  final BorderRadius borderRadius;
  final Color backgroundColor;
  final Color frontColor;
  final double percentage;
  final Duration duration;
  final bool enableIndicator;

  double get _width => (width ?? Get.context.width) - layoutPadding;
  BorderRadius get _borderRadius =>
      borderRadius ?? BorderRadius.circular(Constants.smallBorderRadius);
  Color get _backgroundColor => backgroundColor ?? Colors.grey[200];
  Color get _frontColor => frontColor ?? Get.theme.accentColor;
  String get _percentString {
    if (percentage == 1.0)
      return '100%';
    else if (percentage == 0.0) return '0%';
    return '${percentage * 100}%';
  }

  Widget get _indicator {
    return Container(
      width: Get.textTheme.bodyText1.fontSize * 4,
      child: Column(
        children: [
          Text(
            _percentString,
            style: Get.textTheme.bodyText1.copyWith(
              color: Get.theme.primaryColor,
            ),
          ),
          CustomPaint(
            size: Size(10.0, 10.0),
            painter: TrianglePainter(
              color: Get.theme.accentColor,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      overflow: Overflow.visible,
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
            borderRadius: BorderRadius.only(
              topLeft: _borderRadius.topLeft,
              bottomLeft: _borderRadius.bottomLeft,
              topRight: percentage == 1.0
                  ? _borderRadius.topRight
                  : Radius.circular(0.0),
              bottomRight: percentage == 1.0
                  ? _borderRadius.bottomRight
                  : Radius.circular(0.0),
            ),
          ),
          duration: duration,
          curve: Curves.ease,
        ),
        AnimatedPositioned(
          bottom: height,
          left: _width * percentage - Get.textTheme.bodyText1.fontSize * 2,
          duration: duration,
          curve: Curves.ease,
          child: AnimatedOpacity(
            opacity: enableIndicator ? 1.0 : 0.0,
            duration: duration,
            curve: Curves.ease,
            child: _indicator,
          ),
        ),
      ],
    );
  }
}

class TrianglePainter extends CustomPainter {
  TrianglePainter({
    @required this.color,
  }) : assert(color != null);

  Color color;

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = new Paint()
      ..color = color
      ..style = PaintingStyle.fill
      ..strokeWidth = 1;

    Path path = Path();
    path.moveTo(size.width * 0.5, size.height);
    path.lineTo(size.width, 0.0);
    path.lineTo(0.0, 0.0);
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
