import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:habit_calendar/constants/constants.dart';
import 'package:habit_calendar/widgets/slidable.dart';

typedef OnBackgroundChangedAnimation = Future<void> Function(
  HabitTileBackgroundType from,
  HabitTileBackgroundType to,
);
typedef OnBackgroundChangedCallback = void Function(
  HabitTileBackgroundType from,
  HabitTileBackgroundType to,
);

enum HabitTileBackgroundType {
  background,
  secondaryBackground,
}

class HabitTile extends StatefulWidget {
  HabitTile({
    @required this.key,
    this.padding = const EdgeInsets.symmetric(horizontal: 20.0),
    this.width,
    this.height = 90.0,
    @required this.date,
    @required this.name,
    this.checkMark,
    this.background,
    this.secondaryBackground,
    this.initBackground = HabitTileBackgroundType.background,
    this.onBackgroundChangedAnimation,
    this.onBeforeBackgroundChanged,
    this.onBackgroundChanged,
  })  : assert(key != null),
        assert(secondaryBackground != null ? background != null : true),
        super(key: key);

  final Key key;
  final EdgeInsets padding;
  final double width;
  final double height;
  final Text date;
  final Text name;
  final Widget checkMark;
  final Widget background;
  final Widget secondaryBackground;
  final HabitTileBackgroundType initBackground;
  final OnBackgroundChangedAnimation onBackgroundChangedAnimation;
  final OnBackgroundChangedCallback onBeforeBackgroundChanged;
  final OnBackgroundChangedCallback onBackgroundChanged;

  @override
  _HabitTileState createState() => _HabitTileState();
}

class _HabitTileState extends State<HabitTile> {
  SlidableController _slidableController = SlidableController();
  bool _isBackground;

  @override
  void initState() {
    _isBackground = widget.initBackground == HabitTileBackgroundType.background;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Slidable(
      key: widget.key,
      controller: _slidableController,
      background: InkWell(
        onTap: () async {
          if (widget.onBackgroundChangedAnimation != null) {
            if (_isBackground) {
              await widget.onBackgroundChangedAnimation(
                HabitTileBackgroundType.background,
                HabitTileBackgroundType.secondaryBackground,
              );
            } else {
              await widget.onBackgroundChangedAnimation(
                HabitTileBackgroundType.secondaryBackground,
                HabitTileBackgroundType.background,
              );
            }
          }
          // Call onBeforeBackgroundChanged callback
          if (widget.onBeforeBackgroundChanged != null) {
            if (_isBackground) {
              widget.onBeforeBackgroundChanged(
                HabitTileBackgroundType.background,
                HabitTileBackgroundType.secondaryBackground,
              );
            } else {
              widget.onBeforeBackgroundChanged(
                HabitTileBackgroundType.secondaryBackground,
                HabitTileBackgroundType.background,
              );
            }
          }

          // Animate reverse and after change background
          await _slidableController.reverse().then((value) {
            setState(() {
              _isBackground = !_isBackground;
            });
          });

          // Call onBackgroundChanged callback
          if (widget.onBackgroundChanged != null) {
            if (_isBackground) {
              widget.onBackgroundChanged(
                HabitTileBackgroundType.secondaryBackground,
                HabitTileBackgroundType.background,
              );
            } else {
              widget.onBackgroundChanged(
                HabitTileBackgroundType.background,
                HabitTileBackgroundType.secondaryBackground,
              );
            }
          }
        },
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
          margin: widget.padding,
          width: widget.width ?? Get.context.width,
          height: widget.height,
          child: Row(
            children: [
              Expanded(
                flex: 1,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    AnimatedOpacity(
                      opacity: _isBackground ? 0.0 : 0.8,
                      duration: Duration(
                        milliseconds: Constants.smallAnimationSpeed,
                      ),
                      curve: Curves.ease,
                      child: widget.checkMark,
                    ),
                    widget.date,
                  ],
                ),
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

class HabitTileBackground extends StatefulWidget {
  HabitTileBackground({
    @required this.color,
    @required this.child,
  });

  final Color color;
  final Widget child;

  @override
  _HabitTileBackgroundState createState() => _HabitTileBackgroundState();
}

class _HabitTileBackgroundState extends State<HabitTileBackground> {
  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.centerRight,
      decoration: BoxDecoration(
        color: widget.color,
        borderRadius: BorderRadius.circular(
          Constants.mediumBorderRadius,
        ),
      ),
      child: widget.child,
    );
  }
}
