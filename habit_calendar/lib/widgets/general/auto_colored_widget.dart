import 'package:flutter/material.dart';
import 'package:habit_calendar/constants/constants.dart';

class AutoColoredWidget extends StatefulWidget {
  AutoColoredWidget({
    Key key,
    this.child,
    this.lightColor,
    this.darkColor,
    @required this.backgroundColor,
  })  : assert(child != null),
        assert(backgroundColor != null),
        super(key: key);

  final Widget child;
  final Color lightColor;
  final Color darkColor;
  final Color backgroundColor;

  @override
  _AutoColoredWidgetState createState() => _AutoColoredWidgetState();
}

class _AutoColoredWidgetState extends State<AutoColoredWidget> {
  Color get _color {
    return widget.backgroundColor.computeLuminance() < 0.5
        ? widget.lightColor ?? Colors.white
        : widget.darkColor ?? Color(Constants.black);
  }

  @override
  Widget build(BuildContext context) {
    return ColorFiltered(
      colorFilter: ColorFilter.mode(_color, BlendMode.srcATop),
      child: widget.child,
    );
  }
}
