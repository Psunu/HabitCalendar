import 'package:habit_calendar/enums/day_of_the_week.dart';

class Habit {
  int id;
  String name;
  String description;
  List<DayOfTheWeek> dotw = List<DayOfTheWeek>();
  DateTime whatTime;
  Duration notificationTime;
  bool statusBarFix;
  int groupId;
  int notificationTypeId;

  Habit(
    this.id,
    this.name,
    this.description,
    this.whatTime,
    this.notificationTime,
    this.statusBarFix,
    this.groupId,
    this.notificationTypeId,
  );

  Habit.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        name = json['name'],
        description = json['description'],
        whatTime = json['what_time'] != null
            ? DateTime.parse(json['what_time'])
            : null,
        notificationTime = json['notification_time'] != null
            ? Duration(seconds: json['notification_time'])
            : null,
        statusBarFix = json['status_bar_fix'] == 0 ? false : true,
        groupId = json['group_id'],
        notificationTypeId = json['notification_type_id'];

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'description': description,
        'what_time': whatTime.toIso8601String(),
        'notification_time': notificationTime.inSeconds,
        'status_bar_fix': statusBarFix ? 1 : 0,
        'group_id': groupId,
        'notification_type_id': notificationTypeId,
      };

  void dotwFromJsons(List<Map<String, dynamic>> jsons) {
    dotw = List<DayOfTheWeek>();
    jsons.forEach((element) {
      if (element['habit_id'] == id)
        dotw.add(DayOfTheWeek.values[element['week'] - 1]);
    });
  }

  List<Map<String, dynamic>> dotwToJsons() {
    var result = List<Map<String, dynamic>>();
    dotw.forEach((element) {
      result.add(
        {
          'habit_id': id,
          'week': element.index + 1,
        },
      );
    });
    return result;
  }

  String toString() =>
      'id: $id, name: $name, description: $description, dotw: $dotw, whatTime: $whatTime, notificationTime: $notificationTime, statusBarFix: $statusBarFix, groupId: $groupId, notificationTypeId: $notificationTypeId';
}
