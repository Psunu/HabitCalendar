import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DeleteConfirmDialog extends StatelessWidget {
  DeleteConfirmDialog({
    Key key,
    @required this.message,
    this.backgroundColor = Colors.white,
    this.onCancelTap,
    this.onDeleteTap,
  })  : assert(message != null),
        super(key: key);

  final Widget message;
  final Color backgroundColor;

  final void Function() onCancelTap;
  final void Function() onDeleteTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      type: MaterialType.transparency,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            message,
            Divider(),
            Row(
              children: [
                Expanded(
                  child: FlatButton(
                    onPressed: onCancelTap,
                    child: Text(
                      '취소'.tr.capitalizeFirst,
                      style: Get.textTheme.bodyText1.copyWith(
                        color: Get.theme.accentColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: FlatButton(
                    onPressed: onDeleteTap,
                    child: Text(
                      '삭제'.tr.capitalizeFirst,
                      style: Get.textTheme.bodyText1.copyWith(
                        color: Get.theme.accentColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
