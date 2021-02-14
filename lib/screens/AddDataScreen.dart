import 'dart:ui';

import 'package:bp_monitor/constants.dart';
import 'package:bp_monitor/util/BloodPresureData.dart';
import 'package:flutter/material.dart';

class AddDataScreen extends StatefulWidget {
  @override
  _AddDataScreenState createState() => _AddDataScreenState();
}

class _AddDataScreenState extends State<AddDataScreen> {
  int diastolic = 0, systolic = 0;
  TextEditingController _diastolicController = TextEditingController();
  TextEditingController _systolicController = TextEditingController();

  BPDataProvider _provider = BPDataProvider();

  Future<void> _addData() async {
    if (diastolic != 0 && systolic != 0) {
      await _provider.open(Constants.DB_PATH);
      await _provider.insert(
        BPData(
            diastolic: diastolic,
            systolic: systolic,
            timestamp: DateTime.now().millisecondsSinceEpoch),
      );
      await _provider.close();
      final SnackBar snackBar = SnackBar(content: Text('Data was added'));

      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    } else {
      final SnackBar snackBar = SnackBar(
          content: Text(
              'Make sure that both Diastolic and Systolic fields are filled'));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _diastolicController,
              keyboardType: TextInputType.number,
              textAlign: TextAlign.center,
              decoration: InputDecoration(labelText: 'Diastolic'),
              onChanged: (String value) {
                try {
                  diastolic = int.parse(value);
                } catch (e) {
                  SnackBar snackbar = SnackBar(
                    content: Text('Enter only whole numbers'),
                    duration: Duration(milliseconds: 500),
                  );
                  ScaffoldMessenger.of(context).showSnackBar(snackbar);
                }
              },
            ),
            TextField(
              keyboardType: TextInputType.number,
              controller: _systolicController,
              decoration: InputDecoration(labelText: 'Systolic'),
              onChanged: (String value) {
                try {
                  systolic = int.parse(value);
                } catch (e) {
                  SnackBar snackbar = SnackBar(
                    content: Text('Enter only whole numbers'),
                    duration: Duration(milliseconds: 500),
                  );
                  ScaffoldMessenger.of(context).showSnackBar(snackbar);
                }
              },
            ),
            MaterialButton(
              onPressed: () {
                _addData();
              },
              child: Text('Add data'),
            )
          ],
        ),
      ),
    );
  }
}
