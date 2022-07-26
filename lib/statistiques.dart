import 'package:flutter/material.dart';
import 'package:portfeuille_numerique/methodes.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:portfeuille_numerique/models/depensesCats.dart';
import 'package:portfeuille_numerique/models/operation_entree.dart';
import 'package:portfeuille_numerique/models/operation_sortir.dart';
import 'package:portfeuille_numerique/models/utilisateur.dart';
import 'package:sqflite/sqflite.dart';

class statistique extends StatefulWidget {
  //const statistique({Key? key}) : super(key: key);

  utilisateur? usr;
  statistique(this.usr);
  @override
  State<statistique> createState() => _statistiqueState(this.usr);
}

class _statistiqueState extends State<statistique> {
  utilisateur? usr;
  _statistiqueState(this.usr);
  int? total;
  int? totalRevenus;
  List<charts.Series<diagram, String>>? _seriedata;
  List<charts.Series<pollution, String>>? _mesdata;
  List<charts.Series<salles, int>>? _allsalles;
  List<depensesCats>? allDepensesCats;
  int? count;
  int? count2;
  List<depensesCats>? allrevenus;
  int? rvenusCount;
  int? depensesCount;

  //List<operation_sortir>? alldepenses;
  static var revenus;
  static var depenses;
  List<depensesCats>? depens;
  _generatedData() {}

  var piedata2 = <diagram>[];
  generatedData() async {
    Color col;
    var piedata = <diagram>[];

    if (allDepensesCats != null) {
      for (int i = 0; i < count!; i++) {
        if (allDepensesCats![i].coleur == "Vert") {
          col = Colors.green;
        } else if (allDepensesCats![i].coleur == "Rouge") {
          col = Colors.red;
        } else if (allDepensesCats![i].coleur == "Joune") {
          col = Colors.yellow;
        } else if (allDepensesCats![i].coleur == "Rose") {
          col = Colors.pink;
        } else {
          col = Colors.black;
        }

        int tot = 0;
        for (int j = 0; j < count!; j++) {
          if (allDepensesCats![j].nomcat == allDepensesCats![i].nomcat &&
              i != j) {
            tot = tot + allDepensesCats![j].montant!;
          }
        }
        piedata.add(diagram(allDepensesCats![i].nomcat,
            allDepensesCats![i].montant! + tot, col));
      }
      var ids = Set();
      piedata.retainWhere((element) => ids.add(element.nomCat));
    } else {
      piedata.add(diagram("aa", 345, Colors.black));
    }

    _seriedata!.add(
      charts.Series(
          data: piedata,
          domainFn: (diagram task, _) => task.nomCat,
          measureFn: (diagram task, _) => task.montant,
          colorFn: (diagram task, _) =>
              charts.ColorUtil.fromDartColor(task.colorval),
          id: 'Daily task',
          labelAccessorFn: (diagram row, _) => '${row.montant}'),
    );
    piedata2 = piedata;
  }

  getTotal() {
    int to = 0;
    for (int i = 0; i < piedata2.length; i++) {
      to = to + piedata2[i].montant!;
    }
    return to;
  }

  getTotalRevenus() {
    var unqRev = getUniqueRevenus();
    int to = 0;
    for (int i = 0; i < unqRev.length; i++) {
      to = (to + unqRev[i].montant!) as int;
    }
    return to;
  }

  getUniqueDepenses() {
    var uniquedepenses = [];
    if (allDepensesCats != null) {
      for (int i = 0; i < count!; i++) {
        int tot = 0;
        for (int j = 0; j < count!; j++) {
          if (allDepensesCats![j].nomcat == allDepensesCats![i].nomcat &&
              i != j) {
            tot = tot + allDepensesCats![j].montant!;
          }
        }
        uniquedepenses.add(depensesCats(
            allDepensesCats![i].id,
            allDepensesCats![i].montant! + tot,
            allDepensesCats![i].description,
            allDepensesCats![i].date,
            allDepensesCats![i].id_categorie,
            allDepensesCats![i].nomcat,
            allDepensesCats![i].coleur));
      }
    } else {}
    var ids = Set();
    uniquedepenses.retainWhere((element) => ids.add(element.nomcat));
    return uniquedepenses;
  }

  getUniqueRevenus() {
    var uniquerevenu = [];
    if (allrevenus != null) {
      for (int i = 0; i < count2!; i++) {
        int tot = 0;
        for (int j = 0; j < count2!; j++) {
          if (allrevenus![j].nomcat == allrevenus![i].nomcat && i != j) {
            tot = tot + allrevenus![j].montant!;
          }
        }
        uniquerevenu.add(depensesCats(
            allrevenus![i].id,
            allrevenus![i].montant! + tot,
            allrevenus![i].description,
            allrevenus![i].date,
            allrevenus![i].id_categorie,
            allrevenus![i].nomcat,
            allrevenus![i].coleur));
      }
    } else {}
    var ids = Set();
    uniquerevenu.retainWhere((element) => ids.add(element.nomcat));
    return uniquerevenu;
  }

  updateCategories() async {
    utilisateur? user =
        await helper.getUser(this.usr!.email!, this.usr!.password!);
    int a = user!.id!;
    final Future<Database>? db = helper.initialiseDataBase();
    var ourDb = db;
    if (ourDb != null) {
      ourDb.then((database) {
        Future<List<depensesCats>> depenses = helper.getAllDepensesCats(a);

        depenses.then((theList) {
          setState(() {
            this.allDepensesCats = theList;
            if (allDepensesCats != null) {
              this.count = theList.length;
            }
          });
        });
      });
    }
  }

  getAllRevenusCats() async {
    utilisateur? user =
        await helper.getUser(this.usr!.email!, this.usr!.password!);
    int a = user!.id!;
    final Future<Database>? db = helper.initialiseDataBase();
    var ourDb = db;
    if (ourDb != null) {
      ourDb.then((database) {
        Future<List<depensesCats>> revenies = helper.getAllRevenusCats(a);

        revenies.then((theList) {
          setState(() {
            this.allrevenus = theList;
            if (allrevenus != null) {
              this.count2 = theList.length;
            }
          });
        });
      });
    }
  }

  // getAllDepenses() async {
  //   utilisateur? user =
  //       await helper.getUser(this.usr!.email!, this.usr!.password!);
  //   int a = user!.id!;
  //   final Future<Database>? db = helper.initialiseDataBase();
  //   var ourDb = db;
  //   if (ourDb != null) {
  //     ourDb.then((database) {
  //       Future<List<operation_sortir>> revenies = helper.getAllDepenses(a);

  //       revenies.then((theList) {
  //         setState(() {
  //           this.alldepenses = theList;
  //           if (alldepenses != null) {
  //             this.depensesCount = theList.length;
  //           }
  //         });
  //       });
  //     });
  //   }
  // }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    updateCategories();
    _seriedata = [];
    _mesdata = [];
    _allsalles = [];
    // _generatedData();
    generatedData();
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
    if (allrevenus == null) {
      getAllRevenusCats();
    }
    if (allDepensesCats == null) {
      updateCategories();
      // getUniqueDepenses();
    } else {
      _seriedata = [];
      generatedData();
    }
    // print(allDepensesCats!.length);
    // print(allrevenus!.length);
    revenus = getUniqueRevenus();
    rvenusCount = revenus.length;
    depenses = getUniqueDepenses();
    depensesCount = depenses.length;
    //depenses = this.alldepenses;
    total = getTotal();
    totalRevenus = getTotalRevenus();
    print(count);
    print(depenses);
    print(depenses.length);
    // print(total);
    // print(usr!.password);
    // print(allDepensesCats!.length);
    return MaterialApp(
        home: DefaultTabController(
      length: mytabs.length,
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          title: Text("Statistiques"),
          bottom: TabBar(
            tabs: mytabs,
          ),
        ),
        drawer: drowerfunction(context, usr),
        body: TabBarView(
          children: [
            //first container
            Container(
                //   child: Column(
                //     children: [
                //       Container(
                //         width: 400,
                //         height: 200,
                //         child: charts.BarChart(
                //           _mesdata,
                //           animate: true,
                //           animationDuration: Duration(seconds: 5),
                //           //barGroupingType: charts.BarGroupingType.grouped,
                //           defaultRenderer:
                //               charts.BarRendererConfig(maxBarWidthPx: 40),
                //           // behaviors: [
                //           //   new charts.DatumLegend(
                //           //     outsideJustification:
                //           //         charts.OutsideJustification.endDrawArea,
                //           //     horizontalFirst: false,
                //           //     desiredMaxRows: 2,
                //           //     cellPadding: new EdgeInsets.only(right: 4, bottom: 4),
                //           //     entryTextStyle: charts.TextStyleSpec(
                //           //       color: charts.MaterialPalette.purple.shadeDefault,
                //           //       fontSize: 11,
                //           //     ),
                //           //   )
                //           // ],
                //         ),
                //       ),
                //       Container(
                //         width: 400,
                //         height: 200,
                //         child: charts.LineChart(
                //           _allsalles,
                //           animate: true,
                //           animationDuration: Duration(seconds: 5),
                //           //barGroupingType: charts.BarGroupingType.grouped,
                //           defaultRenderer: charts.LineRendererConfig(
                //               includeArea: true, stacked: true),
                //           behaviors: [
                //             charts.ChartTitle('year',
                //                 behaviorPosition: charts.BehaviorPosition.bottom,
                //                 titleOutsideJustification:
                //                     charts.OutsideJustification.middleDrawArea),
                //             charts.ChartTitle('sales',
                //                 behaviorPosition: charts.BehaviorPosition.start,
                //                 titleOutsideJustification:
                //                     charts.OutsideJustification.middleDrawArea),
                //             charts.ChartTitle('departement',
                //                 behaviorPosition: charts.BehaviorPosition.end,
                //                 titleOutsideJustification:
                //                     charts.OutsideJustification.middleDrawArea)
                //           ],
                //         ),
                //       ),
                //     ],
                //   ),
                ),
            //end of first container

            //start second container
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
                          "Le total de depenses  :",
                          style: TextStyle(fontSize: 20),
                        ),
                        Text(
                          "$total",
                          style: TextStyle(fontSize: 20, color: Colors.green),
                        ),
                      ],
                    ),
                  ),
                  //ajouter ici le diagramme circulaire
                  Padding(
                    padding: EdgeInsets.only(top: 40),
                    child: Container(
                      width: 400,
                      height: 400,
                      child: charts.PieChart(
                        _seriedata,
                        animate: true,
                        animationDuration: Duration(seconds: 5),
                        defaultRenderer: new charts.ArcRendererConfig(
                            arcWidth: 70,
                            arcRendererDecorators: [
                              new charts.ArcLabelDecorator(
                                  labelPosition: charts.ArcLabelPosition.inside)
                            ]),
                        behaviors: [
                          new charts.DatumLegend(
                            outsideJustification:
                                charts.OutsideJustification.endDrawArea,
                            horizontalFirst: false,
                            desiredMaxRows: 2,
                            cellPadding:
                                new EdgeInsets.only(right: 4, bottom: 4),
                            entryTextStyle: charts.TextStyleSpec(
                              color: charts.MaterialPalette.purple.shadeDefault,
                              fontSize: 11,
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                  Container()
                ],
              ),
            ),
            //end second container
            Container(
              child: Column(
                children: [
                  Padding(
                      padding: EdgeInsets.only(top: 20),
                      child: Card(
                        child: Text(
                          "Registre des revenus et depense ",
                          style: TextStyle(fontSize: 18),
                        ),
                      )),
                  Padding(
                    padding: EdgeInsets.only(top: 10),
                    child: ListTile(
                      title: Text("Revenus"),
                      trailing: Text("$totalRevenus"),
                    ),
                  ),
                  Expanded(
                    child: ListView.builder(
                      //itemBuilder: ,
                      itemCount: rvenusCount,
                      itemBuilder: (context, pos) {
                        return Card(
                          color: Colors.white,
                          //elevation: 2.0,
                          child: ListTile(
                            title: Text("${revenus[pos].nomcat}"),
                            trailing: Text("${revenus[pos].montant}"),
                          ),
                        );
                      },
                    ),
                  ),
                  ListTile(
                    title: Text("depenses"),
                    trailing: Text("$total"),
                  ),
                  Expanded(
                      child: ListView.builder(
                          itemCount: depensesCount,
                          itemBuilder: (context, pos) {
                            return Card(
                              child: ListTile(
                                title: Text("${depenses[pos].nomcat}"),
                                trailing: Text("${depenses[pos].montant}"),
                              ),
                            );
                          })),
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

class diagram {
  String? nomCat;
  int? montant;
  Color? colorval;
  diagram.withnull();
  diagram(this.nomCat, this.montant, this.colorval);
}

// _generatedData() {
//   var listsalles1 = [
//     salles(1, 10),
//     salles(2, 20),
//     salles(3, 30),
//     salles(4, 60),
//   ];
//   var listsalles2 = [
//     salles(1, 25),
//     salles(2, 45),
//     salles(3, 70),
//     salles(4, 90),
//   ];
//   var listsalles3 = [
//     salles(1, 65),
//     salles(2, 28),
//     salles(3, 35),
//     salles(4, 55),
//   ];
//   var data1 = [
//     pollution("NKTT", 2018, 2345),
//     pollution("NDB", 2010, 20000),
//     pollution("Kiffa", 2020, 40000),
//   ];
//   var data2 = [
//     pollution("Rosso", 2019, 234500),
//     pollution("Nema", 2010, 50000),
//     pollution("Aioun", 2022, 400000)
//   ];
//   var data3 = [
//     pollution("aaa", 2001, 100000),
//     pollution("bbb", 2002, 200000),
//     pollution("ccc", 2003, 300000)
//   ];
//   var piedata = [
//     Task("work", 40000, Colors.red),
//     Task("work", 5000, Colors.red),
//     Task("achats", 2000, Colors.green),
//     // Task("ventes", 40000, Colors.orange),
//     // Task("hhhh", 40000, Colors.yellow),
//   ];
//   _allsalles!.add(
//     charts.Series(
//       domainFn: (salles sale, _) => sale.year,
//       measureFn: (salles sale, _) => sale.salle,
//       id: '2025',
//       data: listsalles1,
//       // fillPatternFn: (_, __) => charts.FillPatternType.solid,
//     ),
//   );
//   _allsalles!.add(
//     charts.Series(
//       domainFn: (salles sale, _) => sale.year,
//       measureFn: (salles sale, _) => sale.salle,
//       id: '2025',
//       data: listsalles2,
//       // fillPatternFn: (_, __) => charts.FillPatternType.solid,
//     ),
//   );
//   _mesdata!.add(
//     charts.Series(
//         domainFn: (pollution poll, _) => poll.place,
//         measureFn: (pollution poll, _) => poll.quantite,
//         id: '2025',
//         data: data1,
//         fillPatternFn: (_, __) => charts.FillPatternType.solid,
//         fillColorFn: (pollution poll, _) =>
//             charts.ColorUtil.fromDartColor(Colors.green)),
//   );
//   _mesdata!.add(
//     charts.Series(
//         domainFn: (pollution poll, _) => poll.place,
//         measureFn: (pollution poll, _) => poll.quantite,
//         id: '2025',
//         data: data2,
//         fillPatternFn: (_, __) => charts.FillPatternType.solid,
//         fillColorFn: (pollution poll, _) =>
//             charts.ColorUtil.fromDartColor(Colors.green)),
//   );
//   // _seriedata!.add(
//   //   charts.Series(
//   //       data: piedata,
//   //       domainFn: (Task task, _) => task.task,
//   //       measureFn: (Task task, _) => task.taskvalue,
//   //       colorFn: (Task task, _) =>
//   //           charts.ColorUtil.fromDartColor(task.colorval),
//   //       id: 'Daily task',
//   //       labelAccessorFn: (Task row, _) => '${row.taskvalue}'),
//   // );
// }
