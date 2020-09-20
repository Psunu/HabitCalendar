// import 'package:habit_calendar/classes/dao.dart';
// import 'package:habit_calendar/models/group.dart';
// import 'package:sqflite/sqflite.dart';
// import 'package:get/get.dart';

// class GroupDao extends Dao {
//   //Stream<List<Group>> liveGroups;
//   //var groups = List<Group>().obs;
//   ConflictAlgorithm conflictAlgorithm = ConflictAlgorithm.replace;

//   GroupDao(Database database, {this.conflictAlgorithm}) : super(database);

//   @override
//   Future<void> createTable() async {
//     super.database.execute('''
//       CREATE TABLE IF NOT EXISTS ${Group.tableName} (
//         ${Group.columnId} INTEGER PRIMARY KEY,
//         ${Group.columnName} TEXT NOT NULL,
//         ${Group.columnColor} INTEGER NOT NULL
//       );
//     ''');
//   }

//   Future<RxList<Group>> getAll() async {
//     final List<Map<String, dynamic>> maps =
//         await super.database.query(Group.tableName);
//     observable.update((value) {
//       value = List.generate(maps.length, (i) => Group.fromJson(maps[i]));
//     });
//     return observable;
//   }

//   Future<Group> getGroupById(int id) async {
//     final maps = await super.database.query(Group.tableName,
//         where: '${Group.columnId} = ?', whereArgs: [id]);
//     if (maps.isEmpty)
//       return null;
//     else
//       return Group.fromJson(maps[0]);
//   }

//   Future<void> insert(Group group) async {
//     await super.database.insert(
//           Group.tableName,
//           group.toJson(),
//           conflictAlgorithm: conflictAlgorithm,
//         );

//     Group data = await getGroupById(group.id);
//     onUpdateOrInsert(data, (i) => observable[i].id == group.id);
//   }

//   Future<void> update(Group group) async {
//     await super.database.update(Group.tableName, group.toJson(),
//         where: '${Group.columnId} = ?', whereArgs: [group.id]);

//     Group data = await getGroupById(group.id);
//     onUpdateOrInsert(data, (i) => observable[i].id == group.id);
//   }

//   Future<void> delete(Group group) async {
//     await super.database.delete(Group.tableName,
//         where: '${Group.columnId} == ?', whereArgs: [group.id]);
//     onDelete(group, (index) => observable[index].id == group.id);
//   }
// }
