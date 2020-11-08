import 'package:habit_calendar/services/database/app_database.dart';
import 'package:habit_calendar/services/database/tables/notice_types.dart';
import 'package:moor_flutter/moor_flutter.dart';

part 'notice_type_dao.g.dart';

@UseDao(tables: [NoticeTypes])
class NoticeTypeDao extends DatabaseAccessor<AppDatabase>
    with _$NoticeTypeDaoMixin {
  final AppDatabase db;

  // Called by the AppDatabase class
  NoticeTypeDao(this.db) : super(db);

  Future<List<NoticeType>> getAllNoticeTypes() => select(noticeTypes).get();
  Stream<List<NoticeType>> watchAllNoticeTypes() => select(noticeTypes).watch();
  Future insertNoticeType(NoticeType noticeType) =>
      into(noticeTypes).insert(noticeType);
  Future updateNoticeType(NoticeType noticeType) =>
      update(noticeTypes).replace(noticeType);
  Future deleteNoticeType(NoticeType noticeType) =>
      delete(noticeTypes).delete(noticeType);
}
