import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:habit_calendar/constants/constants.dart';
import 'package:habit_calendar/widgets/general_purpose/auto_colored_icon.dart';
import 'package:habit_calendar/widgets/general_purpose/auto_colored_text.dart';

class BottomBar extends StatelessWidget {
  BottomBar({
    Key key,
    this.displayOnlyDelete,
    this.backgroundColor = Colors.white,
    this.onEditTap,
    this.onDeleteTap,
  }) : super(key: key);

  final bool displayOnlyDelete;
  final Color backgroundColor;

  final void Function() onEditTap;
  final void Function() onDeleteTap;

  Widget _buildChild(IconData iconData, String text) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Column(
        children: [
          AutoColoredIcon(
            backgroundColor: backgroundColor,
            child: Icon(
              iconData,
              size: Get.textTheme.bodyText2.fontSize * 1.7,
            ),
          ),
          AutoColoredText(
            backgroundColor: backgroundColor,
            child: Text(
              text,
              style: Get.textTheme.bodyText2,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: Get.width,
      decoration: BoxDecoration(
        color: backgroundColor,
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
              child: InkResponse(
                onTap: () {
                  if (onEditTap != null) onEditTap();
                },
                child: _buildChild(Icons.edit, '수정'.tr.capitalizeFirst),
              ),
            ),
            Expanded(
              child: InkResponse(
                onTap: () {
                  if (onDeleteTap != null) onDeleteTap();
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
