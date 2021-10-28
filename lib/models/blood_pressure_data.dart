import 'package:sqflite/sqflite.dart';
import 'package:sqflite/sqlite_api.dart';

import '../constants.dart';

class BPData {
  int? id, systolic, diastolic, heartrate, timestamp;

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      Constants.COLUMN_SYSTOLIC: systolic,
      Constants.COLUMN_DIASTOLIC: diastolic,
      Constants.COLUMN_TIMESTAMP: timestamp,
      Constants.COLUMN_HEARTRATE: heartrate
    };
    if (id != null) {
      map[Constants.COLUMN_ID] = id;
    }
    return map;
  }

  BPData(
      {required this.diastolic,
      required this.systolic,
      required this.heartrate,
      required this.timestamp});
  BPData.fromMap(Map<String, dynamic> map) {
    id = map[Constants.COLUMN_ID];
    systolic = map[Constants.COLUMN_SYSTOLIC];
    diastolic = map[Constants.COLUMN_DIASTOLIC];
    heartrate = map[Constants.COLUMN_HEARTRATE];
    timestamp = map[Constants.COLUMN_TIMESTAMP];
  }

  String toCSVLine() {
    return "$id,$systolic,$diastolic,$heartrate,${timestamp.toString()}";
  }
}

class BPDataProvider {
  late Database db;

  Future open(String path) async {
    db = await openDatabase(path, version: 1,
        onCreate: (Database db, int version) async {
      await db.execute('''
      create table ${Constants.TABLE_BP_DATA} (
        ${Constants.COLUMN_ID} integer primary key autoincrement,
        ${Constants.COLUMN_SYSTOLIC} integer not null,
        ${Constants.COLUMN_DIASTOLIC} integer not null,
        ${Constants.COLUMN_TIMESTAMP} integer not null,
	${Constants.COLUMN_HEARTRATE} integer)
      ''');
    });
  }

  Future<BPData> insert(BPData bpData) async {
    bpData.id = await db.insert(Constants.TABLE_BP_DATA, bpData.toMap());
    return bpData;
  }

  Future<BPData?> getBPData(int id) async {
    List<Map> maps = await db.query(Constants.TABLE_BP_DATA,
        columns: [
          Constants.COLUMN_ID,
          Constants.COLUMN_SYSTOLIC,
          Constants.COLUMN_DIASTOLIC,
          Constants.COLUMN_TIMESTAMP,
          Constants.COLUMN_HEARTRATE
        ],
        where: '${Constants.COLUMN_ID} = ?',
        whereArgs: [id]);
    if (maps.length > 0) {
      return BPData.fromMap(maps.first as Map<String, dynamic>);
    }
    return null;
  }

  Future<List<BPData>> getAllBPData() async {
    List<BPData> data = [];
    List<Map<String, dynamic>> records =
        await db.query(Constants.TABLE_BP_DATA);

    for (Map<String, dynamic> record in records) {
      data.add(BPData.fromMap(record));
    }
    return data;
  }

  Future<int> delete(int id) async {
    return await db.delete(Constants.TABLE_BP_DATA,
        where: '${Constants.COLUMN_ID} = ?', whereArgs: [id]);
  }

  Future<int> update(BPData data) async {
    return await db.update(Constants.TABLE_BP_DATA, data.toMap(),
        where: '${Constants.COLUMN_ID} = ?', whereArgs: [data.id]);
  }

  void dropTable() => db.delete(Constants.TABLE_BP_DATA);

  Future close() async => db.close();
}
