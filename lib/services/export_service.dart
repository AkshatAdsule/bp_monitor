import 'dart:async';

import 'package:bp_monitor/models/blood_pressure_data.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

import 'dart:io' show Directory, File;

class ExportService {
  static Future<String> exportAsCSV(List<BPData> bpdata) async {
    if (await Permission.storage.isGranted) {}
    DateTime date = DateTime.now();
    Directory? dir = await getExternalStorageDirectory();
    File file = File(dir!.path + '/bpdata_${date.toString()}.csv');
    String dbString = "id,systolic,diastolic,heartrate,timestamp\n";
    for (BPData data in bpdata) {
      dbString += (data.toCSVLine() + "\n");
    }
    await file.writeAsString(dbString);

    return file.path;
  }
}
