import 'package:flutter/material.dart';
import 'package:habit_calendar/constants/constants.dart';

class AutoColoredIcon extends StatefulWidget {
  AutoColoredIcon({
    Key key,
    @required this.child,
    this.lightColor,
    this.darkColor,
    @required this.backgroundColor,
  })  : assert(child != null),
        assert(backgroundColor != null),
        super(key: key);

  final Icon child;
  final Color lightColor;
  final Color darkColor;
  final Color backgroundColor;

  @override
  _AutoColoredIconState createState() => _AutoColoredIconState();
}

class _AutoColoredIconState extends State<AutoColoredIcon> {
  Color get _color => widget.backgroundColor.computeLuminance() < 0.5
      ? widget.lightColor ?? Colors.white
      : widget.darkColor ?? Color(Constants.black);

  @override
  Widget build(BuildContext context) {
    return IconTheme(
      data: IconThemeData(color: _color),
      child: widget.child,
    );
  }
}
