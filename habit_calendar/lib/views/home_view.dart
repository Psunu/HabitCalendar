import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:animations/animations.dart';
import 'package:habit_calendar/utils/utils.dart';

import '../widgets/general_purpose/open_container_fab.dart';
import '../controllers/home_controller.dart';
import '../views/make_habit_view.dart';

class HomeView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<HomeController>(
      init: HomeController(),
      builder: (controller) => Scaffold(
          appBar: AppBar(
            backgroundColor: Get.theme.scaffoldBackgroundColor,
            elevation: 0.0,
            leading: IconButton(
              icon: Icon(
                Icons.menu,
                color: Get.textTheme.bodyText2.color,
              ),
              onPressed: () => controller.navigateToManage(),
            ),
            title: Align(
              alignment: Alignment.centerRight,
              child: Text(
                Utils.getFormedDate(
                  DateTime.now(),
                ),
                style: Get.textTheme.bodyText1,
              ),
            ),
          ),
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
