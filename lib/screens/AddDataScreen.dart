import 'package:bp_monitor/constants.dart';
import 'package:bp_monitor/models/BloodPressureData.dart';
import 'package:flutter/material.dart';

class AddDataScreen extends StatefulWidget {
  @override
  _AddDataScreenState createState() => _AddDataScreenState();
}

class _AddDataScreenState extends State<AddDataScreen> {
  int _diastolic = 0, _systolic = 0;
  TextEditingController _diastolicController = TextEditingController();
  TextEditingController _systolicController = TextEditingController();

  BPDataProvider _provider = BPDataProvider();

  Future<void> _addData() async {
    if ((_diastolic >= Constants.DIASTOLIC_MIN &&
            _diastolic <= Constants.DIASTOLIC_MAX) &&
        (_systolic >= Constants.SYSTOLIC_MIN &&
            _diastolic <= Constants.SYSTOLIC_MAX)) {
      await _provider.open(Constants.DB_PATH);
      await _provider.insert(
        BPData(
          diastolic: _diastolic,
          systolic: _systolic,
          timestamp: DateTime.now().millisecondsSinceEpoch,
        ),
      );
      await _provider.close();
      _diastolicController.clear();
      _systolicController.clear();
      final SnackBar snackBar = SnackBar(content: Text('Data was added'));

      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    } else {
      final SnackBar snackBar = SnackBar(
        content: Text(
            'Make sure that both Diastolic and Systolic fields are filled and are valid'),
      );
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
              decoration: InputDecoration(labelText: 'Diastolic'),
              onChanged: (String value) {
                try {
                  _diastolic = int.parse(value);
                } catch (e) {
                  if (value != "") {
                    SnackBar snackbar = SnackBar(
                      content: Text('Enter only whole numbers'),
                      duration: Duration(milliseconds: 1500),
                    );
                    ScaffoldMessenger.of(context).showSnackBar(snackbar);
                  }
                }
              },
            ),
            TextField(
              keyboardType: TextInputType.number,
              controller: _systolicController,
              decoration: InputDecoration(labelText: 'Systolic'),
              onChanged: (String value) {
                try {
                  _systolic = int.parse(value);
                } catch (e) {
                  if (value != "") {
                    SnackBar snackbar = SnackBar(
                      content: Text('Enter only whole numbers'),
                      duration: Duration(milliseconds: 1500),
                    );
                    ScaffoldMessenger.of(context).showSnackBar(snackbar);
                  }
                }
              },
            ),
            SizedBox(
              height: 20,
            ),
            FlatButton(
              color: Colors.red,
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
