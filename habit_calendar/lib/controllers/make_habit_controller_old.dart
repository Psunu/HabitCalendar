import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:habit_calendar/enums/day_of_the_week.dart';
import 'package:habit_calendar/services/database/app_database.dart';
import 'package:habit_calendar/utils/utils.dart';
import 'package:habit_calendar/widgets/general/duration_picker.dart';
import 'package:habit_calendar/widgets/general/time_picker.dart';
import 'package:habit_calendar/widgets/general/week_card.dart';
import 'package:moor_flutter/moor_flutter.dart';

import '../services/database/db_service.dart';

class MakeHabitController extends GetxController {
  final _dbService = Get.find<DbService>();

  // TextField Controllers
  final nameController = TextEditingController();
  final descriptionController = TextEditingController();

  // TextField FocusNode
  final nameFocusNode = FocusNode();
  final descriptionFocusNode = FocusNode();

  // Groups variables
  final groups = List<Group>().obs;
  final selectedGroup = Rx<Group>();

  // Habits variable
  final habits = List<Habit>().obs;

  // Weeks input
  final selectedWeeks = Map<int, bool>().obs;
  int weeksLength = 7;

  // Times input
  final whatTime = DateTime(0, 0, 0, 0, 0).obs;
  final notificationTime = Duration().obs;

  // Validation alert variables
  final isNameDuplicatedAlertOn = false.obs;
  final isNameEmptyAlertOn = false.obs;
  final isWeeksAlertOn = false.obs;

  // Ativation variables
  bool isWhatTimeActivated = false;
  bool isNotificationActivated = false;
  bool isDescriptionActivated = false;

  // settings
  final weekCardHeight = 60.0;
  final iconSize = 30.0;
  final iconTextPadding = 20.0;

  // Get Set
  bool get isNameAlertOn =>
      isNameEmptyAlertOn.value || isNameDuplicatedAlertOn.value;

  String get nameErrorString => isNameEmptyAlertOn.value
      ? '습관 이름을 입력해 주세요'.tr.capitalizeFirst
      : isNameDuplicatedAlertOn.value
          ? '이미 진행중인 습관입니다'.tr.capitalizeFirst
          : '';

  String get selectedWeeksString {
    if (selectedWeeks.isEmpty) return '반복할 요일을 선택해 주세요'.tr.capitalizeFirst;

    int falses = 0;
    int trues = 0;

    String result = '매주'.tr.capitalizeFirst;

    selectedWeeks.forEach((key, value) {
      if (value) {
        result += ' ' +
            Utils.getWeekString(DayOfTheWeek.values[key]).toLowerCase() +
            ',';
        trues++;
      } else {
        falses++;
      }
    });

    if (falses == selectedWeeks.length)
      return '반복할 요일을 선택해 주세요'.tr.capitalizeFirst;
    if (trues == weeksLength) return '매일'.tr.capitalizeFirst;
    return result.replaceRange(result.length - 1, result.length, '');
  }

  String get whatTimeString => Utils.getWhatTimeString(whatTime.value);

  String get notificationTimeString =>
      Utils.getNotificationTimeString(notificationTime.value);

  // Controller life cycle
  @override
  void onInit() async {
    print('init');
    groups.bindStream(_dbService.database.groupDao.watchAllGroups());
    // when use groups variable right after bindStream() it doesn't work because of database query delay
    // so selectedGroup variable initiated by getGroupById()
    selectedGroup.value = await _dbService.database.groupDao.getGroupById(0);

    habits.bindStream(_dbService.database.habitDao.watchAllHabits());

    for (int i = 0; i < weeksLength; i++) {
      selectedWeeks[i] = false;
    }

    Get.focusScope.requestFocus(nameFocusNode);

    super.onInit();
  }

  // Primary Methods
  Future<void> save() async {
    // if name has error
    if (checkNameError()) {
      return;
    }
    if (!_isWeekSelected()) {
      print('weeks empty');
      isWeeksAlertOn.value = true;
      return;
    }

    int id = await _dbService.database.habitDao.insertHabit(
      Habit(
        id: null,
        name: nameController.text,
        groupId: selectedGroup.value.id,
        whatTime: isWhatTimeActivated ? whatTime.value : null,
        noticeTypeId: 1,
        memo: isDescriptionActivated ? descriptionController.text : null,
      ),
    );
    selectedWeeks.forEach((key, value) async {
      if (value) {
        await _dbService.database.habitWeekDao
            .insertHabitWeek(HabitWeek(habitId: id, week: key));
      }
    });

    Get.back();
  }

  void onGroupSelected(int groupId) {
    selectedGroup.value =
        groups.singleWhere((element) => element.id == groupId);
    Get.focusScope.unfocus();
  }

  void onWhatTimeValueChanged(bool value) {
    isWhatTimeActivated = value;
  }

  void onWhatTimeTapped() {
    if (isWhatTimeActivated) {
      Utils.customShowModalBottomSheet(
        builder: (context) {
          return Padding(
            padding: const EdgeInsets.all(30.0),
            child: TimePicker(
              ampmStyle: Get.textTheme.bodyText1,
              timeStyle: Get.textTheme.headline5,
              initTime: whatTime.value,
              height: 200.0,
              onTimeChanged: (time) {
                whatTime.value = time;
              },
            ),
          );
        },
      );
    }
  }

  void onNotificationTimeValueChanged(bool value) {
    isNotificationActivated = value;
  }

  void onNotificationTimeTapped() {
    if (isNotificationActivated) {
      Utils.customShowModalBottomSheet(
        builder: (context) {
          return Padding(
            padding: const EdgeInsets.all(30.0),
            child: DurationPicker(
              height: 200.0,
              durationStyle: Get.textTheme.headline5,
              tagStyle: Get.textTheme.bodyText1,
              initDuration: notificationTime.value,
              onDurationChanged: (duration) {
                notificationTime.value = duration;
              },
            ),
          );
        },
      );
    }
  }

  void onDescriptionValueChanged(bool value) {
    isDescriptionActivated = value;
  }

  // Utility Methods
  bool checkNameError() {
    isNameEmptyAlertOn.value = false;
    isNameDuplicatedAlertOn.value = false;

    if (nameController.text.isEmpty) {
      print('name empty');
      isNameEmptyAlertOn.value = true;
      return true;
    } else if (_isNameDuplicated()) {
      print('name duplicated');
      isNameDuplicatedAlertOn.value = true;
      return true;
    }

    return false;
  }

  List<Widget> buildWeekCards(BuildContext context, int length) {
    weeksLength = length;
    EdgeInsets margin = const EdgeInsets.only(right: 2.0);

    return List.generate(length, (index) {
      if (index == length - 1)
        margin = const EdgeInsets.only(left: 2.0);
      else if (index != 0) margin = const EdgeInsets.symmetric(horizontal: 2.0);

      return Expanded(
        child: WeekCard(
          margin: margin,
          height: weekCardHeight,
          child: Text(
            Utils.getWeekString(DayOfTheWeek.values[index]),
          ),
          onTap: (selected) {
            FocusScope.of(context).unfocus();
            selectedWeeks[index] = selected;
            isWeeksAlertOn.value = false;
          },
        ),
      );
    });
  }

  Widget buildIconText({
    @required IconData iconData,
    @required String text,
    String initText,
    @required RxBool isActivated,
    @required void Function() onTap,
  }) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: iconTextPadding),
      child: Row(
        children: [
          InkWell(
            customBorder: const CircleBorder(),
            onTap: () {
              isActivated.value = !isActivated.value;
              Get.focusScope.unfocus();
            },
            child: Icon(
              iconData,
              size: iconSize,
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
                Get.focusScope.unfocus();
              },
              child: Text(
                text,
                style: Get.textTheme.headline6.copyWith(
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

  // local method
  bool _isNameDuplicated() {
    bool result = false;

    for (int i = 0; i < habits.length; i++) {
      if (habits[i].name.compareTo(nameController.text) == 0) {
        result = true;
        break;
      }
    }

    return result;
  }

  bool _isWeekSelected() {
    int falseNum = 0;

    selectedWeeks.forEach((key, value) {
      if (!value) falseNum++;
    });

    if (falseNum == selectedWeeks.length) return false;

    return true;
  }
}
