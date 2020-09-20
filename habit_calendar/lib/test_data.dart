import 'package:habit_calendar/enums/completion.dart';

final fakeHabits = <Map<String, dynamic>>[
  {
    'id': 0,
    'name': 'habit1',
    'description': 'habit1 description',
    'whatTime': DateTime.now().microsecondsSinceEpoch,
    'notificationTime': Duration(minutes: 1).inSeconds,
    'statusBarFix': false,
    'groupId': 0,
    'notificationTypeId': 0,
  },
  {
    'id': 2,
    'name': 'habit2',
    'description': 'habit2 description',
    'whatTime': null,
    'notificationTime': null,
    'statusBarFix': false,
    'groupId': 0,
    'notificationTypeId': 0,
  }
];

final fakeDotws = <Map<String, dynamic>>[
  {
    'habitId': 0,
    'week': 6,
  },
  {
    'habitId': 1,
    'week': 2,
  },
  {
    'habitId': 2,
    'week': 2,
  },
];

final fakeEvents = <Map<String, dynamic>>[
  {
    'id': 1,
    'date': DateTime.now().toIso8601String(),
    'completion': Completion.Ok.index,
    'habitId': 1,
  },
];
