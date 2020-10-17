import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:habit_calendar/constants/constants.dart';
import 'package:habit_calendar/services/database/app_database.dart';
import 'package:habit_calendar/utils/utils.dart';
import 'package:habit_calendar/widgets/icon_text.dart';
import 'package:habit_calendar/widgets/time_picker.dart';

//TODO implement HabitInfoWidget
//show habit's info
//fix error when habit's info is null
class HabitInfoWidget extends StatefulWidget {
  HabitInfoWidget({
    Key key,
    @required this.habit,
    Color backgroundColor,
    this.borderRadius = Constants.largeBorderRadius,
    this.padding = const EdgeInsets.all(Constants.padding),
    this.margin = const EdgeInsets.all(Constants.padding),
  })  : assert(habit != null),
        backgroundColor = backgroundColor ?? Colors.white,
        super(key: key);

  final Habit habit;
  final Color backgroundColor;
  final double borderRadius;
  final EdgeInsets padding;
  final EdgeInsets margin;

  @override
  _HabitInfoWidgetState createState() => _HabitInfoWidgetState();
}

class _HabitInfoWidgetState extends State<HabitInfoWidget> {
  RxBool _isWhatTimeActivated;
  DateTime _whatTime;

  @override
  void initState() {
    _whatTime = widget.habit.whatTime;
    _isWhatTimeActivated = (widget.habit.whatTime != null).obs;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: widget.padding,
      margin: widget.margin,
      decoration: BoxDecoration(
        color: widget.backgroundColor,
        borderRadius: BorderRadius.circular(widget.borderRadius),
      ),
      child: DefaultTextStyle(
        style: Get.textTheme.headline6,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(widget.habit.name),
                ),
                Row(
                  children: [
                    CircleIconButton(iconData: Icons.edit),
                    SizedBox(width: 10.0),
                    CircleIconButton(iconData: Icons.more_vert),
                  ],
                ),
              ],
            ),
            Divider(),
            Material(
              type: MaterialType.transparency,
              child: IconText(
                iconData: Icons.access_time,
                text: Utils.getWhatTimeString(_whatTime),
                isActivated: _isWhatTimeActivated,
                onTap: () {
                  if (_isWhatTimeActivated.value) {
                    showModalBottomSheet(
                      context: Get.context,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.only(
                          topLeft: const Radius.circular(
                              Constants.largeBorderRadius),
                          topRight: const Radius.circular(
                              Constants.largeBorderRadius),
                        ),
                      ),
                      builder: (context) {
                        return Padding(
                          padding: const EdgeInsets.all(30.0),
                          child: TimePicker(
                            ampmStyle: Get.textTheme.bodyText1,
                            timeStyle: Get.textTheme.headline5,
                            initTime: _whatTime,
                            height: 200.0,
                            onTimeChanged: (time) {
                              setState(() {
                                _whatTime = time;
                              });
                            },
                          ),
                        );
                      },
                    );
                  }
                },
              ),
            ),
            Text(widget.habit.whatTime?.toString() ?? ''),
            Text(widget.habit.notificationTime?.toString() ?? ''),
            Text(widget.habit.description ?? ''),
          ],
        ),
      ),
    );
  }
}

class CircleIconButton extends StatelessWidget {
  const CircleIconButton({
    Key key,
    @required this.iconData,
  })  : assert(iconData != null),
        super(key: key);

  final IconData iconData;

  @override
  Widget build(BuildContext context) {
    return Material(
      type: MaterialType.transparency,
      shape: CircleBorder(),
      child: InkWell(
        customBorder: CircleBorder(),
        onTap: () {},
        child: Icon(
          iconData,
          size: Get.textTheme.headline6.fontSize,
        ),
      ),
    );
  }
}
