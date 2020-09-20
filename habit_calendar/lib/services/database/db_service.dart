import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:habit_calendar/services/database/app_database.dart';

class DbService extends GetxService {
  AppDatabase _database;
  AppDatabase get database => _database;

  DbService init() {
    WidgetsFlutterBinding.ensureInitialized();
    _database = AppDatabase();
    return this;
  }
}
