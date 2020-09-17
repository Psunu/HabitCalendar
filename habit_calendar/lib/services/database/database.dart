import 'dart:async';

import 'package:flutter/material.dart';
import 'package:habit_calendar/classes/dao.dart';
import 'package:habit_calendar/services/database/event_dao.dart';
import 'package:habit_calendar/services/database/group_dao.dart';
import 'package:habit_calendar/services/database/habit_dao.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:get/get.dart';

class DbService extends GetxService {
  Database _database;
  Database get database => _database;
  List<Dao> daos = List<Dao>();

  Future<DbService> init() async {
    WidgetsFlutterBinding.ensureInitialized();

    _database = await openDatabase(
      join(await getDatabasesPath(), 'habit_calendar_database.db'),
      version: 1,
      onCreate: (db, version) async {
        initDaos(db);
        await db.execute('''
          PRAGMA foreign_keys = ON;

          CREATE TABLE IF NOT EXISTS notification_type (
            id INTEGER PRIMARY KEY,
            type TEXT
          );
        ''');
        daos.forEach((element) async => await element.createTable());
      },
    );
    initDaos(_database);

    return this;
  }

  void initDaos(Database database) {
    if (daos.isEmpty) {
      daos.add(GroupDao(database));
      daos.add(HabitDao(database));
      daos.add(EventDao(database));
    }
  }

  T getDao<T>() {
    T result;
    daos.forEach((element) {
      if (element is T) result = element as T;
    });

    return result;
  }
}
