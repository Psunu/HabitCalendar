import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:habit_calendar/constants/constants.dart';
import 'package:habit_calendar/services/database/app_database.dart';
import 'package:habit_calendar/utils/utils.dart';
import 'package:habit_calendar/widgets/general_purpose/alert.dart';
import 'package:habit_calendar/widgets/general_purpose/duration_picker.dart';
import 'package:habit_calendar/widgets/general_purpose/icon_text.dart';
import 'package:habit_calendar/widgets/general_purpose/time_picker.dart';
import 'package:habit_calendar/widgets/general_purpose/week_card.dart';
import 'package:habit_calendar/widgets/project_purpose/bottom_buttons.dart';
import 'package:habit_calendar/widgets/project_purpose/duration_chip.dart';
import 'package:habit_calendar/widgets/project_purpose/group_chip.dart';
import 'package:habit_calendar/widgets/project_purpose/group_maker.dart';

const _askFlex = 50;
const _mainFlex = 100;
const _nextFlex = 300;

TextStyle get _askStringStyle => Get.textTheme.headline6;
TextStyle get _inputTextStyle => Get.textTheme.headline5;
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

Widget _buildNextButton({@required void Function() onPressed}) {
  assert(onPressed != null);

  return Align(
    alignment: Alignment.bottomRight,
    child: FlatButton(
      onPressed: onPressed,
      child: Text(
        '다음'.tr.capitalizeFirst,
        style: Get.textTheme.bodyText1.copyWith(
          color: Get.theme.accentColor,
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

/// Step 0 : Habit name and group
class MakeStep0 extends StatefulWidget {
  MakeStep0({
    Key key,
    @required this.index,
    @required this.habits,
    @required this.groups,
    @required this.nameTextController,
    this.onSave,
    this.onAddGroup,
    this.goNext,
  })  : assert(index != null),
        assert(habits != null),
        assert(groups != null),
        assert(nameTextController != null),
        super(key: key);

  final int index;
  final List<Habit> habits;
  final List<Group> groups;
  final TextEditingController nameTextController;
  final void Function(int selectedGroupId) onSave;
  final Future<int> Function(Group group) onAddGroup;
  final void Function(int index) goNext;

  @override
  _MakeStep0State createState() => _MakeStep0State();
}

class _MakeStep0State extends State<MakeStep0> with TickerProviderStateMixin {
  // TODO add translation
  final _askNameString = '어떤 습관을 만들고 싶으세요?';
  final _askGroupString = '어떤 폴더에 분류할까요?';

  final _nameEmptyString = '습관 이름을 입력해 주세요'.tr;
  final _nameDuplicatedString = '이미 진행중인 습관입니다'.tr;

  // Animations
  AnimationController _initController;
  Animation<double> _initAnimation;
  AnimationController _toStage1Controller;
  Animation<double> _hideAnimation;
  Animation<int> _hideIntAnimation;
  Animation<double> _showAnimation;
  Animation<int> _showIntAnimation;

  int _stage = 0;

  /// At first default group is selected
  int _selectedGroup = 0;

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
    // Init init aninmation
    _initController = AnimationController(
      duration: const Duration(milliseconds: Constants.mediumAnimationSpeed),
      vsync: this,
    );
    _initAnimation = _initController.drive(
      Tween(begin: 0.0, end: 1.0).chain(CurveTween(curve: Curves.ease)),
    );

    // Init stage change animation
    _toStage1Controller = AnimationController(
      duration: const Duration(milliseconds: Constants.largeAnimationSpeed),
      vsync: this,
    );
    _hideAnimation = _toStage1Controller.drive(
      Tween(begin: 1.0, end: 0.0).chain(CurveTween(curve: Curves.ease)),
    );
    _hideIntAnimation = _toStage1Controller.drive(
      IntTween(begin: _askFlex, end: 0).chain(CurveTween(curve: Curves.ease)),
    )..addListener(() {
        setState(() {});
      });
    _showAnimation = _toStage1Controller.drive(
      Tween(begin: 0.0, end: 1.0).chain(CurveTween(curve: Curves.ease)),
    );
    _showIntAnimation = _toStage1Controller.drive(
      IntTween(begin: 0, end: _nextFlex).chain(CurveTween(curve: Curves.ease)),
    )..addListener(() {
        setState(() {});
      });

    /// Wait until OpenContainer animation end.
    /// and then animate init animation
    Future.delayed(Duration(milliseconds: Constants.largeAnimationSpeed))
        .then((value) => _initController.forward());

    super.initState();
  }

  @override
  void dispose() {
    _initController.dispose();
    _toStage1Controller.dispose();

    super.dispose();
  }

  void _showGroupMaker() {
    Utils.customShowModal(builder: (context) {
      return GroupMaker.hideHabits(
        groups: widget.groups,
        onSave: (group, _) async {
          /// last index is widget.groups.length - 1.
          /// so added group index will be widget.groups.length.
          final addedIndex = widget.groups.length;

          if (widget.onAddGroup != null) await widget.onAddGroup(group);

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
          style: _contentStyle,
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

  void _validateName() {
    final text = widget.nameTextController.text;

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

  void _onPreviousTap() {
    _toStage1Controller.reverse();

    setState(() {
      _stage = 0;
    });
  }

  void _onNextTap() {
    _validateName();
    if (_isNameAlertOn) return;

    switch (_stage) {
      case 0:
        _toStage1Controller.forward();

        setState(() {
          _stage = 1;
        });
        break;
      case 1:
      default:
        if (widget.onSave != null) widget.onSave(_selectedGroup);
        if (widget.goNext != null) widget.goNext(widget.index);
    }
  }

  Widget get _stage0 {
    return Column(
      children: [
        Expanded(
          flex: _hideIntAnimation.value,
          child: SizedBox(
            height: 0.0,
            child: FadeScaleTransition(
              animation: _hideAnimation,
              child: Center(
                child: Text(
                  _askNameString,
                  style: _askStringStyle,
                ),
              ),
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
              child: Alert(
                alertContent: _buildAlertContent(errorString: _alertString),
                isAlertOn: _isNameAlertOn,
                child: TextField(
                  enabled: _stage == 0,
                  controller: widget.nameTextController,
                  textAlign: TextAlign.center,
                  style: _inputTextStyle,
                  onChanged: (text) {
                    setState(() {
                      _isNameEmpty = false;
                      _isNameDuplicated = false;
                    });
                  },
                  onEditingComplete: () {
                    _validateName();
                    if (!_isNameAlertOn) FocusScope.of(context).unfocus();
                  },
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget get _stage1 {
    return SizedBox(
      height: 0.0,
      child: Column(
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
      ),
    );
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
        color: Colors.transparent,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: [
            Expanded(
              flex: _askFlex,
              child: _stage0,
            ),
            // Group
            Expanded(
              flex: _showIntAnimation.value,
              child: FadeScaleTransition(
                animation: _showAnimation,
                child: _stage1,
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                FadeScaleTransition(
                  animation: _showAnimation,
                  child: _buildPreviousButtion(
                    onPressed: _onPreviousTap,
                  ),
                ),
                _buildNextButton(
                  onPressed: _onNextTap,
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}

// Step 1 : Set repeat time
class MakeStep1 extends StatefulWidget {
  MakeStep1({
    Key key,
    @required this.index,
    @required this.habits,
    @required this.groups,
    this.onSave,
    this.goNext,
    this.goPrevious,
  })  : assert(index != null),
        assert(habits != null),
        assert(groups != null),
        super(key: key);

  final int index;
  final List<Habit> habits;
  final List<Group> groups;
  final void Function(
    Map<int, bool> weeks,
    DateTime whatTime,
    List<Duration> notificationTimes,
  ) onSave;
  final void Function(int index) goNext;
  final void Function(int index) goPrevious;

  @override
  _MakeStep1State createState() => _MakeStep1State();
}

class _MakeStep1State extends State<MakeStep1> with TickerProviderStateMixin {
  // TODO add translation
  final _askWeekString = '반복할 요일을 선택해주세요'.tr;
  final _askWhatTimeString = '몇시에 할 예정이세요?'.tr;
  final _askNoticeTimeString = '언제 알려드릴까요?'.tr;
  final _switchString = '설정 안함'.tr;

  final _weekAlertString = '반복할 요일을 선택해주세요'.tr;

  final _durationPickerMaxHours = 23;

  // Animations
  AnimationController _initController;
  Animation<double> _initAnimation;

  AnimationController _toStage1Controller;
  Animation<double> _toStage1HideAnimation;
  Animation<int> _toStage1HideIntAnimation;
  Animation<double> _toStage1ShowAnimation;
  Animation<int> _toStage1ShowIntAnimation;

  AnimationController _toStage2Controller;
  Animation<double> _toStage2HideAnimation;
  Animation<int> _toStage2HideIntAnimation;
  Animation<double> _toStage2ShowAnimation;
  Animation<int> _toStage2ShowIntAnimation;

  CrossFadeState _stage0CrossFadeState = CrossFadeState.showFirst;
  CrossFadeState _stage1CrossFadeState = CrossFadeState.showFirst;

  // Stage
  int _stage = 0;

  // Result
  Map<int, bool> _weeks = Map<int, bool>();
  bool _weekAlertOn = false;

  DateTime _whatTime = DateTime(0);
  bool _whenever = false;

  // List<Duration> _notificationTimes = List<Duration>();
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

  bool get _isWeekSelected {
    bool result = false;

    _weeks.forEach((key, value) {
      if (value) result = true;
    });

    return result;
  }

  @override
  void initState() {
    for (int i = 0; i < 7; i++) {
      _weeks[i] = false;
    }

    // As default 0, 5, 10, 15, 30 minutes
    _noticeTimeSelection = {
      0: false,
      5: false,
      10: false,
      15: false,
      30: false,
    };

    // Init animations
    _initController = AnimationController(
      duration: const Duration(milliseconds: Constants.mediumAnimationSpeed),
      vsync: this,
    );
    _initAnimation = _initController.drive(
      Tween(begin: 0.0, end: 1.0).chain(CurveTween(curve: Curves.ease)),
    );

    _toStage1Controller = AnimationController(
      duration: const Duration(milliseconds: Constants.largeAnimationSpeed),
      vsync: this,
    )..addStatusListener((status) {
        if (status == AnimationStatus.forward) {
          setState(() {
            _stage0CrossFadeState = CrossFadeState.showSecond;
          });
        } else if (status == AnimationStatus.reverse) {
          setState(() {
            _stage0CrossFadeState = CrossFadeState.showFirst;
          });
        }
      });
    _toStage1HideAnimation = _toStage1Controller.drive(
      Tween(begin: 1.0, end: 0.0).chain(CurveTween(curve: Curves.ease)),
    );
    _toStage1HideIntAnimation = _toStage1Controller.drive(
      IntTween(begin: _askFlex, end: 0).chain(CurveTween(curve: Curves.ease)),
    )..addListener(() {
        setState(() {});
      });
    _toStage1ShowAnimation = _toStage1Controller.drive(
      Tween(begin: 0.0, end: 1.0).chain(CurveTween(curve: Curves.ease)),
    );
    _toStage1ShowIntAnimation = _toStage1Controller.drive(
      IntTween(begin: 0, end: _nextFlex).chain(CurveTween(curve: Curves.ease)),
    )..addListener(() {
        setState(() {});
      });

    _toStage2Controller = AnimationController(
      duration: const Duration(milliseconds: Constants.largeAnimationSpeed),
      vsync: this,
    )..addStatusListener((status) {
        if (status == AnimationStatus.forward) {
          setState(() {
            _stage1CrossFadeState = CrossFadeState.showSecond;
          });
        } else if (status == AnimationStatus.reverse) {
          setState(() {
            _stage1CrossFadeState = CrossFadeState.showFirst;
          });
        }
      });
    _toStage2HideAnimation = _toStage2Controller.drive(
      Tween(begin: 1.0, end: 0.0).chain(CurveTween(curve: Curves.ease)),
    );
    _toStage2HideIntAnimation = _toStage2Controller.drive(
      IntTween(begin: _askFlex, end: 0).chain(CurveTween(curve: Curves.ease)),
    )..addListener(() {
        setState(() {});
      });
    _toStage2ShowAnimation = _toStage2Controller.drive(
      Tween(begin: 0.0, end: 1.0).chain(CurveTween(curve: Curves.ease)),
    );
    _toStage2ShowIntAnimation = _toStage2Controller.drive(
      IntTween(begin: 0, end: _nextFlex * 6)
          .chain(CurveTween(curve: Curves.ease)),
    )..addListener(() {
        setState(() {});
      });

    _initController.forward();

    super.initState();
  }

  @override
  void dispose() {
    _initController.dispose();
    _toStage1Controller.dispose();
    _toStage2Controller.dispose();

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
    switch (_stage) {
      case 2:
        _stage = 1;
        _toStage2Controller.reverse();
        break;
      case 1:
        _stage = 0;
        _toStage1Controller.reverse();
        break;
      case 0:
      default:
        if (widget.goPrevious != null) widget.goPrevious(widget.index);
    }
  }

  void _onNextTap() {
    switch (_stage) {
      case 0:
        if (!_isWeekSelected) {}
        _validateWeek();
        if (_weekAlertOn) return;

        _stage = 1;
        _toStage1Controller.forward();
        break;
      case 1:
        if (_whenever) continue end;
        _stage = 2;
        _toStage2Controller.forward();
        break;
      case 2:
      end:
      default:
        if (widget.onSave != null)
          widget.onSave(
            _weeks,
            _whenever ? null : _whatTime,
            _whenever ? List<Duration>() : _notificationTimes,
          );
        if (widget.goNext != null) widget.goNext(widget.index);
    }
  }

  void _onWeekTap(int index, bool isSelected) {
    setState(() {
      _weekAlertOn = false;
      _weeks[index] = isSelected;
    });
  }

  void _onWhatTimeChanged(DateTime whatTime) {
    setState(() {
      _whatTime = whatTime;
    });
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
              BottomButtons(
                leftButtonAction: () => Navigator.of(context).pop(),
                rightButtonAction: () {
                  setState(() {
                    _noticeTimeSelection[duration.inMinutes] = true;
                  });
                  Navigator.of(context).pop();
                },
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

    /// At first groups is not loaded from database
    /// groups.length is 0 and list will be added only GroupChip.add
    /// then next build groups[0] will GroupChip.add
    if (widget.groups.length == 0) return list;

    _noticeTimeSelection.forEach((key, value) {
      String durationString;
      Key valueKey = ValueKey(key);

      if (key == 0) {
        durationString = Utils.getWhatTimeString(_whatTime);
        valueKey = ValueKey(_whatTime.millisecondsSinceEpoch);
      }

      list.add(
        Padding(
          key: valueKey,
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

  Widget get _stage0 {
    return SizedBox(
      height: 0.0,
      child: Column(
        children: [
          Expanded(
            flex: _toStage1HideIntAnimation.value,
            child: SizedBox(
              height: 0,
              child: FadeScaleTransition(
                animation: _toStage1HideAnimation,
                child: Center(
                  child: Text(
                    _askWeekString,
                    style: _askStringStyle,
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            flex: _mainFlex,
            child: FadeScaleTransition(
              animation: _toStage2HideAnimation,
              child: SizeTransition(
                sizeFactor: _initAnimation,
                axis: Axis.horizontal,
                child: SingleChildScrollView(
                  child: AnimatedCrossFade(
                    duration: _toStage1Controller.duration,
                    firstCurve: Curves.ease,
                    secondCurve: Curves.ease,
                    crossFadeState: _stage0CrossFadeState,
                    firstChild: SingleChildScrollView(
                      child: Column(
                        children: [
                          Alert(
                            alertContent: _buildAlertContent(
                              errorString: _weekAlertString,
                            ),
                            isAlertOn: _weekAlertOn,
                            child: Row(
                              children: WeekCard.buildOneWeek(
                                height: 60.0,
                                onTap: _onWeekTap,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    secondChild: Column(
                      children: [
                        Text(
                          WeekCard.selectedWeeksString(_weeks),
                          style: _inputTextStyle,
                        ),
                        Divider(),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget get _stage1 {
    return SizedBox(
      height: 0.0,
      child: Column(
        children: [
          Expanded(
            flex: _toStage2HideIntAnimation.value,
            child: SizedBox(
              height: 0.0,
              child: FadeScaleTransition(
                animation: _toStage2HideAnimation,
                child: Center(
                  child: Text(
                    _askWhatTimeString,
                    style: _askStringStyle,
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            flex: _mainFlex,
            child: SingleChildScrollView(
              child: AnimatedCrossFade(
                duration: _toStage2Controller.duration,
                firstCurve: Curves.ease,
                secondCurve: Curves.ease,
                crossFadeState: _stage1CrossFadeState,
                firstChild: TimePicker(
                  onTimeChanged: _onWhatTimeChanged,
                  reverseSwitch: true,
                  switchText: Text(
                    _switchString,
                    style: Get.textTheme.bodyText2,
                  ),
                  onStatusChanged: (whenever) {
                    _whenever = !whenever;
                  },
                ),
                secondChild: Column(
                  children: [
                    Text(
                      Utils.getWhatTimeString(_whatTime),
                      style: _inputTextStyle,
                    ),
                    Divider(),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget get _stage2 {
    return SizedBox(
      height: 0.0,
      child: Column(
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
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Expanded(
            flex: _toStage2HideIntAnimation.value,
            child: _stage0,
          ),
          Expanded(
            flex: _toStage1ShowIntAnimation.value,
            child: FadeScaleTransition(
              animation: _toStage1ShowAnimation,
              child: _stage1,
            ),
          ),
          Expanded(
            flex: _toStage2ShowIntAnimation.value,
            child: FadeScaleTransition(
              animation: _toStage2ShowAnimation,
              child: _stage2,
            ),
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
