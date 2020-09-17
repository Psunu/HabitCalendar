import 'package:habit_calendar/classes/dao.dart';
import 'package:habit_calendar/models/event.dart';
import 'package:sqflite/sqflite.dart';
import 'package:get/get.dart';

class EventDao extends Dao {
  Stream<List<Event>> liveEvents;
  var events = List<Event>().obs;
  ConflictAlgorithm conflictAlgorithm = ConflictAlgorithm.replace;

  EventDao(Database database, {this.conflictAlgorithm}) : super(database);

  Future<void> createTable() async {
    super.database.execute('''
      CREATE TABLE events (
        id INTEGER PRIMARY KEY,
        date TEXT NOT NULL,
        completion INTEGER NOT NULL,
        habit_id INTEGER NOT NULL,
        FOREIGN KEY (habit_id) REFERENCES habits (id) ON UPDATE CASCADE ON DELETE CASCADE
      );
    ''');
  }

  Future<List<Event>> getAll() async {
    final List<Map<String, dynamic>> maps =
        await super.database.query('events');
    events = List.generate(maps.length, (i) => Event.fromJson(maps[i]));
    return events;
  }

  Future<void> insert(Event event) async {
    await super.database.insert(
          'events',
          event.toJson(),
          conflictAlgorithm: conflictAlgorithm,
        );
  }
}
