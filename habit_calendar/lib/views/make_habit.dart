import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:habit_calendar/widgets/time_picker.dart';

import '../controllers/make_habit_controller.dart';

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
            title: Text('습관 만들기'),
            backgroundColor: Get.theme.scaffoldBackgroundColor,
            elevation: 0.0,
            actions: [
              FlatButton(onPressed: controller.save, child: Text('저장')),
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
                          style: Get.textTheme.headline4
                              .copyWith(color: Colors.black87),
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
                  // Row(
                  //   children: [
                  //     Padding(
                  //       padding: const EdgeInsets.symmetric(horizontal: 3.0),
                  //       child: InputChip(
                  //         label: Text('언제'),
                  //         padding: EdgeInsets.all(10.0),
                  //         onPressed: () {},
                  //       ),
                  //     ),
                  //     Padding(
                  //       padding: const EdgeInsets.symmetric(horizontal: 3.0),
                  //       child: InputChip(
                  //         label: Text('알림'),
                  //         padding: EdgeInsets.all(10.0),
                  //         onPressed: () {},
                  //       ),
                  //     ),
                  //     Padding(
                  //       padding: const EdgeInsets.symmetric(horizontal: 3.0),
                  //       child: InputChip(
                  //         label: Text('설명'),
                  //         padding: EdgeInsets.all(10.0),
                  //         onPressed: () {},
                  //       ),
                  //     ),
                  //   ],
                  // ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10.0),
                    child: InkWell(
                      customBorder: const CircleBorder(),
                      onTap: () {
                        controller.whatTimeActivated.value =
                            !controller.whatTimeActivated.value;
                        if (controller.whatTimeActivated.value)
                          showModalBottomSheet(
                            context: context,
                            builder: (context) {
                              return TimePicker();
                            },
                          );
                      },
                      child: Icon(
                        Icons.access_time,
                        size: 50.0,
                        color: controller.whatTimeActivated.value
                            ? Get.theme.accentColor
                            : Colors.grey[400],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10.0),
                    child: InkWell(
                      customBorder: const CircleBorder(),
                      onTap: () => controller.notificationActivated.value =
                          !controller.notificationActivated.value,
                      child: Icon(
                        Icons.notifications,
                        size: 50.0,
                        color: controller.notificationActivated.value
                            ? Get.theme.accentColor
                            : Colors.grey[400],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10.0),
                    child: InkWell(
                      customBorder: const CircleBorder(),
                      onTap: () => controller.descriptionActivated.value =
                          !controller.descriptionActivated.value,
                      child: Icon(
                        Icons.description,
                        size: 50.0,
                        color: controller.descriptionActivated.value
                            ? Get.theme.accentColor
                            : Colors.grey[400],
                      ),
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
