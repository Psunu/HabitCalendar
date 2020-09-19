import 'package:habit_calendar/classes/dao.dart';
import 'package:habit_calendar/models/notification_type.dart';
import 'package:sqflite/sqflite.dart';
import 'package:get/get.dart';

class NotificationTypeDao extends Dao {
  var notificationTypes = List<NotificationType>().obs;
  ConflictAlgorithm conflictAlgorithm = ConflictAlgorithm.replace;

  NotificationTypeDao(Database database, {this.conflictAlgorithm})
      : super(database);

  @override
  Future<void> createTable() async {
    super.database.execute('''
          CREATE TABLE IF NOT EXISTS ${NotificationType.tableName} (
            ${NotificationType.columnId} INTEGER PRIMARY KEY,
            ${NotificationType.columnType} TEXT
          );
    ''');
  }

  Future<List<NotificationType>> getAll() async {
    final List<Map<String, dynamic>> maps =
        await super.database.query(NotificationType.tableName);
    notificationTypes =
        List.generate(maps.length, (i) => NotificationType.fromJson(maps[i]));
    return notificationTypes;
  }

  Future<NotificationType> getNotificationTypeById(int id) async {
    final maps = await super.database.query(NotificationType.tableName,
        where: '${NotificationType.columnId} = ?', whereArgs: [id]);
    if (maps.isEmpty)
      return null;
    else
      return NotificationType.fromJson(maps[0]);
  }

  Future<void> insert(NotificationType notificationType) async {
    await super.database.insert(
          NotificationType.tableName,
          notificationType.toJson(),
          conflictAlgorithm: conflictAlgorithm,
        );

    NotificationType data = await getNotificationTypeById(notificationType.id);
    onUpdateOrInsert(data, (i) => observable[i].id == notificationType.id);
  }

  Future<void> update(NotificationType notificationType) async {
    await super.database.update(
        NotificationType.tableName, notificationType.toJson(),
        where: '${NotificationType.columnId} = ?',
        whereArgs: [notificationType.id]);

    NotificationType data = await getNotificationTypeById(notificationType.id);
    onUpdateOrInsert(data, (i) => observable[i].id == notificationType.id);
  }

  Future<void> delete(NotificationType notificationType) async {
    await super.database.delete(NotificationType.tableName,
        where: '${NotificationType.columnId} == ?',
        whereArgs: [notificationType.id]);
    onDelete(notificationType,
        (index) => observable[index].id == notificationType.id);
  }
}
