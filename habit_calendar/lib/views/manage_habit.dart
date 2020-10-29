import 'package:flutter/material.dart';
import 'package:flutter_reorderable_list/flutter_reorderable_list.dart';
import 'package:get/get.dart';
import 'package:habit_calendar/constants/constants.dart';
import 'package:habit_calendar/controllers/manage_habit_controller.dart';

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
            ),
            child: ReorderableList(
              onReorder: controller.reorderCallback,
              onReorderDone: controller.reorderDone,
              decoratePlaceholder: (widget, opacity) {
                return DecoratedPlaceholder(widget: widget, offset: 0.0);
              },
              child: ListView.builder(
                physics: BouncingScrollPhysics(),
                itemCount: controller.groups.length,
                itemBuilder: (context, index) {
                  final group = controller.groups[index];

                  return ReorderableItem(
                    key: ValueKey(group.id),
                    childBuilder: (context, state) {
                      return controller.buildReorderItemChild(
                        /// To reflect controller.habits changes use Obx
                        /// Maybe because it is returned from builder.
                        /// it is at out of GetX Widget.
                        /// so it can't listen to controller's Rx property
                        Obx(() => Padding(
                              key: ValueKey(group.id),
                              padding: const EdgeInsets.fromLTRB(
                                Constants.padding,
                                0.0,
                                Constants.padding,
                                8.0,
                              ),
                              child: GroupCard(
                                group: group,
                                memberHabits: controller.groupMembersOf(
                                  group.id,
                                ),
                                colorCircleSize: 20.0,
                                height: 70.0,
                                editModeAction: ReorderableListener(
                                  child: Center(
                                    child: Icon(Icons.reorder),
                                  ),
                                ),
                                isSelected:
                                    controller.selectedGroups[group.id] ??
                                        false,
                                onHabitTapped: controller.onHabitTapped,
                                isEditMode: controller.isEditMode.value,
                                onLongPress: controller.onLongPress,
                                onTapAfterLongPress:
                                    controller.onTapAfterLongPress,
                              ),
                            )),
                        context,
                        state,
                      );
                    },
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
