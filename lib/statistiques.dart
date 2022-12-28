import 'package:flutter/material.dart';
import 'package:portfeuille_numerique/form_recherche.dart';
import 'package:portfeuille_numerique/methodes.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:portfeuille_numerique/models/argent.dart';
import 'package:portfeuille_numerique/models/compte.dart';
import 'package:portfeuille_numerique/models/depensesCats.dart';
import 'package:portfeuille_numerique/models/ressource.dart';
import 'package:portfeuille_numerique/models/utilisateur.dart';
import 'package:sqflite/sqflite.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'models/compteRessource.dart';
import 'package:get/get.dart';

class statistique extends StatefulWidget {
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
  static var revenus;
  static var depenses;
  List<depensesCats>? depens;
  _generatedData() {}
  TextEditingController dateDebut = TextEditingController();
  TextEditingController dateFin = TextEditingController();
  var piedata2 = <diagram>[];
  generatedData() async {
    Color col;
    var piedata = <diagram>[];

    if (allDepensesCats != null) {
      for (int i = 0; i < count!; i++) {
        if (allDepensesCats![i].coleur == "vert") {
          col = Colors.green;
        } else if (allDepensesCats![i].coleur == "rouge") {
          col = Colors.red;
        } else if (allDepensesCats![i].coleur == "jaune") {
          col = Colors.yellow;
        } else if (allDepensesCats![i].coleur == "rose") {
          col = Colors.pink;
        } else if (allDepensesCats![i].coleur == 'blue') {
          col = Colors.blue;
        } else if (allDepensesCats![i].coleur == 'orange') {
          col = Colors.orange;
        } else if (allDepensesCats![i].coleur == 'gris') {
          col = Colors.grey;
        } else if (allDepensesCats![i].coleur == 'marron') {
          col = Colors.brown;
        } else if (allDepensesCats![i].coleur == 'violet') {
          col = Colors.purple;
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
          domainFn: (diagram task, _) => task.nomCat!,
          measureFn: (diagram task, _) => task.montant,
          colorFn: (diagram task, _) =>
              charts.ColorUtil.fromDartColor(task.colorval!),
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

  String nomRessource1 = "72".tr;
  String nomRessource2 = "72".tr;
  updateCategories(String nomRess) async {
    if (nomRess != "72".tr) {
      ressource? res = await helper.getSpecifyRessource(nomRess);
      int idres = res!.id_ress!;
      compte? cmp = await helper.getSpecifyCompte(idres);
      int id_cmp = cmp!.id!;
      final Future<Database>? db = helper.initialiseDataBase();
      var ourDb = db;
      if (ourDb != null) {
        ourDb.then((database) {
          Future<List<depensesCats>> depenses =
              helper.getSpecifyDepensesCats(id_cmp, this.usr!.id!);

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
    } else {
      final Future<Database>? db = helper.initialiseDataBase();
      var ourDb = db;
      if (ourDb != null) {
        ourDb.then((database) {
          Future<List<depensesCats>> depenses =
              helper.getAllDepensesCats(this.usr!.id!);

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
  }

  getAllRevenusCats(String nomRess) async {
    if (nomRess != "72".tr) {
      ressource? res = await helper.getSpecifyRessource(nomRess);
      int idres = res!.id_ress!;
      compte? cmp = await helper.getSpecifyCompte(idres);
      int id_cmp = cmp!.id!;
      final Future<Database>? db = helper.initialiseDataBase();
      var ourDb = db;
      if (ourDb != null) {
        ourDb.then((database) {
          Future<List<depensesCats>> revenies =
              helper.getSpecifyRevenusCats(id_cmp, this.usr!.id!);

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
    } else {
      final Future<Database>? db = helper.initialiseDataBase();
      var ourDb = db;
      if (ourDb != null) {
        ourDb.then((database) {
          Future<List<depensesCats>> revenies =
              helper.getAllRevenusCats(this.usr!.id!);

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
  }

  getRechercheRevenus(String debut, String fin, String nomRess) async {
    if (nomRess == "72".tr) {
      final Future<Database>? db = helper.initialiseDataBase();
      var ourDb = db;
      if (ourDb != null) {
        ourDb.then((database) {
          Future<List<depensesCats>> revenies =
              helper.getAllRevenusrecherche(debut, fin, this.usr!.id!);

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
    } else {
      ressource? res = await helper.getSpecifyRessource(nomRess);
      int idres = res!.id_ress!;
      compte? cmp = await helper.getSpecifyCompte(idres);
      int id_cmp = cmp!.id!;
      final Future<Database>? db = helper.initialiseDataBase();
      var ourDb = db;
      if (ourDb != null) {
        ourDb.then((database) {
          Future<List<depensesCats>> revenies = helper
              .getSpecifyRevenusrecherche(debut, fin, id_cmp, this.usr!.id!);

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
  }

  getRechercheDepense(String debut, String fin, String nomRess) async {
    if (nomRess == "72".tr) {
      final Future<Database>? db = helper.initialiseDataBase();
      var ourDb = db;
      if (ourDb != null) {
        ourDb.then((database) {
          Future<List<depensesCats>> depense =
              helper.getRechercheDepenses(debut, fin, this.usr!.id!);

          depense.then((theList) {
            setState(() {
              this.allDepensesCats = theList;
              if (allDepensesCats != null) {
                this.count = theList.length;
              }
            });
          });
        });
      }
    } else {
      ressource? res = await helper.getSpecifyRessource(nomRess);
      int idres = res!.id_ress!;
      compte? cmp = await helper.getSpecifyCompte(idres);
      int id_cmp = cmp!.id!;
      final Future<Database>? db = helper.initialiseDataBase();
      var ourDb = db;
      if (ourDb != null) {
        ourDb.then((database) {
          Future<List<depensesCats>> depense = helper
              .getSpecifyRechercheDepenses(debut, fin, id_cmp, this.usr!.id!);

          depense.then((theList) {
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
  }

  List<argent>? allargentCompte;
  List<argent>? allargentBankily;
  List<argent>? allargentBank;
  static var diagramdata;

  getTousArgent(String nomRess) async {
    if (nomRess != "72".tr) {
      ressource? res = await helper.getSpecifyRessource(nomRess);
      int idRes = res!.id_ress!;
      int a = this.usr!.id!;
      final Future<Database>? db = helper.initialiseDataBase();
      var ourDb = db;
      if (ourDb != null) {
        ourDb.then((database) {
          Future<List<argent>> argents =
              helper.getAllArgentSpecifyCompte(idRes, a);

          argents.then((theList) {
            setState(() {
              this.allargentCompte = theList;
            });
          });
        });
      }
    } else {
      int a = this.usr!.id!;
      final Future<Database>? db = helper.initialiseDataBase();
      var ourDb = db;
      if (ourDb != null) {
        ourDb.then((database) {
          Future<List<argent>> argents = helper.getAllArgent(a);

          argents.then((theList) {
            setState(() {
              this.allargentCompte = theList;
            });
          });
        });
      }
    }
  }

  List<depensesCats> mylist = [];
  int totl = 0;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    updateCategories(nomRessource2);
    _seriedata = [];
    _mesdata = [];
    _allsalles = [];
    // _generatedData();
    generatedData();
  }

  final List<Tab> mytabs = [
    Tab(
      text: "69".tr,
    ),
    Tab(
      text: "70".tr,
    ),
    Tab(
      text: "71".tr,
    )
  ];
  int indexTab = 0;
  @override
  Widget build(BuildContext context) {
    if (allrevenus == null) {
      getAllRevenusCats(nomRessource1);
    }
    if (allDepensesCats == null) {
      updateCategories(nomRessource2);
    } else {
      _seriedata = [];
      generatedData();
    }
    if (this.allargentCompte == null) {
      getTousArgent(nomRessource1);
    }
    diagramdata = this.allargentCompte;
    print(diagramdata);
    revenus = getUniqueRevenus();
    rvenusCount = revenus.length;
    depenses = getUniqueDepenses();
    depensesCount = depenses.length;
    total = getTotal();
    totalRevenus = getTotalRevenus();

    return DefaultTabController(
      length: mytabs.length,
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          title: Text("d".tr),
          bottom: TabBar(
            tabs: mytabs,
          ),
        ),
        drawer: drowerfunction(context, usr),
        body: TabBarView(
          children: [
            //first container
            Column(
              children: [
                Padding(
                  padding: EdgeInsets.only(top: 30, left: 20, right: 20),
                  child: FutureBuilder(
                      future: getComptesRessource(this.usr!.id!),
                      builder: (BuildContext context,
                          AsyncSnapshot<List<compteRessource>> snapshot) {
                        if (!snapshot.hasData) {
                          return CircularProgressIndicator();
                        } else {
                          return DropdownButton<String>(
                            items: snapshot.data!
                                .map((cmpRes) => DropdownMenuItem<String>(
                                      child: Text(cmpRes.nom_ress!),
                                      value: cmpRes.nom_ress,
                                    ))
                                .toList(),
                            onChanged: (String? value) {
                              setState(() {
                                nomRessource1 = value!;
                              });
                              getTousArgent(nomRessource1);
                            },
                            isExpanded: true,
                            //value: currentNomCat,
                            hint: Text(
                              '$nomRessource1',
                              style: TextStyle(
                                fontSize: 17,
                                //fontWeight: FontWeight.bold
                              ),
                            ),
                            underline: Container(
                              height: 2,
                              color: Colors.black,
                            ),
                          );
                        }
                      }),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 40),
                  child: Container(
                    height: MediaQuery.of(context).size.height - 300,
                    child: SfCartesianChart(
                      primaryXAxis: CategoryAxis(),
                      title: ChartTitle(text: '73'.tr),
                      legend: Legend(isVisible: true),
                      tooltipBehavior: TooltipBehavior(enable: true),
                      series: <ChartSeries<argent, int>>[
                        LineSeries(
                            dataSource: diagramdata,
                            xValueMapper: (argent diag, _) =>
                                DateTime.parse(diag.date!).day,
                            yValueMapper: (argent diag, _) => diag.montant,
                            name: 'Solde',
                            dataLabelSettings:
                                DataLabelSettings(isVisible: true))
                      ],
                    ),
                  ),
                ),
              ],
            ),
            //end of first container

            //start second container
            Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.only(top: 30, left: 20, right: 20),
                    child: FutureBuilder(
                        future: getComptesRessource(this.usr!.id!),
                        builder: (BuildContext context,
                            AsyncSnapshot<List<compteRessource>> snapshot) {
                          if (!snapshot.hasData) {
                            return CircularProgressIndicator();
                          } else {
                            return DropdownButton<String>(
                              items: snapshot.data!
                                  .map((cmpRes) => DropdownMenuItem<String>(
                                        child: Text(cmpRes.nom_ress!),
                                        value: cmpRes.nom_ress,
                                      ))
                                  .toList(),
                              onChanged: (String? value) {
                                setState(() {
                                  nomRessource2 = value!;
                                });
                                updateCategories(nomRessource2);
                              },
                              isExpanded: true,
                              //value: currentNomCat,
                              hint: Text(
                                '$nomRessource2',
                                style: TextStyle(
                                  fontSize: 17,
                                  //fontWeight: FontWeight.bold
                                ),
                              ),
                              underline: Container(
                                height: 2,
                                color: Colors.black,
                              ),
                            );
                          }
                        }),
                  ),
                  //ajouter ici le diagramme circulaire
                  Padding(
                    padding: EdgeInsets.only(top: 60),
                    child: Container(
                      width: 400,
                      height: 400,
                      child: charts.PieChart(
                        List.from(_seriedata!),
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
                              color: charts.MaterialPalette.black,
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
                    padding: const EdgeInsets.only(top: 5, left: 20, right: 20),
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    rechercheRapport(usr!.id!)));
                      },
                      child: Row(
                        children: [
                          Icon(Icons.search),
                          SizedBox(
                            width: 20,
                          ),
                          Text('74'.tr)
                        ],
                      ),
                      style: ElevatedButton.styleFrom(shape: StadiumBorder()),
                    ),
                  ),
                  Padding(
                      padding: EdgeInsets.only(top: 20),
                      child: Card(
                        child: Text(
                          "75".tr,
                          style: TextStyle(fontSize: 20),
                        ),
                      )),
                  Padding(
                    padding: EdgeInsets.only(top: 10),
                    child: ListTile(
                      title: Text(
                        "76".tr,
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      trailing: Text(
                        "$totalRevenus",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  Expanded(
                    child: ListView.builder(
                      //itemBuilder: ,
                      itemCount: rvenusCount,
                      itemBuilder: (context, pos) {
                        return Card(
                          elevation: 8,
                          shape: RoundedRectangleBorder(
                            side: BorderSide(
                              color: Colors.white.withOpacity(1),
                            ),
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                          child: ListTile(
                            title: Text("${revenus[pos].nomcat}"),
                            trailing: Text("${revenus[pos].montant}"),
                          ),
                        );
                      },
                    ),
                  ),
                  ListTile(
                    title: Text(
                      "77".tr,
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    trailing: Text(
                      "$total",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  Expanded(
                      child: ListView.builder(
                          itemCount: depensesCount,
                          itemBuilder: (context, pos) {
                            return Card(
                              elevation: 8,
                              shape: RoundedRectangleBorder(
                                side: BorderSide(
                                  color: Colors.white.withOpacity(1),
                                ),
                                borderRadius: BorderRadius.circular(20.0),
                              ),
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
    );
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

class diagrameSolde {
  //String? month;
  int? montant;
  DateTime? date;
  String? type;
  diagrameSolde(this.date, this.montant, this.type);
  diagrameSolde.aaa(this.date, this.montant);
}
