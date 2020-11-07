import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:habit_calendar/constants/constants.dart';
import 'package:habit_calendar/controllers/make_habit_controller_edit.dart';
import 'package:habit_calendar/views/make_steps.dart';
import 'package:habit_calendar/widgets/general_purpose/auto_colored_icon.dart';

class MakeHabitView extends StatelessWidget {
  final _sharedAxisTransitionType = SharedAxisTransitionType.vertical;
  MakeHabitController get _controller => MakeHabitController(
        stepsLength: 2,
      );

  final List<Widget> _steps = List<Widget>();

  void init() {
    _steps.add(
      GetX<MakeHabitController>(
        init: _controller,
        builder: (controller) => MakeStep0(
          index: 0,
          habits: controller.habits.toList(),
          groups: controller.groups.toList(),
          nameTextController: controller.nameTextController,
          onAddGroup: controller.dbService.database.groupDao.insertGroup,
          onSave: controller.onStep0Save,
          goNext: controller.goNext,
        ),
      ),
    );
    _steps.add(
      GetX<MakeHabitController>(
        init: _controller,
        builder: (controller) => MakeStep1(
          index: 1,
          habits: controller.habits.toList(),
          groups: controller.groups.toList(),
          onSave: controller.onStep1Save,
          goNext: controller.goNext,
          goPrevious: controller.goPrevious,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    init();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Get.theme.scaffoldBackgroundColor,
        elevation: 0.0,
        leading: IconButton(
          icon: AutoColoredIcon(
            child: Icon(Icons.arrow_back),
            backgroundColor: Get.theme.scaffoldBackgroundColor,
          ),
          onPressed: () => Get.back(),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(Constants.padding),
          child: GetX<MakeHabitController>(
            init: _controller,
            builder: (controller) => PageTransitionSwitcher(
              transitionBuilder: (
                Widget child,
                Animation<double> animation,
                Animation<double> secondaryAnimation,
              ) {
                return SharedAxisTransition(
                  animation: animation,
                  secondaryAnimation: secondaryAnimation,
                  transitionType: _sharedAxisTransitionType,
                  child: child,
                );
              },
              duration: const Duration(
                milliseconds: Constants.largeAnimationSpeed,
              ),
              child: _steps[controller.currentStep.value],
            ),
          ),
        ),
      ),
    );
  }
}
