import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:habit_calendar/constants/constants.dart';

const _kPadding = 20.0;
const _kButtonPadding = 13.0;

class BottomButtons extends StatelessWidget {
  BottomButtons({
    Key key,
    this.backgroundColor,
    this.margin = const EdgeInsets.all(_kPadding),
    this.padding = const EdgeInsets.all(_kButtonPadding),
    this.spaceBetween = false,
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
  final bool spaceBetween;
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
          children: [
            Expanded(
              child: Align(
                alignment:
                    spaceBetween ? Alignment.centerLeft : Alignment.center,
                child: leftButton ??
                    FlatButton(
                      padding: padding,
                      shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(Constants.smallBorderRadius),
                      ),
                      onPressed: _leftButtonAction,
                      child: Text(
                        _leftButtonString,
                        style: Get.textTheme.bodyText1,
                      ),
                    ),
              ),
            ),
            Expanded(
              child: Align(
                alignment:
                    spaceBetween ? Alignment.centerRight : Alignment.center,
                child: rightButton ??
                    FlatButton(
                      padding: padding,
                      shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(Constants.smallBorderRadius),
                      ),
                      onPressed: rightButtonAction,
                      child: Text(
                        _rightButtonString,
                        style: Get.textTheme.bodyText1.copyWith(
                          color: Get.theme.primaryColor,
                          fontWeight: FontWeight.bold,
                        ),
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
