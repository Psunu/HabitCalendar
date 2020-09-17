import 'package:sqflite/sqflite.dart';

abstract class Dao {
  final Database database;
  Dao(this.database);

  Future<void> createTable();
}
