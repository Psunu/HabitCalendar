import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import './selector.dart';

class TimePicker extends StatefulWidget {
  TimePicker({
    this.itemExtent = 40.0,
    this.height,
    this.enable24 = false,
    this.ampmStyle,
    this.timeStyle,
    this.tagStyle,
    this.initTime,
    this.onTimeChanged,
  });

  final double itemExtent;
  final double height;
  final bool enable24;
  final TextStyle ampmStyle;
  final TextStyle timeStyle;
  final TextStyle tagStyle;
  final DateTime initTime;
  final void Function(DateTime) onTimeChanged;

  @override
  _TimePickerState createState() => _TimePickerState();
}

class _TimePickerState extends State<TimePicker> {
  FixedExtentScrollController _ampmController;
  FixedExtentScrollController _hourController;
  FixedExtentScrollController _minuteController;

  DateTime _time;
  bool _enable24;

  TextStyle get _ampmStyle => widget.ampmStyle ?? Get.textTheme.bodyText1;
  TextStyle get _timeStyle => widget.timeStyle ?? Get.textTheme.headline5;
  TextStyle get _tagStyle => widget.tagStyle ?? Get.textTheme.bodyText2;

  double get _height => widget.height ?? widget.itemExtent * 5;

  @override
  void initState() {
    _time = widget.initTime ?? DateTime(0, 0, 0, 0, 0);
    _enable24 = widget.enable24;

    // ScrollController init
    _ampmController =
        FixedExtentScrollController(initialItem: _time.hour < 12 ? 0 : 1);

    _hourController = FixedExtentScrollController(initialItem: _time.hour);
    _minuteController = FixedExtentScrollController(initialItem: _time.minute);

    // Add listener to ScrollController
    if (widget.onTimeChanged != null) {
      // Add listener to hourController
      _hourController.addListener(() {
        int hour = _hourController.selectedItem;
        _time =
            DateTime(_time.year, _time.month, _time.day, hour, _time.minute);

        if (hour > 11)
          _ampmController.animateToItem(1,
              duration: Duration(milliseconds: 100), curve: Curves.ease);
        else
          _ampmController.animateToItem(0,
              duration: Duration(milliseconds: 100), curve: Curves.ease);

        widget.onTimeChanged(_time);
      });
      // Add listener to minuteController
      _minuteController.addListener(() {
        _time = DateTime(_time.year, _time.month, _time.day, _time.hour,
            _minuteController.selectedItem);

        widget.onTimeChanged(_time);
      });
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Row(
          children: [
            // AmPm
            Selector(
              controller: _ampmController,
              items: ['오전'.tr.toUpperCase(), '오후'.tr.toUpperCase()],
              scrollDisabled: true,
              selectedStyle: _ampmStyle,
              unselectedStyle: Selector.getUnselectedStyle(_ampmStyle),
              tagStyle: _tagStyle,
            ),
            // Hour
            Selector(
              controller: _hourController,
              items: List.generate(
                24,
                (index) {
                  if (!_enable24 && index > 12) {
                    return (index - 12).toString();
                  }
                  return index.toString();
                },
              ),
              height: _height,
              tag: '시'.tr,
              selectedStyle: _timeStyle,
              unselectedStyle: Selector.getUnselectedStyle(_timeStyle),
              tagStyle: _tagStyle,
            ),
            // Padding to align with Selectors
            // Padding value = font size + adjustment
            Padding(
              padding: EdgeInsets.only(
                top: widget.ampmStyle.fontSize + 10,
              ),
              child: Text(
                ':',
                style: widget.timeStyle,
              ),
            ),
            // Minute
            Selector(
              controller: _minuteController,
              items: List.generate(60, (index) => index.toString()),
              height: _height,
              tag: '분'.tr,
              selectedStyle: _timeStyle,
              unselectedStyle: Selector.getUnselectedStyle(_timeStyle),
              tagStyle: _tagStyle,
            ),
          ],
        ),
        Row(
          children: [
            Switch.adaptive(
              value: _enable24,
              onChanged: (enabled) {
                setState(() {
                  _enable24 = enabled;
                });
              },
            ),
            Text(
              '24H',
              style: Get.textTheme.bodyText2,
            ),
          ],
        )
      ],
    );
  }
}
