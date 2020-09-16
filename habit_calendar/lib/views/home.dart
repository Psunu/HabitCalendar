import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:habit_calendar/controllers/home_controller.dart';

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<HomeController>(
      init: HomeController(),
      builder: (controller) => Scaffold(
        body: SafeArea(
          child: controller.pages[controller.currentIndex],
        ),
        bottomNavigationBar: BottomNavigationBar(
          onTap: controller.onBottomNavTapped,
          currentIndex: controller.currentIndex,
          items: [
            const BottomNavigationBarItem(
              icon: const Icon(Icons.home),
              title: const Text('Home'),
            ),
            const BottomNavigationBarItem(
              icon: const Icon(Icons.calendar_today),
              title: const Text('Calendar'),
            ),
          ],
        ),
      ),
    );
  }
}
