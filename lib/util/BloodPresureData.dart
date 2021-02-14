import 'package:flutter/cupertino.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite/sqlite_api.dart';

final String tableBPData = 'bpData';
final String columnId = '_id';
final String columnSystolic = 'systolic';
final String columnDiastolic = 'diastolic';
final String columnTimestamp = 'timestamp';

class BPData {
  int id, systolic, diastolic, timestamp;

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      columnSystolic: systolic,
      columnDiastolic: diastolic,
      columnTimestamp: timestamp
    };
    if (id != null) {
      map[columnId] = id;
    }
    return map;
  }

  BPData(
      {@required this.diastolic,
      @required this.systolic,
      @required this.timestamp});
  BPData.fromMap(Map<String, dynamic> map) {
    id = map[columnId];
    systolic = map[columnSystolic];
    diastolic = map[columnDiastolic];
    timestamp = map[columnTimestamp];
  }
}

class BPDataProvider {
  Database db;

  Future open(String path) async {
    db = await openDatabase(path, version: 1,
        onCreate: (Database db, int version) async {
      await db.execute('''
      create table $tableBPData (
        $columnId integer primary key autoincrement,
        $columnSystolic integer not null,
        $columnDiastolic integer not null,
        $columnTimestamp integer not null)
      ''');
    });
  }

  Future<BPData> insert(BPData bpData) async {
    bpData.id = await db.insert(tableBPData, bpData.toMap());
    return bpData;
  }

  Future<BPData> getBPData(int id) async {
    List<Map> maps = await db.query(tableBPData,
        columns: [columnId, columnSystolic, columnDiastolic, columnTimestamp],
        where: '$columnId = ?',
        whereArgs: [id]);
    if (maps.length > 0) {
      return BPData.fromMap(maps.first);
    }
    return null;
  }

  Future<List<BPData>> getAllBPData() async {
    List<BPData> data = [];
    List<Map<String, dynamic>> records = await db.query(tableBPData);

    for (Map<String, dynamic> record in records) {
      data.add(BPData.fromMap(record));
    }
    return data;
  }

  Future<int> delete(int id) async {
    return await db
        .delete(tableBPData, where: '$columnId = ?', whereArgs: [id]);
  }

  Future<int> update(BPData data) async {
    return await db.update(tableBPData, data.toMap(),
        where: '$columnId = ?', whereArgs: [data.id]);
  }

  Future close() async => db.close();
}
