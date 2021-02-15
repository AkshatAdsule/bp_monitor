import 'package:bp_monitor/components/linechart.dart';
import 'package:bp_monitor/constants.dart';
import 'package:bp_monitor/models/BloodPressureData.dart';
import 'package:flutter/material.dart';

class ViewDataScreen extends StatefulWidget {
  @override
  _ViewDataScreenState createState() => _ViewDataScreenState();
}

class _ViewDataScreenState extends State<ViewDataScreen> {
  BPDataProvider dataProvider = new BPDataProvider();
  List<BPData> _data = [];

  void _getData() async {
    await dataProvider.open(Constants.DB_PATH);
    dataProvider.getAllBPData().then((data) {
      setState(() {
        _data = data;
      });
    });
    dataProvider.close();
  }

  @override
  void initState() {
    _getData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: _data == null || _data.length == 0
              ? Center(
                  child: Text(
                    'No data, add data to get started',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                )
              : BPLineChart(data: _data),
        ),
      ),
    );
  }
}
