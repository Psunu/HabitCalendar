import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:habit_calendar/constants/constants.dart';
import 'package:habit_calendar/controllers/manage_habit_controller.dart';
import 'package:habit_calendar/widgets/auto_colored_icon.dart';
import 'package:habit_calendar/widgets/auto_colored_text.dart';
import 'package:habit_calendar/widgets/reorderable.dart';
import 'package:habit_calendar/widgets/group_card.dart';

class ManageHabit extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetX<ManageHabitController>(
      init: ManageHabitController(),
      builder: (controller) => WillPopScope(
        onWillPop: controller.onWillPop,
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Get.theme.scaffoldBackgroundColor,
            elevation: 0.0,
            centerTitle: true,
            leading: IconButton(
              icon: AutoColoredIcon(
                backgroundColor: Get.theme.scaffoldBackgroundColor,
                child: Icon(
                  Icons.arrow_back,
                  color: Get.textTheme.bodyText1.color,
                ),
              ),
              onPressed: () => Get.back(),
            ),
            actions: [
              controller.isEditMode.value
                  ? IconButton(
                      icon: AutoColoredIcon(
                        backgroundColor: Get.theme.scaffoldBackgroundColor,
                        child: Icon(
                          Icons.clear,
                          color: Get.textTheme.bodyText1.color,
                        ),
                      ),
                      onPressed: () async {
                        await controller.onWillPop();
                      },
                    )
                  : Container(),
            ],
            title: AutoColoredText(
              backgroundColor: Get.theme.scaffoldBackgroundColor,
              child: Text(
                '폴더'.tr.capitalizeFirst,
                style: Get.textTheme.headline6,
              ),
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
              // enableOneDraggable: true,
              // selectedKey: controller.selectedGroupKey.value,
              // onReorder: (oldIndex, newIndex) {},
              children: List.generate(
                controller.groups.length,
                (index) {
                  final group = controller.groups[index];

                  return Reorderable(
                    // enabled: group.id == controller.selectedGroupId.value,
                    data: group.id,
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: GroupCard(
                        group: group,
                        habits: controller.habits,
                        colorCircleSize: 20.0,
                        height: 70.0,
                        // isSelected:
                        // controller.selectedGroups[group.id] ?? false,
                        onHabitTapped: controller.onHabitTapped,
                        isEditMode: controller.isEditMode.value,
                        // selectedGroupId: controller.selectedGroupId.value,
                        onLongPress: (groupId, isSelected) {
                          controller.isEditMode.value = true;
                          // controller.selectedGroups[groupId] = isSelected;
                        },
                        onTapAfterLongPress: (groupId, isSelected) {
                          // controller.selectedGroups[groupId] = isSelected;
                        },
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}
