import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:habit_calendar/constants/constants.dart';
import 'package:habit_calendar/services/database/app_database.dart';
import 'package:habit_calendar/utils/utils.dart';

import './bottom_buttons.dart';
import './group_popup_menu.dart';
import '../general_purpose/duration_picker.dart';
import '../general_purpose/icon_text.dart';
import '../general_purpose/time_picker.dart';
import '../general_purpose/week_card.dart';

const _kIconSize = 25.0;
const _kWeekLength = 7;
const _kIconTextPadding = 20.0;

class HabitInfoWidget extends StatefulWidget {
  HabitInfoWidget({
    Key key,
    @required this.habit,
    this.actions,
    this.onSave,
    this.habits,
    this.groups,
    @required this.weeks,
    this.weekCardHeight = 60.0,
    this.errorNameEmptyString,
    this.errorNameDuplicatedString,
    this.errorWeekUnselected,
  })  : assert(habit != null),
        assert(weeks != null),
        super(key: key);

  final Habit habit;

  final List<Widget> actions;

  final void Function(Habit, List<HabitWeek>) onSave;

  // habit list to check duplacation
  final List<Habit> habits;

  final List<Group> groups;

  /// Key : 0 ~ 6 (mon ~ sun)
  /// Value : True(selected) / False (unselected)
  final List<HabitWeek> weeks;

  final double weekCardHeight;

  final String errorNameEmptyString;

  final String errorNameDuplicatedString;

  final String errorWeekUnselected;

  @override
  _HabitInfoWidgetState createState() => _HabitInfoWidgetState();
}

class _HabitInfoWidgetState extends State<HabitInfoWidget>
    with TickerProviderStateMixin {
  // Name field
  TextEditingController _nameController = TextEditingController();
  bool _isNameEmptyAlertOn = false;
  bool _isNameDuplicatedAlertOn = false;

  // Group field
  int _selectedGroupId;

  // Weeks field
  Map<int, bool> _weeks = Map<int, bool>();
  bool _displayWeekCard = false;
  AnimationController _weekCardController;
  Animation _weekCardAnimation;
  AnimationController _weekTextController;
  Animation _weekTextAnimation;
  bool _isWeekUnselectedAlertOn = false;

  // WhatTime fields
  bool _isWhatTimeActivated;
  DateTime _whatTime;

  // NotificationTime fields
  bool _isNotificationActivated;
  Duration _notificationTime;

  // Description fields
  bool _isDescriptionActivated;
  TextEditingController _memoController = TextEditingController();

  // Get Set
  bool get _isNameAlertOn => _isNameEmptyAlertOn || _isNameDuplicatedAlertOn;

  String get _nameErrorString => _isNameEmptyAlertOn
      ? widget.errorNameEmptyString ?? '습관 이름을 입력해 주세요'.tr.capitalizeFirst
      : _isNameDuplicatedAlertOn
          ? widget.errorNameDuplicatedString ??
              '이미 진행중인 습관입니다'.tr.capitalizeFirst
          : '';

  String get _errorWeekUnselectedString => _isWeekUnselectedAlertOn
      ? widget.errorWeekUnselected ?? '반복할 요일을 선택해 주세요'.tr.capitalizeFirst
      : '';
  bool get _isWeekSelected {
    for (int i = 0; i < _weeks.length; i++) {
      if (_weeks[i]) return true;
    }

    return false;
  }

  String get _selectedWeeksString {
    int trues = 0;

    String result = '매주'.tr.capitalizeFirst;

    _weeks.forEach((key, value) {
      if (value) {
        result += ' ' + Utils.getWeekString(key).toLowerCase() + ',';
        trues++;
      }
    });

    if (trues == _weeks.length) return '매일'.tr.capitalizeFirst;

    // Remove comma(,) at the end of result string
    return result.replaceRange(result.length - 1, result.length, '');
  }

  List<HabitWeek> get _listHabitWeek {
    List<HabitWeek> result = List<HabitWeek>();

    _weeks.forEach((key, value) async {
      if (value) {
        result.add(HabitWeek(habitId: widget.habit.id, week: key));
      }
    });

    return result;
  }

  bool get _isModified {
    bool nameModified = false;
    bool groupModified = false;
    bool weekModified = false;
    bool whatTimeModified = false;
    bool notificationTimeModified = false;
    bool memoModified = false;

    nameModified = widget.habit.name.compareTo(_nameController.text) != 0;

    groupModified = widget.habit.groupId != _selectedGroupId;

    // If whatTime is set. (whatTime is activated)
    if (widget.habit.whatTime != null) {
      // If activation changed
      if (_isWhatTimeActivated == false) {
        whatTimeModified = true;
        // compare time
      } else {
        whatTimeModified = widget.habit.whatTime.compareTo(_whatTime) != 0;
      }

      /// If whatTime is not set. (whatTime is not activated)
      /// check only activation
    } else {
      whatTimeModified = _isWhatTimeActivated;
    }

    // If memo is set. (memo is activated)
    if (widget.habit.memo != null) {
      // If activation changed
      if (_isDescriptionActivated == false) {
        memoModified = true;
        // compare text
      } else {
        memoModified = widget.habit.memo.compareTo(_memoController.text) != 0;
      }

      /// If memo is not set. (memo is not activated)
      /// check only activation
    } else {
      memoModified = _isDescriptionActivated;
    }

    final Map<int, bool> testWeeks = Map<int, bool>();
    for (int i = 0; i < _kWeekLength; i++) {
      testWeeks[i] = false;
    }
    widget.weeks.forEach((element) {
      if (element.habitId == widget.habit.id) {
        testWeeks[element.week] = true;
      }
    });

    for (int i = 0; i < _kWeekLength; i++) {
      weekModified = testWeeks[i] != _weeks[i];
      if (weekModified) break;
    }

    return nameModified ||
        groupModified ||
        weekModified ||
        whatTimeModified ||
        notificationTimeModified ||
        memoModified;
  }

  Color _getGroupColor() => Color(widget.groups
          .singleWhere((element) => element.id == widget.habit.groupId,
              orElse: () => null)
          ?.color ??
      Colors.white.value);

  // Name validation
  bool _checkNameError() {
    _isNameEmptyAlertOn = false;
    _isNameDuplicatedAlertOn = false;

    if (_nameController.text.isEmpty) {
      print('name empty');
      setState(() {
        _isNameEmptyAlertOn = true;
      });
      return true;
    } else if (_isNameDuplicated) {
      print('name duplicated');
      setState(() {
        _isNameDuplicatedAlertOn = true;
      });
      return true;
    }

    return false;
  }

  bool get _isNameDuplicated {
    if (widget.habits.isNull) return false;

    bool result = false;

    for (int i = 0; i < widget.habits.length; i++) {
      if (widget.habits[i].id == widget.habit.id) continue;
      if (widget.habits[i].name.compareTo(_nameController.text) == 0) {
        result = true;
        break;
      }
    }

    return result;
  }

  List<Widget> get _weekCards {
    EdgeInsets margin = const EdgeInsets.only(right: 2.0);
    return List.generate(_kWeekLength, (index) {
      if (index == _kWeekLength - 1)
        margin = const EdgeInsets.only(left: 2.0);
      else if (index != 0) margin = const EdgeInsets.symmetric(horizontal: 2.0);

      return Expanded(
        child: WeekCard(
          margin: margin,
          height: widget.weekCardHeight * 0.8,
          initValue: _weeks[index],
          child: Text(
            Utils.getWeekString(index),
          ),
          onTap: (selected) {
            Get.focusScope.unfocus();

            setState(() {
              _isWeekUnselectedAlertOn = false;
              _weeks[index] = selected;
            });
          },
        ),
      );
    });
  }

  @override
  void initState() {
    // Init name
    _nameController.text = widget.habit.name;

    // Init group
    _selectedGroupId = widget.habit.groupId;

    // Init weeks
    for (int i = 0; i < _kWeekLength; i++) {
      _weeks[i] = false;
    }
    widget.weeks.forEach((element) {
      if (element.habitId == widget.habit.id) {
        _weeks[element.week] = true;
      }
    });

    // Init Week animation
    _weekCardController = AnimationController(
      duration: Duration(milliseconds: Constants.smallAnimationSpeed),
      vsync: this,
    );
    _weekCardAnimation = Tween(
      begin: 0.0,
      end: 1.0,
    ).chain(CurveTween(curve: Curves.ease)).animate(_weekCardController);

    _weekTextController = AnimationController(
      duration: Duration(milliseconds: Constants.smallAnimationSpeed),
      vsync: this,
    );
    _weekTextAnimation = Tween(
      begin: 1.0,
      end: 0.0,
    ).chain(CurveTween(curve: Curves.ease)).animate(_weekTextController);

    // Init whatTime
    _isWhatTimeActivated = widget.habit.whatTime != null;
    _whatTime = widget.habit.whatTime;

    // Init memo
    if (widget.habit.memo != null) {
      _memoController.text = widget.habit.memo;
      _memoController.selection =
          TextSelection.collapsed(offset: widget.habit.memo.length);
    }
    _isDescriptionActivated = widget.habit.memo != null;

    super.initState();
  }

  // Utility methods
  Widget _getErrorText(bool condition, String text) {
    return Row(
      children: [
        Icon(
          Icons.error_outline,
          size: condition ? Get.textTheme.headline6.fontSize * 0.65 : 0.0,
          color: Colors.red,
        ),
        SizedBox(
          width: 5.0,
        ),
        Text(
          text,
          style: Get.textTheme.headline6.copyWith(
            fontSize: condition ? Get.textTheme.headline6.fontSize * 0.65 : 0.0,
            color: Colors.red,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Material(
        type: MaterialType.transparency,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Row(
                    children: [
                      // Group
                      Padding(
                        padding: const EdgeInsets.only(right: 8.0),
                        child: GroupPopupMenu(
                          groups: widget.groups,
                          initColor: _getGroupColor(),
                          colorCirclePadding:
                              const EdgeInsets.fromLTRB(0.0, 8.0, 8.0, 8.0),
                          onSelected: (groupId) {
                            Get.focusScope.unfocus();

                            setState(() {
                              _selectedGroupId = groupId;
                            });
                          },
                        ),
                      ),

                      // Name
                      Expanded(
                        child: Column(
                          children: [
                            // Name text error
                            AnimatedSize(
                              vsync: this,
                              duration: const Duration(
                                milliseconds: Constants.smallAnimationSpeed,
                              ),
                              child: _getErrorText(
                                  _isNameAlertOn, _nameErrorString),
                            ),
                            // Name text
                            TextField(
                              controller: _nameController,
                              decoration: InputDecoration(
                                border: InputBorder.none,
                              ),
                              style: Get.textTheme.headline6,
                              onEditingComplete: () {
                                if (!_checkNameError()) {
                                  Get.focusScope.unfocus();
                                }
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                // Actions
                Row(
                  children: widget.actions ?? [Container()],
                )
              ],
            ),
            Divider(),
            // Week
            Padding(
              padding: const EdgeInsets.only(bottom: _kIconTextPadding),
              child: GestureDetector(
                onTap: () async {
                  setState(() {
                    _displayWeekCard = !_displayWeekCard;
                  });

                  if (_displayWeekCard) {
                    await _weekTextController.forward();
                    await _weekCardController.forward();
                  }
                },
                child: Stack(
                  alignment: Alignment.topCenter,
                  children: [
                    // Week Text
                    FadeTransition(
                      opacity: _weekTextAnimation,
                      child: SizeTransition(
                        sizeFactor: _weekTextAnimation,
                        child: Container(
                          width: double.infinity,
                          child: Text(
                            _selectedWeeksString,
                            style: Get.textTheme.bodyText1,
                          ),
                        ),
                      ),
                    ),
                    // Week Cards
                    Column(
                      children: [
                        // Week Error
                        AnimatedSize(
                          vsync: this,
                          duration: const Duration(
                            milliseconds: Constants.smallAnimationSpeed,
                          ),
                          child: Container(
                            height: _isWeekUnselectedAlertOn ? null : 0.0,
                            child: Padding(
                              padding: EdgeInsets.only(
                                right: _isWeekUnselectedAlertOn ? 0.0 : 0.0,
                              ),
                              child: _getErrorText(
                                _isWeekUnselectedAlertOn,
                                _errorWeekUnselectedString,
                              ),
                            ),
                          ),
                        ),
                        // Week Cards
                        Container(
                          child: FadeTransition(
                            opacity: _weekCardAnimation,
                            child: SizeTransition(
                              sizeFactor: _weekCardAnimation,
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: _weekCards,
                              ),
                            ),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
            // WhatTime
            Padding(
              padding: const EdgeInsets.only(bottom: _kIconTextPadding),
              child: IconText(
                icon: Icon(
                  Icons.access_time,
                  size: _kIconSize,
                ),
                text: Text(
                  Utils.getWhatTimeString(_whatTime ?? DateTime(0)),
                  style: Get.textTheme.bodyText1,
                ),
                initValue: _isWhatTimeActivated,
                onValueChanged: (value) {
                  setState(() {
                    _isWhatTimeActivated = value;
                  });
                },
                onTap: () {
                  if (_isWhatTimeActivated) {
                    showModalBottomSheet(
                      context: Get.context,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.only(
                          topLeft: const Radius.circular(
                              Constants.largeBorderRadius),
                          topRight: const Radius.circular(
                              Constants.largeBorderRadius),
                        ),
                      ),
                      builder: (context) {
                        return Padding(
                          padding: const EdgeInsets.all(30.0),
                          child: TimePicker(
                            ampmStyle: Get.textTheme.bodyText1,
                            timeStyle: Get.textTheme.headline5,
                            initTime: _whatTime,
                            onTimeChanged: (time) {
                              setState(() {
                                _whatTime = time;
                              });
                            },
                          ),
                        );
                      },
                    );
                  }
                },
              ),
            ),
            // Notification Time
            Padding(
              padding: const EdgeInsets.only(bottom: _kIconTextPadding),
              child: IconText(
                icon: Icon(
                  Icons.notifications,
                  size: _kIconSize,
                ),
                text: Text(
                  Utils.getNotificationTimeString(_notificationTime),
                  style: Get.textTheme.bodyText1,
                ),
                initValue: _isNotificationActivated,
                onValueChanged: (value) {
                  setState(() {
                    _isNotificationActivated = value;
                  });
                },
                onTap: () {
                  if (_isWhatTimeActivated) {
                    showModalBottomSheet(
                      context: Get.context,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.only(
                          topLeft: const Radius.circular(
                              Constants.largeBorderRadius),
                          topRight: const Radius.circular(
                              Constants.largeBorderRadius),
                        ),
                      ),
                      builder: (context) {
                        return Padding(
                          padding: const EdgeInsets.all(30.0),
                          child: DurationPicker(
                            durationStyle: Get.textTheme.headline5,
                            initDuration: _notificationTime,
                            onDurationChanged: (duration) {
                              setState(() {
                                _notificationTime = duration;
                              });
                            },
                          ),
                        );
                      },
                    );
                  }
                },
              ),
            ),
            // Description
            Padding(
              padding: const EdgeInsets.only(bottom: _kIconTextPadding),
              child: IconText.description(
                icon: Icon(
                  Icons.description,
                  size: _kIconSize,
                ),
                style: Get.textTheme.bodyText1,
                descriptionController: _memoController,
                initValue: _isDescriptionActivated,
                onValueChanged: (value) {
                  setState(() {
                    _isDescriptionActivated = value;
                  });
                },
              ),
            ),
            // Bottom buttons
            AnimatedSize(
              duration: Duration(milliseconds: Constants.mediumAnimationSpeed),
              vsync: this,
              child: BottomButtons(
                margin: const EdgeInsets.all(0.0),
                padding: const EdgeInsets.all(0.0),
                height: _isModified ? null : 0.0,
                rightButtonAction: () {
                  if (_checkNameError()) {
                    return;
                  }

                  if (!_isWeekSelected) {
                    setState(() {
                      _isWeekUnselectedAlertOn = true;
                    });
                    return;
                  }

                  widget.onSave(
                    Habit(
                      id: widget.habit.id,
                      name: _nameController.text,
                      groupId: _selectedGroupId,
                      whatTime: _isWhatTimeActivated
                          ? _whatTime ?? DateTime(0)
                          : null,
                      memo:
                          _isDescriptionActivated ? _memoController.text : null,
                      noticeMessage: widget.habit.noticeMessage,
                      noticeTypeId: widget.habit.noticeTypeId,
                    ),
                    _listHabitWeek,
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
