import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:habit_calendar/constants/constants.dart';
import 'package:habit_calendar/widgets/general_purpose/auto_colored_icon.dart';
import 'package:habit_calendar/widgets/project_purpose/custom_chip.dart';

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
        assert(color != null),
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
  final _borderRadius = BorderRadius.circular(Constants.smallBorderRadius);
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

  Widget get _child {
    switch (widget.type) {
      case _DurationChipType.durationChip:
        return Row(
          children: [
            Text(
              _durationString,
              style: widget.style ?? Get.textTheme.bodyText1,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        );
      case _DurationChipType.add:
      default:
        return AutoColoredIcon(
          backgroundColor: widget.color,
          child: Icon(
            Icons.add,
          ),
        );
    }
  }

  void Function() get _callback {
    switch (widget.type) {
      case _DurationChipType.durationChip:
        return () {
          if (widget.onValueChanged != null)
            widget.onValueChanged(
              widget.duration,
              !widget.value,
            );

          if (widget.onTap != null) widget.onTap();
        };
      case _DurationChipType.add:
      default:
        return () {
          if (widget.onTap != null) widget.onTap();
        };
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _callback,
      child: Material(
        color: widget.color,
        borderRadius: _borderRadius,
        elevation: widget.value ? 5.0 : 0.0,
        child: CustomChip(
          color: widget.color,
          padding: const EdgeInsets.symmetric(
            vertical: 8.0,
            horizontal: 16.0,
          ),
          borderRadius: _borderRadius,
          child: _child,
        ),
      ),
    );
  }
}
