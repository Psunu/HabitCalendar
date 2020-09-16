class Event {
  int id;
  DateTime date;
  int habitId;

  Event(this.id, this.date, this.habitId);

  Event.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        date = json['date'],
        habitId = json['habit_id'];

  Map<String, dynamic> toJson() => {
        'id': id,
        'date': date.toIso8601String(),
        'habit_id': habitId,
      };
}
