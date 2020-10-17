import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:habit_calendar/constants/constants.dart';
import 'package:habit_calendar/services/database/app_database.dart';
import 'package:habit_calendar/widgets/group_circle.dart';

const _kChipPadding = 13.0;

class GroupCard extends StatefulWidget {
  const GroupCard({
    Key key,
    @required this.groupName,
    @required this.numGroupMembers,
    @required this.groupMembers,
    @required this.color,
    this.backgroundColor = Colors.white,
    this.outlineColor = Colors.grey,
    this.colorCircleSize = 20.0,
    this.width,
    this.height = 70.0,
    this.onHabitTapped,
  }) : super(key: key);

  final Text groupName;
  final Text numGroupMembers;
  final List<Habit> groupMembers;
  final Color color;
  final Color backgroundColor;
  final Color outlineColor;
  final double colorCircleSize;
  final double width;
  final double height;
  final void Function(int) onHabitTapped;

  @override
  _GroupCardState createState() => _GroupCardState();
}

class _GroupCardState extends State<GroupCard> with TickerProviderStateMixin {
  AnimationController _actionAnimationController;
  Animation _actionAnimation;

  double get _width => widget.width ?? Get.context.width;

  bool expanded = false;

  @override
  void initState() {
    _actionAnimationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: Constants.smallAnimationSpeed),
    );
    _actionAnimation = _actionAnimationController.drive(
      Tween(begin: 0.0, end: 0.5).chain(
        CurveTween(curve: Curves.ease),
      ),
    );

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: widget.backgroundColor,
        borderRadius: BorderRadius.circular(Constants.mediumBorderRadius),
      ),
      width: _width,
      child: Padding(
        padding: const EdgeInsets.only(left: 10.0),
        child: Stack(
          children: [
            SingleChildScrollView(
              physics: NeverScrollableScrollPhysics(),
              child: AnimatedSize(
                alignment: Alignment.topCenter,
                vsync: this,
                duration:
                    Duration(milliseconds: Constants.mediumAnimationSpeed),
                curve: Curves.ease,
                child: Column(
                  children: [
                    SizedBox(
                      height: widget.height,
                      child: Row(
                        children: [
                          const SizedBox(width: 40.0),
                          widget.groupName,
                          Expanded(
                            child: Align(
                              alignment: Alignment.centerRight,
                              child: widget.numGroupMembers,
                            ),
                          ),
                          RotationTransition(
                            turns: _actionAnimation,
                            child: IconButton(
                              splashRadius: 0.1,
                              splashColor: Colors.transparent,
                              icon: const Icon(Icons.expand_more),
                              onPressed: () {
                                setState(
                                  () {
                                    if (widget.groupMembers.isEmpty ||
                                        widget.groupMembers.isNull) return;

                                    if (expanded) {
                                      _actionAnimationController.reverse();
                                    } else {
                                      _actionAnimationController.forward();
                                    }

                                    expanded = !expanded;
                                  },
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                    expanded ? _buildExpand() : Container(),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: GroupCircle(
                color: widget.color,
                height: widget.colorCircleSize,
                width: widget.colorCircleSize,
                outlineColor: widget.outlineColor,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildExpand() {
    if (widget.groupMembers.isNull || widget.groupMembers.isEmpty) {
      return Container();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Divider(height: 0.0),
        ConstrainedBox(
          constraints: BoxConstraints(maxHeight: widget.height * 3),
          child: SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(
                    top: 10.0,
                    bottom: 10.0,
                    right: 16.0,
                  ),
                  child: Wrap(
                    spacing: 16.0,
                    children: List.generate(
                      widget.groupMembers.length,
                      (index) => InkWell(
                        onTap: () {
                          if (!widget.onHabitTapped.isNull)
                            widget.onHabitTapped(widget.groupMembers[index].id);
                        },
                        child: Chip(
                          backgroundColor: widget.backgroundColor,
                          shape: RoundedRectangleBorder(
                            side: BorderSide(color: widget.outlineColor),
                            borderRadius: BorderRadius.circular(
                                Constants.largeBorderRadius),
                          ),
                          labelPadding: const EdgeInsets.symmetric(
                            horizontal: _kChipPadding,
                          ),
                          label: Text(
                            widget.groupMembers[index].name,
                            style: Get.textTheme.bodyText1,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
