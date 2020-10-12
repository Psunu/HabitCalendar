import 'package:flutter/material.dart';

class GroupCircle extends StatelessWidget {
  const GroupCircle({
    Key key,
    this.width = 30.0,
    this.height = 30.0,
    this.color,
    this.outlineColor,
    this.outlineWidth = 1.5,
  }) : super(key: key);

  final double width;
  final double height;
  final Color color;
  final Color outlineColor;
  final double outlineWidth;

  Color get _color => color ?? Colors.white;
  Color get _outlineColor => outlineColor ?? Colors.grey[400];

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: _outlineColor,
          width: outlineWidth,
        ),
        color: _color,
      ),
    );
  }
}
