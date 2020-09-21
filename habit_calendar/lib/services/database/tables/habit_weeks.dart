import 'package:moor_flutter/moor_flutter.dart';

class HabitWeeks extends Table {
  IntColumn get habitId => integer().customConstraint(
      'REFERENCES habits (id) ON UPDATE CASCADE ON DELETE CASCADE')();
  IntColumn get week => integer().customConstraint(
      'REFERENCES weeks (id) ON UPDATE CASCADE ON DELETE CASCADE')();

  @override
  Set<Column> get primaryKey => {habitId, week};
}
