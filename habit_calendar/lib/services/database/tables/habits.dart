import 'package:moor_flutter/moor_flutter.dart';

class Habits extends Table {
  IntColumn get id => integer()();
  TextColumn get name => text()();
  TextColumn get description => text().nullable()();
  DateTimeColumn get whatTime => dateTime().nullable()();
  IntColumn get notificationTime => integer().nullable()();
  BoolColumn get statusBarFix => boolean().withDefault(const Constant(false))();
  IntColumn get groupId =>
      integer().withDefault(const Constant(0)).customConstraint(
          'DEFAULT 0 REFERENCES groups(id) ON UPDATE CASCADE ON DELETE SET DEFAULT')();
  IntColumn get notificationTypeId =>
      integer().withDefault(const Constant(0)).customConstraint(
          'DEFAULT 0 REFERENCES notification_types (id) ON UPDATE CASCADE ON DELETE SET DEFAULT')();

  @override
  Set<Column> get primaryKey => {id};
}
