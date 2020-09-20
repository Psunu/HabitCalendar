// import 'package:habit_calendar/enums/day_of_the_week.dart';

// class Habit {
//   int id;
//   String name;
//   String description;
//   List<DayOfTheWeek> week = List<DayOfTheWeek>();
//   DateTime whatTime;
//   Duration notificationTime;
//   bool statusBarFix;
//   int groupId;
//   int notificationTypeId;

//   Habit(
//     this.id,
//     this.name,
//     this.description,
//     this.whatTime,
//     this.notificationTime,
//     this.statusBarFix,
//     this.groupId,
//     this.notificationTypeId,
//   );

//   static final tableName = 'habits';
//   static final columnId = 'id';
//   static final columnHabitId = 'habit_id';
//   static final columnName = 'name';
//   static final columnDescription = 'description';
//   static final columnWhatTime = 'what_time';
//   static final columnNotificationTime = 'notification_time';
//   static final columnStatusBarFix = 'status_bar_fix';
//   static final columnGroupId = 'group_id';
//   static final columnNotificationTypeId = 'notification_type_id';

//   Habit.fromJson(Map<String, dynamic> json)
//       : id = json[columnId],
//         name = json[columnName],
//         description = json[columnDescription],
//         whatTime = json[columnWhatTime] != null
//             ? DateTime.parse(json[columnWhatTime])
//             : null,
//         notificationTime = json[columnNotificationTime] != null
//             ? Duration(seconds: json[columnNotificationTime])
//             : null,
//         statusBarFix = json[columnStatusBarFix] == 0 ? false : true,
//         groupId = json[columnGroupId],
//         notificationTypeId = json[columnNotificationTypeId];

//   Map<String, dynamic> toJson() => {
//         columnId: id,
//         columnName: name,
//         columnDescription: description,
//         columnWhatTime: whatTime.toIso8601String(),
//         columnNotificationTime: notificationTime.inSeconds,
//         columnStatusBarFix: statusBarFix ? 1 : 0,
//         columnGroupId: groupId,
//         columnNotificationTypeId: notificationTypeId,
//       };

//   void weekFromJsons(List<Map<String, dynamic>> jsons) {
//     week = List<DayOfTheWeek>();
//     jsons.forEach((element) {
//       if (element[columnHabitId] == id)
//         week.add(DayOfTheWeek.values[element['week'] - 1]);
//     });
//   }

//   List<Map<String, dynamic>> weekToJsons() {
//     var result = List<Map<String, dynamic>>();
//     week.forEach((element) {
//       result.add(
//         {
//           columnHabitId: id,
//           'week': element.index + 1,
//         },
//       );
//     });
//     return result;
//   }

//   String toString() =>
//       '$columnId: $id, $columnName: $name, $columnDescription: $description, week: $week, $columnWhatTime: $whatTime, $columnNotificationTime: $notificationTime, $columnStatusBarFix: $statusBarFix, $groupId: $groupId, $columnNotificationTypeId: $notificationTypeId';
// }
