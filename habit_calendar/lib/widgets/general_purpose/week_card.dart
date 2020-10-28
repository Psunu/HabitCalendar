import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:habit_calendar/constants/constants.dart';

class WeekCard extends StatefulWidget {
  WeekCard({
    this.width,
    this.height,
    this.child,
    this.padding,
    this.margin,
    this.borderRadius,
    this.color,
    this.selectedColor,
    this.duration,
    this.onTapped,
    this.initValue,
    this.key,
  }) : super(key: key);

  final double width;
  final double height;
  final Text child;
  final EdgeInsets padding;
  final EdgeInsets margin;
  final double borderRadius;
  final Color color;
  final Color selectedColor;
  final Duration duration;
  final void Function(bool) onTapped;
  final bool initValue;
  final Key key;

  @override
  _WeekCardState createState() => _WeekCardState();
}

class _WeekCardState extends State<WeekCard> {
  bool _selected;

  @override
  void initState() {
    _selected = widget.initValue ?? false;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        setState(() {
          _selected = !_selected;
          if (widget.onTapped != null) widget.onTapped(_selected);
        });
      },
      child: AnimatedContainer(
        duration: widget.duration ??
            const Duration(
              milliseconds: Constants.mediumAnimationSpeed,
            ),
        curve: Curves.ease,
        width: widget.width,
        height: _selected ? widget.height * 1.3 : widget.height,
        padding: widget.padding,
        margin: widget.margin,
        decoration: BoxDecoration(
          color: _selected
              ? widget.selectedColor ?? Get.theme.accentColor
              : widget.color ?? Colors.grey[300],
          borderRadius: BorderRadius.circular(widget.borderRadius ?? 10.0),
        ),
        child: DefaultTextStyle(
            style: Get.textTheme.bodyText1
                .copyWith(color: _selected ? Colors.white : Colors.black87),
            child: Center(child: widget.child)),
      ),
    );
  }
}
