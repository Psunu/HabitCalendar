import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:habit_calendar/widgets/duration_picker.dart';
import 'package:habit_calendar/widgets/time_picker.dart';

import '../controllers/make_habit_controller.dart';

// TODO Check not null variable is filled
// TODO implment group select
class MakeHabit extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetX<MakeHabitController>(
      init: MakeHabitController(),
      builder: (controller) => SafeArea(
        child: Scaffold(
          appBar: AppBar(
            iconTheme: IconThemeData(color: Colors.black87),
            textTheme: Get.textTheme,
            backgroundColor: Get.theme.scaffoldBackgroundColor,
            elevation: 0.0,
            actions: [
              FlatButton(
                onPressed: () {
                  controller.save();
                  Get.back();
                },
                child: Text('저장'),
              ),
            ],
          ),
          body: SingleChildScrollView(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Column(
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
                          style: Get.textTheme.headline4,
                        ),
                      ),
                      InkWell(
                        customBorder: const CircleBorder(),
                        child: Container(
                          width: 36,
                          height: 36,
                          decoration: BoxDecoration(
                            border:
                                Border.all(color: Colors.grey[400], width: 1.5),
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
                  _buildIconText(
                    iconData: Icons.access_time,
                    text: controller.whatTimeString,
                    isActivated: controller.isWhatTimeActivated,
                    onTap: () {
                      if (controller.isWhatTimeActivated.value) {
                        _customShowModalBottomSheet(
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
                  _buildIconText(
                    iconData: Icons.notifications,
                    text: controller.notificationTimeString,
                    isActivated: controller.isNotificationActivated,
                    onTap: () {
                      if (controller.isNotificationActivated.value) {
                        _customShowModalBottomSheet(
                          builder: (context) {
                            return Padding(
                              padding: const EdgeInsets.all(30.0),
                              child: DurationPicker(
                                height: 200.0,
                                style: Get.textTheme.headline5,
                                initDuration: controller.notificationTime.value,
                                onDurationChanged: (duration) {
                                  controller.notificationTime.value = duration;
                                },
                              ),
                            );
                          },
                        );
                      }
                    },
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 20.0),
                    child: Row(
                      children: [
                        InkWell(
                          customBorder: const CircleBorder(),
                          onTap: () {
                            controller.isDescriptionActivated.value =
                                !controller.isDescriptionActivated.value;
                          },
                          child: Icon(
                            Icons.description,
                            size: 48.0,
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
                            enabled: controller.isDescriptionActivated.value,
                            controller: controller.descriptionController,
                            keyboardType: TextInputType.text,
                            style: Get.textTheme.headline5,
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

  Widget _buildIconText({
    @required IconData iconData,
    @required String text,
    @required RxBool isActivated,
    @required void Function() onTap,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20.0),
      child: Row(
        children: [
          InkWell(
            customBorder: const CircleBorder(),
            onTap: () {
              isActivated.value = !isActivated.value;
              onTap();
            },
            child: Icon(
              iconData,
              size: 48.0,
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
              },
              child: Text(
                text,
                style: Get.textTheme.headline5.copyWith(
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

  Future<T> _customShowModalBottomSheet<T>(
      {@required void Function(BuildContext) builder}) {
    return showModalBottomSheet<T>(
      context: Get.context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(15.0),
          topRight: Radius.circular(15.0),
        ),
      ),
      builder: builder,
    );
  }
}
