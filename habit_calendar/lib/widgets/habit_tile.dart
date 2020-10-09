import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:habit_calendar/constants/constants.dart';
import 'package:habit_calendar/widgets/slidable.dart';

// TODO implement dismissible
class HabitTile extends StatefulWidget {
  HabitTile({
    @required this.key,
    this.padding,
    this.width,
    this.height,
    @required this.date,
    @required this.name,
    this.background,
    this.secondaryBackground,
  })  : assert(key != null),
        assert(secondaryBackground != null ? background != null : true),
        super(key: key);

  final Key key;
  final EdgeInsets padding;
  final double width;
  final double height;
  final Text date;
  final Text name;
  final Widget background;
  final Widget secondaryBackground;

  @override
  _HabitTileState createState() => _HabitTileState();
}

class _HabitTileState extends State<HabitTile> {
  SlidableController _slidableController = SlidableController();
  bool _isBackground = true;

  @override
  Widget build(BuildContext context) {
    return Slidable(
      key: widget.key,
      controller: _slidableController,
      background: InkWell(
        onTap: () => setState(() {
          _slidableController.reverse();
          _isBackground = !_isBackground;
        }),
        child: _isBackground
            ? widget.background
            : widget.secondaryBackground ?? widget.background,
      ),
      slideThresholds: 0.25,
      child: Card(
        margin: const EdgeInsets.all(0.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(
            Constants.mediumBorderRadius,
          ),
        ),
        child: Container(
          margin:
              widget.padding ?? const EdgeInsets.symmetric(horizontal: 20.0),
          width: widget.width ?? Get.context.width,
          height: widget.height ?? 90.0,
          child: Row(
            children: [
              Expanded(
                flex: 1,
                child: widget.date,
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 5.0, vertical: 10.0),
                child: VerticalDivider(),
              ),
              Expanded(
                flex: 3,
                child: widget.name,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
