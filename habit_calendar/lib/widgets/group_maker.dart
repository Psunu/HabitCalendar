import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:habit_calendar/constants/constants.dart';
import 'package:habit_calendar/services/database/app_database.dart';
import 'package:habit_calendar/widgets/auto_colored_icon.dart';
import 'package:habit_calendar/widgets/bottom_buttons.dart';
import 'package:habit_calendar/widgets/color_circle.dart';

const _kChipPadding = 13.0;

class GroupMaker extends StatefulWidget {
  GroupMaker({
    Key key,
    @required this.groups,
    @required this.habits,
    this.selectedGroupId,
    this.onSave,
    this.backgroundColor = Colors.white,
    this.outlineColor = Colors.grey,
    this.errorNameEmptyString,
    this.errorNameDuplicatedString,
  })  : assert(groups != null),
        assert(habits != null),
        super(key: key);

  // Group list to check group name duplicated
  final List<Group> groups;

  final List<Habit> habits;

  /// Group id that used to recognize which habits are included in that group
  /// and init habitChipSelection
  final int selectedGroupId;

  final Color backgroundColor;

  final void Function(Group, List<int>) onSave;

  final Color outlineColor;

  final String errorNameEmptyString;

  final String errorNameDuplicatedString;

  @override
  _GroupMakerState createState() => _GroupMakerState();
}

class _GroupMakerState extends State<GroupMaker> with TickerProviderStateMixin {
  bool isNameEmptyAlertOn = false;
  bool isNameDuplicatedAlertOn = false;
  bool isExpanded = false;

  TextEditingController nameController = TextEditingController();
  Color selectedColor = Colors.white;
  Map<int, bool> habitChipSelection = Map<int, bool>();

  AnimationController colorExpandController;
  Animation colorExpandAnimation;
  AnimationController colorController;
  Animation colorAnimation;

  bool get isNameAlertOn => isNameEmptyAlertOn || isNameDuplicatedAlertOn;

  String get nameErrorString => isNameEmptyAlertOn
      ? widget.errorNameEmptyString ?? '폴더 이름을 입력해 주세요'.tr.capitalizeFirst
      : isNameDuplicatedAlertOn
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
        SelectableColorCircle<Color>(
          colorCircle: ColorCircle(
            color: placeHolder ? Colors.white : colors[i],
            outlineColor: placeHolder ? Colors.white : Colors.grey,
          ),
          checkMark: AutoColoredIcon(
            backgroundColor: placeHolder ? Colors.white : colors[i],
            child: Icon(
              Icons.check,
            ),
          ),
          value: placeHolder ? Colors.white : colors[i],
          groupValue: selectedColor,
          onChanged: (value) {
            setState(() {
              selectedColor = value;
            });
          },
          enable: !placeHolder,
          onTap: (selected) {
            setState(() {
              selectedColor = colors[i];
            });
          },
        ),
      );
    }

    if (expand != null) {
      children.add(
        InkWell(
          borderRadius: BorderRadius.circular(Constants.largeBorderRadius),
          onTap: () async {
            setState(() {
              isExpanded = !isExpanded;
            });

            if (isExpanded) {
              await colorController.forward();
              await colorExpandController.forward();
            } else {
              await colorExpandController.reverse();
              await colorController.reverse();
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
        (index) => GestureDetector(
          onTap: () {},
          child: FilterChip(
            elevation: habitChipSelection[widget.habits[index].id] ? 7.0 : 0.0,
            selected: habitChipSelection[widget.habits[index].id],
            onSelected: (selected) {
              setState(() {
                habitChipSelection[widget.habits[index].id] = selected;
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
              style: Get.textTheme.bodyText1,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ),
      ),
    );
  }

  // Name validation
  bool _checkNameError() {
    isNameEmptyAlertOn = false;
    isNameDuplicatedAlertOn = false;

    if (nameController.text.isEmpty) {
      print('name empty');
      setState(() {
        isNameEmptyAlertOn = true;
      });
      return true;
    } else if (_isNameDuplicated) {
      print('name duplicated');
      setState(() {
        isNameDuplicatedAlertOn = true;
      });
      return true;
    }

    return false;
  }

  bool get _isNameDuplicated {
    for (int i = 0; i < widget.groups.length; i++) {
      if (widget.selectedGroupId != null &&
          widget.groups[i].id == widget.selectedGroupId) continue;
      if (widget.groups[i].name.compareTo(nameController.text) == 0) {
        return true;
      }
    }

    return false;
  }

  @override
  void initState() {
    // Init habitChipSelection
    widget.habits.forEach((element) {
      if (widget.selectedGroupId != null &&
          element.groupId == widget.selectedGroupId) {
        habitChipSelection[element.id] = true;
      } else {
        habitChipSelection[element.id] = false;
      }
    });

    colorExpandController = AnimationController(
      duration: Duration(
        milliseconds: Constants.mediumAnimationSpeed,
      ),
      vsync: this,
    );
    colorExpandAnimation = Tween(begin: 0.0, end: 1.0)
        .chain(CurveTween(curve: Curves.ease))
        .animate(colorExpandController);

    colorController = AnimationController(
      duration: Duration(
        milliseconds: Constants.mediumAnimationSpeed,
      ),
      vsync: this,
    );
    colorAnimation = Tween(begin: 1.0, end: 0.0)
        .chain(CurveTween(curve: Curves.ease))
        .animate(colorController);

    super.initState();
  }

  @override
  void dispose() {
    colorExpandController.dispose();
    colorController.dispose();
    nameController.dispose();

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
                                size: isNameAlertOn
                                    ? Get.textTheme.headline6.fontSize * 0.65
                                    : 0.0,
                                color: Colors.red,
                              ),
                              SizedBox(
                                width: 5.0,
                              ),
                              Text(
                                nameErrorString,
                                style: Get.textTheme.bodyText2.copyWith(
                                  fontSize: isNameAlertOn
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
                          controller: nameController,
                          decoration: InputDecoration(
                            hintText: '폴더'.tr.capitalizeFirst + ' ' + '이름'.tr,
                            border: InputBorder.none,
                          ),
                          style: Get.textTheme.headline6,
                          onTap: () {
                            setState(() {
                              isNameEmptyAlertOn = false;
                              isNameDuplicatedAlertOn = false;
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
                    color: selectedColor ?? Colors.white,
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
                    opacity: colorAnimation,
                    child: SizeTransition(
                      sizeFactor: colorAnimation,
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
                    opacity: colorExpandAnimation,
                    child: SizeTransition(
                      sizeFactor: colorExpandAnimation,
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
                rightButtonAction: () {
                  if (_checkNameError()) return;

                  final group = Group(
                    id: widget.selectedGroupId,
                    name: nameController.text,
                    color: selectedColor.value,
                  );

                  final includedHabitId = List<int>();
                  habitChipSelection.forEach((key, value) {
                    if (value) includedHabitId.add(key);
                  });

                  if (widget.onSave != null)
                    widget.onSave(group, includedHabitId);

                  Get.back();
                },
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
    this.onTap,
    this.initStatus,
    this.enable,
  })  : assert(colorCircle != null),
        assert(checkMark != null),
        assert(onChanged != null ? value != null : true),
        super(key: key);

  final ColorCircle colorCircle;
  final Widget checkMark;
  final T value;
  final T groupValue;
  final void Function(T) onChanged;
  final void Function(bool) onTap;
  final bool initStatus;
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
