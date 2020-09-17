import 'package:habit_calendar/classes/dao.dart';
import 'package:habit_calendar/models/group.dart';
import 'package:sqflite/sqflite.dart';
import 'package:get/get.dart';

class GroupDao extends Dao {
  Stream<List<Group>> liveGroups;
  var groups = List<Group>().obs;
  ConflictAlgorithm conflictAlgorithm = ConflictAlgorithm.replace;

  GroupDao(Database database, {this.conflictAlgorithm}) : super(database);

  @override
  Future<void> createTable() async {
    super.database.execute('''
      CREATE TABLE IF NOT EXISTS groups (
        id INTEGER PRIMARY KEY,
        name TEXT NOT NULL,
        color INTEGER NOT NULL
      );
    ''');
  }

  Future<List<Group>> getAll() async {
    final List<Map<String, dynamic>> maps =
        await super.database.query('groups');
    groups = List.generate(maps.length, (i) => Group.fromJson(maps[i]));
    return groups;
  }
}
