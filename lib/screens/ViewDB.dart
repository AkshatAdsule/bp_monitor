import 'package:bp_monitor/constants.dart';
import 'package:bp_monitor/util/BloodPressureData.dart';
import 'package:flutter/material.dart';

class ViewDB extends StatefulWidget {
  @override
  _ViewDBState createState() => _ViewDBState();
}

class _ViewDBState extends State<ViewDB> {
  BPDataProvider _provider = BPDataProvider();
  List<BPData> _data;

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
        child: _data == null || _data.length == 0
            ? Center(
                child: Text(
                  'No data, add data to get started',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
              )
            : SingleChildScrollView(
                child: DataTable(
                  columns: [
                    DataColumn(
                      label: Text('Timestamp'),
                    ),
                    DataColumn(
                      label: Text('Diastolic'),
                    ),
                    DataColumn(
                      label: Text('Systolic'),
                    ),
                  ],
                  rows: [
                    for (BPData data in _data)
                      DataRow(
                        cells: [
                          DataCell(
                            Text(
                              DateTime.fromMillisecondsSinceEpoch(
                                      data.timestamp)
                                  .toString(),
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
                        ],
                      ),
                  ],
                ),
              ),
      ),
    );
  }
}
