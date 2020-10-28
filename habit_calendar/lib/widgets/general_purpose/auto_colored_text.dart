import 'package:flutter/material.dart';
import 'package:get/get.dart';

const _kRed = 0.2126;
const _kGreen = 0.7152;
const _kBlue = 0.0722;

/// Text color will decided by backgroundColor luminance
/// when luminace is under 148.0 color is dark
/// otherwise color is light
const _luminanceBasis = 148.0;

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
  double contrastRatio;
  TextStyle textStyle;

  double get relativeLuminance {
    return (widget.backgroundColor.red * _kRed) +
        (widget.backgroundColor.green * _kGreen) +
        (widget.backgroundColor.blue * _kBlue);
  }

  Color get textColor {
    return relativeLuminance < _luminanceBasis
        ? widget.lightColor ?? Colors.white
        : widget.darkColor ?? Colors.black87;
  }

  @override
  void initState() {
    if (widget.child.style != null) {
      textStyle = widget.child.style.copyWith(color: textColor);
    } else {
      textStyle = Get.textTheme.bodyText2.copyWith(color: textColor);
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTextStyle(
      style: textStyle,
      child: IconTheme(
        data: IconThemeData(color: textColor),
        child: Text(
          widget.child.data,
          key: widget.child.key,
          style: textStyle,
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
