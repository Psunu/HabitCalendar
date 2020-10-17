import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:habit_calendar/constants/constants.dart';
import 'package:habit_calendar/widgets/duration_picker.dart';
import 'package:habit_calendar/widgets/group_circle.dart';
import 'package:habit_calendar/widgets/icon_text.dart';
import 'package:habit_calendar/widgets/time_picker.dart';

import '../controllers/make_habit_controller.dart';

class MakeHabit extends StatefulWidget {
  @override
  _MakeHabitState createState() => _MakeHabitState();
}

class _MakeHabitState extends State<MakeHabit> with TickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    return GetX<MakeHabitController>(
      init: MakeHabitController(),
      builder: (controller) => SafeArea(
        child: Stack(
          children: [
            Scaffold(
              body: SingleChildScrollView(
                child: Container(
                  padding: const EdgeInsets.all(
                    Constants.padding,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              // Name
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    AnimatedSize(
                                      vsync: this,
                                      duration: const Duration(
                                        milliseconds:
                                            Constants.smallAnimationSpeed,
                                      ),
                                      child: Row(
                                        children: [
                                          Icon(
                                            Icons.error_outline,
                                            size: controller.isNameAlertOn
                                                ? 17.0
                                                : 0.0,
                                            color: Colors.red,
                                          ),
                                          SizedBox(
                                            width: 5.0,
                                          ),
                                          Text(
                                            controller.nameErrorString,
                                            style: Get.textTheme.bodyText2
                                                .copyWith(
                                              fontSize: controller.isNameAlertOn
                                                  ? Get.textTheme.bodyText2
                                                      .fontSize
                                                  : 0.0,
                                              color: Colors.red,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    TextField(
                                      controller: controller.nameController,
                                      focusNode: controller.nameFocusNode,
                                      decoration: InputDecoration(
                                        hintText: '습관 이름',
                                        border: InputBorder.none,
                                      ),
                                      style: Get.textTheme.headline5,
                                      onTap: () {
                                        controller.isNameEmptyAlertOn.value =
                                            false;
                                        controller.isNameDuplicatedAlertOn
                                            .value = false;
                                      },
                                    ),
                                  ],
                                ),
                              ),
                              // Group
                              PopupMenuButton<int>(
                                itemBuilder: controller.popupMenuEntryBuilder,
                                onCanceled: () => Get.focusScope.unfocus(),
                                onSelected: (_) => Get.focusScope.unfocus(),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(
                                    Constants.smallBorderRadius,
                                  ),
                                ),
                                child: GroupCircle(
                                  color: Color(
                                    controller?.selectedGroup?.value?.color ??
                                        Colors.white.value,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 20.0,
                          ),
                          // Weeks
                          SizedBox(
                            height: 25.0,
                            child: Row(
                              children: [
                                AnimatedSize(
                                  vsync: this,
                                  duration: const Duration(
                                    milliseconds: Constants.smallAnimationSpeed,
                                  ),
                                  child: Padding(
                                    padding: EdgeInsets.only(
                                      right: controller.isWeeksAlertOn.value
                                          ? 5.0
                                          : 0.0,
                                    ),
                                    child: Icon(
                                      Icons.error_outline,
                                      size: controller.isWeeksAlertOn.value
                                          ? 17.0
                                          : 0.0,
                                      color: Colors.red,
                                    ),
                                  ),
                                ),
                                Text(
                                  controller.selectedWeeksString,
                                  style: controller.isWeeksAlertOn.value
                                      ? Get.textTheme.bodyText2.copyWith(
                                          color: Colors.red,
                                        )
                                      : Get.textTheme.bodyText2,
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: controller.weekCardHeight * 1.3,
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: controller.buildWeekTiles(7),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 20.0),
                            child: Divider(),
                          ),
                          // WhatTime
                          IconText(
                            iconData: Icons.access_time,
                            text: controller.whatTimeString,
                            isActivated: controller.isWhatTimeActivated,
                            onTap: () {
                              if (controller.isWhatTimeActivated.value) {
                                controller.customShowModalBottomSheet(
                                  builder: (context) {
                                    return Padding(
                                      padding: const EdgeInsets.all(30.0),
                                      child: TimePicker(
                                        ampmStyle: Get.textTheme.bodyText1,
                                        timeStyle: Get.textTheme.headline5,
                                        initTime: controller.whatTime.value,
                                        height: 200.0,
                                        onTimeChanged: (time) {
                                          controller.whatTime.value = time;
                                        },
                                      ),
                                    );
                                  },
                                );
                              }
                            },
                          ),
                          // Notification time
                          IconText(
                            iconData: Icons.notifications,
                            text: controller.notificationTimeString,
                            isActivated: controller.isNotificationActivated,
                            onTap: () {
                              if (controller.isNotificationActivated.value) {
                                controller.customShowModalBottomSheet(
                                  builder: (context) {
                                    return Padding(
                                      padding: const EdgeInsets.all(30.0),
                                      child: DurationPicker(
                                        height: 200.0,
                                        durationStyle: Get.textTheme.headline5,
                                        tagStyle: Get.textTheme.bodyText1,
                                        initDuration:
                                            controller.notificationTime.value,
                                        onDurationChanged: (duration) {
                                          controller.notificationTime.value =
                                              duration;
                                        },
                                      ),
                                    );
                                  },
                                );
                              }
                            },
                          ),
                          // Description
                          Padding(
                            padding: EdgeInsets.symmetric(
                              vertical: controller.iconTextPadding,
                            ),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(top: 8.0),
                                  child: InkWell(
                                    customBorder: const CircleBorder(),
                                    onTap: () {
                                      controller.isDescriptionActivated.value =
                                          !controller
                                              .isDescriptionActivated.value;
                                      if (controller
                                          .isDescriptionActivated.value) {
                                        Get.focusScope.requestFocus(
                                            controller.descriptionFocusNode);
                                      } else {
                                        Get.focusScope.unfocus();
                                      }
                                    },
                                    child: Icon(
                                      Icons.description,
                                      size: controller.iconSize,
                                      color: controller
                                              .isDescriptionActivated.value
                                          ? Get.theme.accentColor
                                          : Colors.grey[400],
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: 30.0,
                                ),
                                Expanded(
                                  child: TextField(
                                    controller:
                                        controller.descriptionController,
                                    focusNode: controller.descriptionFocusNode,
                                    keyboardType: TextInputType.text,
                                    style:
                                        controller.isDescriptionActivated.value
                                            ? Get.textTheme.headline6
                                            : Get.textTheme.headline6.copyWith(
                                                color: Colors.grey,
                                              ),
                                    maxLines: null,
                                    decoration: InputDecoration(
                                      hintText: '메모',
                                      hintStyle:
                                          Get.textTheme.headline6.copyWith(
                                        color: Colors.grey,
                                      ),
                                      border: InputBorder.none,
                                    ),
                                    onChanged: (text) {
                                      if (text.isEmpty)
                                        controller.isDescriptionActivated
                                            .value = false;
                                      else if (!controller
                                          .isDescriptionActivated.value)
                                        controller.isDescriptionActivated
                                            .value = true;
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
            // Cancel and Save button
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                color: Get.theme.scaffoldBackgroundColor,
                child: Padding(
                  padding: EdgeInsets.all(20.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Expanded(
                        child: FlatButton(
                          padding: const EdgeInsets.all(13.0),
                          onPressed: () => Get.back(),
                          child: Text(
                            '취소',
                            style: Get.textTheme.headline6
                                .copyWith(color: Colors.grey[700]),
                          ),
                        ),
                      ),
                      Expanded(
                        child: RaisedButton(
                          padding: const EdgeInsets.all(13.0),
                          color: Get.theme.accentColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                                Constants.mediumBorderRadius),
                          ),
                          onPressed: controller.save,
                          child: Text(
                            '저장',
                            style: Get.textTheme.headline6.copyWith(
                                color: Get.theme.scaffoldBackgroundColor),
                          ),
                        ),
                      ),
                    ],
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
