import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:habit_calendar/constants/constants.dart';
import 'package:habit_calendar/services/database/app_database.dart';
import 'package:habit_calendar/widgets/color_circle.dart';

class GroupPopupMenu extends StatefulWidget {
  GroupPopupMenu({
    Key key,
    @required this.groups,
    this.initColor,
    this.onSelected,
  })  : assert(groups != null),
        super(key: key);

  final List<Group> groups;
  final Color initColor;
  final void Function(int) onSelected;

  @override
  _GroupPopupMenuState createState() => _GroupPopupMenuState();
}

class _GroupPopupMenuState extends State<GroupPopupMenu> {
  Color childColor;

  @override
  void initState() {
    childColor = widget.initColor ?? Colors.white;
    super.initState();
  }

  List<PopupMenuEntry<int>> _popupMenuEntryBuilder(BuildContext context) {
    final list = List<PopupMenuEntry<int>>();
    list.add(PopupMenuItem(
      height: Get.textTheme.bodyText1.fontSize + 5.0,
      enabled: false,
      child: Center(
        child: Text(
          '폴더'.tr.capitalizeFirst,
          style: Get.textTheme.bodyText1,
        ),
      ),
    ));

    if (widget.groups != null && widget.groups.isNotEmpty) {
      list.add(PopupMenuDivider());

      widget.groups.forEach((group) {
        list.add(PopupMenuItem(
          height: Get.textTheme.bodyText1.fontSize * 2.5,
          value: group.id,
          child: Row(
            children: [
              ColorCircle(
                color: Color(group.color),
                width: Get.textTheme.bodyText1.fontSize,
                height: Get.textTheme.bodyText1.fontSize,
              ),
              SizedBox(
                width: 10.0,
              ),
              Text(
                group.name,
                style: Get.textTheme.bodyText1,
              ),
            ],
          ),
        ));
      });
    }

    return list;
  }

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<int>(
      itemBuilder: _popupMenuEntryBuilder,
      onCanceled: () => Get.focusScope.unfocus(),
      onSelected: (groupId) {
        setState(() {
          childColor = Color(widget.groups
              .singleWhere((element) => element.id == groupId)
              .color);
        });
        widget.onSelected(groupId);
      },
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(
          Constants.smallBorderRadius,
        ),
      ),
      child: ColorCircle(
        color: childColor,
        width: 20.0,
        height: 20.0,
      ),
    );
  }
}
