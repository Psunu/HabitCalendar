import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:habit_calendar/constants/constants.dart';
import 'package:habit_calendar/controllers/manage_habit_controller.dart';
import 'package:habit_calendar/widgets/group_circle.dart';

const _kCardHeight = 90.0;
const _kGroupCircleSize = 20.0;

class ManageHabit extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetX<ManageHabitController>(
      init: ManageHabitController(),
      builder: (controller) => Scaffold(
        body: Container(
          padding: const EdgeInsets.only(
            top: Constants.padding,
            bottom: Constants.padding + 40.0,
            left: Constants.padding,
            right: Constants.padding,
          ),
          child: ListView.builder(
            itemCount: controller.groups.length + 1,
            itemBuilder: (context, index) {
              if (index == 0) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Stack(
                      alignment: Alignment.centerLeft,
                      children: [
                        InkWell(
                          onTap: () => Get.back(),
                          child: Icon(
                            Icons.arrow_back,
                            // color: Get.theme.accentColor,
                          ),
                        ),
                        Center(
                          child: Text(
                            'GROUPS',
                            style: Get.textTheme.bodyText1,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: Constants.padding,
                    ),
                  ],
                );
              }

              final group = controller.groups[index - 1];

              return Card(
                margin: const EdgeInsets.all(0.0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(
                    Constants.mediumBorderRadius,
                  ),
                ),
                child: Container(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 15.0,
                  ),
                  width: Get.context.width,
                  height: _kCardHeight,
                  child: Stack(
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(
                            width: 40.0,
                          ),
                          Text(
                            group.name,
                            style: Get.textTheme.headline6,
                          ),
                          Expanded(
                            child: Align(
                              alignment: Alignment.centerRight,
                              child: Text(
                                controller.numGroupMembers(group.id).toString(),
                                style: Get.textTheme.bodyText1,
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 10.0,
                          ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: GroupCircle(
                          color: Color(
                            group.color,
                          ),
                          height: _kGroupCircleSize,
                          width: _kGroupCircleSize,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
