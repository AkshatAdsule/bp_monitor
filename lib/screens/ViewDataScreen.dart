import 'package:bp_monitor/constants.dart';
import 'package:bp_monitor/util/BloodPresureData.dart';
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
          child: _data == []
              ? null
              : ListView.builder(
                  itemCount: _data.length,
                  itemBuilder: (BuildContext context, int index) =>
                      buildRow(_data[index])),
        ),
      ),
    );
  }
}

Widget buildRow(BPData data) {
  return Padding(
    padding: const EdgeInsets.all(8.0),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Text('Diastolic: ${data.diastolic}'),
        Text('Systolic: ${data.systolic}'),
      ],
    ),
  );
}
