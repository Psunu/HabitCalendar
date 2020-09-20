import 'package:moor_flutter/moor_flutter.dart';

class Weeks extends Table {
  IntColumn get id => integer()();
  TextColumn get week => text()();

  @override
  Set<Column> get primaryKey => {id};
}
