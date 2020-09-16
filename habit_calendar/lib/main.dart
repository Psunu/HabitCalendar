import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:habit_calendar/services/database.dart';
import 'package:habit_calendar/views/home.dart';

Future<void> main() async {
  _initServices();
  runApp(MyApp());
}

void _initServices() async {
  print('starting services ...');
  await Get.putAsync(() => DbService().init());
  print('All services started...');
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      theme: ThemeData(
          textTheme: TextTheme(
        headline1: TextStyle(fontSize: 60.0),
      )),
      home: Home(),
    );
  }
}
