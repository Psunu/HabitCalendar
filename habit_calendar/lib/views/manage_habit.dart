import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:habit_calendar/constants/constants.dart';
import 'package:habit_calendar/controllers/manage_habit_controller.dart';
import 'package:habit_calendar/services/database/app_database.dart';
import 'package:habit_calendar/widgets/group_card.dart';
import 'package:habit_calendar/widgets/group_circle.dart';

const _kCardHeight = 90.0;
const _kGroupCircleSize = 20.0;

class ManageHabit extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetX<ManageHabitController>(
      init: ManageHabitController(),
      builder: (controller) => Scaffold(
        appBar: AppBar(
          backgroundColor: Get.theme.scaffoldBackgroundColor,
          elevation: 0.0,
          centerTitle: true,
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back,
              color: Get.textTheme.bodyText1.color,
            ),
            onPressed: () => Get.back(),
          ),
          title: Text(
            'GROUPS',
            style: Get.textTheme.bodyText1,
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {},
          child: Icon(Icons.add),
        ),
        body: Container(
          padding: const EdgeInsets.only(
            top: Constants.padding,
            bottom: Constants.padding + 40.0,
            left: Constants.padding,
            right: Constants.padding,
          ),
          child: ListView.builder(
            itemCount: controller.groups.length,
            itemBuilder: (context, index) {
              final group = controller.groups[index];

              return GroupCard(
                groupName: Text(
                  group.name,
                  style: Get.textTheme.headline6,
                ),
                numGroupMembers: Text(
                  controller.numGroupMembers(group.id).toString(),
                  style: Get.textTheme.bodyText1,
                ),
                groupMembers: controller.groupMembers(group.id),
                color: Color(group.color),
                colorCircleSize: _kGroupCircleSize,
                height: _kCardHeight,
              );
            },
          ),
        ),
      ),
    );
  }
}
