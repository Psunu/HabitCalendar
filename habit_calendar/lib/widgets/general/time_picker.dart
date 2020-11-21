import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import './selector.dart';

enum _Ampm {
  am,
  pm,
}

class TimePicker extends StatefulWidget {
  TimePicker({
    Key key,
    this.itemExtent = 40.0,
    this.height,
    this.ampmStyle,
    this.timeStyle,
    this.tagStyle,
    this.initTime,
    this.initValue = true,
    this.reverseSwitch = false,
    this.hideSwitch = false,
    this.switchText,
    this.onTimeChanged,
    this.onStatusChanged,
  }) : super(key: key);

  final double itemExtent;
  final double height;
  final TextStyle ampmStyle;
  final TextStyle timeStyle;
  final TextStyle tagStyle;
  final DateTime initTime;
  final bool initValue;
  final bool reverseSwitch;
  final bool hideSwitch;
  final Widget switchText;
  final void Function(DateTime) onTimeChanged;
  final void Function(bool enabled) onStatusChanged;

  @override
  _TimePickerState createState() => _TimePickerState();
}

class _TimePickerState extends State<TimePicker> {
  DateTime _time;
  GlobalKey<SelectorState> _ampmState = GlobalKey();
  bool _enabled;
  _Ampm _ampm = _Ampm.am;

  final _enabledColorFilter = ColorFilter.mode(
    Colors.transparent,
    BlendMode.overlay,
  );
  final _disabledColorFilter = ColorFilter.mode(
    Colors.grey,
    BlendMode.srcATop,
  );

  TextStyle get _ampmStyle => widget.ampmStyle ?? Get.textTheme.bodyText1;
  TextStyle get _timeStyle => widget.timeStyle ?? Get.textTheme.headline5;
  TextStyle get _tagStyle => widget.tagStyle ?? Get.textTheme.bodyText2;

  bool get _getEnabled {
    if (widget.reverseSwitch)
      return !_enabled;
    else
      return _enabled;
  }

  @override
  void initState() {
    _time = widget.initTime ?? DateTime(0);
    _enabled = widget.initValue;
    _enabled = _getEnabled;

    super.initState();
  }

  void _onAmPmChanged(int index) {
    switch (index) {
      // If it is changedto am. subtract 12 hour
      case 0:
        _ampm = _Ampm.am;
        if (_time.hour > 11) {
          _time = _time.subtract(Duration(hours: 12));
        }
        break;
      // If it is changed to pm. add 12 hour
      case 1:
        _ampm = _Ampm.pm;
        if (_time.hour < 12) {
          _time = _time.add(Duration(hours: 12));
        }
        break;
      default:
    }

    if (widget.onTimeChanged != null) widget.onTimeChanged(_time);
  }

  void _onHourChanged(int index) {
    /// [12(0), 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11]
    /// 11 -> 12(0) : am -> pm
    /// 0 -> 23(11) : am -> pm
    /// 23(11) -> 0 : pm -> am
    /// 12(0) -> 11 : pm -> am
    int animateToIndex;
    if (index == 0) {
      if (_time.hour == 11) {
        _ampm = _Ampm.pm;
        animateToIndex = 1;
      } else if (_time.hour == 23) {
        _ampm = _Ampm.am;
        animateToIndex = 0;
      }
    } else if (index == 11) {
      if (_time.hour == 0) {
        _ampm = _Ampm.pm;
        animateToIndex = 1;
      } else if (_time.hour == 12) {
        _ampm = _Ampm.am;
        animateToIndex = 0;
      }
    }

    int hour = index;
    if (_ampm == _Ampm.pm) {
      hour = index + 12;
    }

    _time = DateTime(0, 1, 1, hour, _time.minute);

    if (animateToIndex != null) {
      _ampmState.currentState.animateToIndex(animateToIndex);
    }

    if (widget.onTimeChanged != null) widget.onTimeChanged(_time);
  }

  void _onMinuteChanged(int index) {
    _time = DateTime(0, 1, 1, _time.hour, index);
    if (widget.onTimeChanged != null) widget.onTimeChanged(_time);
  }

  void _onSwitchChanged(bool enabled) {
    setState(() {
      _enabled = enabled;
    });

    if (widget.onStatusChanged != null) {
      widget.onStatusChanged(_getEnabled);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        ColorFiltered(
          colorFilter: _getEnabled ? _enabledColorFilter : _disabledColorFilter,
          child: Padding(
            padding: const EdgeInsets.only(top: 14.0),
            child: Row(
              children: [
                // AmPm
                Selector(
                  key: _ampmState,
                  items: ['오전'.tr.toUpperCase(), '오후'.tr.toUpperCase()],
                  initialItem: _time.hour < 12 ? 0 : 1,
                  scrollDisabled: !_getEnabled,
                  selectedStyle: _ampmStyle,
                  unselectedStyle: Selector.getUnselectedStyle(_ampmStyle),
                  tagStyle: _tagStyle,
                  onIndexChanged: _onAmPmChanged,
                ),
                // Hour
                Selector(
                  items: List.generate(
                    12,
                    (index) {
                      if (index == 0) {
                        return 12.toString();
                      } else {
                        return index.toString();
                      }
                    },
                  ),
                  initialItem: _time.hour,
                  infinite: true,
                  scrollDisabled: !_getEnabled,
                  tag: '시'.tr,
                  selectedStyle: _timeStyle,
                  unselectedStyle: Selector.getUnselectedStyle(_timeStyle),
                  tagStyle: _tagStyle,
                  onIndexChanged: _onHourChanged,
                ),
                // Padding to align with Selectors
                // Padding value = font size + adjustment
                Padding(
                  padding: EdgeInsets.only(
                    top: _ampmStyle.fontSize + 15,
                  ),
                  child: Text(
                    ':',
                    style: _timeStyle,
                  ),
                ),
                // Minute
                Selector(
                  items: List.generate(60, (index) => index.toString()),
                  initialItem: _time.minute,
                  infinite: true,
                  scrollDisabled: !_getEnabled,
                  tag: '분'.tr,
                  selectedStyle: _timeStyle,
                  unselectedStyle: Selector.getUnselectedStyle(_timeStyle),
                  tagStyle: _tagStyle,
                  onIndexChanged: _onMinuteChanged,
                ),
              ],
            ),
          ),
        ),
        widget.hideSwitch
            ? Container()
            : Row(
                children: [
                  Switch.adaptive(
                    value: _enabled,
                    onChanged: _onSwitchChanged,
                    activeColor: Get.theme.accentColor,
                  ),
                  widget.switchText ??
                      Text(
                        'enabled',
                        style: Get.textTheme.bodyText2,
                      ),
                ],
              ),
      ],
    );
  }
}
