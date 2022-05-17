import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;

class objectif extends StatefulWidget {
  const objectif({Key? key}) : super(key: key);

  @override
  State<objectif> createState() => _objectifState();
}

class _objectifState extends State<objectif> {
  List<charts.Series<Task, String>>? _seriedata;
  _generatedData() {
    var piedata = [
      Task("work", 300, Colors.red),
      Task("student", 10000, Colors.green),
      Task("hhhhh", 2000, Colors.orange),
    ];
    _seriedata!.add(
      charts.Series(
          data: piedata,
          domainFn: (Task task, _) => task.task,
          measureFn: (Task task, _) => task.taskvalue,
          colorFn: (Task task, _) =>
              charts.ColorUtil.fromDartColor(task.colorval),
          id: 'Daily task',
          labelAccessorFn: (Task row, _) => '${row.taskvalue}'),
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _seriedata = [];
    _generatedData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Container(
        width: 100,
        height: 100,
        child: charts.PieChart(
          _seriedata,
          animate: true,
          animationDuration: Duration(seconds: 5),
          // behaviors: [
          //   new charts.DatumLegend(
          //     outsideJustification: charts.OutsideJustification.endDrawArea,
          //     horizontalFirst: false,
          //     desiredMaxRows: 2,
          //     cellPadding: new EdgeInsets.only(right: 4, bottom: 4),
          //     entryTextStyle: charts.TextStyleSpec(
          //       color: charts.MaterialPalette.purple.shadeDefault,
          //       fontSize: 11,
          //     ),
          //   )
          // ],
          defaultRenderer: new charts.ArcRendererConfig(
              arcWidth: 50,
              arcRendererDecorators: [
                new charts.ArcLabelDecorator(
                    labelPosition: charts.ArcLabelPosition.inside)
              ]),
        ),
      ),
    );
  }
}

class Task {
  String? task;
  double? taskvalue;
  Color? colorval;

  Task(this.task, this.taskvalue, this.colorval);
}
