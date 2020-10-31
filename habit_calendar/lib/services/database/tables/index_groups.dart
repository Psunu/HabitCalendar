import 'package:moor_flutter/moor_flutter.dart';

class IndexGroups extends Table {
  IntColumn get groupId => integer().customConstraint(
      'REFERENCES groups (id) ON UPDATE CASCADE ON DELETE CASCADE')();
  IntColumn get indx => integer()();

  @override
  Set<Column> get primaryKey => {groupId};
}
