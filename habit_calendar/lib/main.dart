import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:habit_calendar/services/database/db_service.dart';
import 'package:habit_calendar/translations/messages.dart';

import 'package:habit_calendar/views/home.dart';

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
      theme: ThemeData.light().copyWith(
        textTheme: context.textTheme
            .apply(
              bodyColor: Colors.black87,
              displayColor: Colors.black87,
            )
            .copyWith(
              headline5: context.textTheme.headline4.copyWith(
                fontSize: 30.0,
                color: Colors.black87,
              ),
              headline6: context.textTheme.headline6.copyWith(
                color: Colors.black87,
                fontWeight: FontWeight.normal,
              ),
              bodyText1: context.textTheme.bodyText1.copyWith(
                fontSize: 16.0,
                fontWeight: FontWeight.normal,
              ),
            ),
      ),
      home: Home(),
    );
  }
}
