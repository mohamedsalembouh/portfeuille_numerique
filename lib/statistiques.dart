import 'package:flutter/material.dart';
import 'package:portfeuille_numerique/methodes.dart';
import 'package:charts_flutter/flutter.dart' as charts;

class statistique extends StatefulWidget {
  const statistique({Key? key}) : super(key: key);

  @override
  State<statistique> createState() => _statistiqueState();
}

class _statistiqueState extends State<statistique> {
  List<charts.Series<Task, String>>? _seriedata;
  List<charts.Series<pollution, String>>? _mesdata;
  List<charts.Series<salles, int>>? _allsalles;
  _generatedData() {
    var listsalles1 = [
      salles(1, 10),
      salles(2, 20),
      salles(3, 30),
      salles(4, 60),
    ];
    var listsalles2 = [
      salles(1, 25),
      salles(2, 45),
      salles(3, 70),
      salles(4, 90),
    ];
    var listsalles3 = [
      salles(1, 65),
      salles(2, 28),
      salles(3, 35),
      salles(4, 55),
    ];
    var data1 = [
      pollution("NKTT", 2018, 2345),
      pollution("NDB", 2010, 20000),
      pollution("Kiffa", 2020, 40000),
    ];
    var data2 = [
      pollution("Rosso", 2019, 234500),
      pollution("Nema", 2010, 50000),
      pollution("Aioun", 2022, 400000)
    ];
    var data3 = [
      pollution("aaa", 2001, 100000),
      pollution("bbb", 2002, 200000),
      pollution("ccc", 2003, 300000)
    ];
    var piedata = [
      Task("work", 40000, Colors.red),
      Task("achats", 200000, Colors.green),
      // Task("ventes", 40000, Colors.orange),
      // Task("hhhh", 40000, Colors.yellow),
    ];
    _allsalles!.add(
      charts.Series(
        domainFn: (salles sale, _) => sale.year,
        measureFn: (salles sale, _) => sale.salle,
        id: '2025',
        data: listsalles1,
        // fillPatternFn: (_, __) => charts.FillPatternType.solid,
      ),
    );
    _allsalles!.add(
      charts.Series(
        domainFn: (salles sale, _) => sale.year,
        measureFn: (salles sale, _) => sale.salle,
        id: '2025',
        data: listsalles2,
        // fillPatternFn: (_, __) => charts.FillPatternType.solid,
      ),
    );
    _mesdata!.add(
      charts.Series(
          domainFn: (pollution poll, _) => poll.place,
          measureFn: (pollution poll, _) => poll.quantite,
          id: '2025',
          data: data1,
          fillPatternFn: (_, __) => charts.FillPatternType.solid,
          fillColorFn: (pollution poll, _) =>
              charts.ColorUtil.fromDartColor(Colors.green)),
    );
    _mesdata!.add(
      charts.Series(
          domainFn: (pollution poll, _) => poll.place,
          measureFn: (pollution poll, _) => poll.quantite,
          id: '2025',
          data: data2,
          fillPatternFn: (_, __) => charts.FillPatternType.solid,
          fillColorFn: (pollution poll, _) =>
              charts.ColorUtil.fromDartColor(Colors.green)),
    );
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
    _mesdata = [];
    _allsalles = [];
    _generatedData();
  }

  final List<Tab> mytabs = [
    Tab(
      text: "solde",
    ),
    Tab(
      text: "depense",
    ),
    Tab(
      text: "Rapports",
    )
  ];
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: DefaultTabController(
      length: mytabs.length,
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: appbar2function(mytabs, "Statistiques"),
        drawer: drowerfunction(context),
        body: TabBarView(
          children: [
            Container(
              child: Column(
                children: [
                  Container(
                    width: 400,
                    height: 200,
                    child: charts.BarChart(
                      _mesdata,
                      animate: true,
                      animationDuration: Duration(seconds: 5),
                      //barGroupingType: charts.BarGroupingType.grouped,
                      defaultRenderer:
                          charts.BarRendererConfig(maxBarWidthPx: 40),
                      // behaviors: [
                      //   new charts.DatumLegend(
                      //     outsideJustification:
                      //         charts.OutsideJustification.endDrawArea,
                      //     horizontalFirst: false,
                      //     desiredMaxRows: 2,
                      //     cellPadding: new EdgeInsets.only(right: 4, bottom: 4),
                      //     entryTextStyle: charts.TextStyleSpec(
                      //       color: charts.MaterialPalette.purple.shadeDefault,
                      //       fontSize: 11,
                      //     ),
                      //   )
                      // ],
                    ),
                  ),
                  Container(
                    width: 400,
                    height: 200,
                    child: charts.LineChart(
                      _allsalles,
                      animate: true,
                      animationDuration: Duration(seconds: 5),
                      //barGroupingType: charts.BarGroupingType.grouped,
                      defaultRenderer: charts.LineRendererConfig(
                          includeArea: true, stacked: true),
                      behaviors: [
                        charts.ChartTitle('year',
                            behaviorPosition: charts.BehaviorPosition.bottom,
                            titleOutsideJustification:
                                charts.OutsideJustification.middleDrawArea),
                        charts.ChartTitle('sales',
                            behaviorPosition: charts.BehaviorPosition.start,
                            titleOutsideJustification:
                                charts.OutsideJustification.middleDrawArea),
                        charts.ChartTitle('departement',
                            behaviorPosition: charts.BehaviorPosition.end,
                            titleOutsideJustification:
                                charts.OutsideJustification.middleDrawArea)
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.only(top: 40, bottom: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Text(
                          "Les 30 dernieres jours :",
                          style: TextStyle(fontSize: 20),
                        ),
                        Text(
                          "1700000 ",
                          style: TextStyle(fontSize: 20, color: Colors.green),
                        ),
                      ],
                    ),
                  ),
                  //ajouter ici le diagramme circulaire
                  Container(
                    width: 200,
                    height: 200,
                    child: charts.PieChart(
                      _seriedata,
                      animate: true,
                      animationDuration: Duration(seconds: 5),
                      defaultRenderer: new charts.ArcRendererConfig(
                        arcWidth: 20,
                        // arcRendererDecorators: [
                        //   new charts.ArcLabelDecorator(
                        //       labelPosition: charts.ArcLabelPosition.inside)
                        // ]
                      ),
                      behaviors: [
                        new charts.DatumLegend(
                          outsideJustification:
                              charts.OutsideJustification.endDrawArea,
                          horizontalFirst: false,
                          desiredMaxRows: 2,
                          cellPadding: new EdgeInsets.only(right: 4, bottom: 4),
                          entryTextStyle: charts.TextStyleSpec(
                            color: charts.MaterialPalette.purple.shadeDefault,
                            fontSize: 11,
                          ),
                        )
                      ],
                    ),
                  ),
                  Container()
                ],
              ),
            ),
            Container(
              child: Column(
                children: [
                  Expanded(
                    child: Column(
                      children: [
                        Row(
                          children: [Text("Tableau des Revenus & depenses ")],
                        ),
                        Row(
                          children: [Text("Les 30 dernieres jours ")],
                        ),
                        // Padding(
                        //   padding: EdgeInsets.only(top: 20),
                        //   child: Row(
                        //     mainAxisAlignment: MainAxisAlignment.spaceAround,
                        //     children: [
                        //       Text("Presentation generale resume "),
                        //       Text("Revenus"),
                        //       Text("Depenses"),
                        //     ],
                        //   ),
                        // ),
                        // Row(
                        //   mainAxisAlignment: MainAxisAlignment.spaceAround,
                        //   children: [Text("Compteur"), Text("4"), Text("16")],
                        // ),
                        // Row(
                        //   mainAxisAlignment: MainAxisAlignment.spaceAround,
                        //   children: [
                        //     Text("Moyenne"),
                        //     Text("76000"),
                        //     Text("12000")
                        //   ],
                        // ),

                        // new code
                        Expanded(
                          child: ListView(
                            children: [
                              ListTile(
                                // isThreeLine: true,
                                title: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    Text("Presentation generale"),
                                    Text("Revenus"),
                                    Text("Depenses"),
                                  ],
                                ),
                              ),
                              ListTile(
                                //isThreeLine: true,
                                title: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    Text("Compteur"),
                                    Text("4"),
                                    Text("16")
                                  ],
                                ),
                              ),
                              ListTile(
                                //isThreeLine: true,
                                title: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    Text("Moyenne"),
                                    Text("76000"),
                                    Text("12000")
                                  ],
                                ),
                                //subtitle: Text("data"),
                              ),
                            ],
                          ),
                        ),
                        //fin new code
                      ],
                    ),
                  ),
                  Expanded(
                    child: Column(
                      children: [
                        // Row(
                        //   children: [Text("Registre des revenus et depenses ")],
                        // ),
                        // Row(
                        //   children: [Text("Les 30 dernieres jours ")],
                        // ),

                        Container(
                          child: Expanded(
                            child: Container(
                              // color: Colors.blue,
                              child: ListView(
                                children: [
                                  ListTile(
                                    title: Text(
                                        "Registre des revenus et depenses "),
                                  ),
                                  ListTile(
                                    title: Text("Revenus"),
                                    // leading: Icon(),
                                    trailing: Text("totale"),
                                  ),
                                  ListTile(
                                    title: Text("vente"),
                                    leading: Icon(Icons.play_arrow),
                                    trailing: Text("montant"),
                                  ),
                                  ListTile(
                                    title: Text("Depenses"),
                                    // leading: Icon(),
                                    trailing: Text("totale"),
                                  ),
                                  ListTile(
                                    title: Text("achats"),
                                    leading: Icon(Icons.play_arrow),
                                    trailing: Text("montant"),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    ));
  }
}

class Task {
  String? task;
  double? taskvalue;
  Color? colorval;

  Task(this.task, this.taskvalue, this.colorval);
}

class pollution {
  String? place;
  int? year;
  int? quantite;
  pollution(this.place, this.year, this.quantite);
}

class salles {
  int? salle;
  int? year;
  salles(this.salle, this.year);
}
