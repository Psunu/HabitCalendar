import 'package:flutter/material.dart';

const _kRed = 0.2126;
const _kGreen = 0.7152;
const _kBlue = 0.0722;

/// Icon color will decided by backgroundColor luminance
/// when luminace is under 148.0 color is dark
/// otherwise color is light
const _luminanceBasis = 148.0;

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
  double contrastRatio;

  double get relativeLuminance {
    return (widget.backgroundColor.red * _kRed) +
        (widget.backgroundColor.green * _kGreen) +
        (widget.backgroundColor.blue * _kBlue);
  }

  Color get iconColor {
    return relativeLuminance < _luminanceBasis
        ? widget.lightColor ?? Colors.white
        : widget.darkColor ?? Colors.black87;
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return IconTheme(
      data: IconThemeData(color: iconColor),
      child: widget.child,
    );
  }
}
