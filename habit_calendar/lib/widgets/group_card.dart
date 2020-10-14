import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:habit_calendar/constants/constants.dart';
import 'package:habit_calendar/services/database/app_database.dart';
import 'package:habit_calendar/widgets/group_circle.dart';

// TODO implment GroupCard
// Center text
// overflow problem
class GroupCard extends StatefulWidget {
  const GroupCard({
    Key key,
    @required this.groupName,
    @required this.numGroupMembers,
    @required this.groupMembers,
    @required this.color,
    this.colorCircleSize = 20.0,
    this.width,
    this.height = 90.0,
  }) : super(key: key);

  final Text groupName;
  final Text numGroupMembers;
  final List<Habit> groupMembers;
  final Color color;
  final double colorCircleSize;
  final double width;
  final double height;

  @override
  _GroupCardState createState() => _GroupCardState();
}

class _GroupCardState extends State<GroupCard> {
  double get _width => widget.width ?? Get.context.width;
  bool expanded = false;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(0.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(
          Constants.mediumBorderRadius,
        ),
      ),
      child: AnimatedContainer(
        duration: Duration(
          milliseconds: Constants.mediumAnimationSpeed,
        ),
        curve: Curves.ease,
        margin: const EdgeInsets.only(
          left: 15.0,
        ),
        width: _width,
        height: expanded
            ? widget.height + widget.height * widget.groupMembers.length
            : widget.height,
        child: Stack(
          children: [
            Column(
              // mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: 40.0,
                    ),
                    widget.groupName,
                    Expanded(
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: widget.numGroupMembers,
                      ),
                    ),
                    IconButton(
                      splashColor: Colors.transparent,
                      icon: Icon(
                        expanded ? Icons.expand_less : Icons.expand_more,
                      ),
                      onPressed: () {
                        setState(
                          () {
                            expanded = !expanded;
                          },
                        );
                      },
                    ),
                  ],
                ),
                expanded ? _buildExpand() : Container(),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: GroupCircle(
                color: widget.color,
                height: widget.colorCircleSize,
                width: widget.colorCircleSize,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildExpand() {
    return Column(
      children: List.generate(
        widget.groupMembers.length,
        (index) => Card(
          margin: const EdgeInsets.all(0.0),
          child: Container(
            width: _width,
            height: widget.height,
            child: Row(
              children: [
                Text(
                  widget.groupMembers[index].name,
                  style: Get.textTheme.headline6,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
