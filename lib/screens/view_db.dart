import 'package:bp_monitor/constants.dart';
import 'package:bp_monitor/models/blood_pressure_data.dart';
import 'package:bp_monitor/util/util.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class ViewDB extends StatefulWidget {
  @override
  _ViewDBState createState() => _ViewDBState();
}

class _ViewDBState extends State<ViewDB> {
  BPDataProvider _provider = BPDataProvider();
  List<BPData>? _data;

  Future<void> _init() async {
    await _provider.open(Constants.DB_PATH);
    _provider.getAllBPData().then((List<BPData> value) {
      setState(() {
        _data = value;
      });
    });
    await _provider.close();
  }

  @override
  void initState() {
    _init();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('View Data'),
      ),
      body: Center(
        child: _data == null || _data!.length == 0
            ? Center(
                child: Text(
                  'No data, add data to get started',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
              )
            : SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: DataTable(
                    columns: [
                      DataColumn(
                        label: Text('Date'),
                      ),
                      DataColumn(
                        label: Text('Diastolic'),
                      ),
                      DataColumn(
                        label: Text('Systolic'),
                      ),
                      DataColumn(
                        label: Text('Heart Rate'),
                      ),
                    ],
                    rows: [
                      for (BPData data in _data!)
                        DataRow(
                          cells: [
                            DataCell(
                              Text(
                                Util.formatTime(
                                  DateTime.fromMillisecondsSinceEpoch(
                                      data.timestamp!),
                                ),
                              ),
                            ),
                            DataCell(
                              Text(
                                data.diastolic.toString(),
                              ),
                            ),
                            DataCell(
                              Text(
                                data.systolic.toString(),
                              ),
                            ),
                            DataCell(
                              Text(
                                data.heartrate.toString(),
                              ),
                            ),
                          ],
                        ),
                    ],
                  ),
                ),
              ),
      ),
    );
  }
}
