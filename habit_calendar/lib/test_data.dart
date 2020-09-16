final fakeHabits = <Map<String, dynamic>>[
  {
    'id': 1,
    'name': 'habit1',
    'description': 'habit1 description',
    'when': DateTime.now().toIso8601String(),
    'notification_time': Duration(minutes: 1).inSeconds,
    'status_bar_fix': 0,
    'group_id': 0,
    'notification_type_id': 0,
  },
  {
    'id': 2,
    'name': 'habit2',
    'description': 'habit2 description',
    'when': null,
    'notification_time': null,
    'status_bar_fix': 0,
    'group_id': 0,
    'notification_type_id': 0,
  }
];
