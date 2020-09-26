import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HabitTile extends StatelessWidget {
  final EdgeInsets padding;
  final double width;
  final double height;
  final Text date;
  final Text name;

  HabitTile({this.padding, this.width, this.height, this.date, this.name});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Container(
        margin: padding ?? const EdgeInsets.symmetric(horizontal: 20.0),
        width: width ?? Get.context.width,
        height: height ?? 90.0,
        child: Row(
          children: [
            Expanded(
              flex: 1,
              child: date,
            ),
            Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 5.0, vertical: 10.0),
              child: VerticalDivider(),
            ),
            Expanded(
              flex: 4,
              child: name,
            ),
          ],
        ),
      ),
    );
  }
}
