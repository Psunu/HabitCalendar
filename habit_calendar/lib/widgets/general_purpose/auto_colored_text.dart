import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:habit_calendar/constants/constants.dart';

class AutoColoredText extends StatefulWidget {
  AutoColoredText({
    Key key,
    this.child,
    this.lightColor,
    this.darkColor,
    @required this.backgroundColor,
  })  : assert(child != null),
        assert(backgroundColor != null),
        super(key: key);

  final Text child;
  final Color lightColor;
  final Color darkColor;
  final Color backgroundColor;

  @override
  _AutoColoredTextState createState() => _AutoColoredTextState();
}

class _AutoColoredTextState extends State<AutoColoredText> {
  TextStyle _textStyle;

  Color get textColor {
    return widget.backgroundColor.computeLuminance() < 0.5
        ? widget.lightColor ?? Colors.white
        : widget.darkColor ?? Color(Constants.black);
  }

  @override
  void initState() {
    if (widget.child.style != null) {
      _textStyle = widget.child.style.copyWith(color: textColor);
    } else {
      _textStyle = Get.textTheme.bodyText2.copyWith(color: textColor);
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTextStyle(
      style: _textStyle,
      child: IconTheme(
        data: IconThemeData(color: textColor),
        child: Text(
          widget.child.data,
          key: widget.child.key,
          style: _textStyle,
          strutStyle: widget.child.strutStyle,
          textAlign: widget.child.textAlign,
          textDirection: widget.child.textDirection,
          locale: widget.child.locale,
          softWrap: widget.child.softWrap,
          overflow: widget.child.overflow,
          textScaleFactor: widget.child.textScaleFactor,
          maxLines: widget.child.maxLines,
          semanticsLabel: widget.child.semanticsLabel,
          textWidthBasis: widget.child.textWidthBasis,
          textHeightBehavior: widget.child.textHeightBehavior,
        ),
      ),
    );
  }
}
