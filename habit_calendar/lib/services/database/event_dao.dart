import 'package:habit_calendar/classes/dao.dart';
import 'package:habit_calendar/models/event.dart';
import 'package:habit_calendar/models/habit.dart';
import 'package:sqflite/sqflite.dart';
import 'package:get/get.dart';

class EventDao extends Dao {
  Stream<List<Event>> liveEvents;
  var events = List<Event>().obs;
  ConflictAlgorithm conflictAlgorithm = ConflictAlgorithm.replace;

  EventDao(Database database, {this.conflictAlgorithm}) : super(database);

  Future<void> createTable() async {
    super.database.execute('''
      CREATE TABLE ${Event.tableName} (
        ${Event.columnId} INTEGER PRIMARY KEY,
        ${Event.columnDate} TEXT NOT NULL,
        ${Event.columnCompletion} INTEGER NOT NULL,
        ${Event.columnHabitId} INTEGER NOT NULL,
        FOREIGN KEY (${Event.columnHabitId}) REFERENCES habits (${Habit.columnId}) ON UPDATE CASCADE ON DELETE CASCADE
      );
    ''');
  }

  Future<List<Event>> getAll() async {
    final List<Map<String, dynamic>> maps =
        await super.database.query(Event.tableName);
    events = List.generate(maps.length, (i) => Event.fromJson(maps[i]));
    return events;
  }

  Future<void> insert(Event event) async {
    await super.database.insert(
          Event.tableName,
          event.toJson(),
          conflictAlgorithm: conflictAlgorithm,
        );
  }
}
