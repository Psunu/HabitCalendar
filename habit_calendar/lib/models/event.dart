import 'package:habit_calendar/enums/completion.dart';

class Event {
  int id;
  Completion completion;
  DateTime date;
  int habitId;

  Event(this.id, this.date, this.completion, this.habitId);

  Event.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        date = DateTime.parse(json['date']),
        completion = Completion.values[json['completion']],
        habitId = json['habit_id'];

  Map<String, dynamic> toJson() => {
        'id': id,
        'date': date.toIso8601String(),
        'completion': completion.index,
        'habit_id': habitId,
      };

  String toString() =>
      'id: $id, date: $date, completion: $completion, habitId: $habitId';
}
