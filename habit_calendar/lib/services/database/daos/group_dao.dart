import 'package:habit_calendar/services/database/app_database.dart';
import 'package:habit_calendar/services/database/tables/groups.dart';
import 'package:habit_calendar/services/database/tables/index_groups.dart';
import 'package:moor_flutter/moor_flutter.dart';

part 'group_dao.g.dart';

@UseDao(tables: [Groups, IndexGroups])
class GroupDao extends DatabaseAccessor<AppDatabase> with _$GroupDaoMixin {
  final AppDatabase db;

  // Called by the AppDatabase class
  GroupDao(this.db) : super(db);

  // TODO order by indexgroup
  Future<List<Group>> getAllGroups() => (select(groups)
        ..orderBy(
          [
            (t) => OrderingTerm(expression: t.id),
          ],
        ))
      .get();
  Stream<List<Group>> watchAllGroups() => (select(groups)
        ..orderBy(
          [
            (t) => OrderingTerm(expression: t.id),
          ],
        ))
      .watch();
  Future<Group> getGroupById(int id) =>
      (select(groups)..where((group) => group.id.equals(id))).getSingle();
  Future<int> insertGroup(Group group) async {
    final int id = await into(groups).insert(group);
    await into(indexGroups).insert(IndexGroup(groupId: id, index: id));

    return id;
  }

  Future<bool> updateGroup(Group group) => update(groups).replace(group);
  Future<int> deleteGroup(Group group) => delete(groups).delete(group);
}
