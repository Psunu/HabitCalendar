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

  Future<List<Group>> getAllGroups() => (select(groups).join(
        [
          leftOuterJoin(
            indexGroups,
            indexGroups.groupId.equalsExp(groups.id),
          )
        ],
      )..orderBy(
              [
                // First order : index
                OrderingTerm(
                  expression: indexGroups.indx,
                  mode: OrderingMode.asc,
                ),

                /// When index is mixed and some groups are removed and added
                /// index can be duplicated.
                /// Second order is groups id. because latest group id is
                /// awalys heighest
                OrderingTerm(
                  expression: groups.id,
                  mode: OrderingMode.asc,
                ),
              ],
            ))
          .map((row) => row.readTable(groups))
          .get();
  Stream<List<Group>> watchAllGroups() => (select(groups).join(
        [
          leftOuterJoin(
            indexGroups,
            indexGroups.groupId.equalsExp(groups.id),
          ),
        ],
      )..orderBy(
              [
                // First order : index
                OrderingTerm(
                  expression: indexGroups.indx,
                  mode: OrderingMode.asc,
                ),

                /// When index is mixed and some groups are removed and added
                /// index can be duplicated.
                /// Second order is groups id. because latest group id is
                /// awalys heighest
                OrderingTerm(
                  expression: groups.id,
                  mode: OrderingMode.asc,
                ),
              ],
            ))
          .watch()
          .map(
            (rows) => rows
                .map(
                  (row) => row.readTable(groups),
                )
                .toList(),
          );

  Future<Group> getGroupById(int id) =>
      (select(groups)..where((group) => group.id.equals(id))).getSingle();
  Future<int> insertGroup(Group group) async {
    return transaction<int>(() async {
      final int id = await into(groups).insert(group);
      await into(indexGroups).insert(IndexGroup(groupId: id, indx: id));

      return id;
    });
  }

  Future<bool> updateGroup(Group group) => update(groups).replace(group);
  Future<int> deleteGroup(Group group) async {
    // Prevent to delete default folder
    if (group.id == 0) return 0;

    return delete(groups).delete(group);
  }

  Future<int> deleteAllGroupsById(List<int> groupIds) async {
    return transaction(() async {
      int numDeleted = 0;

      for (final groupId in groupIds) {
        // Prevent to delete default folder
        if (groupId == 0) continue;

        numDeleted +=
            await (delete(groups)..where((tbl) => tbl.id.equals(groupId))).go();
      }

      return numDeleted;
    });
  }
}
