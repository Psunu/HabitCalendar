import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:habit_calendar/constants/constants.dart';
import 'package:habit_calendar/services/database/app_database.dart';
import '../general_purpose/auto_colored_icon.dart';
import './bottom_buttons.dart';
import '../general_purpose/color_circle.dart';

const _kChipPadding = 13.0;

class GroupMaker extends StatefulWidget {
  GroupMaker({
    Key key,
    @required this.groups,
    @required this.habits,
    this.selectedGroup,
    this.onSave,
    this.backgroundColor = Colors.white,
    this.outlineColor = Colors.grey,
    this.errorNameEmptyString,
    this.errorNameDuplicatedString,
    this.duration = const Duration(milliseconds: Constants.largeAnimationSpeed),
  })  : assert(groups != null),
        assert(habits != null),
        super(key: key);

  // Group list to check group name duplicated
  final List<Group> groups;

  final List<Habit> habits;

  /// Group id that used to recognize which habits are included in that group
  /// and init habitChipSelection
  final Group selectedGroup;

  final Color backgroundColor;

  final void Function(Group, List<int>) onSave;

  final Color outlineColor;

  final String errorNameEmptyString;

  final String errorNameDuplicatedString;

  final Duration duration;

  @override
  _GroupMakerState createState() => _GroupMakerState();
}

class _GroupMakerState extends State<GroupMaker> with TickerProviderStateMixin {
  bool _isNameEmptyAlertOn = false;
  bool _isNameDuplicatedAlertOn = false;
  bool _isExpanded = false;

  TextEditingController _nameController = TextEditingController();
  Color _selectedColor = Colors.white;
  Map<int, bool> _habitChipSelection = Map<int, bool>();

  AnimationController _colorExpandController;
  Animation _colorExpandAnimation;
  AnimationController _colorController;
  Animation _colorAnimation;

  bool get _isNameAlertOn => _isNameEmptyAlertOn || _isNameDuplicatedAlertOn;

  String get _nameErrorString => _isNameEmptyAlertOn
      ? widget.errorNameEmptyString ?? '폴더 이름을 입력해 주세요'.tr.capitalizeFirst
      : _isNameDuplicatedAlertOn
          ? widget.errorNameDuplicatedString ?? '폴더가 이미 있습니다'.tr.capitalizeFirst
          : '';

  Widget _buildCircleRow(
      {@required List<Color> colors, int length, Widget expand}) {
    if (colors.isNull) return Container();

    List<Widget> children = List<Widget>();

    bool placeHolder = false;
    int _length = length ?? colors.length;
    for (int i = 0; i < _length; i++) {
      placeHolder = i >= colors.length;
      children.add(
        SelectableColorCircle<int>(
          colorCircle: ColorCircle(
            color: placeHolder ? Colors.white : colors[i],
            outlineColor: placeHolder ? Colors.white : Colors.grey,
          ),
          checkMark: placeHolder
              ? null
              : AutoColoredIcon(
                  backgroundColor: placeHolder ? Colors.white : colors[i],
                  child: Icon(
                    Icons.check,
                  ),
                ),
          value: placeHolder ? Colors.white.value : colors[i].value,
          groupValue: _selectedColor.value,
          onChanged: (value) {
            setState(() {
              _selectedColor = Color(value);
            });
          },
          enable: !placeHolder,
        ),
      );
    }

    if (expand != null) {
      children.add(
        InkWell(
          borderRadius: BorderRadius.circular(Constants.largeBorderRadius),
          onTap: () async {
            setState(() {
              _isExpanded = !_isExpanded;
            });

            if (_isExpanded) {
              await _colorController.forward();
              await _colorExpandController.forward();
            } else {
              await _colorExpandController.reverse();
              await _colorController.reverse();
            }
          },
          child: ColorCircle(
            child: expand,
          ),
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: children,
      ),
    );
  }

  Widget _buildExpandColumn({
    @required List<Color> colors,
    @required int rowLength,
    Widget firstRow,
  }) {
    if (colors.isNull || rowLength.isNull) return Container();

    List<Widget> rows = List<Widget>();

    if (firstRow != null) rows.add(firstRow);

    for (int i = 0; i < (colors.length / rowLength).ceil(); i++) {
      rows.add(
        _buildCircleRow(
          colors: colors
              .getRange(
                  i * rowLength,
                  ((i * rowLength) + rowLength) >= colors.length
                      ? colors.length
                      : (i * rowLength) + rowLength)
              .toList(),
          length: rowLength,
        ),
      );
    }

    return Column(
      children: rows,
    );
  }

  Widget _buildHabitsWrap() {
    return Wrap(
      spacing: 16.0,
      children: List.generate(
        widget.habits.length,
        (index) {
          /// edit mode and default group is selected and this habit is in default group
          /// this filter chip will be disabled (text will be grey and can not be tapped)
          final bool isDefaultGroup = widget.habits[index].groupId == 0 &&
                  widget.selectedGroup?.id == 0 ??
              false;

          return FilterChip(
            elevation: _habitChipSelection[widget.habits[index].id] ? 7.0 : 0.0,
            selected: _habitChipSelection[widget.habits[index].id],
            onSelected: isDefaultGroup
                ? null
                : (selected) {
                    setState(() {
                      _habitChipSelection[widget.habits[index].id] = selected;
                    });
                  },
            backgroundColor: widget.backgroundColor,
            selectedColor: widget.backgroundColor,
            shape: RoundedRectangleBorder(
              side: BorderSide(color: widget.outlineColor),
              borderRadius: BorderRadius.circular(Constants.largeBorderRadius),
            ),
            labelPadding: const EdgeInsets.symmetric(
              horizontal: _kChipPadding,
            ),
            label: Text(
              widget.habits[index].name,
              style: isDefaultGroup
                  ? Get.textTheme.bodyText1.copyWith(color: Colors.grey)
                  : Get.textTheme.bodyText1,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          );
        },
      ),
    );
  }

  void _onSave() {
    if (_checkNameError()) return;

    /// Instatiate Group
    /// If add group. then group.id is null (auto increment)
    /// if edit group. then group id is selected group.id
    final group = Group(
      id: widget.selectedGroup?.id,
      name: _nameController.text,
      color: _selectedColor.value,
    );

    /// Make selected habits to list
    final includedHabitId = List<int>();
    _habitChipSelection.forEach((key, value) {
      if (value) includedHabitId.add(key);
    });

    if (widget.onSave != null) widget.onSave(group, includedHabitId);

    Get.back();
  }

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
    for (int i = 0; i < widget.groups.length; i++) {
      if (widget.selectedGroup != null &&
          widget.groups[i].id == widget.selectedGroup.id) continue;
      if (widget.groups[i].name.compareTo(_nameController.text) == 0) {
        return true;
      }
    }

    return false;
  }

  @override
  void initState() {
    // Init habitChipSelection
    widget.habits.forEach((element) {
      if (widget.selectedGroup != null &&
          element.groupId == widget.selectedGroup.id) {
        _habitChipSelection[element.id] = true;
      } else {
        _habitChipSelection[element.id] = false;
      }
    });

    // Init animations
    _colorExpandController = AnimationController(
      duration: Duration(
        milliseconds: Constants.mediumAnimationSpeed,
      ),
      vsync: this,
    );
    _colorExpandAnimation = Tween(begin: 0.0, end: 1.0)
        .chain(CurveTween(curve: Curves.ease))
        .animate(_colorExpandController);

    _colorController = AnimationController(
      duration: Duration(
        milliseconds: Constants.mediumAnimationSpeed,
      ),
      vsync: this,
    );
    _colorAnimation = Tween(begin: 1.0, end: 0.0)
        .chain(CurveTween(curve: Curves.ease))
        .animate(_colorController);

    // When edit group
    if (widget.selectedGroup != null) {
      _nameController.text = widget.selectedGroup.name;
      _selectedColor = Color(widget.selectedGroup.color);
    }

    super.initState();
  }

  @override
  void dispose() {
    _colorExpandController.dispose();
    _colorController.dispose();
    _nameController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      type: MaterialType.transparency,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  // Name
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Name error
                        AnimatedSize(
                          vsync: this,
                          duration: const Duration(
                            milliseconds: Constants.smallAnimationSpeed,
                          ),
                          child: Row(
                            children: [
                              Icon(
                                Icons.error_outline,
                                size: _isNameAlertOn
                                    ? Get.textTheme.headline6.fontSize * 0.65
                                    : 0.0,
                                color: Colors.red,
                              ),
                              SizedBox(
                                width: 5.0,
                              ),
                              Text(
                                _nameErrorString,
                                style: Get.textTheme.bodyText2.copyWith(
                                  fontSize: _isNameAlertOn
                                      ? Get.textTheme.headline6.fontSize * 0.65
                                      : 0.0,
                                  color: Colors.red,
                                ),
                              ),
                            ],
                          ),
                        ),
                        // Name text
                        TextField(
                          controller: _nameController,
                          decoration: InputDecoration(
                            hintText: '폴더'.tr.capitalizeFirst + ' ' + '이름'.tr,
                            border: InputBorder.none,
                          ),
                          style: Get.textTheme.headline6,
                          onTap: () {
                            setState(() {
                              _isNameEmptyAlertOn = false;
                              _isNameDuplicatedAlertOn = false;
                            });
                          },
                          onEditingComplete: () {
                            if (!_checkNameError()) {
                              Get.focusScope.unfocus();
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                  // Group
                  ColorCircle(
                    color: _selectedColor ?? Colors.white,
                    width: Get.textTheme.headline6.fontSize * 1.2,
                    height: Get.textTheme.headline6.fontSize * 1.2,
                  ),
                ],
              ),
              SizedBox(
                height: 20.0,
              ),
              Stack(
                alignment: Alignment.topCenter,
                children: [
                  // Color
                  FadeTransition(
                    opacity: _colorAnimation,
                    child: SizeTransition(
                      sizeFactor: _colorAnimation,
                      child: _buildCircleRow(
                        colors: [
                          Colors.red,
                          Colors.orange,
                          Colors.yellow,
                          Colors.green,
                          Colors.blue,
                        ],
                        expand: Icon(Icons.expand_more),
                      ),
                    ),
                  ),
                  // Color expand
                  FadeTransition(
                    opacity: _colorExpandAnimation,
                    child: SizeTransition(
                      sizeFactor: _colorExpandAnimation,
                      child: Container(
                        // height: isExpanded ? null : 0.0,
                        child: _buildExpandColumn(
                          firstRow: _buildCircleRow(
                            colors: [
                              Colors.red,
                              Colors.orange,
                              Colors.yellow,
                              Colors.green,
                              Colors.blue,
                            ],
                            expand: Icon(Icons.expand_less),
                          ),
                          colors: [
                            Colors.red,
                            Colors.orange,
                            Colors.yellow,
                            Colors.green,
                            Colors.blue,
                            Colors.purple,
                            Colors.red,
                            Colors.orange,
                            Colors.yellow,
                            Colors.green,
                            Colors.blue,
                            Colors.purple,
                            Colors.red,
                            Colors.orange,
                            Colors.yellow,
                            Colors.green,
                            Colors.blue,
                          ],
                          rowLength: 6,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Divider(),
              // Habits
              _buildHabitsWrap(),
              // Buttons
              BottomButtons(
                margin: const EdgeInsets.all(0.0),
                padding: const EdgeInsets.all(0.0),
                rightButtonAction: _onSave,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class SelectableColorCircle<T> extends StatelessWidget {
  SelectableColorCircle({
    Key key,
    @required this.colorCircle,
    this.checkMark,
    @required this.value,
    @required this.groupValue,
    @required this.onChanged,
    this.enable,
  })  : assert(colorCircle != null),
        assert(onChanged != null ? value != null : true),
        super(key: key);

  final ColorCircle colorCircle;
  final Widget checkMark;
  final T value;
  final T groupValue;
  final void Function(T) onChanged;
  final bool enable;

  @override
  Widget build(BuildContext context) {
    final selected = value == groupValue;

    return InkWell(
      borderRadius: BorderRadius.circular(Constants.largeBorderRadius),
      onTap: enable ?? true
          ? () {
              if (onChanged != null) onChanged(value);
            }
          : null,
      child: Stack(
        alignment: Alignment.center,
        children: [
          colorCircle,
          selected ? checkMark ?? Container() : Container(),
        ],
      ),
    );
  }
}
