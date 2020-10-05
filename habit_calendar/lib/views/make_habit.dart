import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:habit_calendar/widgets/duration_picker.dart';
import 'package:habit_calendar/widgets/time_picker.dart';

import '../controllers/make_habit_controller.dart';

// TODO implment group select
class MakeHabit extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetX<MakeHabitController>(
      init: MakeHabitController(),
      builder: (controller) => SafeArea(
        child: Scaffold(
          body: SingleChildScrollView(
            child: Container(
              padding: const EdgeInsets.only(
                left: 35.0,
                right: 35.0,
                top: 45.0,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: controller.nameController,
                              decoration: InputDecoration(
                                hintText: '습관 이름',
                                border: InputBorder.none,
                              ),
                              style: Get.textTheme.headline5,
                            ),
                          ),
                          InkWell(
                            customBorder: const CircleBorder(),
                            child: Container(
                              width: 36,
                              height: 36,
                              decoration: BoxDecoration(
                                border: Border.all(
                                    color: Colors.grey[400], width: 1.5),
                                color: Colors.white,
                                shape: BoxShape.circle,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 20.0,
                      ),
                      SizedBox(
                        height: 25.0,
                        child: Text(controller.selectedWeeksString),
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
                      controller.buildIconText(
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
                      controller.buildIconText(
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
                      Padding(
                        padding: EdgeInsets.symmetric(
                          vertical: controller.iconTextPadding,
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(top: 8.0),
                              child: Icon(
                                Icons.description,
                                size: controller.iconSize,
                                color: controller.isDescriptionActivated.value
                                    ? Get.theme.accentColor
                                    : Colors.grey[400],
                              ),
                            ),
                            SizedBox(
                              width: 30.0,
                            ),
                            Expanded(
                              child: TextField(
                                controller: controller.descriptionController,
                                keyboardType: TextInputType.text,
                                style: Get.textTheme.headline6,
                                maxLines: null,
                                decoration: InputDecoration(
                                  hintText: '메모',
                                  hintStyle: Get.textTheme.headline6.copyWith(
                                    color: Colors.grey,
                                  ),
                                  border: InputBorder.none,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  Builder(
                    builder: (context) => ButtonBar(
                      alignment: MainAxisAlignment.spaceAround,
                      children: [
                        FlatButton(
                          onPressed: () => Get.back(),
                          child: Text(
                            '취소',
                            style: Get.textTheme.headline6,
                          ),
                        ),
                        FlatButton(
                          onPressed: () {
                            controller.save();
                          },
                          child: Text(
                            '저장',
                            style: Get.textTheme.headline6,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
