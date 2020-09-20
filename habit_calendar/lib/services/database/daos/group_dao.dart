import 'package:habit_calendar/services/database/app_database.dart';
import 'package:habit_calendar/services/database/tables/groups.dart';
import 'package:moor_flutter/moor_flutter.dart';

part 'group_dao.g.dart';

@UseDao(tables: [Groups])
class GroupDao extends DatabaseAccessor<AppDatabase> with _$GroupDaoMixin {
  final AppDatabase db;

  // Called by the AppDatabase class
  GroupDao(this.db) : super(db);

  Future<List<Group>> getAllGroups() => select(groups).get();
  Stream<List<Group>> watchAllGroups() => select(groups).watch();
  Future insertGroup(Group group) => into(groups).insert(group);
  Future updateGroup(Group group) => update(groups).replace(group);
  Future deleteGroup(Group group) => delete(groups).delete(group);
}