import 'package:habit_calendar/services/database/app_database.dart';
import 'package:habit_calendar/services/database/tables/events.dart';
import 'package:moor_flutter/moor_flutter.dart';

part 'event_dao.g.dart';

@UseDao(tables: [Events])
class EventDao extends DatabaseAccessor<AppDatabase> with _$EventDaoMixin {
  final AppDatabase db;

  // Called by the AppDatabase class
  EventDao(this.db) : super(db);

  Future<List<Event>> getAllEvents() => select(events).get();
  Stream<List<Event>> watchAllEvents() => select(events).watch();
  Future insertEvent(Event event) => into(events).insert(event);
  Future updateEvent(Event event) => update(events).replace(event);
  Future deleteEvent(Event event) => delete(events).delete(event);
}
