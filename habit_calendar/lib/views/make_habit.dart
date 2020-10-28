import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:habit_calendar/constants/constants.dart';
import 'package:habit_calendar/widgets/bottom_buttons.dart';
import 'package:habit_calendar/widgets/duration_picker.dart';
import 'package:habit_calendar/widgets/group_popup_menu.dart';
import 'package:habit_calendar/widgets/icon_text.dart';
import 'package:habit_calendar/widgets/time_picker.dart';

import '../controllers/make_habit_controller.dart';

const _kIconTextPadding = 20.0;

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
              body: ScrollConfiguration(
                behavior: ScrollBehavior(),
                child: SingleChildScrollView(
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
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
                                                  ? Get.textTheme.headline5
                                                          .fontSize *
                                                      0.45
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
                                                fontSize:
                                                    controller.isNameAlertOn
                                                        ? Get
                                                                .textTheme
                                                                .headline5
                                                                .fontSize *
                                                            0.45
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
                                          hintText: '습관'.tr.capitalizeFirst +
                                              ' ' +
                                              '이름'.tr,
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
                                GroupPopupMenu(
                                  groups: controller.groups,
                                  onSelected: (groupId) {
                                    controller.selectedGroup.value =
                                        controller.groups.singleWhere(
                                            (element) => element.id == groupId);
                                    Get.focusScope.unfocus();
                                  },
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
                                      milliseconds:
                                          Constants.smallAnimationSpeed,
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
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: controller.buildWeekTiles(7),
                              ),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 20.0),
                              child: Divider(),
                            ),
                            // WhatTime
                            Padding(
                              padding: const EdgeInsets.only(
                                  bottom: _kIconTextPadding),
                              child: IconText(
                                icon: Icon(Icons.access_time),
                                text: Text(controller.whatTimeString),
                                initValue: controller.isWhatTimeActivated,
                                onValueChanged: (value) {
                                  controller.isWhatTimeActivated = value;
                                },
                                onTap: () {
                                  if (controller.isWhatTimeActivated) {
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
                            ),
                            // Notification time
                            Padding(
                              padding: const EdgeInsets.only(
                                  bottom: _kIconTextPadding),
                              child: IconText(
                                icon: Icon(Icons.notifications),
                                text: Text(controller.notificationTimeString),
                                initValue: controller.isNotificationActivated,
                                onValueChanged: (value) {
                                  controller.isNotificationActivated = value;
                                },
                                onTap: () {
                                  if (controller.isNotificationActivated) {
                                    controller.customShowModalBottomSheet(
                                      builder: (context) {
                                        return Padding(
                                          padding: const EdgeInsets.all(30.0),
                                          child: DurationPicker(
                                            height: 200.0,
                                            durationStyle:
                                                Get.textTheme.headline5,
                                            tagStyle: Get.textTheme.bodyText1,
                                            initDuration: controller
                                                .notificationTime.value,
                                            onDurationChanged: (duration) {
                                              controller.notificationTime
                                                  .value = duration;
                                            },
                                          ),
                                        );
                                      },
                                    );
                                  }
                                },
                              ),
                            ),
                            // Description
                            Padding(
                              padding: const EdgeInsets.only(
                                  bottom: _kIconTextPadding),
                              child: IconText.description(
                                icon: Icon(Icons.description),
                                focusNode: controller.descriptionFocusNode,
                                descriptionController:
                                    controller.descriptionController,
                                initValue: controller.isDescriptionActivated,
                                onValueChanged: (value) {
                                  controller.isDescriptionActivated = value;
                                },
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            // Cancel and Save button
            Align(
              alignment: Alignment.bottomCenter,
              child: BottomButtons(
                rightButtonAction: controller.save,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
