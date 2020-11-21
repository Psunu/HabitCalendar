import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:habit_calendar/constants/constants.dart';
import 'package:habit_calendar/services/database/db_service.dart';
import 'package:habit_calendar/translations/messages.dart';
import 'package:habit_calendar/views/home_view.dart';

Future<void> main() async {
  await _initServices();
  runApp(MyApp());
}

Future<void> _initServices() async {
  print('starting services ...');
  Get.lazyPut(() => DbService().init());
  print('All services started...');
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      translations: Messages(),
      // locale: Locale('en', 'US'),
      locale: window.locale,

      fallbackLocale: Locale('ko', 'KR'),

      theme: ThemeData.light().copyWith(
        scaffoldBackgroundColor: const Color(Constants.lightScaffoldColor),
        primaryColor: const Color(Constants.primaryColor),
        accentColor: const Color(Constants.accentColor),
        textTheme: context.textTheme
            .apply(
              bodyColor: const Color(Constants.black),
              displayColor: const Color(Constants.black),
            )
            .copyWith(
              headline4: context.textTheme.headline4.copyWith(
                fontSize: 28.0,
                color: const Color(Constants.black),
              ),
              headline5: context.textTheme.headline5.copyWith(
                color: const Color(Constants.black),
              ),
              headline6: context.textTheme.headline6.copyWith(
                color: const Color(Constants.black),
                fontWeight: FontWeight.normal,
              ),
              bodyText1: context.textTheme.bodyText1.copyWith(
                color: const Color(Constants.black),
                fontSize: 16.0,
                fontWeight: FontWeight.normal,
              ),
              bodyText2: context.textTheme.bodyText1.copyWith(
                color: const Color(Constants.black),
                fontSize: 14.0,
                fontWeight: FontWeight.normal,
              ),
            ),
      ),
      home: HomeView(),
    );
  }
}
