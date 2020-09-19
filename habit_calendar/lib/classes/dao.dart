import 'package:get/get.dart';
import 'package:sqflite/sqflite.dart';

abstract class Dao<T> {
  final Database database;
  RxList<T> observable;
  Dao(this.database) : observable = List<T>().obs;

  Future<void> createTable();

  void onUpdateOrInsert(T data, bool Function(int index) where) {
    for (int i = 0; i < observable.length; i++) {
      if (where(i)) {
        observable[i] = data;
      } else {
        observable.add(data);
      }
    }
  }

  void onDelete(T data, bool Function(int index) where) {
    for (int i = 0; i < observable.length; i++) {
      if (where(i)) {
        observable.removeAt(i);
      }
    }
  }
}
