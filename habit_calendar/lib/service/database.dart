import 'dart:async';

import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:get/get.dart';

class DbService extends GetxService {
  Database _database;
  Database get database => _database;

  Future<DbService> init() async {
    WidgetsFlutterBinding.ensureInitialized();

    _database = await openDatabase(
      join(await getDatabasesPath(), 'habit_calendar_database.db'),
    );

    _database.execute('''
      PRAGMA foreign_keys = ON;
      
      CREATE TABLE groups (
        id INTEGER PRIMARY KEY,
        name TEXT NOT NULL,
        color INTEGER NOT NULL
      );
      
      CREATE TABLE notification_type (
        id INTEGER PRIMARY KEY,
        type TEXT
      );
      
      CREATE TABLE habits (
        id INTEGER PRIMARY KEY,
        name TEXT NOT NULL,
        description TEXT,
        when TEXT,
        notification_time INTEGER,
        status_bar_fix INTEGER NOT NULL DEFAULT 0,
        group_id INTEGER NOT NULL DEFAULT 0,
        notification_type_id INTEGER NOT NULL DEFAULT 0,
        FOREIGN KEY group_id REFERENCES groups (id) on UPDATE CASCADE ON DELETE SET 0,
        FOREIGN key notification_type_id REFERENCES notification_type (id) on update CASCADE on delete set 0
      );

      CREATE TABLE habits_week (
        habit_id INTEGER,
        week INTEGER,
        FOREIGN KEY habit_id REFERENCES habits (id) on UPDATE CASCADE ON DELETE CASCADE
      );
     
      CREATE TABLE events (
        id INTEGER PRIMARY KEY,
        date TEXT not NULL,
        habit_id INTEGER,
        FOREIGN KEY habit_id REFERENCES habits (id) ON UPDATE CASCADE ON DELETE CASCADE
      );
    ''');

    return this;
  }
}
