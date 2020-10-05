import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:animations/animations.dart';
import 'package:habit_calendar/widgets/open_container_fab.dart';

import '../controllers/home_controller.dart';
import '../views/make_habit.dart';

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<HomeController>(
      init: HomeController(),
      builder: (controller) => Scaffold(
          body: PageTransitionSwitcher(
            transitionBuilder: (
              Widget child,
              Animation<double> primaryAnimation,
              Animation<double> secondaryAnimation,
            ) {
              return FadeThroughTransition(
                child: SafeArea(child: child),
                animation: primaryAnimation,
                secondaryAnimation: secondaryAnimation,
              );
            },
            child: controller.pages[controller.currentIndex],
          ),
          bottomNavigationBar: BottomNavigationBar(
            onTap: controller.onBottomNavTapped,
            currentIndex: controller.currentIndex,
            items: [
              const BottomNavigationBarItem(
                icon: const Icon(Icons.home),
                label: 'Home',
              ),
              const BottomNavigationBarItem(
                icon: const Icon(Icons.calendar_today),
                label: 'Calendar',
              ),
            ],
          ),
          floatingActionButton: OpenContainerFab(
            openPage: MakeHabit(),
            icon: Icon(
              Icons.add,
              color: Colors.white,
            ),
          )),
    );
  }
}
