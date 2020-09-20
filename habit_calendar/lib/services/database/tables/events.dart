import 'package:moor_flutter/moor_flutter.dart';

class Events extends Table {
  IntColumn get id => integer()();
  DateTimeColumn get date => dateTime()();
  IntColumn get completion => integer()();
  IntColumn get habitId => integer().customConstraint(
      'REFERENCES habits (id) ON UPDATE CASCADE ON DELETE CASCADE')();

  @override
  Set<Column> get primaryKey => {id};
}
