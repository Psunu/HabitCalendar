import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:habit_calendar/constants/constants.dart';
import 'package:habit_calendar/utils/utils.dart';

const _kWeekLength = 7;

class WeekCard extends StatefulWidget {
  WeekCard({
    Key key,
    this.width,
    this.height,
    this.padding,
    this.margin,
    this.animationAxis = Axis.vertical,
    this.animationRatio = 1.3,
    this.duration = const Duration(
      milliseconds: Constants.mediumAnimationSpeed,
    ),
    BorderRadius borderRadius,
    Color color,
    Color selectedColor,
    this.onTap,
    this.initValue,
    this.child,
  })  : assert(animationAxis == Axis.vertical ? height != null : width != null),
        borderRadius = borderRadius ??
            BorderRadius.circular(
              Constants.smallBorderRadius,
            ),
        color = color ?? Colors.grey[300],
        selectedColor = selectedColor ?? Get.theme.accentColor,
        super(key: key);

  final Axis animationAxis;
  final double animationRatio;
  final double width;
  final double height;
  final Text child;
  final EdgeInsets padding;
  final EdgeInsets margin;
  final BorderRadius borderRadius;
  final Color color;
  final Color selectedColor;
  final Duration duration;
  final void Function(bool) onTap;
  final bool initValue;

  static List<Widget> buildOneWeek({
    double width,
    double height,
    EdgeInsets padding,
    double margin = 2.0,
    Axis animationAxis = Axis.vertical,
    double animationRatio = 1.3,
    Duration duration = const Duration(
      milliseconds: Constants.mediumAnimationSpeed,
    ),
    BorderRadius borderRadius,
    Color color,
    Color selectedColor,
    void Function(int, bool) onTap,
    Map<int, bool> initValue,
    TextStyle textStyle,
  }) {
    EdgeInsets _margin = EdgeInsets.only(right: margin);
    if (initValue == null) initValue = Map<int, bool>();

    return List.generate(_kWeekLength, (index) {
      if (index == _kWeekLength - 1)
        _margin = EdgeInsets.only(left: margin);
      else if (index != 0) _margin = EdgeInsets.symmetric(horizontal: margin);

      return Expanded(
        child: WeekCard(
          key: ValueKey(index),
          width: width,
          height: height,
          padding: padding,
          margin: _margin,
          animationAxis: animationAxis,
          animationRatio: animationRatio,
          duration: duration,
          borderRadius: borderRadius,
          color: color,
          selectedColor: selectedColor,
          onTap: (isSelected) {
            if (onTap != null) onTap(index, isSelected);
          },
          initValue: initValue[index],
          child: Text(
            Utils.getWeekString(index),
            style: textStyle,
          ),
        ),
      );
    });
  }

  static String selectedWeeksString(Map<int, bool> weeks) {
    if (weeks.isEmpty) return '반복할 요일을 선택해 주세요'.tr.capitalizeFirst;

    int falses = 0;
    int trues = 0;

    String result = '매주'.tr.capitalizeFirst;

    weeks.forEach((key, value) {
      if (value) {
        result += ' ' + Utils.getWeekString(key).toLowerCase() + ',';
        trues++;
      } else {
        falses++;
      }
    });

    if (falses == weeks.length) return '반복할 요일을 선택해 주세요'.tr.capitalizeFirst;
    if (trues == weeks.length) return '매일'.tr.capitalizeFirst;

    // Remove last comma of the string
    result = result.replaceRange(result.length - 1, result.length, '');
    result += '요일';
    return result;
  }

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
          if (widget.onTap != null) widget.onTap(_selected);
        });
      },
      child: AnimatedContainer(
        duration: widget.duration,
        curve: Curves.ease,
        width: _selected && widget.animationAxis == Axis.horizontal
            ? widget.width * widget.animationRatio
            : widget.width,
        height: _selected && widget.animationAxis == Axis.vertical
            ? widget.height * widget.animationRatio
            : widget.height,
        padding: widget.padding,
        margin: widget.margin,
        decoration: BoxDecoration(
          color: _selected ? widget.selectedColor : widget.color,
          borderRadius: widget.borderRadius,
        ),
        child: DefaultTextStyle(
            style: Get.textTheme.bodyText1
                .copyWith(color: _selected ? Colors.white : Colors.black87),
            child: Center(child: widget.child)),
      ),
    );
  }
}
