import 'package:bp_monitor/constants.dart';
import 'package:bp_monitor/models/blood_pressure_data.dart';
import 'package:bp_monitor/util/util.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AddDataScreen extends StatefulWidget {
  @override
  _AddDataScreenState createState() => _AddDataScreenState();
}

class _AddDataScreenState extends State<AddDataScreen> {
  TextEditingController _diastolicController = TextEditingController();
  TextEditingController _systolicController = TextEditingController();
  TextEditingController _heartRateController = TextEditingController();

  BPDataProvider _provider = BPDataProvider();

  Future<void> _addData() async {
    int diastolic, systolic, heartRate;

    // Make sure fields are filled by trying to convert to int
    try {
      diastolic = int.parse(_diastolicController.value.text);
      systolic = int.parse(_systolicController.value.text);
      heartRate = int.parse(_heartRateController.value.text);
    } catch (error) {
      Util.showSnackBar(context, "Make sure all fields are filled out");
      return;
    }

    // Validate data before adding to db
    if (!(diastolic >= Constants.DIASTOLIC_MIN &&
        diastolic <= Constants.DIASTOLIC_MAX)) {
      Util.showSnackBar(context,
          "Diastolic value looks of. Make sure that diastolic value is correct");
    } else if (!(systolic >= Constants.SYSTOLIC_MIN &&
        systolic <= Constants.SYSTOLIC_MAX)) {
      Util.showSnackBar(context,
          "Systolic value looks of. Make sure that systolic value is correct");
    } else if (!(heartRate >= Constants.HEART_RATE_MIN &&
        heartRate <= Constants.HEART_RATE_MAX)) {
      Util.showSnackBar(context,
          "Heart rate value looks of. Make sure that heart rate value is correct");
    } else {
      await _provider.open(Constants.DB_PATH);
      await _provider
          .insert(
            BPData(
              diastolic: diastolic,
              systolic: systolic,
              heartrate: heartRate,
              timestamp: DateTime.now().millisecondsSinceEpoch,
            ),
          )
          .then(
            (value) => Util.showSnackBar(context, "Data was added"),
          );
      await _provider.close();
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
            _buildTextField("Diastolic", _diastolicController,
                Constants.DIASTOLIC_MIN, Constants.DIASTOLIC_MAX),
            _buildTextField("Systolic", _systolicController,
                Constants.SYSTOLIC_MIN, Constants.SYSTOLIC_MAX),
            _buildTextField("Heart rate", _heartRateController,
                Constants.HEART_RATE_MIN, Constants.HEART_RATE_MAX),
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

  TextField _buildTextField(
      String name, TextEditingController controller, int min, int max) {
    return TextField(
      controller: controller,
      keyboardType: TextInputType.number,
      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
      decoration: InputDecoration(
        labelText: '$name ($min - $max)',
      ),
    );
  }
}
