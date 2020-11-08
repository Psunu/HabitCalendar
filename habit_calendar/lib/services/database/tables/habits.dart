import 'package:moor_flutter/moor_flutter.dart';

class Habits extends Table {
  IntColumn get id => integer()();
  TextColumn get name => text()();
  DateTimeColumn get whatTime => dateTime().nullable()();
  TextColumn get memo => text().nullable()();
  TextColumn get noticeMessage => text().nullable()();
  IntColumn get groupId =>
      integer().withDefault(const Constant(0)).customConstraint(
          'DEFAULT 0 REFERENCES groups(id) ON UPDATE CASCADE ON DELETE SET DEFAULT')();
  IntColumn get noticeTypeId =>
      integer().withDefault(const Constant(0)).customConstraint(
          'DEFAULT 0 REFERENCES notice_types (id) ON UPDATE CASCADE ON DELETE SET DEFAULT')();

  @override
  Set<Column> get primaryKey => {id};
}
