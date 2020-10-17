import 'package:flutter/material.dart';
import 'package:get/get.dart';

const _kIconSize = 30.0;
const _kIconTextPadding = 20.0;

class IconText extends StatelessWidget {
  IconText({
    @required this.iconData,
    @required this.text,
    this.initText,
    @required this.isActivated,
    this.iconSize = _kIconSize,
    this.iconTextPadding = _kIconTextPadding,
    @required this.onTap,
  });

  final IconData iconData;
  final String text;
  final String initText;
  final RxBool isActivated;
  final double iconSize;
  final double iconTextPadding;
  final void Function() onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: iconTextPadding),
      child: Row(
        children: [
          InkWell(
            customBorder: const CircleBorder(),
            onTap: () {
              isActivated.value = !isActivated.value;
              Get.focusScope.unfocus();
            },
            child: Icon(
              iconData,
              size: iconSize,
              color:
                  isActivated.value ? Get.theme.accentColor : Colors.grey[400],
            ),
          ),
          SizedBox(
            width: 30.0,
          ),
          Expanded(
            child: InkWell(
              onTap: () {
                if (!isActivated.value) {
                  isActivated.value = !isActivated.value;
                }
                onTap();
                Get.focusScope.unfocus();
              },
              child: Text(
                text,
                style: Get.textTheme.headline6.copyWith(
                  color: isActivated.value ? Colors.black87 : Colors.grey,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
