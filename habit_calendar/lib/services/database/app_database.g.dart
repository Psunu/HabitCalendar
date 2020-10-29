// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// **************************************************************************
// MoorGenerator
// **************************************************************************

// ignore_for_file: unnecessary_brace_in_string_interps, unnecessary_this
class Group extends DataClass implements Insertable<Group> {
  final int id;
  final String name;
  final int color;
  Group({@required this.id, @required this.name, @required this.color});
  factory Group.fromData(Map<String, dynamic> data, GeneratedDatabase db,
      {String prefix}) {
    final effectivePrefix = prefix ?? '';
    final intType = db.typeSystem.forDartType<int>();
    final stringType = db.typeSystem.forDartType<String>();
    return Group(
      id: intType.mapFromDatabaseResponse(data['${effectivePrefix}id']),
      name: stringType.mapFromDatabaseResponse(data['${effectivePrefix}name']),
      color: intType.mapFromDatabaseResponse(data['${effectivePrefix}color']),
    );
  }
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (!nullToAbsent || id != null) {
      map['id'] = Variable<int>(id);
    }
    if (!nullToAbsent || name != null) {
      map['name'] = Variable<String>(name);
    }
    if (!nullToAbsent || color != null) {
      map['color'] = Variable<int>(color);
    }
    return map;
  }

  GroupsCompanion toCompanion(bool nullToAbsent) {
    return GroupsCompanion(
      id: id == null && nullToAbsent ? const Value.absent() : Value(id),
      name: name == null && nullToAbsent ? const Value.absent() : Value(name),
      color:
          color == null && nullToAbsent ? const Value.absent() : Value(color),
    );
  }

  factory Group.fromJson(Map<String, dynamic> json,
      {ValueSerializer serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return Group(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      color: serializer.fromJson<int>(json['color']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'color': serializer.toJson<int>(color),
    };
  }

  Group copyWith({int id, String name, int color}) => Group(
        id: id ?? this.id,
        name: name ?? this.name,
        color: color ?? this.color,
      );
  @override
  String toString() {
    return (StringBuffer('Group(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('color: $color')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      $mrjf($mrjc(id.hashCode, $mrjc(name.hashCode, color.hashCode)));
  @override
  bool operator ==(dynamic other) =>
      identical(this, other) ||
      (other is Group &&
          other.id == this.id &&
          other.name == this.name &&
          other.color == this.color);
}

class GroupsCompanion extends UpdateCompanion<Group> {
  final Value<int> id;
  final Value<String> name;
  final Value<int> color;
  const GroupsCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.color = const Value.absent(),
  });
  GroupsCompanion.insert({
    this.id = const Value.absent(),
    @required String name,
    @required int color,
  })  : name = Value(name),
        color = Value(color);
  static Insertable<Group> custom({
    Expression<int> id,
    Expression<String> name,
    Expression<int> color,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (color != null) 'color': color,
    });
  }

  GroupsCompanion copyWith(
      {Value<int> id, Value<String> name, Value<int> color}) {
    return GroupsCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      color: color ?? this.color,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (color.present) {
      map['color'] = Variable<int>(color.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('GroupsCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('color: $color')
          ..write(')'))
        .toString();
  }
}

class $GroupsTable extends Groups with TableInfo<$GroupsTable, Group> {
  final GeneratedDatabase _db;
  final String _alias;
  $GroupsTable(this._db, [this._alias]);
  final VerificationMeta _idMeta = const VerificationMeta('id');
  GeneratedIntColumn _id;
  @override
  GeneratedIntColumn get id => _id ??= _constructId();
  GeneratedIntColumn _constructId() {
    return GeneratedIntColumn(
      'id',
      $tableName,
      false,
    );
  }

  final VerificationMeta _nameMeta = const VerificationMeta('name');
  GeneratedTextColumn _name;
  @override
  GeneratedTextColumn get name => _name ??= _constructName();
  GeneratedTextColumn _constructName() {
    return GeneratedTextColumn(
      'name',
      $tableName,
      false,
    );
  }

  final VerificationMeta _colorMeta = const VerificationMeta('color');
  GeneratedIntColumn _color;
  @override
  GeneratedIntColumn get color => _color ??= _constructColor();
  GeneratedIntColumn _constructColor() {
    return GeneratedIntColumn(
      'color',
      $tableName,
      false,
    );
  }

  @override
  List<GeneratedColumn> get $columns => [id, name, color];
  @override
  $GroupsTable get asDslTable => this;
  @override
  String get $tableName => _alias ?? 'groups';
  @override
  final String actualTableName = 'groups';
  @override
  VerificationContext validateIntegrity(Insertable<Group> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id'], _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name'], _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('color')) {
      context.handle(
          _colorMeta, color.isAcceptableOrUnknown(data['color'], _colorMeta));
    } else if (isInserting) {
      context.missing(_colorMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Group map(Map<String, dynamic> data, {String tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : null;
    return Group.fromData(data, _db, prefix: effectivePrefix);
  }

  @override
  $GroupsTable createAlias(String alias) {
    return $GroupsTable(_db, alias);
  }
}

class NotificationType extends DataClass
    implements Insertable<NotificationType> {
  final int id;
  final String type;
  NotificationType({@required this.id, @required this.type});
  factory NotificationType.fromData(
      Map<String, dynamic> data, GeneratedDatabase db,
      {String prefix}) {
    final effectivePrefix = prefix ?? '';
    final intType = db.typeSystem.forDartType<int>();
    final stringType = db.typeSystem.forDartType<String>();
    return NotificationType(
      id: intType.mapFromDatabaseResponse(data['${effectivePrefix}id']),
      type: stringType.mapFromDatabaseResponse(data['${effectivePrefix}type']),
    );
  }
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (!nullToAbsent || id != null) {
      map['id'] = Variable<int>(id);
    }
    if (!nullToAbsent || type != null) {
      map['type'] = Variable<String>(type);
    }
    return map;
  }

  NotificationTypesCompanion toCompanion(bool nullToAbsent) {
    return NotificationTypesCompanion(
      id: id == null && nullToAbsent ? const Value.absent() : Value(id),
      type: type == null && nullToAbsent ? const Value.absent() : Value(type),
    );
  }

  factory NotificationType.fromJson(Map<String, dynamic> json,
      {ValueSerializer serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return NotificationType(
      id: serializer.fromJson<int>(json['id']),
      type: serializer.fromJson<String>(json['type']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'type': serializer.toJson<String>(type),
    };
  }

  NotificationType copyWith({int id, String type}) => NotificationType(
        id: id ?? this.id,
        type: type ?? this.type,
      );
  @override
  String toString() {
    return (StringBuffer('NotificationType(')
          ..write('id: $id, ')
          ..write('type: $type')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => $mrjf($mrjc(id.hashCode, type.hashCode));
  @override
  bool operator ==(dynamic other) =>
      identical(this, other) ||
      (other is NotificationType &&
          other.id == this.id &&
          other.type == this.type);
}

class NotificationTypesCompanion extends UpdateCompanion<NotificationType> {
  final Value<int> id;
  final Value<String> type;
  const NotificationTypesCompanion({
    this.id = const Value.absent(),
    this.type = const Value.absent(),
  });
  NotificationTypesCompanion.insert({
    this.id = const Value.absent(),
    @required String type,
  }) : type = Value(type);
  static Insertable<NotificationType> custom({
    Expression<int> id,
    Expression<String> type,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (type != null) 'type': type,
    });
  }

  NotificationTypesCompanion copyWith({Value<int> id, Value<String> type}) {
    return NotificationTypesCompanion(
      id: id ?? this.id,
      type: type ?? this.type,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (type.present) {
      map['type'] = Variable<String>(type.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('NotificationTypesCompanion(')
          ..write('id: $id, ')
          ..write('type: $type')
          ..write(')'))
        .toString();
  }
}

class $NotificationTypesTable extends NotificationTypes
    with TableInfo<$NotificationTypesTable, NotificationType> {
  final GeneratedDatabase _db;
  final String _alias;
  $NotificationTypesTable(this._db, [this._alias]);
  final VerificationMeta _idMeta = const VerificationMeta('id');
  GeneratedIntColumn _id;
  @override
  GeneratedIntColumn get id => _id ??= _constructId();
  GeneratedIntColumn _constructId() {
    return GeneratedIntColumn(
      'id',
      $tableName,
      false,
    );
  }

  final VerificationMeta _typeMeta = const VerificationMeta('type');
  GeneratedTextColumn _type;
  @override
  GeneratedTextColumn get type => _type ??= _constructType();
  GeneratedTextColumn _constructType() {
    return GeneratedTextColumn(
      'type',
      $tableName,
      false,
    );
  }

  @override
  List<GeneratedColumn> get $columns => [id, type];
  @override
  $NotificationTypesTable get asDslTable => this;
  @override
  String get $tableName => _alias ?? 'notification_types';
  @override
  final String actualTableName = 'notification_types';
  @override
  VerificationContext validateIntegrity(Insertable<NotificationType> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id'], _idMeta));
    }
    if (data.containsKey('type')) {
      context.handle(
          _typeMeta, type.isAcceptableOrUnknown(data['type'], _typeMeta));
    } else if (isInserting) {
      context.missing(_typeMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  NotificationType map(Map<String, dynamic> data, {String tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : null;
    return NotificationType.fromData(data, _db, prefix: effectivePrefix);
  }

  @override
  $NotificationTypesTable createAlias(String alias) {
    return $NotificationTypesTable(_db, alias);
  }
}

class Week extends DataClass implements Insertable<Week> {
  final int id;
  final String week;
  Week({@required this.id, @required this.week});
  factory Week.fromData(Map<String, dynamic> data, GeneratedDatabase db,
      {String prefix}) {
    final effectivePrefix = prefix ?? '';
    final intType = db.typeSystem.forDartType<int>();
    final stringType = db.typeSystem.forDartType<String>();
    return Week(
      id: intType.mapFromDatabaseResponse(data['${effectivePrefix}id']),
      week: stringType.mapFromDatabaseResponse(data['${effectivePrefix}week']),
    );
  }
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (!nullToAbsent || id != null) {
      map['id'] = Variable<int>(id);
    }
    if (!nullToAbsent || week != null) {
      map['week'] = Variable<String>(week);
    }
    return map;
  }

  WeeksCompanion toCompanion(bool nullToAbsent) {
    return WeeksCompanion(
      id: id == null && nullToAbsent ? const Value.absent() : Value(id),
      week: week == null && nullToAbsent ? const Value.absent() : Value(week),
    );
  }

  factory Week.fromJson(Map<String, dynamic> json,
      {ValueSerializer serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return Week(
      id: serializer.fromJson<int>(json['id']),
      week: serializer.fromJson<String>(json['week']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'week': serializer.toJson<String>(week),
    };
  }

  Week copyWith({int id, String week}) => Week(
        id: id ?? this.id,
        week: week ?? this.week,
      );
  @override
  String toString() {
    return (StringBuffer('Week(')
          ..write('id: $id, ')
          ..write('week: $week')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => $mrjf($mrjc(id.hashCode, week.hashCode));
  @override
  bool operator ==(dynamic other) =>
      identical(this, other) ||
      (other is Week && other.id == this.id && other.week == this.week);
}

class WeeksCompanion extends UpdateCompanion<Week> {
  final Value<int> id;
  final Value<String> week;
  const WeeksCompanion({
    this.id = const Value.absent(),
    this.week = const Value.absent(),
  });
  WeeksCompanion.insert({
    this.id = const Value.absent(),
    @required String week,
  }) : week = Value(week);
  static Insertable<Week> custom({
    Expression<int> id,
    Expression<String> week,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (week != null) 'week': week,
    });
  }

  WeeksCompanion copyWith({Value<int> id, Value<String> week}) {
    return WeeksCompanion(
      id: id ?? this.id,
      week: week ?? this.week,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (week.present) {
      map['week'] = Variable<String>(week.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('WeeksCompanion(')
          ..write('id: $id, ')
          ..write('week: $week')
          ..write(')'))
        .toString();
  }
}

class $WeeksTable extends Weeks with TableInfo<$WeeksTable, Week> {
  final GeneratedDatabase _db;
  final String _alias;
  $WeeksTable(this._db, [this._alias]);
  final VerificationMeta _idMeta = const VerificationMeta('id');
  GeneratedIntColumn _id;
  @override
  GeneratedIntColumn get id => _id ??= _constructId();
  GeneratedIntColumn _constructId() {
    return GeneratedIntColumn(
      'id',
      $tableName,
      false,
    );
  }

  final VerificationMeta _weekMeta = const VerificationMeta('week');
  GeneratedTextColumn _week;
  @override
  GeneratedTextColumn get week => _week ??= _constructWeek();
  GeneratedTextColumn _constructWeek() {
    return GeneratedTextColumn(
      'week',
      $tableName,
      false,
    );
  }

  @override
  List<GeneratedColumn> get $columns => [id, week];
  @override
  $WeeksTable get asDslTable => this;
  @override
  String get $tableName => _alias ?? 'weeks';
  @override
  final String actualTableName = 'weeks';
  @override
  VerificationContext validateIntegrity(Insertable<Week> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id'], _idMeta));
    }
    if (data.containsKey('week')) {
      context.handle(
          _weekMeta, week.isAcceptableOrUnknown(data['week'], _weekMeta));
    } else if (isInserting) {
      context.missing(_weekMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Week map(Map<String, dynamic> data, {String tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : null;
    return Week.fromData(data, _db, prefix: effectivePrefix);
  }

  @override
  $WeeksTable createAlias(String alias) {
    return $WeeksTable(_db, alias);
  }
}

class Habit extends DataClass implements Insertable<Habit> {
  final int id;
  final String name;
  final String description;
  final DateTime whatTime;
  final int notificationTime;
  final bool statusBarFix;
  final int groupId;
  final int notificationTypeId;
  Habit(
      {@required this.id,
      @required this.name,
      this.description,
      this.whatTime,
      this.notificationTime,
      @required this.statusBarFix,
      @required this.groupId,
      @required this.notificationTypeId});
  factory Habit.fromData(Map<String, dynamic> data, GeneratedDatabase db,
      {String prefix}) {
    final effectivePrefix = prefix ?? '';
    final intType = db.typeSystem.forDartType<int>();
    final stringType = db.typeSystem.forDartType<String>();
    final dateTimeType = db.typeSystem.forDartType<DateTime>();
    final boolType = db.typeSystem.forDartType<bool>();
    return Habit(
      id: intType.mapFromDatabaseResponse(data['${effectivePrefix}id']),
      name: stringType.mapFromDatabaseResponse(data['${effectivePrefix}name']),
      description: stringType
          .mapFromDatabaseResponse(data['${effectivePrefix}description']),
      whatTime: dateTimeType
          .mapFromDatabaseResponse(data['${effectivePrefix}what_time']),
      notificationTime: intType
          .mapFromDatabaseResponse(data['${effectivePrefix}notification_time']),
      statusBarFix: boolType
          .mapFromDatabaseResponse(data['${effectivePrefix}status_bar_fix']),
      groupId:
          intType.mapFromDatabaseResponse(data['${effectivePrefix}group_id']),
      notificationTypeId: intType.mapFromDatabaseResponse(
          data['${effectivePrefix}notification_type_id']),
    );
  }
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (!nullToAbsent || id != null) {
      map['id'] = Variable<int>(id);
    }
    if (!nullToAbsent || name != null) {
      map['name'] = Variable<String>(name);
    }
    if (!nullToAbsent || description != null) {
      map['description'] = Variable<String>(description);
    }
    if (!nullToAbsent || whatTime != null) {
      map['what_time'] = Variable<DateTime>(whatTime);
    }
    if (!nullToAbsent || notificationTime != null) {
      map['notification_time'] = Variable<int>(notificationTime);
    }
    if (!nullToAbsent || statusBarFix != null) {
      map['status_bar_fix'] = Variable<bool>(statusBarFix);
    }
    if (!nullToAbsent || groupId != null) {
      map['group_id'] = Variable<int>(groupId);
    }
    if (!nullToAbsent || notificationTypeId != null) {
      map['notification_type_id'] = Variable<int>(notificationTypeId);
    }
    return map;
  }

  HabitsCompanion toCompanion(bool nullToAbsent) {
    return HabitsCompanion(
      id: id == null && nullToAbsent ? const Value.absent() : Value(id),
      name: name == null && nullToAbsent ? const Value.absent() : Value(name),
      description: description == null && nullToAbsent
          ? const Value.absent()
          : Value(description),
      whatTime: whatTime == null && nullToAbsent
          ? const Value.absent()
          : Value(whatTime),
      notificationTime: notificationTime == null && nullToAbsent
          ? const Value.absent()
          : Value(notificationTime),
      statusBarFix: statusBarFix == null && nullToAbsent
          ? const Value.absent()
          : Value(statusBarFix),
      groupId: groupId == null && nullToAbsent
          ? const Value.absent()
          : Value(groupId),
      notificationTypeId: notificationTypeId == null && nullToAbsent
          ? const Value.absent()
          : Value(notificationTypeId),
    );
  }

  factory Habit.fromJson(Map<String, dynamic> json,
      {ValueSerializer serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return Habit(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      description: serializer.fromJson<String>(json['description']),
      whatTime: serializer.fromJson<DateTime>(json['whatTime']),
      notificationTime: serializer.fromJson<int>(json['notificationTime']),
      statusBarFix: serializer.fromJson<bool>(json['statusBarFix']),
      groupId: serializer.fromJson<int>(json['groupId']),
      notificationTypeId: serializer.fromJson<int>(json['notificationTypeId']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'description': serializer.toJson<String>(description),
      'whatTime': serializer.toJson<DateTime>(whatTime),
      'notificationTime': serializer.toJson<int>(notificationTime),
      'statusBarFix': serializer.toJson<bool>(statusBarFix),
      'groupId': serializer.toJson<int>(groupId),
      'notificationTypeId': serializer.toJson<int>(notificationTypeId),
    };
  }

  Habit copyWith(
          {int id,
          String name,
          String description,
          DateTime whatTime,
          int notificationTime,
          bool statusBarFix,
          int groupId,
          int notificationTypeId}) =>
      Habit(
        id: id ?? this.id,
        name: name ?? this.name,
        description: description ?? this.description,
        whatTime: whatTime ?? this.whatTime,
        notificationTime: notificationTime ?? this.notificationTime,
        statusBarFix: statusBarFix ?? this.statusBarFix,
        groupId: groupId ?? this.groupId,
        notificationTypeId: notificationTypeId ?? this.notificationTypeId,
      );
  @override
  String toString() {
    return (StringBuffer('Habit(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('description: $description, ')
          ..write('whatTime: $whatTime, ')
          ..write('notificationTime: $notificationTime, ')
          ..write('statusBarFix: $statusBarFix, ')
          ..write('groupId: $groupId, ')
          ..write('notificationTypeId: $notificationTypeId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => $mrjf($mrjc(
      id.hashCode,
      $mrjc(
          name.hashCode,
          $mrjc(
              description.hashCode,
              $mrjc(
                  whatTime.hashCode,
                  $mrjc(
                      notificationTime.hashCode,
                      $mrjc(
                          statusBarFix.hashCode,
                          $mrjc(groupId.hashCode,
                              notificationTypeId.hashCode))))))));
  @override
  bool operator ==(dynamic other) =>
      identical(this, other) ||
      (other is Habit &&
          other.id == this.id &&
          other.name == this.name &&
          other.description == this.description &&
          other.whatTime == this.whatTime &&
          other.notificationTime == this.notificationTime &&
          other.statusBarFix == this.statusBarFix &&
          other.groupId == this.groupId &&
          other.notificationTypeId == this.notificationTypeId);
}

class HabitsCompanion extends UpdateCompanion<Habit> {
  final Value<int> id;
  final Value<String> name;
  final Value<String> description;
  final Value<DateTime> whatTime;
  final Value<int> notificationTime;
  final Value<bool> statusBarFix;
  final Value<int> groupId;
  final Value<int> notificationTypeId;
  const HabitsCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.description = const Value.absent(),
    this.whatTime = const Value.absent(),
    this.notificationTime = const Value.absent(),
    this.statusBarFix = const Value.absent(),
    this.groupId = const Value.absent(),
    this.notificationTypeId = const Value.absent(),
  });
  HabitsCompanion.insert({
    this.id = const Value.absent(),
    @required String name,
    this.description = const Value.absent(),
    this.whatTime = const Value.absent(),
    this.notificationTime = const Value.absent(),
    this.statusBarFix = const Value.absent(),
    this.groupId = const Value.absent(),
    this.notificationTypeId = const Value.absent(),
  }) : name = Value(name);
  static Insertable<Habit> custom({
    Expression<int> id,
    Expression<String> name,
    Expression<String> description,
    Expression<DateTime> whatTime,
    Expression<int> notificationTime,
    Expression<bool> statusBarFix,
    Expression<int> groupId,
    Expression<int> notificationTypeId,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (description != null) 'description': description,
      if (whatTime != null) 'what_time': whatTime,
      if (notificationTime != null) 'notification_time': notificationTime,
      if (statusBarFix != null) 'status_bar_fix': statusBarFix,
      if (groupId != null) 'group_id': groupId,
      if (notificationTypeId != null)
        'notification_type_id': notificationTypeId,
    });
  }

  HabitsCompanion copyWith(
      {Value<int> id,
      Value<String> name,
      Value<String> description,
      Value<DateTime> whatTime,
      Value<int> notificationTime,
      Value<bool> statusBarFix,
      Value<int> groupId,
      Value<int> notificationTypeId}) {
    return HabitsCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      whatTime: whatTime ?? this.whatTime,
      notificationTime: notificationTime ?? this.notificationTime,
      statusBarFix: statusBarFix ?? this.statusBarFix,
      groupId: groupId ?? this.groupId,
      notificationTypeId: notificationTypeId ?? this.notificationTypeId,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (whatTime.present) {
      map['what_time'] = Variable<DateTime>(whatTime.value);
    }
    if (notificationTime.present) {
      map['notification_time'] = Variable<int>(notificationTime.value);
    }
    if (statusBarFix.present) {
      map['status_bar_fix'] = Variable<bool>(statusBarFix.value);
    }
    if (groupId.present) {
      map['group_id'] = Variable<int>(groupId.value);
    }
    if (notificationTypeId.present) {
      map['notification_type_id'] = Variable<int>(notificationTypeId.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('HabitsCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('description: $description, ')
          ..write('whatTime: $whatTime, ')
          ..write('notificationTime: $notificationTime, ')
          ..write('statusBarFix: $statusBarFix, ')
          ..write('groupId: $groupId, ')
          ..write('notificationTypeId: $notificationTypeId')
          ..write(')'))
        .toString();
  }
}

class $HabitsTable extends Habits with TableInfo<$HabitsTable, Habit> {
  final GeneratedDatabase _db;
  final String _alias;
  $HabitsTable(this._db, [this._alias]);
  final VerificationMeta _idMeta = const VerificationMeta('id');
  GeneratedIntColumn _id;
  @override
  GeneratedIntColumn get id => _id ??= _constructId();
  GeneratedIntColumn _constructId() {
    return GeneratedIntColumn(
      'id',
      $tableName,
      false,
    );
  }

  final VerificationMeta _nameMeta = const VerificationMeta('name');
  GeneratedTextColumn _name;
  @override
  GeneratedTextColumn get name => _name ??= _constructName();
  GeneratedTextColumn _constructName() {
    return GeneratedTextColumn(
      'name',
      $tableName,
      false,
    );
  }

  final VerificationMeta _descriptionMeta =
      const VerificationMeta('description');
  GeneratedTextColumn _description;
  @override
  GeneratedTextColumn get description =>
      _description ??= _constructDescription();
  GeneratedTextColumn _constructDescription() {
    return GeneratedTextColumn(
      'description',
      $tableName,
      true,
    );
  }

  final VerificationMeta _whatTimeMeta = const VerificationMeta('whatTime');
  GeneratedDateTimeColumn _whatTime;
  @override
  GeneratedDateTimeColumn get whatTime => _whatTime ??= _constructWhatTime();
  GeneratedDateTimeColumn _constructWhatTime() {
    return GeneratedDateTimeColumn(
      'what_time',
      $tableName,
      true,
    );
  }

  final VerificationMeta _notificationTimeMeta =
      const VerificationMeta('notificationTime');
  GeneratedIntColumn _notificationTime;
  @override
  GeneratedIntColumn get notificationTime =>
      _notificationTime ??= _constructNotificationTime();
  GeneratedIntColumn _constructNotificationTime() {
    return GeneratedIntColumn(
      'notification_time',
      $tableName,
      true,
    );
  }

  final VerificationMeta _statusBarFixMeta =
      const VerificationMeta('statusBarFix');
  GeneratedBoolColumn _statusBarFix;
  @override
  GeneratedBoolColumn get statusBarFix =>
      _statusBarFix ??= _constructStatusBarFix();
  GeneratedBoolColumn _constructStatusBarFix() {
    return GeneratedBoolColumn('status_bar_fix', $tableName, false,
        defaultValue: const Constant(false));
  }

  final VerificationMeta _groupIdMeta = const VerificationMeta('groupId');
  GeneratedIntColumn _groupId;
  @override
  GeneratedIntColumn get groupId => _groupId ??= _constructGroupId();
  GeneratedIntColumn _constructGroupId() {
    return GeneratedIntColumn('group_id', $tableName, false,
        $customConstraints:
            'REFERENCES groups(id) ON UPDATE CASCADE ON DELETE SET DEFAULT',
        defaultValue: const Constant(0));
  }

  final VerificationMeta _notificationTypeIdMeta =
      const VerificationMeta('notificationTypeId');
  GeneratedIntColumn _notificationTypeId;
  @override
  GeneratedIntColumn get notificationTypeId =>
      _notificationTypeId ??= _constructNotificationTypeId();
  GeneratedIntColumn _constructNotificationTypeId() {
    return GeneratedIntColumn('notification_type_id', $tableName, false,
        $customConstraints:
            'REFERENCES notification_types (id) ON UPDATE CASCADE ON DELETE SET DEFAULT',
        defaultValue: const Constant(0));
  }

  @override
  List<GeneratedColumn> get $columns => [
        id,
        name,
        description,
        whatTime,
        notificationTime,
        statusBarFix,
        groupId,
        notificationTypeId
      ];
  @override
  $HabitsTable get asDslTable => this;
  @override
  String get $tableName => _alias ?? 'habits';
  @override
  final String actualTableName = 'habits';
  @override
  VerificationContext validateIntegrity(Insertable<Habit> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id'], _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name'], _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('description')) {
      context.handle(
          _descriptionMeta,
          description.isAcceptableOrUnknown(
              data['description'], _descriptionMeta));
    }
    if (data.containsKey('what_time')) {
      context.handle(_whatTimeMeta,
          whatTime.isAcceptableOrUnknown(data['what_time'], _whatTimeMeta));
    }
    if (data.containsKey('notification_time')) {
      context.handle(
          _notificationTimeMeta,
          notificationTime.isAcceptableOrUnknown(
              data['notification_time'], _notificationTimeMeta));
    }
    if (data.containsKey('status_bar_fix')) {
      context.handle(
          _statusBarFixMeta,
          statusBarFix.isAcceptableOrUnknown(
              data['status_bar_fix'], _statusBarFixMeta));
    }
    if (data.containsKey('group_id')) {
      context.handle(_groupIdMeta,
          groupId.isAcceptableOrUnknown(data['group_id'], _groupIdMeta));
    }
    if (data.containsKey('notification_type_id')) {
      context.handle(
          _notificationTypeIdMeta,
          notificationTypeId.isAcceptableOrUnknown(
              data['notification_type_id'], _notificationTypeIdMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Habit map(Map<String, dynamic> data, {String tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : null;
    return Habit.fromData(data, _db, prefix: effectivePrefix);
  }

  @override
  $HabitsTable createAlias(String alias) {
    return $HabitsTable(_db, alias);
  }
}

class HabitWeek extends DataClass implements Insertable<HabitWeek> {
  final int habitId;
  final int week;
  HabitWeek({@required this.habitId, @required this.week});
  factory HabitWeek.fromData(Map<String, dynamic> data, GeneratedDatabase db,
      {String prefix}) {
    final effectivePrefix = prefix ?? '';
    final intType = db.typeSystem.forDartType<int>();
    return HabitWeek(
      habitId:
          intType.mapFromDatabaseResponse(data['${effectivePrefix}habit_id']),
      week: intType.mapFromDatabaseResponse(data['${effectivePrefix}week']),
    );
  }
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (!nullToAbsent || habitId != null) {
      map['habit_id'] = Variable<int>(habitId);
    }
    if (!nullToAbsent || week != null) {
      map['week'] = Variable<int>(week);
    }
    return map;
  }

  HabitWeeksCompanion toCompanion(bool nullToAbsent) {
    return HabitWeeksCompanion(
      habitId: habitId == null && nullToAbsent
          ? const Value.absent()
          : Value(habitId),
      week: week == null && nullToAbsent ? const Value.absent() : Value(week),
    );
  }

  factory HabitWeek.fromJson(Map<String, dynamic> json,
      {ValueSerializer serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return HabitWeek(
      habitId: serializer.fromJson<int>(json['habitId']),
      week: serializer.fromJson<int>(json['week']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'habitId': serializer.toJson<int>(habitId),
      'week': serializer.toJson<int>(week),
    };
  }

  HabitWeek copyWith({int habitId, int week}) => HabitWeek(
        habitId: habitId ?? this.habitId,
        week: week ?? this.week,
      );
  @override
  String toString() {
    return (StringBuffer('HabitWeek(')
          ..write('habitId: $habitId, ')
          ..write('week: $week')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => $mrjf($mrjc(habitId.hashCode, week.hashCode));
  @override
  bool operator ==(dynamic other) =>
      identical(this, other) ||
      (other is HabitWeek &&
          other.habitId == this.habitId &&
          other.week == this.week);
}

class HabitWeeksCompanion extends UpdateCompanion<HabitWeek> {
  final Value<int> habitId;
  final Value<int> week;
  const HabitWeeksCompanion({
    this.habitId = const Value.absent(),
    this.week = const Value.absent(),
  });
  HabitWeeksCompanion.insert({
    @required int habitId,
    @required int week,
  })  : habitId = Value(habitId),
        week = Value(week);
  static Insertable<HabitWeek> custom({
    Expression<int> habitId,
    Expression<int> week,
  }) {
    return RawValuesInsertable({
      if (habitId != null) 'habit_id': habitId,
      if (week != null) 'week': week,
    });
  }

  HabitWeeksCompanion copyWith({Value<int> habitId, Value<int> week}) {
    return HabitWeeksCompanion(
      habitId: habitId ?? this.habitId,
      week: week ?? this.week,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (habitId.present) {
      map['habit_id'] = Variable<int>(habitId.value);
    }
    if (week.present) {
      map['week'] = Variable<int>(week.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('HabitWeeksCompanion(')
          ..write('habitId: $habitId, ')
          ..write('week: $week')
          ..write(')'))
        .toString();
  }
}

class $HabitWeeksTable extends HabitWeeks
    with TableInfo<$HabitWeeksTable, HabitWeek> {
  final GeneratedDatabase _db;
  final String _alias;
  $HabitWeeksTable(this._db, [this._alias]);
  final VerificationMeta _habitIdMeta = const VerificationMeta('habitId');
  GeneratedIntColumn _habitId;
  @override
  GeneratedIntColumn get habitId => _habitId ??= _constructHabitId();
  GeneratedIntColumn _constructHabitId() {
    return GeneratedIntColumn('habit_id', $tableName, false,
        $customConstraints:
            'REFERENCES habits (id) ON UPDATE CASCADE ON DELETE CASCADE');
  }

  final VerificationMeta _weekMeta = const VerificationMeta('week');
  GeneratedIntColumn _week;
  @override
  GeneratedIntColumn get week => _week ??= _constructWeek();
  GeneratedIntColumn _constructWeek() {
    return GeneratedIntColumn('week', $tableName, false,
        $customConstraints:
            'REFERENCES weeks (id) ON UPDATE CASCADE ON DELETE CASCADE');
  }

  @override
  List<GeneratedColumn> get $columns => [habitId, week];
  @override
  $HabitWeeksTable get asDslTable => this;
  @override
  String get $tableName => _alias ?? 'habit_weeks';
  @override
  final String actualTableName = 'habit_weeks';
  @override
  VerificationContext validateIntegrity(Insertable<HabitWeek> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('habit_id')) {
      context.handle(_habitIdMeta,
          habitId.isAcceptableOrUnknown(data['habit_id'], _habitIdMeta));
    } else if (isInserting) {
      context.missing(_habitIdMeta);
    }
    if (data.containsKey('week')) {
      context.handle(
          _weekMeta, week.isAcceptableOrUnknown(data['week'], _weekMeta));
    } else if (isInserting) {
      context.missing(_weekMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {habitId, week};
  @override
  HabitWeek map(Map<String, dynamic> data, {String tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : null;
    return HabitWeek.fromData(data, _db, prefix: effectivePrefix);
  }

  @override
  $HabitWeeksTable createAlias(String alias) {
    return $HabitWeeksTable(_db, alias);
  }
}

class Event extends DataClass implements Insertable<Event> {
  final int id;
  final DateTime date;
  final int completion;
  final int habitId;
  Event(
      {@required this.id,
      @required this.date,
      @required this.completion,
      @required this.habitId});
  factory Event.fromData(Map<String, dynamic> data, GeneratedDatabase db,
      {String prefix}) {
    final effectivePrefix = prefix ?? '';
    final intType = db.typeSystem.forDartType<int>();
    final dateTimeType = db.typeSystem.forDartType<DateTime>();
    return Event(
      id: intType.mapFromDatabaseResponse(data['${effectivePrefix}id']),
      date:
          dateTimeType.mapFromDatabaseResponse(data['${effectivePrefix}date']),
      completion:
          intType.mapFromDatabaseResponse(data['${effectivePrefix}completion']),
      habitId:
          intType.mapFromDatabaseResponse(data['${effectivePrefix}habit_id']),
    );
  }
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (!nullToAbsent || id != null) {
      map['id'] = Variable<int>(id);
    }
    if (!nullToAbsent || date != null) {
      map['date'] = Variable<DateTime>(date);
    }
    if (!nullToAbsent || completion != null) {
      map['completion'] = Variable<int>(completion);
    }
    if (!nullToAbsent || habitId != null) {
      map['habit_id'] = Variable<int>(habitId);
    }
    return map;
  }

  EventsCompanion toCompanion(bool nullToAbsent) {
    return EventsCompanion(
      id: id == null && nullToAbsent ? const Value.absent() : Value(id),
      date: date == null && nullToAbsent ? const Value.absent() : Value(date),
      completion: completion == null && nullToAbsent
          ? const Value.absent()
          : Value(completion),
      habitId: habitId == null && nullToAbsent
          ? const Value.absent()
          : Value(habitId),
    );
  }

  factory Event.fromJson(Map<String, dynamic> json,
      {ValueSerializer serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return Event(
      id: serializer.fromJson<int>(json['id']),
      date: serializer.fromJson<DateTime>(json['date']),
      completion: serializer.fromJson<int>(json['completion']),
      habitId: serializer.fromJson<int>(json['habitId']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'date': serializer.toJson<DateTime>(date),
      'completion': serializer.toJson<int>(completion),
      'habitId': serializer.toJson<int>(habitId),
    };
  }

  Event copyWith({int id, DateTime date, int completion, int habitId}) => Event(
        id: id ?? this.id,
        date: date ?? this.date,
        completion: completion ?? this.completion,
        habitId: habitId ?? this.habitId,
      );
  @override
  String toString() {
    return (StringBuffer('Event(')
          ..write('id: $id, ')
          ..write('date: $date, ')
          ..write('completion: $completion, ')
          ..write('habitId: $habitId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => $mrjf($mrjc(id.hashCode,
      $mrjc(date.hashCode, $mrjc(completion.hashCode, habitId.hashCode))));
  @override
  bool operator ==(dynamic other) =>
      identical(this, other) ||
      (other is Event &&
          other.id == this.id &&
          other.date == this.date &&
          other.completion == this.completion &&
          other.habitId == this.habitId);
}

class EventsCompanion extends UpdateCompanion<Event> {
  final Value<int> id;
  final Value<DateTime> date;
  final Value<int> completion;
  final Value<int> habitId;
  const EventsCompanion({
    this.id = const Value.absent(),
    this.date = const Value.absent(),
    this.completion = const Value.absent(),
    this.habitId = const Value.absent(),
  });
  EventsCompanion.insert({
    this.id = const Value.absent(),
    @required DateTime date,
    @required int completion,
    @required int habitId,
  })  : date = Value(date),
        completion = Value(completion),
        habitId = Value(habitId);
  static Insertable<Event> custom({
    Expression<int> id,
    Expression<DateTime> date,
    Expression<int> completion,
    Expression<int> habitId,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (date != null) 'date': date,
      if (completion != null) 'completion': completion,
      if (habitId != null) 'habit_id': habitId,
    });
  }

  EventsCompanion copyWith(
      {Value<int> id,
      Value<DateTime> date,
      Value<int> completion,
      Value<int> habitId}) {
    return EventsCompanion(
      id: id ?? this.id,
      date: date ?? this.date,
      completion: completion ?? this.completion,
      habitId: habitId ?? this.habitId,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (date.present) {
      map['date'] = Variable<DateTime>(date.value);
    }
    if (completion.present) {
      map['completion'] = Variable<int>(completion.value);
    }
    if (habitId.present) {
      map['habit_id'] = Variable<int>(habitId.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('EventsCompanion(')
          ..write('id: $id, ')
          ..write('date: $date, ')
          ..write('completion: $completion, ')
          ..write('habitId: $habitId')
          ..write(')'))
        .toString();
  }
}

class $EventsTable extends Events with TableInfo<$EventsTable, Event> {
  final GeneratedDatabase _db;
  final String _alias;
  $EventsTable(this._db, [this._alias]);
  final VerificationMeta _idMeta = const VerificationMeta('id');
  GeneratedIntColumn _id;
  @override
  GeneratedIntColumn get id => _id ??= _constructId();
  GeneratedIntColumn _constructId() {
    return GeneratedIntColumn(
      'id',
      $tableName,
      false,
    );
  }

  final VerificationMeta _dateMeta = const VerificationMeta('date');
  GeneratedDateTimeColumn _date;
  @override
  GeneratedDateTimeColumn get date => _date ??= _constructDate();
  GeneratedDateTimeColumn _constructDate() {
    return GeneratedDateTimeColumn(
      'date',
      $tableName,
      false,
    );
  }

  final VerificationMeta _completionMeta = const VerificationMeta('completion');
  GeneratedIntColumn _completion;
  @override
  GeneratedIntColumn get completion => _completion ??= _constructCompletion();
  GeneratedIntColumn _constructCompletion() {
    return GeneratedIntColumn(
      'completion',
      $tableName,
      false,
    );
  }

  final VerificationMeta _habitIdMeta = const VerificationMeta('habitId');
  GeneratedIntColumn _habitId;
  @override
  GeneratedIntColumn get habitId => _habitId ??= _constructHabitId();
  GeneratedIntColumn _constructHabitId() {
    return GeneratedIntColumn('habit_id', $tableName, false,
        $customConstraints:
            'REFERENCES habits (id) ON UPDATE CASCADE ON DELETE CASCADE');
  }

  @override
  List<GeneratedColumn> get $columns => [id, date, completion, habitId];
  @override
  $EventsTable get asDslTable => this;
  @override
  String get $tableName => _alias ?? 'events';
  @override
  final String actualTableName = 'events';
  @override
  VerificationContext validateIntegrity(Insertable<Event> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id'], _idMeta));
    }
    if (data.containsKey('date')) {
      context.handle(
          _dateMeta, date.isAcceptableOrUnknown(data['date'], _dateMeta));
    } else if (isInserting) {
      context.missing(_dateMeta);
    }
    if (data.containsKey('completion')) {
      context.handle(
          _completionMeta,
          completion.isAcceptableOrUnknown(
              data['completion'], _completionMeta));
    } else if (isInserting) {
      context.missing(_completionMeta);
    }
    if (data.containsKey('habit_id')) {
      context.handle(_habitIdMeta,
          habitId.isAcceptableOrUnknown(data['habit_id'], _habitIdMeta));
    } else if (isInserting) {
      context.missing(_habitIdMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Event map(Map<String, dynamic> data, {String tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : null;
    return Event.fromData(data, _db, prefix: effectivePrefix);
  }

  @override
  $EventsTable createAlias(String alias) {
    return $EventsTable(_db, alias);
  }
}

class IndexGroup extends DataClass implements Insertable<IndexGroup> {
  final int groupId;
  final int index;
  IndexGroup({@required this.groupId, @required this.index});
  factory IndexGroup.fromData(Map<String, dynamic> data, GeneratedDatabase db,
      {String prefix}) {
    final effectivePrefix = prefix ?? '';
    final intType = db.typeSystem.forDartType<int>();
    return IndexGroup(
      groupId:
          intType.mapFromDatabaseResponse(data['${effectivePrefix}group_id']),
      index: intType.mapFromDatabaseResponse(data['${effectivePrefix}index']),
    );
  }
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (!nullToAbsent || groupId != null) {
      map['group_id'] = Variable<int>(groupId);
    }
    if (!nullToAbsent || index != null) {
      map['index'] = Variable<int>(index);
    }
    return map;
  }

  IndexGroupsCompanion toCompanion(bool nullToAbsent) {
    return IndexGroupsCompanion(
      groupId: groupId == null && nullToAbsent
          ? const Value.absent()
          : Value(groupId),
      index:
          index == null && nullToAbsent ? const Value.absent() : Value(index),
    );
  }

  factory IndexGroup.fromJson(Map<String, dynamic> json,
      {ValueSerializer serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return IndexGroup(
      groupId: serializer.fromJson<int>(json['groupId']),
      index: serializer.fromJson<int>(json['index']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'groupId': serializer.toJson<int>(groupId),
      'index': serializer.toJson<int>(index),
    };
  }

  IndexGroup copyWith({int groupId, int index}) => IndexGroup(
        groupId: groupId ?? this.groupId,
        index: index ?? this.index,
      );
  @override
  String toString() {
    return (StringBuffer('IndexGroup(')
          ..write('groupId: $groupId, ')
          ..write('index: $index')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => $mrjf($mrjc(groupId.hashCode, index.hashCode));
  @override
  bool operator ==(dynamic other) =>
      identical(this, other) ||
      (other is IndexGroup &&
          other.groupId == this.groupId &&
          other.index == this.index);
}

class IndexGroupsCompanion extends UpdateCompanion<IndexGroup> {
  final Value<int> groupId;
  final Value<int> index;
  const IndexGroupsCompanion({
    this.groupId = const Value.absent(),
    this.index = const Value.absent(),
  });
  IndexGroupsCompanion.insert({
    this.groupId = const Value.absent(),
    @required int index,
  }) : index = Value(index);
  static Insertable<IndexGroup> custom({
    Expression<int> groupId,
    Expression<int> index,
  }) {
    return RawValuesInsertable({
      if (groupId != null) 'group_id': groupId,
      if (index != null) 'index': index,
    });
  }

  IndexGroupsCompanion copyWith({Value<int> groupId, Value<int> index}) {
    return IndexGroupsCompanion(
      groupId: groupId ?? this.groupId,
      index: index ?? this.index,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (groupId.present) {
      map['group_id'] = Variable<int>(groupId.value);
    }
    if (index.present) {
      map['index'] = Variable<int>(index.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('IndexGroupsCompanion(')
          ..write('groupId: $groupId, ')
          ..write('index: $index')
          ..write(')'))
        .toString();
  }
}

class $IndexGroupsTable extends IndexGroups
    with TableInfo<$IndexGroupsTable, IndexGroup> {
  final GeneratedDatabase _db;
  final String _alias;
  $IndexGroupsTable(this._db, [this._alias]);
  final VerificationMeta _groupIdMeta = const VerificationMeta('groupId');
  GeneratedIntColumn _groupId;
  @override
  GeneratedIntColumn get groupId => _groupId ??= _constructGroupId();
  GeneratedIntColumn _constructGroupId() {
    return GeneratedIntColumn('group_id', $tableName, false,
        $customConstraints:
            'REFERENCES groups (id) ON UPDATE CASCADE ON DELETE CASCADE');
  }

  final VerificationMeta _indexMeta = const VerificationMeta('index');
  GeneratedIntColumn _index;
  @override
  GeneratedIntColumn get index => _index ??= _constructIndex();
  GeneratedIntColumn _constructIndex() {
    return GeneratedIntColumn(
      'index',
      $tableName,
      false,
    );
  }

  @override
  List<GeneratedColumn> get $columns => [groupId, index];
  @override
  $IndexGroupsTable get asDslTable => this;
  @override
  String get $tableName => _alias ?? 'index_groups';
  @override
  final String actualTableName = 'index_groups';
  @override
  VerificationContext validateIntegrity(Insertable<IndexGroup> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('group_id')) {
      context.handle(_groupIdMeta,
          groupId.isAcceptableOrUnknown(data['group_id'], _groupIdMeta));
    }
    if (data.containsKey('index')) {
      context.handle(
          _indexMeta, index.isAcceptableOrUnknown(data['index'], _indexMeta));
    } else if (isInserting) {
      context.missing(_indexMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {groupId};
  @override
  IndexGroup map(Map<String, dynamic> data, {String tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : null;
    return IndexGroup.fromData(data, _db, prefix: effectivePrefix);
  }

  @override
  $IndexGroupsTable createAlias(String alias) {
    return $IndexGroupsTable(_db, alias);
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(SqlTypeSystem.defaultInstance, e);
  $GroupsTable _groups;
  $GroupsTable get groups => _groups ??= $GroupsTable(this);
  $NotificationTypesTable _notificationTypes;
  $NotificationTypesTable get notificationTypes =>
      _notificationTypes ??= $NotificationTypesTable(this);
  $WeeksTable _weeks;
  $WeeksTable get weeks => _weeks ??= $WeeksTable(this);
  $HabitsTable _habits;
  $HabitsTable get habits => _habits ??= $HabitsTable(this);
  $HabitWeeksTable _habitWeeks;
  $HabitWeeksTable get habitWeeks => _habitWeeks ??= $HabitWeeksTable(this);
  $EventsTable _events;
  $EventsTable get events => _events ??= $EventsTable(this);
  $IndexGroupsTable _indexGroups;
  $IndexGroupsTable get indexGroups => _indexGroups ??= $IndexGroupsTable(this);
  GroupDao _groupDao;
  GroupDao get groupDao => _groupDao ??= GroupDao(this as AppDatabase);
  NotificationTypeDao _notificationTypeDao;
  NotificationTypeDao get notificationTypeDao =>
      _notificationTypeDao ??= NotificationTypeDao(this as AppDatabase);
  WeekDao _weekDao;
  WeekDao get weekDao => _weekDao ??= WeekDao(this as AppDatabase);
  HabitDao _habitDao;
  HabitDao get habitDao => _habitDao ??= HabitDao(this as AppDatabase);
  HabitWeekDao _habitWeekDao;
  HabitWeekDao get habitWeekDao =>
      _habitWeekDao ??= HabitWeekDao(this as AppDatabase);
  EventDao _eventDao;
  EventDao get eventDao => _eventDao ??= EventDao(this as AppDatabase);
  IndexGroupDao _indexGroupDao;
  IndexGroupDao get indexGroupDao =>
      _indexGroupDao ??= IndexGroupDao(this as AppDatabase);
  @override
  Iterable<TableInfo> get allTables => allSchemaEntities.whereType<TableInfo>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
        groups,
        notificationTypes,
        weeks,
        habits,
        habitWeeks,
        events,
        indexGroups
      ];
}
