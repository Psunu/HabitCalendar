import 'package:flutter/material.dart';

class DurationPicker extends StatefulWidget {
  final double itemExtent;
  final double height;
  final TextStyle style;
  final Duration initDuration;
  final void Function(Duration) onDurationChanged;

  DurationPicker({
    this.itemExtent,
    this.height,
    this.style,
    this.initDuration,
    this.onDurationChanged,
  });

  @override
  _DurationPickerState createState() => _DurationPickerState();
}

class _DurationPickerState extends State<DurationPicker> {
  FixedExtentScrollController hourController;
  FixedExtentScrollController minuteController;
  FixedExtentScrollController secondController;

  Duration duration;

  @override
  void initState() {
    duration = widget.initDuration ?? Duration();

    // ScrollController init
    hourController = FixedExtentScrollController(initialItem: duration.inHours);
    minuteController = FixedExtentScrollController(
        initialItem: (duration - Duration(hours: duration.inHours)).inMinutes);

    // Add listener to ScrollController
    if (widget.onDurationChanged != null) {
      // Send init duration
      widget.onDurationChanged(duration);

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
        _buildSelector(
          controller: hourController,
          length: 100,
          tag: '시간',
        ),
        Text(
          ':',
          style: widget.style,
        ),
        // Minute
        _buildSelector(
          controller: minuteController,
          length: 60,
          tag: '분',
        ),
      ],
    );
  }

  Widget _buildSelector({
    @required ScrollController controller,
    @required length,
    @required tag,
  }) {
    return Expanded(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(tag),
          ),
          Container(
            height: widget.height ?? (widget.itemExtent * 3) ?? 120.0,
            child: ScrollConfiguration(
              behavior: ScrollBehavior(),
              child: ListWheelScrollView(
                perspective: 0.009,
                controller: controller,
                physics: FixedExtentScrollPhysics(),
                itemExtent: widget.itemExtent ?? 40.0,
                children: List.generate(
                  length,
                  (index) {
                    return Container(
                      height: widget.itemExtent ?? 40.0,
                      child: Center(
                        child: Text(
                          index.toString(),
                          style: widget.style,
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
