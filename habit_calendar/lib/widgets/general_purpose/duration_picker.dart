import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:habit_calendar/widgets/general_purpose/selector.dart';

class DurationPicker extends StatefulWidget {
  DurationPicker({
    this.itemExtent = 40.0,
    this.height,
    this.durationStyle,
    this.tagStyle,
    this.initDuration,
    this.onDurationChanged,
  });

  final double itemExtent;
  final double height;
  final TextStyle durationStyle;
  final TextStyle tagStyle;
  final Duration initDuration;
  final void Function(Duration) onDurationChanged;
  @override
  _DurationPickerState createState() => _DurationPickerState();
}

class _DurationPickerState extends State<DurationPicker> {
  FixedExtentScrollController hourController;
  FixedExtentScrollController minuteController;
  FixedExtentScrollController secondController;

  Duration duration;

  double get _height => widget.height ?? widget.itemExtent * 5;
  TextStyle get _durationStyle =>
      widget.durationStyle ?? Get.textTheme.headline5;
  TextStyle get _tagStyle => widget.tagStyle ?? Get.textTheme.bodyText2;

  @override
  void initState() {
    duration = widget.initDuration ?? Duration();

    // ScrollController init
    hourController = FixedExtentScrollController(initialItem: duration.inHours);
    minuteController = FixedExtentScrollController(
        initialItem: (duration - Duration(hours: duration.inHours)).inMinutes);

    // Add listener to ScrollController
    if (widget.onDurationChanged != null) {
      // Add listener to hourController
      hourController.addListener(() {
        duration = Duration(
          hours: hourController.selectedItem,
          minutes: (duration - Duration(hours: duration.inHours)).inMinutes,
        );
        widget.onDurationChanged(duration);
      });
      // Add listener to minuteController
      minuteController.addListener(() {
        duration = Duration(
          hours: duration.inHours,
          minutes: minuteController.selectedItem,
        );
        widget.onDurationChanged(duration);
      });
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // Hour
        Selector(
          controller: hourController,
          items: List.generate(100, (index) => index.toString()),
          height: _height,
          tag: '시'.tr,
          tagStyle: _tagStyle,
          selectedStyle: _durationStyle,
          unselectedStyle: Selector.getUnselectedStyle(_durationStyle),
        ),
        Padding(
          padding: EdgeInsets.only(top: _tagStyle.fontSize + 10.0),
          child: Text(
            ':',
            style: widget.durationStyle,
          ),
        ),
        // Minute
        Selector(
          controller: minuteController,
          items: List.generate(60, (index) => index.toString()),
          height: _height,
          tag: '분'.tr,
          tagStyle: _tagStyle,
          selectedStyle: _durationStyle,
          unselectedStyle: Selector.getUnselectedStyle(_durationStyle),
        ),
      ],
    );
  }
}
