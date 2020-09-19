import 'package:habit_calendar/enums/completion.dart';

class Event {
  int id;
  DateTime date;
  Completion completion;
  int habitId;

  Event(this.id, this.date, this.completion, this.habitId);

  static final tableName = 'events';
  static final columnId = 'id';
  static final columnDate = 'date';
  static final columnCompletion = 'completion';
  static final columnHabitId = 'habit_id';

  Event.fromJson(Map<String, dynamic> json)
      : id = json[columnId],
        date = DateTime.parse(json[columnDate]),
        completion = Completion.values[json[columnCompletion]],
        habitId = json[columnHabitId];

  Map<String, dynamic> toJson() => {
        columnId: id,
        columnDate: date.toIso8601String(),
        columnCompletion: completion.index,
        columnHabitId: habitId,
      };

  String toString() =>
      '$columnId: $id, $columnDate: $date, $columnCompletion: $completion, $columnHabitId: $habitId';
}
