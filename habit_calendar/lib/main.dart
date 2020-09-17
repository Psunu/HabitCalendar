import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:habit_calendar/services/database/database.dart';
import 'package:habit_calendar/views/home.dart';

Future<void> main() async {
  await _initServices();
  runApp(MyApp());
}

Future<void> _initServices() async {
  print('starting services ...');
  await Get.putAsync(() => DbService().init());
  print('All services started...');
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      theme: ThemeData.light().copyWith(primaryColor: Colors.teal[300]),
      home: Home(),
    );
  }
}
