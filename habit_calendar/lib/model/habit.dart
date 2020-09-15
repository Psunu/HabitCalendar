import 'package:habit_calendar/enums/day_of_the_week.dart';

class Habit {
  int id;
  String name;
  String description;
  DayOfTheWeek dayOfTheWeek;
  DateTime when;
  Duration notificationTime;
  bool statusBarFix;
  int groupId;
  int notificationTypeId;

  Habit({
    this.id,
    this.name,
    this.description,
    this.dayOfTheWeek,
    this.when,
    this.notificationTime,
    this.statusBarFix,
    this.groupId,
    this.notificationTypeId,
  });

  Habit.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        name = json['name'],
        description = json['description'],
        dayOfTheWeek = DayOfTheWeek.values[json['day_of_the_week']],
        when = DateTime.parse(json['when']),
        notificationTime = Duration(seconds: json['notification_time']),
        statusBarFix = json['status_bar_fix'] == 0 ? false : true,
        groupId = json['group_id'],
        notificationTypeId = json['notification_type_id'];

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'description': description,
        'day_of_the_week': dayOfTheWeek.index,
        'when': when.toIso8601String(),
        'notification_time': notificationTime.inSeconds,
        'status_bar_fix': statusBarFix ? 1 : 0,
        'group_id': groupId,
        'notification_type_id': notificationTypeId,
      };
}
