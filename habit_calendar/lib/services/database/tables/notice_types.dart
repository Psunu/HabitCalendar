import 'package:moor_flutter/moor_flutter.dart';

class NoticeTypes extends Table {
  IntColumn get id => integer()();
  TextColumn get type => text()();

  @override
  Set<Column> get primaryKey => {id};
}
