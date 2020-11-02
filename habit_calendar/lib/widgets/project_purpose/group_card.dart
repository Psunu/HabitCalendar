import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:habit_calendar/constants/constants.dart';
import 'package:habit_calendar/services/database/app_database.dart';
import '../general_purpose/auto_colored_icon.dart';
import '../general_purpose/auto_colored_text.dart';
import '../general_purpose/color_circle.dart';

const _kChipPadding = 13.0;

class GroupCard extends StatefulWidget {
  const GroupCard({
    Key key,
    @required this.group,
    @required this.memberHabits,
    this.nameStyle,
    this.numStyle,
    this.backgroundColor = Colors.white,
    this.outlineColor = Colors.grey,
    this.colorCircleSize = 20.0,
    this.height = 70.0,
    this.isSelected = false,
    this.editModeAction,
    this.onHabitTapped,
    this.isEditMode = false,
    this.onTapAfterLongPress,
    this.onLongPress,
  })  : assert(group != null),
        assert(memberHabits != null),
        super(key: key);

  final Group group;

  final List<Habit> memberHabits;

  final TextStyle nameStyle;

  final TextStyle numStyle;

  final Color backgroundColor;

  final Color outlineColor;

  final double colorCircleSize;

  final double height;

  final bool isSelected;

  // parameter : habit id
  final void Function(int) onHabitTapped;

  final bool isEditMode;

  final Widget editModeAction;

  // parameters : group id, isSelected
  final void Function(int, bool) onTapAfterLongPress;

  // parameters : group id, isSelected
  final void Function(int, bool) onLongPress;

  @override
  _GroupCardState createState() => _GroupCardState();
}

class _GroupCardState extends State<GroupCard> with TickerProviderStateMixin {
  AnimationController _actionController;
  Animation<double> _actionAnimation;
  AnimationController _editModeController;
  Animation<double> _toEditModeAnimation;
  Animation<double> _toNormalModeAnimation;

  bool _isExpanded = false;
  bool _isSelected = false;

  bool get _hasNoMembers => widget.memberHabits.length < 1;

  @override
  void initState() {
    _isSelected = widget.isSelected;

    _actionController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: Constants.smallAnimationSpeed),
    );
    _actionAnimation = _actionController.drive(
      Tween(begin: 0.0, end: 0.5).chain(
        CurveTween(curve: Curves.ease),
      ),
    );

    _editModeController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: Constants.smallAnimationSpeed),
    );
    _toEditModeAnimation = _editModeController.drive(
      Tween(begin: 0.0, end: 1.0).chain(
        CurveTween(curve: Curves.ease),
      ),
    );
    _toNormalModeAnimation = _editModeController.drive(
      Tween(begin: 1.0, end: 0.0).chain(
        CurveTween(curve: Curves.ease),
      ),
    );

    super.initState();
  }

  @override
  void dispose() {
    _actionController.dispose();
    _editModeController.dispose();

    super.dispose();
  }

  void _onTap() {
    if (widget.isEditMode) {
      if (!_isSelected) {
        setState(() {
          _isSelected = true;
        });
      } else {
        setState(() {
          _isSelected = false;
        });
      }

      if (widget.onTapAfterLongPress != null) {
        widget.onTapAfterLongPress(widget.group.id, _isSelected);
      }
    } else {
      if (_hasNoMembers) return;

      if (_isExpanded) {
        _actionController.reverse();
      } else {
        _actionController.forward();
      }

      setState(() {
        _isExpanded = !_isExpanded;
      });
    }
  }

  void _onLongPress() {
    if (!_isSelected) {
      setState(() {
        _isSelected = true;
      });
      if (widget.onLongPress != null) {
        widget.onLongPress(widget.group.id, _isSelected);
      }
    }
  }

  Widget _buildExpand() {
    if (_hasNoMembers) {
      return Container();
    }

    Widget buildChild(int index, bool onElevation) {
      return Material(
        type: MaterialType.transparency,
        child: Chip(
          elevation: onElevation ? 5.0 : 0.0,
          backgroundColor: widget.backgroundColor,
          shape: RoundedRectangleBorder(
            side: BorderSide(color: widget.outlineColor),
            borderRadius: BorderRadius.circular(Constants.largeBorderRadius),
          ),
          labelPadding: const EdgeInsets.symmetric(
            horizontal: _kChipPadding,
          ),
          label: AutoColoredText(
            backgroundColor: widget.backgroundColor,
            child: Text(
              widget.memberHabits[index].name,
              style: Get.textTheme.bodyText1,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Divider(height: 0.0),
        ConstrainedBox(
          constraints: BoxConstraints(maxHeight: widget.height * 3),
          child: SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            child: Padding(
              padding: const EdgeInsets.only(
                top: 10.0,
                bottom: 10.0,
                right: 16.0,
              ),
              child: Wrap(
                spacing: 16.0,
                children: List.generate(
                  widget.memberHabits.length,
                  (index) => InkWell(
                    borderRadius: BorderRadius.circular(
                      100.0,
                    ),
                    onTap: () {
                      if (!widget.onHabitTapped.isNull)
                        widget.onHabitTapped(widget.memberHabits[index].id);
                    },
                    child: LongPressDraggable<int>(
                      child: buildChild(index, false),
                      feedback: buildChild(index, true),
                      childWhenDragging: buildChild(index, true),
                      data: widget.memberHabits[index].id,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    print('build');
    if (!widget.isEditMode) {
      _isSelected = false;
      _editModeController.reverse();
    } else {
      if (!_editModeController.isCompleted) _editModeController.forward();
    }

    return GestureDetector(
      onTap: _onTap,
      onLongPress: !widget.isEditMode ? _onLongPress : null,
      child: AnimatedPadding(
        padding: EdgeInsets.all(
          widget.isEditMode && !_isSelected ? 5.0 : 0.0,
        ),
        duration: Duration(milliseconds: Constants.mediumAnimationSpeed),
        curve: Curves.ease,
        child: Material(
          elevation: _isSelected ? 5.0 : 0.0,
          color: widget.backgroundColor,
          borderRadius: BorderRadius.circular(Constants.mediumBorderRadius),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: Stack(
              children: [
                AnimatedSize(
                  alignment: Alignment.topCenter,
                  vsync: this,
                  duration:
                      Duration(milliseconds: Constants.mediumAnimationSpeed),
                  curve: Curves.ease,
                  child: Column(
                    children: [
                      Container(
                        padding: EdgeInsets.symmetric(vertical: 25.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            // Group name
                            Padding(
                              padding: const EdgeInsets.only(left: 40.0),
                              child: AutoColoredText(
                                backgroundColor: widget.backgroundColor,
                                child: Text(
                                  widget.group.name,
                                  style: widget.nameStyle ??
                                      Get.textTheme.headline6,
                                ),
                              ),
                            ),
                            Stack(
                              children: [
                                !widget.isEditMode
                                    ? FadeTransition(
                                        opacity: _toNormalModeAnimation,
                                        child: Row(
                                          children: [
                                            // Group memebers number
                                            AutoColoredText(
                                              backgroundColor:
                                                  widget.backgroundColor,
                                              child: Text(
                                                widget.memberHabits.length
                                                    .toString(),
                                                style: widget.numStyle ??
                                                    Get.textTheme.bodyText1,
                                              ),
                                            ),
                                            const SizedBox(width: 5.0),
                                            // Expand button
                                            RotationTransition(
                                              turns: _actionAnimation,
                                              child: Icon(
                                                Icons.expand_more,
                                                color: _hasNoMembers
                                                    ? Colors.transparent
                                                    : null,
                                              ),
                                            ),
                                          ],
                                        ),
                                      )
                                    : Container(),
                                // Drag icon
                                widget.isEditMode
                                    ? FadeTransition(
                                        opacity: _toEditModeAnimation,
                                        child: Padding(
                                          padding:
                                              const EdgeInsets.only(right: 8.0),
                                          child: widget.editModeAction ??
                                              AutoColoredIcon(
                                                backgroundColor:
                                                    widget.backgroundColor,
                                                child: Icon(Icons.reorder),
                                              ),
                                        ),
                                      )
                                    : Container(),
                              ],
                            ),
                          ],
                        ),
                      ),
                      // Expand part
                      _isExpanded ? _buildExpand() : Container(),
                    ],
                  ),
                ),
                // Group color
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: ColorCircle(
                    color: Color(widget.group.color),
                    height: widget.colorCircleSize,
                    width: widget.colorCircleSize,
                    outlineColor: widget.outlineColor,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
