import 'package:habit_calendar/enums/completion.dart';

final fakeHabits = <Map<String, dynamic>>[
  {
    'id': 1,
    'name': 'habit1',
    'description': 'habit1 description',
    'what_time': DateTime.now().toIso8601String(),
    'notification_time': Duration(minutes: 1).inSeconds,
    'status_bar_fix': 0,
    'group_id': 0,
    'notification_type_id': 0,
  },
  {
    'id': 2,
    'name': 'habit2',
    'description': 'habit2 description',
    'what_time': null,
    'notification_time': null,
    'status_bar_fix': 0,
    'group_id': 0,
    'notification_type_id': 0,
  }
];

final fakeDotws = <Map<String, dynamic>>[
  {
    'habit_id': 1,
    'week': 1,
  },
  {
    'habit_id': 1,
    'week': 2,
  },
  {
    'habit_id': 2,
    'week': 2,
  },
];

final fakeEvents = <Map<String, dynamic>>[
  {
    'id': 1,
    'date': DateTime.now().toIso8601String(),
    'completion': Completion.Ok.index,
    'habit_id': 1,
  },
];
