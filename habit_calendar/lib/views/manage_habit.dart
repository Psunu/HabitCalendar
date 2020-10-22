import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:habit_calendar/constants/constants.dart';
import 'package:habit_calendar/controllers/manage_habit_controller.dart';
import 'package:habit_calendar/widgets/group_card.dart';

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
            '폴더'.tr.capitalizeFirst,
            style: Get.textTheme.headline6,
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: controller.onAddGroupTapped,
          child: Icon(Icons.add),
        ),
        body: Container(
          padding: const EdgeInsets.only(
            top: Constants.padding,
            bottom: Constants.padding + 50.0,
            left: Constants.padding,
            right: Constants.padding,
          ),

          /// ListView.builder doesn't update as soon as habits list updated.
          /// The solution is just use ListView
          child: ListView(
            physics: BouncingScrollPhysics(),
            children: List.generate(
              controller.groups.length,
              (index) {
                final group = controller.groups[index];
                final groupMembers = controller.groupMembers(group.id);

                return Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: GroupCard(
                    groupName: Text(
                      group.name,
                      style: Get.textTheme.headline6,
                    ),
                    numGroupMembers: Text(
                      groupMembers.length.toString(),
                      style: Get.textTheme.bodyText1,
                    ),
                    groupMembers: groupMembers,
                    color: Color(group.color),
                    colorCircleSize: 20.0,
                    height: 70.0,
                    onHabitTapped: controller.onHabitTapped,
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
