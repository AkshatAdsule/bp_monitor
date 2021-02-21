import 'package:bp_monitor/constants.dart';
import 'package:bp_monitor/models/BloodPressureData.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AddDataScreen extends StatefulWidget {
  @override
  _AddDataScreenState createState() => _AddDataScreenState();
}

class _AddDataScreenState extends State<AddDataScreen> {
  TextEditingController _diastolicController = TextEditingController();
  TextEditingController _systolicController = TextEditingController();
  TextEditingController _heartrateController = TextEditingController();

  BPDataProvider _provider = BPDataProvider();

  Future<void> _addData() async {
    int diastolic = int.parse(_diastolicController.value.text);
    int systolic = int.parse(_systolicController.value.text);
    int heartrate = int.parse(_heartrateController.value.text);

    if ((diastolic >= Constants.DIASTOLIC_MIN &&
            diastolic <= Constants.DIASTOLIC_MAX) &&
        (systolic >= Constants.SYSTOLIC_MIN &&
            systolic <= Constants.SYSTOLIC_MAX)) {
      await _provider.open(Constants.DB_PATH);
      await _provider.insert(
        BPData(
          diastolic: diastolic,
          systolic: systolic,
          heartrate: heartrate,
          timestamp: DateTime.now().millisecondsSinceEpoch,
        ),
      );
      await _provider.close();
      _diastolicController.clear();
      _systolicController.clear();
      _heartrateController.clear();
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
              keyboardType: TextInputType.number,
              controller: _systolicController,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              decoration: InputDecoration(
                  labelText:
                      'Systolic (${Constants.SYSTOLIC_MIN} - ${Constants.SYSTOLIC_MAX})'),
            ),
            TextField(
              controller: _diastolicController,
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              decoration: InputDecoration(
                  labelText:
                      'Diastolic (${Constants.DIASTOLIC_MIN} - ${Constants.DIASTOLIC_MAX})'),
            ),
            TextField(
              controller: _heartrateController,
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              decoration: InputDecoration(
                  labelText:
                      'Heartrate (${Constants.HEART_RATE_MIN} - ${Constants.HEART_RATE_MAX})'),
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
