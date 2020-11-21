import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:habit_calendar/widgets/general/selector.dart';

class DurationPicker extends StatefulWidget {
  DurationPicker({
    Key key,
    this.maxHours = 99,
    this.infiniteHours = false,
    this.infiniteMinutes = false,
    this.itemExtent = 40.0,
    this.height,
    this.durationStyle,
    this.tagStyle,
    this.initDuration,
    this.onDurationChanged,
  }) : super(key: key);

  final int maxHours;
  final bool infiniteHours;
  final bool infiniteMinutes;
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
  // Duration _duration;

  int _hours = 0;
  int _minutes = 0;

  Duration get _duration => Duration(hours: _hours, minutes: _minutes);

  TextStyle get _durationStyle =>
      widget.durationStyle ?? Get.textTheme.headline5;
  TextStyle get _tagStyle => widget.tagStyle ?? Get.textTheme.bodyText2;

  @override
  void initState() {
    if (widget.initDuration != null) {
      _hours = widget.initDuration.inHours;
      _minutes =
          widget.initDuration.inMinutes - Duration(hours: _hours).inMinutes;
    }

    super.initState();
  }

  void _onHoursChanged(int index) {
    _hours = index;

    if (widget.onDurationChanged != null) widget.onDurationChanged(_duration);
  }

  void _onMinutesChanged(int index) {
    _minutes = index;

    if (widget.onDurationChanged != null) widget.onDurationChanged(_duration);
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // Hour
        Selector(
          items:
              List.generate(widget.maxHours + 1, (index) => index.toString()),
          initialItem: _hours,
          infinite: widget.infiniteHours,
          tag: '시'.tr,
          tagStyle: _tagStyle,
          selectedStyle: _durationStyle,
          unselectedStyle: Selector.getUnselectedStyle(_durationStyle),
          onIndexChanged: _onHoursChanged,
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
          items: List.generate(60, (index) => index.toString()),
          initialItem: _minutes,
          infinite: widget.infiniteHours,
          tag: '분'.tr,
          tagStyle: _tagStyle,
          selectedStyle: _durationStyle,
          unselectedStyle: Selector.getUnselectedStyle(_durationStyle),
          onIndexChanged: _onMinutesChanged,
        ),
      ],
    );
  }
}
