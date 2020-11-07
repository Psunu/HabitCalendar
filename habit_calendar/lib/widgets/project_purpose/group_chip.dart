import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:habit_calendar/constants/constants.dart';
import 'package:habit_calendar/services/database/app_database.dart';
import 'package:habit_calendar/widgets/general_purpose/auto_colored_icon.dart';
import 'package:habit_calendar/widgets/general_purpose/color_circle.dart';

const _kColorCircleSize = 20.0;

enum _GroupChipType {
  groupChip,
  add,
}

class GroupChip extends StatefulWidget {
  GroupChip({
    Key key,
    @required this.group,
    this.style,
    this.color = Colors.white,
    this.groupValue,
    this.onSelected,
  })  : assert(group != null),
        type = _GroupChipType.groupChip,
        onTap = null,
        super(key: key);

  GroupChip.add({
    Key key,
    this.color = Colors.white,
    this.onTap,
  })  : type = _GroupChipType.add,
        group = null,
        style = null,
        groupValue = null,
        onSelected = null,
        super(key: key);

  final _GroupChipType type;

  final Group group;
  final TextStyle style;
  final Color color;
  final int groupValue;
  final void Function(int groupId) onSelected;

  final void Function() onTap;

  @override
  _GroupChipState createState() => _GroupChipState();
}

class _GroupChipState extends State<GroupChip> {
  bool _isSelected = false;

  Widget _child;
  void Function() _callback;

  @override
  void initState() {
    switch (widget.type) {
      case _GroupChipType.groupChip:
        _child = Row(
          children: [
            ColorCircle(
              color: Color(widget.group.color),
              width: _kColorCircleSize,
              height: _kColorCircleSize,
            ),
            SizedBox(width: 8.0),
            Text(
              widget.group.name,
              style: widget.style ?? Get.textTheme.bodyText1,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        );
        _callback = () {
          setState(() {
            _isSelected = !_isSelected;
          });

          if (widget.onSelected != null) widget.onSelected(widget.group.id);
          if (widget.onTap != null) widget.onTap();
        };
        break;
      case _GroupChipType.add:
        _child = AutoColoredIcon(
          backgroundColor: widget.color,
          child: Icon(
            Icons.add,
          ),
        );
        _callback = () {
          if (widget.onTap != null) widget.onTap();
        };
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.groupValue != null)
      _isSelected = widget.group.id == widget.groupValue;

    return GestureDetector(
      onTap: _callback,
      child: Material(
        color: widget.color,
        borderRadius: BorderRadius.circular(Constants.smallBorderRadius),
        elevation: _isSelected ? 5.0 : 0.0,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: _child,
        ),
      ),
    );
  }
}
