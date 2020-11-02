import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:habit_calendar/constants/constants.dart';
import 'package:habit_calendar/widgets/general_purpose/auto_colored_icon.dart';
import 'package:habit_calendar/widgets/general_purpose/auto_colored_text.dart';

class BottomBar extends StatefulWidget {
  BottomBar({
    Key key,
    this.displayOnlyDelete = false,
    this.backgroundColor = Colors.white,
    this.duration =
        const Duration(milliseconds: Constants.mediumAnimationSpeed),
    this.onEditTap,
    this.onDeleteTap,
  }) : super(key: key);

  final bool displayOnlyDelete;
  final Color backgroundColor;

  final Duration duration;

  final void Function() onEditTap;
  final void Function() onDeleteTap;

  @override
  _BottomBarState createState() => _BottomBarState();
}

class _BottomBarState extends State<BottomBar>
    with SingleTickerProviderStateMixin {
  AnimationController _editController;
  Animation _editAnimation;
  Animation _fadeAnimation;

  @override
  void initState() {
    assert(widget.duration != null);
    _editController =
        AnimationController(duration: widget.duration, vsync: this);
    _editAnimation = _editController.drive(
      IntTween(begin: 100, end: 0).chain(CurveTween(curve: Curves.ease)),
    )..addListener(() {
        setState(() {});
      });

    _fadeAnimation = _editController.drive(
      Tween(begin: 1.0, end: 0.0).chain(CurveTween(curve: Curves.ease)),
    );

    super.initState();
  }

  Widget _buildChild(IconData iconData, String text) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Column(
        children: [
          AutoColoredIcon(
            backgroundColor: widget.backgroundColor,
            child: Icon(
              iconData,
              size: Get.textTheme.bodyText2.fontSize * 1.7,
            ),
          ),
          AutoColoredText(
            backgroundColor: widget.backgroundColor,
            child: Text(
              text,
              maxLines: 1,
              style: Get.textTheme.bodyText2,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (widget.displayOnlyDelete) {
      _editController.forward();
    } else {
      _editController.reverse();
    }
    return Container(
      width: Get.width,
      decoration: BoxDecoration(
        color: widget.backgroundColor,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(Constants.largeBorderRadius),
          topRight: Radius.circular(Constants.largeBorderRadius),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.4),
            spreadRadius: 5,
            blurRadius: 7,
            offset: Offset(0, 3), // changes position of shadow
          ),
        ],
      ),
      child: Material(
        type: MaterialType.transparency,
        child: Row(
          children: [
            Expanded(
              flex: _editAnimation.value,
              // Uses SizedBox to hide widget when flex is going to 0
              child: SizedBox(
                width: 0.0,
                child: FadeScaleTransition(
                  animation: _fadeAnimation,
                  child: InkResponse(
                    onTap: () {
                      if (widget.onEditTap != null && !widget.displayOnlyDelete)
                        widget.onEditTap();
                    },
                    child: _buildChild(Icons.edit, '수정'.tr.capitalizeFirst),
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 100,
              child: InkResponse(
                onTap: () {
                  if (widget.onDeleteTap != null) widget.onDeleteTap();
                },
                child: _buildChild(Icons.delete, '삭제'.tr.capitalizeFirst),
              ),
            )
          ],
        ),
      ),
    );
  }
}
