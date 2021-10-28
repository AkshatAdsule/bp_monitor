import 'package:bp_monitor/models/blood_pressure_data.dart';
import 'package:bp_monitor/util/util.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/material.dart';

class BPLineChart extends StatefulWidget {
  final List<BPData> data;
  BPLineChart({required this.data});
  @override
  _BPLineChartState createState() => _BPLineChartState();
}

class _BPLineChartState extends State<BPLineChart> {
  DateTime? _time;
  Map<String, num>? _measures;

  List<charts.Series<_TimeSeriesBPData, DateTime>> _getSeries() {
    List<_TimeSeriesBPData> _diastolicData = [],
        _systolicData = [],
        _heartrateData = [];

    for (BPData d in widget.data) {
      DateTime time = DateTime.fromMillisecondsSinceEpoch(d.timestamp!);
      _diastolicData.add(
        _TimeSeriesBPData(time: time, data: d.diastolic!),
      );
      _systolicData.add(
        _TimeSeriesBPData(time: time, data: d.systolic!),
      );
      _heartrateData.add(
        _TimeSeriesBPData(time: time, data: d.heartrate!),
      );
    }

    return [
      new charts.Series<_TimeSeriesBPData, DateTime>(
        id: 'Diastolic',
        colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
        domainFn: (_TimeSeriesBPData data, _) => data.time,
        measureFn: (_TimeSeriesBPData data, _) => data.data,
        data: _diastolicData,
      ),
      new charts.Series<_TimeSeriesBPData, DateTime>(
        id: 'Systolic',
        colorFn: (_, __) => charts.MaterialPalette.red.shadeDefault,
        domainFn: (_TimeSeriesBPData data, _) => data.time,
        measureFn: (_TimeSeriesBPData data, _) => data.data,
        data: _systolicData,
      ),
      new charts.Series<_TimeSeriesBPData, DateTime>(
        id: 'Heart Rate',
        colorFn: (_, __) => charts.MaterialPalette.green.shadeDefault,
        domainFn: (_TimeSeriesBPData data, _) => data.time,
        measureFn: (_TimeSeriesBPData data, _) => data.data,
        data: _heartrateData,
      ),
    ];
  }

  void _onSelectionChange(charts.SelectionModel model) {
    final selectedData = model.selectedDatum;

    DateTime time;
    final Map<String, num> measures = {};
    if (selectedData.isNotEmpty) {
      time = selectedData.first.datum.time;
      selectedData.forEach(
        (charts.SeriesDatum datumPair) {
          measures[datumPair.series.displayName!] = datumPair.datum.data;
        },
      );
      setState(() {
        _time = time;
        _measures = measures;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> _children = [
      SizedBox(
        height: MediaQuery.of(context).size.height * 0.65,
        child: charts.TimeSeriesChart(
          _getSeries(),
          defaultRenderer:
              charts.LineRendererConfig(includePoints: true, radiusPx: 3),
          domainAxis: charts.DateTimeAxisSpec(
            renderSpec: charts.GridlineRendererSpec(
              labelStyle: charts.TextStyleSpec(
                  color: charts.MaterialPalette.gray.shade600),
            ),
          ),
          primaryMeasureAxis: charts.NumericAxisSpec(
            viewport: charts.NumericExtents(50, 150),
            renderSpec: charts.GridlineRendererSpec(
              labelStyle: charts.TextStyleSpec(
                color: charts.MaterialPalette.gray.shade600,
              ),
            ),
          ),
          animate: false,
          selectionModels: [
            new charts.SelectionModelConfig(
              type: charts.SelectionModelType.info,
              changedListener: _onSelectionChange,
            )
          ],
          dateTimeFactory: const charts.LocalDateTimeFactory(),
          defaultInteractions: true,
        ),
      ),
    ];

    _children.add(
      new Padding(
        padding: new EdgeInsets.only(top: 5.0),
        child: new Text(
          _time == null ? "" : Util.formatTime(_time!),
        ),
      ),
    );

    _measures?.forEach((String series, num value) {
      Color textColor;
      switch (series) {
        case 'Systolic':
          textColor = Colors.red;
          break;
        case 'Diastolic':
          textColor = Colors.blue;
          break;
        default:
          textColor = Colors.green;
          break;
      }
      _children.add(
        new Text(
          '$series: $value',
          style: TextStyle(
            color: textColor,
          ),
        ),
      );
    });

    return Column(children: _children);
  }
}

class _TimeSeriesBPData {
  final DateTime time;
  final int data;

  _TimeSeriesBPData({required this.time,required this.data});
}
