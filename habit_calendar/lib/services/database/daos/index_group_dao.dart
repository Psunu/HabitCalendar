import 'package:habit_calendar/services/database/app_database.dart';
import 'package:habit_calendar/services/database/tables/index_groups.dart';
import 'package:moor_flutter/moor_flutter.dart';

part 'index_group_dao.g.dart';

@UseDao(tables: [IndexGroups])
class IndexGroupDao extends DatabaseAccessor<AppDatabase>
    with _$IndexGroupDaoMixin {
  final AppDatabase db;

  // Called by the AppDatabase class
  IndexGroupDao(this.db) : super(db);

  Future<List<IndexGroup>> getAllIndexGroups() => select(indexGroups).get();
  Stream<List<IndexGroup>> watchAllIndexGroups() => select(indexGroups).watch();
  Future insertIndexGroup(IndexGroup indexGroup) =>
      into(indexGroups).insert(indexGroup);
  Future updateIndexGroup(IndexGroup indexGroup) =>
      update(indexGroups).replace(indexGroup);
  Future deleteIndexGroup(IndexGroup indexGroup) =>
      delete(indexGroups).delete(indexGroup);
}
