import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:habit_calendar/service/database.dart';

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
      home: MyHome(),
    );
  }
}

class MyHome extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Container(
            child: Text("test"),
          ),
        ),
      ),
    );
  }
}
