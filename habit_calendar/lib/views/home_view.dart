import 'package:animations/animations.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/home_controller.dart';
import '../views/make_habit_view.dart';
import '../widgets/general/open_container_fab.dart';

class HomeView extends StatelessWidget {
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
            selectedItemColor: Get.theme.primaryColor,
            selectedFontSize: Get.textTheme.bodyText2.fontSize,
            unselectedFontSize: Get.textTheme.bodyText2.fontSize,
            items: [
              BottomNavigationBarItem(
                icon: const Icon(Icons.home_rounded),
                label: '홈'.tr,
              ),
              BottomNavigationBarItem(
                icon: const Icon(Icons.calendar_today_outlined),
                activeIcon: const Icon(Icons.calendar_today_rounded),
                label: '캘린더'.tr,
              ),
            ],
          ),
          floatingActionButton: OpenContainerFab(
            openPage: MakeHabitView(),
            icon: Icon(
              Icons.add,
              color: Colors.white,
            ),
          )),
    );
  }
}
