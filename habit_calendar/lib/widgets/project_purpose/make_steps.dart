import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:habit_calendar/constants/constants.dart';
import 'package:habit_calendar/services/database/app_database.dart';
import 'package:habit_calendar/utils/utils.dart';
import 'package:habit_calendar/widgets/general_purpose/alert.dart';
import 'package:habit_calendar/widgets/general_purpose/duration_picker.dart';
import 'package:habit_calendar/widgets/general_purpose/time_picker.dart';
import 'package:habit_calendar/widgets/general_purpose/week_card.dart';
import 'package:habit_calendar/widgets/project_purpose/bottom_buttons.dart';
import 'package:habit_calendar/widgets/project_purpose/custom_chip.dart';
import 'package:habit_calendar/widgets/project_purpose/duration_chip.dart';
import 'package:habit_calendar/widgets/project_purpose/group_chip.dart';
import 'package:habit_calendar/widgets/project_purpose/group_maker.dart';

const _askFlex = 1;
const _mainFlex = 2;
const _headerFlex = 1;
const _contentFlex = 6;

typedef void _GoNextCallBack(int index, {bool skip});
typedef void _GoPreviousCallBack(int index);
typedef void _OnFinallySave(
  Habit habit,
  List<int> weeks,
  List<Duration> notificationTimes,
);

TextStyle get _askStringStyle => Get.textTheme.headline6;
TextStyle get _mainTextStyle => Get.textTheme.headline5;
TextStyle get _contentStyle => Get.textTheme.bodyText1;

Widget _buildPreviousButtion({@required void Function() onPressed}) {
  assert(onPressed != null);

  return Align(
    alignment: Alignment.bottomLeft,
    child: FlatButton(
      onPressed: onPressed,
      child: Text(
        '뒤로'.tr.capitalizeFirst,
        style: Get.textTheme.bodyText1,
      ),
    ),
  );
}

Widget _buildNextButton({
  @required void Function() onPressed,
  bool lastStep = false,
}) {
  assert(onPressed != null);

  return Align(
    alignment: Alignment.bottomRight,
    child: FlatButton(
      onPressed: onPressed,
      child: Text(
        lastStep ? '저장'.tr.capitalizeFirst : '다음'.tr.capitalizeFirst,
        style: Get.textTheme.bodyText1.copyWith(
          color: Get.theme.primaryColor,
          fontWeight: FontWeight.bold,
        ),
      ),
    ),
  );
}

Widget _buildAlertContent({
  Color alertColor = Colors.redAccent,
  IconData iconData = Icons.error_outline,
  @required String errorString,
}) {
  assert(alertColor != null && iconData != null && errorString != null);

  return Row(
    children: [
      Icon(
        iconData,
        color: alertColor,
        size: Get.textTheme.bodyText2.fontSize,
      ),
      SizedBox(width: 8.0),
      Text(
        errorString,
        style: Get.textTheme.bodyText2.copyWith(color: alertColor),
      ),
    ],
  );
}

Widget _buildHeader(String text) {
  return Column(
    children: [
      Expanded(
        child: Text(
          text,
          style: _askStringStyle.copyWith(color: Colors.grey),
          textAlign: TextAlign.center,
        ),
      ),
      Divider(),
    ],
  );
}

// TODO load saved data (init data)
// TODO when tap back button reverse transition
class MakeSteps extends StatefulWidget {
  MakeSteps({
    Key key,
    @required this.habits,
    @required this.groups,
    @required this.insertGroup,
    this.sharedAxisTransitionType = SharedAxisTransitionType.vertical,
    this.reverse = false,
    this.duration = const Duration(milliseconds: 500),
    this.curve = Curves.ease,
    this.onSave,
  })  : assert(habits != null),
        assert(groups != null),
        assert(insertGroup != null),
        super(key: key);

  final List<Habit> habits;
  final List<Group> groups;
  final Future<int> Function(Group group) insertGroup;
  final SharedAxisTransitionType sharedAxisTransitionType;
  final bool reverse;
  final Duration duration;
  final Curve curve;
  final _OnFinallySave onSave;

  @override
  _MakeStepsState createState() => _MakeStepsState();
}

class _MakeStepsState extends State<MakeSteps>
    with SingleTickerProviderStateMixin {
  /// step 0 ~ step 5
  final _stepLength = 6;

  /// init step 0
  int _step = 0;
  bool _reverse = false;
  int _requestSkip = -1;

  // results
  String _name;
  int _groupId = 0;
  Map<int, bool> _weeks = Map<int, bool>();
  DateTime _whatTime = DateTime(0);
  List<Duration> _noticeTimes = List<Duration>();
  String _message;
  String _memo;

  Widget get _child {
    switch (_step) {
      case 0:
        return _Step0(
          index: 0,
          habits: widget.habits,
          goNext: _goNext,
          onSave: (text) => _name = text,
          initValue: _name,
        );
      case 1:
        return _Step1(
          index: 1,
          groups: widget.groups,
          previousResult: _name,
          goNext: _goNext,
          goPrevious: _goPrevious,
          onSave: (groupId) => _groupId = groupId,
          insertGroup: widget.insertGroup,
          initValue: _groupId,
        );
      case 2:
        return _Step2(
          index: 2,
          previousResult: _name,
          goNext: _goNext,
          goPrevious: _goPrevious,
          onSave: (weeks) => _weeks = weeks,
          initValue: _weeks,
        );
      case 3:
        return _Step3(
          index: 3,
          previousResult: WeekCard.selectedWeeksString(_weeks),
          goNext: _goNext,
          goPrevious: _goPrevious,
          onSave: (dateTime) => _whatTime = dateTime,
          initDate: _whatTime,
          initWhenever: _whatTime == null ? true : false,
        );
      case 4:
        return _Step4(
          index: 4,
          previousResult: Utils.getWhatTimeString(_whatTime),
          goNext: _goNext,
          goPrevious: _goPrevious,
          onSave: (notificationTimes) => _noticeTimes = notificationTimes,
          initValue: _noticeTimes,
        );
      case 5:
      default:
        return _Step5(
            index: 5,
            previousResult: _name,
            goNext: _goNext,
            goPrevious: _goPrevious,
            onSave: (optionalInfo) {
              _message = optionalInfo.message;
              _memo = optionalInfo.memo;
            });
    }
  }

  @override
  void initState() {
    _initWeeks();

    super.initState();
  }

  void _initWeeks() {
    for (int i = 0; i < 7; i++) {
      _weeks[i] = true;
    }
  }

  void _goNext(int index, {bool skip = false}) {
    // if last step
    if (index == _stepLength - 1) {
      _save();
    }
    if (skip) {
      if (index + 2 < _stepLength) {
        setState(() {
          _step = index + 2;
          _requestSkip = index + 2;
        });
      }
    } else if (index + 1 < _stepLength)
      setState(() {
        _step = index + 1;
      });

    setState(() {
      _reverse = false;
    });
  }

  void _goPrevious(int index) {
    bool skip = false;
    if (_requestSkip == index) skip = true;

    if (skip) {
      if (index - 2 > -1) {
        setState(() {
          _step = index - 2;
        });
      }
    } else if (index - 1 > -1)
      setState(() {
        _step = index - 1;
      });

    setState(() {
      _reverse = true;
    });
  }

  void _save() {
    if (widget.onSave == null) return;

    final selectedWeeks = List<int>();
    _weeks.forEach((key, value) {
      if (value) selectedWeeks.add(key);
    });

    int noticeTypeId = 0;
    if (_noticeTimes != null && _noticeTimes.length > 0) {
      noticeTypeId = 1;
    }

    widget.onSave(
      Habit(
        id: null,
        name: _name,
        groupId: _groupId,
        whatTime: _whatTime,
        memo: _memo,
        noticeMessage: _message,
        noticeTypeId: noticeTypeId,
      ),
      selectedWeeks,
      _noticeTimes,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Get.theme.scaffoldBackgroundColor,
      child: PageTransitionSwitcher(
        transitionBuilder: (
          Widget child,
          Animation<double> animation,
          Animation<double> secondaryAnimation,
        ) {
          return SharedAxisTransition(
            fillColor: Get.theme.scaffoldBackgroundColor,
            animation: animation,
            secondaryAnimation: secondaryAnimation,
            transitionType: widget.sharedAxisTransitionType,
            child: child,
          );
        },
        duration: widget.duration,
        reverse: _reverse,
        child: _child,
      ),
    );
  }
}

/// Step 0 : Habit name
class _Step0 extends StatefulWidget {
  _Step0({
    Key key,
    @required this.index,
    @required this.habits,
    this.goNext,
    this.onSave,
    this.initValue,
  })  : assert(index != null),
        assert(habits != null),
        super(key: key);

  final int index;
  final List<Habit> habits;
  final void Function(String name) onSave;
  final _GoNextCallBack goNext;
  final String initValue;

  @override
  __Step0State createState() => __Step0State();
}

class __Step0State extends State<_Step0> with TickerProviderStateMixin {
  // TODO add translation
  final _askNameString = '어떤 습관을 만들고 싶으세요?';

  final _nameEmptyString = '습관 이름을 입력해 주세요'.tr;
  final _nameDuplicatedString = '이미 진행중인 습관입니다'.tr;

  // Animations
  AnimationController _initController;
  Animation<double> _initAnimation;

  TextEditingController _nameTextController;

  bool _isNameEmpty = false;
  bool _isNameDuplicated = false;

  bool get _isNameAlertOn => _isNameEmpty || _isNameDuplicated;

  String get _alertString {
    if (_isNameEmpty)
      return _nameEmptyString;
    else if (_isNameDuplicated)
      return _nameDuplicatedString;
    else
      return '';
  }

  @override
  void initState() {
    _nameTextController = TextEditingController(text: widget.initValue);

    // Init init aninmation
    _initController = AnimationController(
      duration: const Duration(milliseconds: Constants.mediumAnimationSpeed),
      vsync: this,
    );
    _initAnimation = _initController.drive(
      Tween(begin: 0.0, end: 1.0).chain(CurveTween(curve: Curves.ease)),
    );

    /// Wait until OpenContainer animation end.
    /// and then animate init animation
    Future.delayed(Duration(milliseconds: Constants.largeAnimationSpeed))
        .then((value) => _initController.forward());

    super.initState();
  }

  @override
  void dispose() {
    _initController.dispose();

    super.dispose();
  }

  void _validateName() {
    final text = _nameTextController.text;

    _isNameEmpty = false;
    _isNameDuplicated = false;

    if (text.isNull || text.isEmpty) {
      setState(() {
        _isNameEmpty = true;
      });
      return;
    }

    for (final habit in widget.habits) {
      if (habit.name.compareTo(text) == 0) {
        setState(() {
          _isNameDuplicated = true;
        });
        break;
      }
    }
  }

  void _onNextTap() {
    _validateName();
    if (_isNameAlertOn) return;

    if (widget.onSave != null) widget.onSave(_nameTextController.text);
    if (widget.goNext != null) widget.goNext(widget.index);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Container(
        /// Give color to Container to fill it's space
        /// if Container doesn't have color then it will
        /// fill only it's child size
        color: Get.theme.scaffoldBackgroundColor,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              flex: _askFlex,
              child: Center(
                child: Text(
                  _askNameString,
                  style: _askStringStyle,
                ),
              ),
            ),
            Expanded(
              flex: _mainFlex,

              /// Use SingleChildScrollView to prevent size error
              /// that caused by keyboard
              child: SingleChildScrollView(
                child: SizeTransition(
                  sizeFactor: _initAnimation,
                  axis: Axis.horizontal,
                  child: Column(
                    children: [
                      Alert(
                        alertContent:
                            _buildAlertContent(errorString: _alertString),
                        isAlertOn: _isNameAlertOn,
                        child: TextField(
                          controller: _nameTextController,
                          textAlign: TextAlign.center,
                          style: _mainTextStyle,
                          onChanged: (text) {
                            setState(() {
                              _isNameEmpty = false;
                              _isNameDuplicated = false;
                            });
                          },
                          onEditingComplete: () {
                            _validateName();
                            if (!_isNameAlertOn)
                              FocusScope.of(context).unfocus();
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Align(
              alignment: Alignment.centerRight,
              child: _buildNextButton(
                onPressed: _onNextTap,
              ),
            )
          ],
        ),
      ),
    );
  }
}

/// Step 1 : Group
class _Step1 extends StatefulWidget {
  _Step1({
    Key key,
    @required this.index,
    @required this.groups,
    @required this.previousResult,
    this.goNext,
    this.goPrevious,
    this.onSave,
    this.insertGroup,
    this.initValue = 0,
  })  : assert(index != null),
        assert(groups != null),
        assert(previousResult != null),
        super(key: key);

  final int index;
  final List<Group> groups;
  final String previousResult;
  final void Function(int selectedGroupId) onSave;
  final Future<int> Function(Group group) insertGroup;
  final _GoNextCallBack goNext;
  final _GoPreviousCallBack goPrevious;
  final int initValue;

  @override
  _Step1State createState() => _Step1State();
}

class _Step1State extends State<_Step1> with TickerProviderStateMixin {
  // TODO add translation
  final _askGroupString = '어떤 폴더에 분류할까요?';

  // At first default group is selected
  int _selectedGroup = 0;

  @override
  void initState() {
    _selectedGroup = widget.initValue;

    super.initState();
  }

  void _showGroupMaker() {
    Utils.customShowModal(builder: (context) {
      return GroupMaker.hideHabits(
        groups: widget.groups,
        onSave: (group, _) async {
          /// last index is widget.groups.length - 1.
          /// so added group index will be widget.groups.length.
          final addedIndex = widget.groups.length;

          if (widget.insertGroup != null) await widget.insertGroup(group);

          setState(() {
            _selectedGroup = addedIndex;
          });
        },
      );
    });
  }

  List<Widget> get _groupChips {
    final list = List<Widget>();
    final padding = EdgeInsets.all(8.0);

    /// At first groups is not loaded from database
    /// groups.length is 0 and list will be added only GroupChip.add
    /// then next build groups[0] will GroupChip.add
    if (widget.groups.length == 0) return list;

    for (int index = 0; index < widget.groups.length; index++) {
      list.add(Padding(
        key: ValueKey(index),
        padding: padding,
        child: GroupChip(
          group: widget.groups[index],
          selectedStyle: _contentStyle,
          unSelectedStyle: _contentStyle,
          groupValue: _selectedGroup,
          onSelected: (selectedGroupId) {
            setState(() {
              _selectedGroup = selectedGroupId;
            });
          },
        ),
      ));
    }

    list.add(Padding(
      padding: padding,
      child: GroupChip.add(
        onTap: _showGroupMaker,
      ),
    ));

    return list;
  }

  void _onPreviousTap() {
    if (widget.goPrevious != null) widget.goPrevious(widget.index);
  }

  void _onNextTap() {
    if (widget.onSave != null) widget.onSave(_selectedGroup);
    if (widget.goNext != null) widget.goNext(widget.index);
  }

  Widget get _mainContent {
    return Column(
      children: [
        Expanded(
          flex: _askFlex,
          child: Center(
            child: Text(
              _askGroupString,
              style: _askStringStyle,
            ),
          ),
        ),
        Expanded(
          flex: _askFlex * 5,
          child: GridView.count(
            physics: BouncingScrollPhysics(),
            childAspectRatio: 3 / 1,
            crossAxisCount: 2,
            children: _groupChips,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Get.theme.scaffoldBackgroundColor,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            flex: _headerFlex,
            child: _buildHeader(widget.previousResult),
          ),
          Expanded(
            flex: _contentFlex,
            child: _mainContent,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildPreviousButtion(
                onPressed: _onPreviousTap,
              ),
              _buildNextButton(
                onPressed: _onNextTap,
              ),
            ],
          )
        ],
      ),
    );
  }
}

// Step 2 : Set repeating weeks
class _Step2 extends StatefulWidget {
  _Step2({
    Key key,
    @required this.index,
    @required this.previousResult,
    this.goNext,
    this.goPrevious,
    this.onSave,
    this.initValue,
  })  : assert(index != null),
        assert(previousResult != null),
        super(key: key);

  final int index;
  final String previousResult;
  final _GoNextCallBack goNext;
  final _GoPreviousCallBack goPrevious;
  final void Function(Map<int, bool> weeks) onSave;
  final Map<int, bool> initValue;

  @override
  _Step2State createState() => _Step2State();
}

class _Step2State extends State<_Step2> with TickerProviderStateMixin {
  // TODO add translation
  final _askWeekString = '반복할 요일을 선택해주세요'.tr;

  String get _weekAlertString => _askWeekString;

  // Animations
  AnimationController _initController;
  Animation<double> _initAnimation;

  // Result
  Map<int, bool> _weeks = Map<int, bool>();
  bool _weekAlertOn = false;

  bool get _isWeekSelected {
    bool result = false;

    _weeks.forEach((key, value) {
      if (value) result = true;
    });

    return result;
  }

  @override
  void initState() {
    if (widget.initValue != null && widget.initValue.isNotEmpty) {
      _weeks = widget.initValue;
    } else {
      for (int i = 0; i < 7; i++) {
        _weeks[i] = true;
      }
    }

    // Init animations
    _initController = AnimationController(
      duration: const Duration(milliseconds: Constants.mediumAnimationSpeed),
      vsync: this,
    );
    _initAnimation = _initController.drive(
      Tween(begin: 0.0, end: 1.0).chain(CurveTween(curve: Curves.ease)),
    );

    _initController.forward();

    super.initState();
  }

  @override
  void dispose() {
    _initController.dispose();

    super.dispose();
  }

  void _validateWeek() {
    _weekAlertOn = false;

    if (!_isWeekSelected) {
      setState(() {
        _weekAlertOn = true;
      });
    }
  }

  void _onPreviousTap() {
    if (widget.goPrevious != null) widget.goPrevious(widget.index);
  }

  void _onNextTap() {
    _validateWeek();
    if (_weekAlertOn) return;

    if (widget.onSave != null) widget.onSave(_weeks);
    if (widget.goNext != null) widget.goNext(widget.index);
  }

  void _onWeekTap(int index, bool isSelected) {
    setState(() {
      _weekAlertOn = false;
      _weeks[index] = isSelected;
    });
  }

  Widget get _mainContent {
    return Column(
      children: [
        Expanded(
          flex: _askFlex,
          child: Center(
            child: Text(
              _askWeekString,
              style: _askStringStyle,
            ),
          ),
        ),
        Expanded(
          flex: _mainFlex,
          child: SizeTransition(
            sizeFactor: _initAnimation,
            axis: Axis.horizontal,
            child: Alert(
              alertContent: _buildAlertContent(
                errorString: _weekAlertString,
              ),
              isAlertOn: _weekAlertOn,
              child: Row(
                children: WeekCard.buildOneWeek(
                  height: 60.0,
                  onTap: _onWeekTap,
                  initValue: _weeks,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Get.theme.scaffoldBackgroundColor,
      child: Column(
        children: [
          Expanded(
            flex: _headerFlex,
            child: _buildHeader(widget.previousResult),
          ),
          Expanded(
            flex: _contentFlex,
            child: _mainContent,
          ),
          // Next, previous buttons
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildPreviousButtion(
                onPressed: _onPreviousTap,
              ),
              _buildNextButton(
                onPressed: _onNextTap,
              ),
            ],
          )
        ],
      ),
    );
  }
}

// Step 3 : Set time to do
class _Step3 extends StatefulWidget {
  _Step3({
    Key key,
    @required this.index,
    @required this.previousResult,
    this.goNext,
    this.goPrevious,
    this.onSave,
    this.initDate,
    this.initWhenever = false,
  })  : assert(index != null),
        assert(previousResult != null),
        super(key: key);

  final int index;
  final String previousResult;
  final _GoNextCallBack goNext;
  final _GoPreviousCallBack goPrevious;
  final void Function(DateTime whatTime) onSave;
  final DateTime initDate;
  final bool initWhenever;

  @override
  _Step3State createState() => _Step3State();
}

class _Step3State extends State<_Step3> with TickerProviderStateMixin {
  // TODO add translation
  final _askWhatTimeString = '몇시에 할 예정이세요?'.tr;
  final _switchString = '설정 안함'.tr;

  // Result
  DateTime _whatTime = DateTime(0);
  bool _whenever = false;

  @override
  void initState() {
    _whatTime = widget.initDate ?? DateTime(0);
    _whenever = widget.initWhenever ?? false;

    super.initState();
  }

  void _onPreviousTap() {
    if (widget.goPrevious != null) widget.goPrevious(widget.index);
  }

  void _onNextTap() {
    if (widget.onSave != null) widget.onSave(_whenever ? null : _whatTime);
    if (widget.goNext != null) widget.goNext(widget.index, skip: _whenever);
  }

  void _onWhatTimeChanged(DateTime whatTime) {
    setState(() {
      _whatTime = whatTime;
    });
  }

  Widget get _mainContent {
    return Column(
      children: [
        Expanded(
          flex: _askFlex,
          child: Center(
            child: Text(
              _askWhatTimeString,
              style: _askStringStyle,
            ),
          ),
        ),
        Expanded(
          flex: _mainFlex,
          child: TimePicker(
            reverseSwitch: true,
            initTime: _whatTime,
            initValue: !_whenever,
            ampmStyle: Get.textTheme.bodyText1.copyWith(
              color: Get.theme.primaryColor,
              fontWeight: FontWeight.bold,
            ),
            timeStyle: Get.textTheme.headline5.copyWith(
              color: Get.theme.primaryColor,
              fontWeight: FontWeight.bold,
            ),
            switchText: Text(
              _switchString,
              style: Get.textTheme.bodyText2,
            ),
            onTimeChanged: _onWhatTimeChanged,
            onStatusChanged: (whenever) {
              _whenever = !whenever;
            },
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Get.theme.scaffoldBackgroundColor,
      child: Column(
        children: [
          Expanded(
            flex: _headerFlex,
            child: _buildHeader(widget.previousResult),
          ),
          Expanded(
            flex: _contentFlex,
            child: _mainContent,
          ),
          // Next, previous buttons
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildPreviousButtion(
                onPressed: _onPreviousTap,
              ),
              _buildNextButton(
                onPressed: _onNextTap,
              ),
            ],
          )
        ],
      ),
    );
  }
}

// Step 4 : Set notification time
class _Step4 extends StatefulWidget {
  _Step4({
    Key key,
    @required this.index,
    @required this.previousResult,
    this.goNext,
    this.goPrevious,
    this.onSave,
    this.initValue,
  })  : assert(index != null),
        assert(previousResult != null),
        super(key: key);

  final int index;
  final String previousResult;
  final _GoNextCallBack goNext;
  final _GoPreviousCallBack goPrevious;
  final void Function(List<Duration> notificationTimes) onSave;
  final List<Duration> initValue;

  @override
  _Step4State createState() => _Step4State();
}

class _Step4State extends State<_Step4> with TickerProviderStateMixin {
  // TODO add translation
  final _askNoticeTimeString = '언제 알려드릴까요?'.tr;
  final _durationPickerMaxHours = 23;

  // key : Duration.inMinutes, value : enabled
  Map<int, bool> _noticeTimeSelection = Map<int, bool>();
  List<Duration> get _notificationTimes {
    final result = List<Duration>();

    _noticeTimeSelection.forEach((key, value) {
      if (value) {
        result.add(Duration(minutes: key));
      }
    });

    return result;
  }

  @override
  void initState() {
    // As default 0, 5, 10, 15, 30 minutes
    _noticeTimeSelection = {
      0: false,
      5: false,
      10: false,
      15: false,
      30: false,
    };

    if (widget.initValue != null) {
      widget.initValue.forEach((element) {
        _noticeTimeSelection[element.inMinutes] = true;
      });
    }

    super.initState();
  }

  void _onPreviousTap() {
    if (widget.goPrevious != null) widget.goPrevious(widget.index);
  }

  void _onNextTap() {
    if (widget.onSave != null) widget.onSave(_notificationTimes);
    if (widget.goNext != null) widget.goNext(widget.index);
  }

  void _showDurationPicker() {
    Utils.customShowModalBottomSheet(
      builder: (context) {
        Duration duration = Duration();

        return Padding(
          padding: const EdgeInsets.only(top: 32.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              DurationPicker(
                maxHours: _durationPickerMaxHours,
                infiniteHours: true,
                infiniteMinutes: true,
                onDurationChanged: (newDuration) => duration = newDuration,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 36.0),
                child: BottomButtons(
                  spaceBetween: true,
                  rightButtonString: '추가'.tr.capitalizeFirst,
                  leftButtonAction: () => Navigator.of(context).pop(),
                  rightButtonAction: () {
                    setState(() {
                      _noticeTimeSelection[duration.inMinutes] = true;
                    });
                    Navigator.of(context).pop();
                  },
                ),
              )
            ],
          ),
        );
      },
    );
  }

  void _onDurationChipValueChanged(Duration duration, bool value) {
    setState(() {
      _noticeTimeSelection[duration.inMinutes] = value;
    });
  }

  List<Widget> get _noticeTimeChips {
    final list = List<Widget>();
    final padding = EdgeInsets.all(8.0);

    _noticeTimeSelection.forEach((key, value) {
      String durationString;

      if (key == 0) {
        durationString = widget.previousResult;
      }

      list.add(
        Padding(
          key: ValueKey(key),
          padding: padding,
          child: DurationChip(
            value: _noticeTimeSelection[key],
            duration: Duration(minutes: key),
            durationString: durationString,
            onValueChanged: _onDurationChipValueChanged,
          ),
        ),
      );
    });

    list.add(
      Padding(
        padding: padding,
        child: DurationChip.add(
          onTap: _showDurationPicker,
        ),
      ),
    );

    return list;
  }

  Widget get _mainContent {
    return Column(
      children: [
        Expanded(
          flex: _askFlex,
          child: Center(
            child: Text(
              _askNoticeTimeString,
              style: _askStringStyle,
            ),
          ),
        ),
        Expanded(
          flex: _askFlex * 5,
          child: GridView.count(
            physics: BouncingScrollPhysics(),
            childAspectRatio: 3 / 1,
            crossAxisCount: 2,
            children: _noticeTimeChips,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Get.theme.scaffoldBackgroundColor,
      child: Column(
        children: [
          Expanded(
            flex: _headerFlex,
            child: _buildHeader(widget.previousResult),
          ),
          Expanded(
            flex: _contentFlex,
            child: _mainContent,
          ),
          // Next, previous buttons
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildPreviousButtion(
                onPressed: _onPreviousTap,
              ),
              _buildNextButton(
                onPressed: _onNextTap,
              ),
            ],
          )
        ],
      ),
    );
  }
}

class _OptionalInfo {
  _OptionalInfo({
    @required this.message,
    @required this.memo,
  });
  final String message;
  final String memo;
}

class _OptionalTextField extends StatelessWidget {
  _OptionalTextField({
    Key key,
    this.askString,
    this.textEditingController,
    this.onCancelTap,
    this.onSaveTap,
  })  : assert(textEditingController != null),
        super(key: key);

  final String askString;
  final TextEditingController textEditingController;
  final void Function() onCancelTap;
  final void Function() onSaveTap;

  @override
  Widget build(BuildContext context) {
    final buttonAction = () {
      FocusScope.of(context).unfocus();
      Navigator.of(context).pop();
    };

    return Material(
      type: MaterialType.transparency,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (askString != null)
            Text(
              askString,
              style: _askStringStyle,
              textAlign: TextAlign.center,
            )
          else
            Container(),
          SingleChildScrollView(
            child: TextField(
              controller: textEditingController,
              style: _mainTextStyle,
              textAlign: TextAlign.center,
            ),
          ),
          BottomButtons(
            spaceBetween: true,
            rightButtonString: '저장'.tr.capitalizeFirst,
            leftButtonAction: () {
              if (onCancelTap != null) onCancelTap();
              buttonAction();
            },
            rightButtonAction: () {
              if (onSaveTap != null) onSaveTap();
              buttonAction();
            },
          )
        ],
      ),
    );
  }
}

// Step 5 : Set additional info
class _Step5 extends StatefulWidget {
  _Step5({
    Key key,
    @required this.index,
    @required this.previousResult,
    this.goNext,
    this.goPrevious,
    this.onSave,
    this.initValue,
  })  : assert(index != null),
        assert(previousResult != null),
        super(key: key);

  final int index;
  final String previousResult;
  final _GoNextCallBack goNext;
  final _GoPreviousCallBack goPrevious;
  final void Function(_OptionalInfo optionalInfo) onSave;
  final List<Duration> initValue;

  @override
  _Step5State createState() => _Step5State();
}

class _Step5State extends State<_Step5> with TickerProviderStateMixin {
  // TODO add translation
  final _askOptionString = '추가 정보를 입력해주세요'.tr;
  final _askMessageString = '알림에 함께 나타날 메세지를\n입력해주세요'.tr;
  final _askMemoString = '메모할 정보를 입력해주세요'.tr;

  List<String> _optionStrings = List<String>();
  List<void Function()> _optionActions = List<void Function()>();
  List<bool> _optionEnabled = List<bool>();

  TextEditingController _messageTextController = TextEditingController();
  TextEditingController _memoTextController = TextEditingController();

  @override
  void initState() {
    _optionStrings = <String>[
      '알림 메세지'.tr.capitalizeFirst,
      '메모'.tr.capitalizeFirst,
    ];
    _optionActions = <void Function()>[
      _option0Action,
      _option1Action,
    ];
    _optionEnabled = <bool>[
      false,
      false,
    ];

    super.initState();
  }

  void _onPreviousTap() {
    if (widget.goPrevious != null) widget.goPrevious(widget.index);
  }

  void _onNextTap() {
    if (widget.onSave != null)
      widget.onSave(
        _OptionalInfo(
          message: _optionEnabled[0] ? _messageTextController.text : null,
          memo: _optionEnabled[1] ? _memoTextController.text : null,
        ),
      );
    if (widget.goNext != null) widget.goNext(widget.index);
  }

  void _option0Action() {
    if (_optionEnabled[0]) {
      setState(() {
        _optionEnabled[0] = false;
      });
      return;
    }

    Utils.customShowModal(
      builder: (context) {
        return _OptionalTextField(
          askString: _askMessageString,
          textEditingController: _messageTextController,
          onCancelTap: () {
            setState(() {
              _optionEnabled[0] = false;
            });
          },
          onSaveTap: () {
            setState(() {
              _optionEnabled[0] = true;
            });
          },
        );
      },
    );
  }

  void _option1Action() {
    if (_optionEnabled[1]) {
      setState(() {
        _optionEnabled[1] = false;
      });
      return;
    }

    Utils.customShowModal(
      builder: (context) {
        return _OptionalTextField(
          askString: _askMemoString,
          textEditingController: _memoTextController,
          onCancelTap: () {
            setState(() {
              _optionEnabled[1] = false;
            });
          },
          onSaveTap: () {
            setState(() {
              _optionEnabled[1] = true;
            });
          },
        );
      },
    );
  }

  List<Widget> get _optionChips {
    final list = List<Widget>();
    final borderRadius = BorderRadius.circular(Constants.smallBorderRadius);

    for (int index = 0; index < _optionStrings.length; index++) {
      final optionString = _optionStrings[index];
      final callback = _optionActions[index];

      list.add(
        Padding(
          key: ValueKey(optionString),
          padding: const EdgeInsets.all(8.0),
          child: GestureDetector(
            onTap: callback,
            child: Material(
              borderRadius: borderRadius,
              elevation: _optionEnabled[index] ? 5.0 : 0.0,
              child: CustomChip(
                borderRadius: borderRadius,
                child: Text(
                  optionString,
                  style: _contentStyle,
                ),
              ),
            ),
          ),
        ),
      );
    }
    _optionStrings.forEach((optionString) {});

    return list;
  }

  Widget get _mainContent {
    return Column(
      children: [
        Expanded(
          flex: _askFlex,
          child: Center(
            child: Text(
              _askOptionString,
              style: _askStringStyle,
            ),
          ),
        ),
        Expanded(
          flex: _askFlex * 4,
          child: GridView.count(
            physics: BouncingScrollPhysics(),
            childAspectRatio: 3 / 1,
            crossAxisCount: 2,
            children: _optionChips,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Get.theme.scaffoldBackgroundColor,
      child: Column(
        children: [
          Expanded(
            flex: _headerFlex,
            child: _buildHeader(widget.previousResult),
          ),
          Expanded(
            flex: _contentFlex,
            child: _mainContent,
          ),
          // Next, previous buttons
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildPreviousButtion(
                onPressed: _onPreviousTap,
              ),
              _buildNextButton(
                onPressed: _onNextTap,
                lastStep: true,
              ),
            ],
          )
        ],
      ),
    );
  }
}
