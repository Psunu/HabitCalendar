import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:habit_calendar/constants/constants.dart';
import 'package:habit_calendar/services/database/app_database.dart';
import 'package:habit_calendar/widgets/color_circle.dart';

class GroupMaker extends StatefulWidget {
  GroupMaker({
    Key key,
    this.onSave,
    this.errorNameEmptyString,
    this.errorNameDuplicatedString,
  }) : super(key: key);

  final void Function(Group) onSave;
  final String errorNameEmptyString;
  final String errorNameDuplicatedString;

  @override
  _GroupMakerState createState() => _GroupMakerState();
}

class _GroupMakerState extends State<GroupMaker> with TickerProviderStateMixin {
  bool isNameAlertOn = false;
  bool isNameEmptyAlertOn = false;
  bool isNameDuplicatedAlertOn = false;
  bool isExpanded = false;

  TextEditingController nameController;
  FocusNode nameFocusNode;
  Color selectedColor;

  String get nameErrorString => isNameEmptyAlertOn
      ? widget.errorNameEmptyString ?? '습관 이름을 입력해 주세요'.tr.capitalizeFirst
      : isNameDuplicatedAlertOn
          ? widget.errorNameDuplicatedString ??
              '이미 진행중인 습관입니다'.tr.capitalizeFirst
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
          checkMark: Icon(
            Icons.check,
            color: Colors.white,
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
          onTap: () {
            setState(() {
              isExpanded = !isExpanded;
            });
          },
          child: ColorCircle(
            child: expand,
          ),
        ),
      );
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: children,
    );
  }

  Widget _buildExpandColumn(
      {@required List<Color> colors, @required int rowLength}) {
    if (colors.isNull || rowLength.isNull) return Container();

    List<Widget> rows = List<Widget>();

    for (int i = 0; i < (colors.length / rowLength).ceil(); i++) {
      rows.add(
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: _buildCircleRow(
            colors: colors
                .getRange(
                    i * rowLength,
                    ((i * rowLength) + rowLength) >= colors.length
                        ? colors.length
                        : (i * rowLength) + rowLength)
                .toList(),
            length: rowLength,
          ),
        ),
      );
    }

    return Column(
      children: rows,
    );
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
                                    ? Get.textTheme.headline6.fontSize * 0.45
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
                                      ? Get.textTheme.headline6.fontSize * 0.45
                                      : 0.0,
                                  color: Colors.red,
                                ),
                              ),
                            ],
                          ),
                        ),
                        TextField(
                          controller: nameController,
                          focusNode: nameFocusNode,
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
                        ),
                      ],
                    ),
                  ),
                  // Group
                  ColorCircle(
                    color: selectedColor ?? Colors.white,
                    width: Get.textTheme.headline6.fontSize,
                    height: Get.textTheme.headline6.fontSize,
                  ),
                ],
              ),
              SizedBox(
                height: 20.0,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
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
              AnimatedSize(
                duration: Duration(
                  milliseconds: Constants.mediumAnimationSpeed,
                ),
                vsync: this,
                curve: Curves.ease,
                child: Container(
                  height: isExpanded ? null : 0.0,
                  child: _buildExpandColumn(
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
              // Weeks
              Divider(),
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

              // if (widget.onTap != null) widget.onTap(_selected);
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
  // @override
  // _SelectableColorCircleState<T> createState() =>
  //     _SelectableColorCircleState<T>();
}

// class _SelectableColorCircleState<T> extends State<SelectableColorCircle<T>> {
//   bool _selected;

//   @override
//   void initState() {
//     _selected = widget.initStatus ?? false;
//     super.initState();
//   }

//   @override
//   Widget build(BuildContext context) {
//     final selected = widget.value == widget.groupValue;

//     return InkWell(
//       borderRadius: BorderRadius.circular(Constants.largeBorderRadius),
//       onTap: widget.enable ?? true
//           ? () {
//               // setState(() {
//               //   _selected = !_selected;
//               // });

//               if (_selected && widget.onChanged != null)
//                 widget.onChanged(widget.value);

//               if (widget.onTap != null) widget.onTap(_selected);
//             }
//           : null,
//       child: Stack(
//         alignment: Alignment.center,
//         children: [
//           widget.colorCircle,
//           selected ? widget.checkMark ?? Container() : Container(),
//         ],
//       ),
//     );
//   }
// }
