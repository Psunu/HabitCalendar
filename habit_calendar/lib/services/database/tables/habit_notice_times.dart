import 'package:moor_flutter/moor_flutter.dart';

class HabitNoticeTimes extends Table {
  IntColumn get id => integer()();
  IntColumn get noticeTime => integer()();
  IntColumn get habitId => integer().customConstraint(
      'REFERENCES habits (id) ON UPDATE CASCADE ON DELETE CASCADE')();

  @override
  Set<Column> get primaryKey => {id};
}
