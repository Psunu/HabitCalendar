import 'package:flutter/material.dart';
import 'package:flutter_reorderable_list/flutter_reorderable_list.dart';
import 'package:get/get.dart';
import 'package:habit_calendar/constants/constants.dart';
import 'package:habit_calendar/services/database/app_database.dart';
import 'package:habit_calendar/services/database/db_service.dart';
import 'package:habit_calendar/utils/utils.dart';
import 'package:habit_calendar/widgets/project_purpose/group_maker.dart';
import 'package:habit_calendar/widgets/project_purpose/habit_info_widget.dart';

const _kIconSize = 22.0;

enum _PopupItemType {
  delete,
}

class GroupCardInfo {
  GroupCardInfo(this.groupId, this.latestPadding, this.isSelected);

  int groupId;
  double latestPadding;
  bool isSelected;
}

class ManageHabitController extends GetxController {
  final groups = List<Group>().obs;
  final habits = List<Habit>().obs;
  final weeks = List<HabitWeek>().obs;
  final isEditMode = false.obs;
  // key : group id / value : isSelected
  final selectedGroups = Map<int, bool>().obs;

  final DbService _dbService = Get.find<DbService>();

  bool _deleteHabit = false;
  Habit _habitBeforeDelete;

  int get numSelectedGroup {
    int selected = 0;

    selectedGroups.forEach((groupId, isSelected) {
      if (isSelected) selected += 1;
    });

    return selected;
  }

  // Controller life cycle
  @override
  void onInit() {
    groups.bindStream(_dbService.database.groupDao.watchAllGroups());
    habits.bindStream(_dbService.database.habitDao.watchAllHabits());
    weeks.bindStream(_dbService.database.habitWeekDao.watchAllHabitWeeks());

    /// Clear selectedGroup when longPress mode end
    /// if skip clearing selectedGroup, then same selectedGroup will be used
    /// next longPress mode
    isEditMode.listen((value) {
      if (!value) {
        selectedGroups.value = Map<int, bool>();
      }
    });

    selectedGroups.listen((value) {
      print('selectedGroup : ' + value.toString());
    });

    super.onInit();
  }

  @override
  void onClose() {
    super.onClose();
  }

  // Primary methods
  Future<void> saveHabit(Habit habit, List<HabitWeek> changedWeeks) async {
    print(await _dbService.database.habitDao.updateHabit(habit));

    weeks
        .where((element) => element?.habitId == habit.id)
        .forEach((element) async {
      await _dbService.database.habitWeekDao.deleteHabitWeek(element);
    });
    changedWeeks.forEach((element) async {
      await _dbService.database.habitWeekDao.insertHabitWeek(element);
    });

    Get.back();
  }

  void onAddGroupTapped() {
    Utils.customShowModal(
      builder: (context) => GroupMaker(
        groups: groups,
        habits: habits,
        onSave: (group, includedHabits) async {
          final groupId = await _dbService.database.groupDao.insertGroup(group);
          includedHabits.forEach((habitId) async {
            await _dbService.database.habitDao.updateHabit(habits
                .singleWhere((element) => element.id == habitId)
                .copyWith(groupId: groupId));
          });
        },
      ),
    );
  }

  void onEditGroupTapped() {
    isEditMode.value = false;

    int selectedGroupId;
    selectedGroups.forEach((groupId, isSelected) {
      if (isSelected) selectedGroupId = groupId;
    });

    Utils.customShowModal(
      builder: (context) => GroupMaker(
        selectedGroup: groups.singleWhere(
          (group) => group.id == selectedGroupId,
          orElse: null,
        ),
        groups: groups,
        habits: habits,
        onSave: (group, includedHabitIds) async {
          // Move unselected habits to default folder
          final orgHabits = habits.where((habit) => habit?.groupId == group.id);
          orgHabits.forEach((element) async {
            if (!includedHabitIds.contains(element.id)) {
              await _dbService.database.habitDao
                  .updateHabit(element.copyWith(groupId: 0));
            }
          });

          // Update group
          await _dbService.database.groupDao.updateGroup(group);

          // Move selected habits to this group
          includedHabitIds.forEach((habitId) async {
            await _dbService.database.habitDao.updateHabit(habits
                .singleWhere((element) => element.id == habitId)
                .copyWith(groupId: group.id));
          });
        },
      ),
    );
  }

  void onHabitTapped(int habitId) {
    Utils.customShowModal(
      builder: (context) => HabitInfoWidget(
        habit: habits.singleWhere((habit) => habit?.id == habitId),
        habits: habits,
        groups: groups,
        weeks: weeks,
        onSave: saveHabit,
        actions: [
          Material(
            type: MaterialType.transparency,
            child: PopupMenuButton<_PopupItemType>(
              itemBuilder: (context) => <PopupMenuEntry<_PopupItemType>>[
                PopupMenuItem<_PopupItemType>(
                  value: _PopupItemType.delete,
                  child: Text(
                    '삭제'.tr.capitalizeFirst,
                    style: Get.textTheme.bodyText2,
                  ),
                )
              ],
              onSelected: (type) {
                switch (type) {
                  case _PopupItemType.delete:
                    Get.back();

                    beforeDeleteHabit(habitId);
                    Get.rawSnackbar(
                      message: '삭제되었습니다',
                      mainButton: FlatButton(
                        onPressed: () {
                          _deleteHabit = false;
                          Get.back();
                          habits.add(_habitBeforeDelete);
                        },
                        child: Text(
                          '되돌리기',
                          style: Get.textTheme.bodyText2
                              .copyWith(color: Colors.white),
                        ),
                      ),
                      snackbarStatus: (status) {
                        if (status == SnackbarStatus.OPEN) {
                          _deleteHabit = true;
                        }
                        if (status == SnackbarStatus.CLOSED && _deleteHabit) {
                          deleteHabit(habitId);
                        }
                        _habitBeforeDelete = null;
                      },
                    );

                    break;
                }
              },
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(
                  Constants.smallBorderRadius,
                ),
              ),
              child: Icon(
                Icons.more_vert,
                size: _kIconSize,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void beforeDeleteHabit(int habitId) {
    _habitBeforeDelete = habits.singleWhere((habit) => habit.id == habitId);
    habits.removeWhere((habit) => habit.id == habitId);
  }

  void deleteHabit(int habitId) {
    _dbService.database.habitDao.deleteHabitById(habitId);
  }

  void onDeleteTapped() {
    List<int> groupIds = List<int>();

    selectedGroups.forEach((groupId, isSelected) {
      // Prevent to delete default folder
      if (groupId == 0) return;

      if (isSelected) {
        groupIds.add(groupId);
      }
    });

    _dbService.database.groupDao.deleteAllGroupsById(groupIds);
  }

  void onAcceptHabit(int habitId, int groupId) async {
    final habit = habits.singleWhere(
      (habit) => habit?.id == habitId,
      orElse: () => null,
    );

    if (habit == null) return;

    await _dbService.database.habitDao.updateHabit(
      habit.copyWith(groupId: groupId),
    );
  }

  // Reorder methods
  // Returns index of item with given key
  int _indexOfKey(Key key) {
    int groupId = (key as ValueKey<int>).value;
    return groups.indexWhere((group) => group.id == groupId);
  }

  bool reorderCallback(Key item, Key newPosition) {
    int draggingIndex = _indexOfKey(item);
    int newPositionIndex = _indexOfKey(newPosition);

    // Uncomment to allow only even target reorder possition
    // if (newPositionIndex % 2 == 1)
    //   return false;

    final draggedItem = groups[draggingIndex];

    print("Reordering $item -> $newPosition");
    groups.removeAt(draggingIndex);
    groups.insert(newPositionIndex, draggedItem);

    return true;
  }

  void reorderDone(Key item) async {
    // Update IndexGroups table if reordered
    final dbGroups = await _dbService.database.groupDao.getAllGroups();
    List<IndexGroup> needUpdate = List<IndexGroup>();

    for (int i = 0; i < groups.length; i++) {
      if (groups[i].id != dbGroups[i].id) {
        needUpdate.add(IndexGroup(groupId: groups[i].id, indx: i));
      }
    }

    await _dbService.database.indexGroupDao.updateAllIndexGroups(needUpdate);

    needUpdate.forEach((element) {
      print('Reordering finished for ${element.groupId} - ${element.indx}');
    });
  }

  Widget buildReorderItemChild(
    Widget child,
    BuildContext context,
    ReorderableItemState state,
  ) {
    if (state == ReorderableItemState.dragProxy ||
        state == ReorderableItemState.dragProxyFinished) {
      // slightly transparent when it dragged
      return Opacity(
        opacity: 0.3,
        child: child,
      );
    }

    return child;
  }

  // GroupCard methods
  void onLongPress(int groupId, bool isSelected) {
    isEditMode.value = true;
    selectedGroups[groupId] = isSelected;
  }

  void onTapAfterLongPress(int groupId, bool isSelected) {
    selectedGroups[groupId] = isSelected;
  }

  List<Habit> groupMembersOf(int groupId) {
    return habits.where((habit) => habit?.groupId == groupId).toList();
  }

  // Utility methods
  Future<bool> onWillPop() async {
    if (isEditMode.value) {
      isEditMode.value = false;
      return false;
    }

    return true;
  }

  int numGroupMembers(int groupId) =>
      habits.where((habit) => habit?.groupId == groupId).length;
  List<Habit> groupMembers(int groupId) =>
      habits.where((habit) => habit?.groupId == groupId).toList();
}
