import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:habit_calendar/constants/constants.dart';

import '../general/slidable.dart';

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
    this.childColor,
    this.ampm,
    @required this.whatTime,
    @required this.name,
    this.slideThreshold = 0.25,
    this.checkMark,
    this.background,
    this.secondaryBackground,
    this.initBackground = HabitTileBackgroundType.background,
    this.onBackgroundChangedAnimation,
    this.onBeforeBackgroundChanged,
    this.onBackgroundChanged,
  })  : assert(key != null),
        assert(whatTime != null),
        assert(name != null),
        assert(secondaryBackground != null ? background != null : true),
        super(key: key);

  final Key key;
  final EdgeInsets padding;
  final double width;
  final double height;
  final Color childColor;
  final Text ampm;
  final Text whatTime;
  final Text name;
  final double slideThreshold;
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

  double get _width => widget.width ?? Get.context.width;
  Color get _childColor => widget.childColor ?? Colors.white;

  Text get _whatTime => widget.ampm != null
      ? Text.rich(
          TextSpan(
            children: [
              TextSpan(
                text: widget.ampm.data,
                style: widget.ampm.style,
              ),
              TextSpan(
                text: ' ',
                style: widget.whatTime.style,
              ),
              TextSpan(
                text: widget.whatTime.data,
                style: widget.whatTime.style,
              ),
            ],
          ),
        )
      : widget.whatTime;

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
        // Add padding to prevent showing little border of background
        child: Padding(
          padding: const EdgeInsets.all(1.0),
          child: _isBackground
              ? widget.background
              : widget.secondaryBackground ?? widget.background,
        ),
      ),
      slideThresholds: widget.slideThreshold,
      child: Container(
        width: _width,
        height: widget.height,
        decoration: BoxDecoration(
          color: _childColor,
          borderRadius: BorderRadius.circular(Constants.mediumBorderRadius),
        ),
        child: Row(
          children: [
            Expanded(
              child: Stack(
                alignment: Alignment.center,
                children: [
                  _whatTime,
                  AnimatedOpacity(
                    opacity: _isBackground ? 0.0 : 0.8,
                    duration: Duration(
                      milliseconds: Constants.smallAnimationSpeed,
                    ),
                    curve: Curves.ease,
                    child: widget.checkMark,
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 10.0,
              ),
              // Remove width to apply padding precisely
              child: VerticalDivider(width: 0.0),
            ),
            Expanded(
              flex: 3,
              child: Padding(
                padding: const EdgeInsets.only(left: 10.0),
                child: widget.name,
              ),
            ),
          ],
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
