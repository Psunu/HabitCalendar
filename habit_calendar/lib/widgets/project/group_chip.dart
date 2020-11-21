import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:habit_calendar/constants/constants.dart';
import 'package:habit_calendar/services/database/app_database.dart';
import 'package:habit_calendar/widgets/general/auto_colored_icon.dart';
import 'package:habit_calendar/widgets/general/color_circle.dart';
import 'package:habit_calendar/widgets/project/custom_chip.dart';

const _kColorCircleSize = 20.0;

enum _GroupChipType {
  groupChip,
  add,
}

class GroupChip extends StatefulWidget {
  GroupChip({
    Key key,
    @required this.group,
    this.selectedStyle,
    this.unSelectedStyle,
    this.color = Colors.white,
    this.groupValue,
    this.onSelected,
  })  : assert(color != null),
        assert(group != null),
        type = _GroupChipType.groupChip,
        onTap = null,
        super(key: key);

  GroupChip.add({
    Key key,
    this.color = Colors.white,
    this.onTap,
  })  : type = _GroupChipType.add,
        group = null,
        selectedStyle = null,
        unSelectedStyle = null,
        groupValue = null,
        onSelected = null,
        super(key: key);

  final _GroupChipType type;

  final Group group;
  final TextStyle selectedStyle;
  final TextStyle unSelectedStyle;
  final Color color;
  final int groupValue;
  final void Function(int groupId) onSelected;

  final void Function() onTap;

  @override
  _GroupChipState createState() => _GroupChipState();
}

class _GroupChipState extends State<GroupChip> {
  final _borderRadius = BorderRadius.circular(Constants.smallBorderRadius);
  bool _isSelected = false;

  TextStyle get _selectedStyle =>
      widget.selectedStyle ??
      Get.textTheme.bodyText1.copyWith(color: Get.theme.accentColor);
  TextStyle get _unSelectedStyle =>
      widget.unSelectedStyle ?? Get.textTheme.bodyText1;

  void Function() get _callback {
    switch (widget.type) {
      case _GroupChipType.groupChip:
        return () {
          setState(() {
            _isSelected = !_isSelected;
          });

          if (widget.onSelected != null) widget.onSelected(widget.group.id);
          if (widget.onTap != null) widget.onTap();
        };
        break;
      case _GroupChipType.add:
      default:
        return () {
          if (widget.onTap != null) widget.onTap();
        };
    }
  }

  Widget get _child {
    switch (widget.type) {
      case _GroupChipType.groupChip:
        return Row(
          children: [
            ColorCircle(
              color: Color(widget.group.color),
              width: _kColorCircleSize,
              height: _kColorCircleSize,
            ),
            SizedBox(width: 8.0),
            Text(
              widget.group.name,
              style: _isSelected ? _selectedStyle : _unSelectedStyle,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        );
      case _GroupChipType.add:
      default:
        return AutoColoredIcon(
          backgroundColor: widget.color,
          child: Icon(
            Icons.add,
          ),
        );
    }
  }

  @override
  void initState() {
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
        borderRadius: _borderRadius,
        elevation: _isSelected ? 5.0 : 0.0,
        child: CustomChip(
          color: widget.color,
          padding: const EdgeInsets.symmetric(
            vertical: 8.0,
            horizontal: 16.0,
          ),
          borderRadius: _borderRadius,
          child: _child,
        ),
      ),
    );
  }
}
