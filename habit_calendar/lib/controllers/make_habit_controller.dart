import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:habit_calendar/constants/constants.dart';
import 'package:habit_calendar/services/database/app_database.dart';
import 'package:habit_calendar/utils/utils.dart';
import 'package:habit_calendar/widgets/week_card.dart';

import '../services/database/db_service.dart';

class MakeHabitController extends GetxController {
  final _dbService = Get.find<DbService>();

  // Groups variables
  final groups = List<Group>().obs;
  final selectedGroup = Rx<Group>();

  // Habits variable
  final habits = List<Habit>().obs;

  // TextField Controllers
  final nameController = TextEditingController();
  final descriptionController = TextEditingController();

  // TextField FocusNode
  final nameFocusNode = FocusNode();
  final descriptionFocusNode = FocusNode();

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
  final isWhatTimeActivated = false.obs;
  final isNotificationActivated = false.obs;
  final isDescriptionActivated = false.obs;

  // settings
  final weekCardHeight = 60.0;
  final iconSize = 30.0;
  final iconTextPadding = 20.0;

  // Get Set
  bool get isNameAlertOn =>
      isNameEmptyAlertOn.value || isNameDuplicatedAlertOn.value;

  String get nameErrorString => isNameEmptyAlertOn.value
      ? '습관 이름을 입력해 주세요'
      : isNameDuplicatedAlertOn.value
          ? '이미 진행중인 습관입니다'
          : '';

  String get selectedWeeksString {
    whatTime.value.toString();
    if (selectedWeeks.isEmpty) return '반복할 요일을 선택해 주세요';

    int falses = 0;
    int trues = 0;

    String result = '매주';

    selectedWeeks.forEach((key, value) {
      if (value) {
        result += ' ' + Utils.getWeekString(key) + ',';
        trues++;
      } else {
        falses++;
      }
    });

    if (falses == selectedWeeks.length) return '반복할 요일을 선택해 주세요';
    if (trues == weeksLength) return '매일';
    return result.replaceRange(result.length - 1, result.length, '');
  }

  String get whatTimeString {
    String result;

    if (whatTime.value.hour < 12) {
      result = '오전 ';
      result += Utils.twoDigits(whatTime.value.hour);
    } else {
      result = '오후 ';
      if (whatTime.value.hour > 12)
        result += Utils.twoDigits(whatTime.value.hour - 12).toString();
      else
        result += Utils.twoDigits(whatTime.value.hour);
    }

    result += ' : ${Utils.twoDigits(whatTime.value.minute)}';

    return result;
  }

  String get notificationTimeString {
    int hours = notificationTime.value.inHours;
    int minutes = (notificationTime.value - Duration(hours: hours)).inMinutes;

    String result = '';

    if (hours > 0) {
      result += '$hours 시간 ';
    } else if (minutes < 1) {
      return '즉시 알림';
    }
    result += '$minutes 분 전에 알림';

    return result;
  }

  // Controller life cycle
  @override
  void onInit() async {
    groups.bindStream(_dbService.database.groupDao.watchAllGroups());
    // when use groups variable right after bindStream() it doesn't work because of database query delay
    // so selectedGroup variable initiated by getGroupById()
    selectedGroup.value = await _dbService.database.groupDao.getGroupById(0);

    habits.bindStream(_dbService.database.habitDao.watchAllHabits());

    for (int i = 0; i < weeksLength; i++) {
      selectedWeeks[i] = false;
    }

    Get.focusScope.requestFocus(nameFocusNode);
  }

  @override
  void onClose() {
    nameController.dispose();
    descriptionController.dispose();
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
        statusBarFix: null,
        groupId: selectedGroup.value.id,
        notificationTypeId: null,
        notificationTime: isNotificationActivated.value
            ? notificationTime.value.inMinutes
            : null,
        whatTime: isWhatTimeActivated.value ? whatTime.value : null,
        description:
            isDescriptionActivated.value ? descriptionController.text : null,
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

  // Utility Methods
  bool checkNameError() {
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

  List<PopupMenuEntry<int>> popupMenuEntryBuilder(BuildContext context) {
    final list = List<PopupMenuEntry<int>>();
    list.add(PopupMenuItem(
      enabled: false,
      child: Text(
        '분류',
        style: Get.textTheme.bodyText1,
      ),
    ));
    list.add(PopupMenuDivider());

    groups.forEach((group) {
      list.add(PopupMenuItem(
        value: group.id,
        child: Row(
          children: [
            Text(
              group.name,
              style: Get.textTheme.bodyText1,
            ),
            SizedBox(
              width: 10.0,
            ),
            Container(
              width: 24.0,
              height: 24.0,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: Colors.grey[400],
                  width: 1.5,
                ),
                color: Color(
                  group.color,
                ),
              ),
            ),
          ],
        ),
      ));
    });

    return list;
  }

  List<Widget> buildWeekTiles(int length) {
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
          borderRadius: Constants.smallBorderRadius,
          child: Text(
            Utils.getWeekString(index),
          ),
          onTapped: (selected) {
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

  Future<T> customShowModalBottomSheet<T>(
      {@required void Function(BuildContext) builder}) {
    return showModalBottomSheet<T>(
      context: Get.context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: const Radius.circular(Constants.largeBorderRadius),
          topRight: const Radius.circular(Constants.largeBorderRadius),
        ),
      ),
      builder: builder,
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
