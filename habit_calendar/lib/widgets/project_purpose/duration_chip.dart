import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:habit_calendar/constants/constants.dart';
import 'package:habit_calendar/utils/utils.dart';
import 'package:habit_calendar/widgets/general_purpose/auto_colored_icon.dart';
import 'package:habit_calendar/widgets/general_purpose/color_circle.dart';

const _kColorCircleSize = 20.0;

enum _DurationChipType {
  durationChip,
  add,
}

class DurationChip extends StatefulWidget {
  DurationChip({
    Key key,
    @required this.duration,
    @required this.value,
    this.durationString,
    this.style,
    this.color = Colors.white,
    this.onValueChanged,
  })  : assert(duration != null),
        assert(value != null),
        type = _DurationChipType.durationChip,
        onTap = null,
        super(key: key);

  DurationChip.add({
    Key key,
    this.color = Colors.white,
    this.onTap,
  })  : duration = null,
        value = false,
        durationString = null,
        type = _DurationChipType.add,
        style = null,
        onValueChanged = null,
        super(key: key);

  final _DurationChipType type;
  final Duration duration;
  final bool value;

  /// If you want to force child text, pass durationString
  /// it will be shown reguardless duration
  final String durationString;
  final TextStyle style;
  final Color color;
  final void Function(Duration duration, bool isSelected) onValueChanged;
  final void Function() onTap;

  @override
  _DurationChipState createState() => _DurationChipState();
}

class _DurationChipState extends State<DurationChip> {
  // bool _isSelected = false;

  Widget _child;
  void Function() _callback;

  String get _durationString {
    if (widget.durationString != null) return widget.durationString;

    String text;
    if (widget.duration.inHours > 0) {
      text = widget.duration.inHours.toString() + '시간 ';

      final minutes = widget.duration.inMinutes -
          Duration(hours: widget.duration.inHours).inMinutes;
      if (minutes > 0) {
        text += minutes.toString() + '분 ';
      }
    } else {
      text = widget.duration.inMinutes.toString() + '분 ';
    }
    text += '전';

    return text;
  }

  @override
  void initState() {
    switch (widget.type) {
      case _DurationChipType.durationChip:
        _child = Row(
          children: [
            Text(
              _durationString,
              style: widget.style ?? Get.textTheme.bodyText1,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        );
        _callback = () {
          if (widget.onValueChanged != null)
            widget.onValueChanged(
              widget.duration,
              !widget.value,
            );

          if (widget.onTap != null) widget.onTap();
        };
        break;
      case _DurationChipType.add:
        _child = AutoColoredIcon(
          backgroundColor: widget.color,
          child: Icon(
            Icons.add,
          ),
        );
        _callback = () {
          if (widget.onTap != null) widget.onTap();
        };
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _callback,
      child: Material(
        color: widget.color,
        borderRadius: BorderRadius.circular(Constants.smallBorderRadius),
        elevation: widget.value ? 5.0 : 0.0,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: _child,
        ),
      ),
    );
  }
}
