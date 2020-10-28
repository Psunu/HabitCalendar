import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:habit_calendar/constants/constants.dart';
import 'package:habit_calendar/controllers/manage_habit_controller.dart';
import 'package:reorderables/reorderables.dart';

import '../widgets/general_purpose/auto_colored_icon.dart';
import '../widgets/general_purpose/auto_colored_text.dart';
import '../widgets/project_purpose/group_card.dart';

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
            child: CustomScrollView(
              physics: BouncingScrollPhysics(),
              slivers: [
                ReorderableSliverList(
                  delegate: ReorderableSliverChildBuilderDelegate(
                    (context, index) {
                      final group = controller.groups[index];

                      return Padding(
                        key: ValueKey(group.id),
                        padding: const EdgeInsets.only(bottom: 8.0),
                        child: GroupCard(
                          group: group,
                          habits: controller.habits,
                          colorCircleSize: 20.0,
                          height: 70.0,
                          latestPadding: controller.latestPaddingOf(group.id),
                          isSelected: controller.isSelected(group.id),
                          onHabitTapped: controller.onHabitTapped,
                          isEditMode: controller.isEditMode.value,
                          onLongPress: controller.onLongPress,
                          onTapAfterLongPress: controller.onTapAfterLongPress,
                          onPaddingChanged: controller.onPaddingChanged,
                        ),
                      );
                    },
                    childCount: controller.groups.length,
                  ),
                  onReorder: (int oldIndex, int newIndex) {
                    var group;
                    group = controller.groups.removeAt(oldIndex);
                    controller.groups.insert(newIndex, group);
                  },
                  buildDraggableFeedback: (context, constraints, widget) {
                    return Container(
                      width: constraints.maxWidth,
                      child: widget,
                    );
                  },
                  needsLongPressDraggable: !controller.isEditMode.value,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
