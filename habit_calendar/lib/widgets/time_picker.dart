import 'package:flutter/material.dart';

class TimePicker extends StatefulWidget {
  final double itemExtent;
  final double height;
  final bool enable24;
  final TextStyle ampmStyle;
  final TextStyle timeStyle;
  final DateTime initTime;
  final void Function(DateTime) onTimeChanged;

  TimePicker({
    this.itemExtent,
    this.height,
    this.enable24,
    this.ampmStyle,
    this.timeStyle,
    this.initTime,
    this.onTimeChanged,
  });

  @override
  _TimePickerState createState() => _TimePickerState();
}

class _TimePickerState extends State<TimePicker> {
  FixedExtentScrollController ampmController;
  FixedExtentScrollController hourController;
  FixedExtentScrollController minuteController;

  bool pmSet = false;

  DateTime time;

  @override
  void initState() {
    time = widget.initTime ?? DateTime(0, 0, 0, 0, 0);

    // ScrollController init
    ampmController =
        FixedExtentScrollController(initialItem: time.hour < 12 ? 0 : 1);
    if (widget.enable24 ?? false) {
      hourController = FixedExtentScrollController(initialItem: time.hour);
    } else {
      hourController = FixedExtentScrollController(
          initialItem: time.hour < 12 ? time.hour : time.hour - 12);
    }
    minuteController = FixedExtentScrollController(initialItem: time.minute);

    // Add listener to ScrollController
    if (widget.onTimeChanged != null) {
      // Send init time
      widget.onTimeChanged(time);

      // Add listener to hourController
      hourController.addListener(() {
        int hour = hourController.selectedItem;
        time = DateTime(time.year, time.month, time.day, hour, time.minute);

        if (hour > 11)
          ampmController.animateToItem(1,
              duration: Duration(milliseconds: 100), curve: Curves.ease);
        else
          ampmController.animateToItem(0,
              duration: Duration(milliseconds: 100), curve: Curves.ease);

        widget.onTimeChanged(time);
      });
      // Add listener to minuteController
      minuteController.addListener(() {
        time = DateTime(time.year, time.month, time.day, time.hour,
            minuteController.selectedItem);

        widget.onTimeChanged(time);
      });
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // AmPm
        _buildSelector(
          controller: ampmController,
          length: 2,
          ampm: true,
          style: widget.ampmStyle,
        ),
        // Hour
        _buildSelector(
          controller: hourController,
          length: 24,
          hour12: !(widget.enable24 ?? false),
          tag: '시',
          style: widget.timeStyle,
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
        _buildSelector(
          controller: minuteController,
          length: 60,
          tag: '분',
          style: widget.timeStyle,
        ),
      ],
    );
  }

  Widget _buildSelector({
    @required ScrollController controller,
    @required length,
    bool hour12 = false,
    bool ampm = false,
    TextStyle style,
    String tag,
  }) {
    return Expanded(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              tag ?? '',
              style: widget.ampmStyle,
            ),
          ),
          Container(
            height: widget.height ?? (widget.itemExtent * 3) ?? 120.0,
            child: ScrollConfiguration(
              behavior: ScrollBehavior(),
              child: ListWheelScrollView(
                perspective: 0.009,
                controller: controller,
                physics: ampm
                    ? NeverScrollableScrollPhysics()
                    : FixedExtentScrollPhysics(),
                itemExtent: widget.itemExtent ?? 40.0,
                children: List.generate(
                  length,
                  (index) {
                    String value;
                    if (ampm)
                      value = index == 0 ? '오전' : '오후';
                    else if (hour12)
                      value = index > 12
                          ? (index - 12).toString()
                          : index.toString();
                    else
                      value = index.toString();

                    return Container(
                      height: widget.itemExtent ?? 40.0,
                      child: Center(
                        child: Text(
                          value,
                          style: style,
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
