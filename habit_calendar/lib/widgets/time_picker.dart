import 'package:flutter/material.dart';

class TimePicker extends StatelessWidget {
  final double itemExtent;
  final double height;
  final double itemWidth;
  TimePicker({this.itemExtent, this.height, this.itemWidth});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height ?? 120.0,
      child: ListWheelScrollView(
        controller: FixedExtentScrollController(),
        physics: FixedExtentScrollPhysics(),
        itemExtent: itemExtent ?? 40.0,
        children: List.generate(
          12,
          (index) => Container(
            height: itemExtent ?? 40.0,
            width: itemWidth ?? 100.0,
            child: Center(
              child: Text(
                (index + 1).toString(),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
