import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:habit_calendar/constants/constants.dart';
import 'package:habit_calendar/widgets/auto_colored_text.dart';

const _kPadding = 20.0;
const _kButtonPadding = 13.0;

class BottomButtons extends StatelessWidget {
  BottomButtons({
    Key key,
    this.backgroundColor,
    this.margin = const EdgeInsets.all(_kPadding),
    this.padding = const EdgeInsets.all(_kButtonPadding),
    this.height,
    this.leftButton,
    this.rightButton,
    this.leftButtonString,
    this.rightButtonString,
    this.leftButtonAction,
    this.rightButtonAction,
  }) : super(key: key);

  final Color backgroundColor;
  final EdgeInsets margin;
  final EdgeInsets padding;
  final double height;
  final Widget leftButton;
  final Widget rightButton;
  final String leftButtonString;
  final String rightButtonString;
  final void Function() leftButtonAction;
  final void Function() rightButtonAction;

  void Function() get _leftButtonAction => leftButtonAction ?? () => Get.back();

  String get _leftButtonString => leftButtonString ?? '취소'.tr.capitalizeFirst;
  String get _rightButtonString => rightButtonString ?? '저장'.tr.capitalizeFirst;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: backgroundColor,
      height: height,
      child: Padding(
        padding: margin,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Expanded(
              child: leftButton ??
                  FlatButton(
                    padding: padding,
                    onPressed: _leftButtonAction,
                    child: Text(
                      _leftButtonString,
                      style: Get.textTheme.headline6
                          .copyWith(color: Colors.grey[700]),
                    ),
                  ),
            ),
            Expanded(
              child: rightButton ??
                  RaisedButton(
                    padding: padding,
                    color: Get.theme.accentColor,
                    shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(Constants.mediumBorderRadius),
                    ),
                    onPressed: rightButtonAction,
                    child: AutoColoredText(
                      backgroundColor: Get.theme.accentColor,
                      child: Text(
                        _rightButtonString,
                        style: Get.textTheme.headline6,
                      ),
                    ),
                  ),
            ),
          ],
        ),
      ),
    );
  }
}
