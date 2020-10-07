import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:habit_calendar/constants/constants.dart';
import 'package:habit_calendar/widgets/rounded_rectangle_dismissible.dart';

// TODO implement dismissible
class HabitTile extends StatelessWidget {
  final Key key;
  final EdgeInsets padding;
  final double width;
  final double height;
  final Text date;
  final Text name;
  final Widget background;
  final Widget secondaryBackground;

  HabitTile(
      {@required this.key,
      this.padding,
      this.width,
      this.height,
      @required this.date,
      @required this.name,
      this.background,
      this.secondaryBackground})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RoundedRectangleDismissible(
      key: key,
      background: background,
      secondaryBackground: secondaryBackground,
      borderRadius: BorderRadius.circular(Constants.mediumBorderRadius),
      child: Card(
        margin: const EdgeInsets.all(0.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(
            Constants.mediumBorderRadius,
          ),
        ),
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
                flex: 3,
                child: name,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
