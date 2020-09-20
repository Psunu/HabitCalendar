import 'package:habit_calendar/services/database/app_database.dart';
import 'package:habit_calendar/services/database/tables/notification_types.dart';
import 'package:moor_flutter/moor_flutter.dart';

part 'notification_type_dao.g.dart';

@UseDao(tables: [NotificationTypes])
class NotificationTypeDao extends DatabaseAccessor<AppDatabase>
    with _$NotificationTypeDaoMixin {
  final AppDatabase db;

  // Called by the AppDatabase class
  NotificationTypeDao(this.db) : super(db);

  Future<List<NotificationType>> getAllNotificationTypes() =>
      select(notificationTypes).get();
  Stream<List<NotificationType>> watchAllNotificationTypes() =>
      select(notificationTypes).watch();
  Future insertNotificationType(NotificationType notificationType) =>
      into(notificationTypes).insert(notificationType);
  Future updateNotificationType(NotificationType notificationType) =>
      update(notificationTypes).replace(notificationType);
  Future deleteNotificationType(NotificationType notificationType) =>
      delete(notificationTypes).delete(notificationType);
}
