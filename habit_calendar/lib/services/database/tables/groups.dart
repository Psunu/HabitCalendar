import 'package:moor_flutter/moor_flutter.dart';

class Groups extends Table {
  IntColumn get id => integer()();
  TextColumn get name => text()();
  IntColumn get color => integer()();

  @override
  Set<Column> get primaryKey => {id};
}
