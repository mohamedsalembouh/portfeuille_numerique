import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:portfeuille_numerique/db/sql_helper.dart';
import 'package:portfeuille_numerique/statistiques.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:sqflite/sqflite.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'form_recherche.dart';
import 'methodes.dart';
import 'models/argent.dart';
import 'models/compte.dart';
import 'models/compteRessource.dart';
import 'models/depensesCats.dart';
import 'models/ressource.dart';

class detailStatistique extends StatefulWidget {
  // const detailStatistique({ Key? key }) : super(key: key);
  int? id_utilisateur;
  detailStatistique(this.id_utilisateur);

  @override
  State<detailStatistique> createState() =>
      _detailStatistiqueState(this.id_utilisateur);
}

class _detailStatistiqueState extends State<detailStatistique> {
  int? id_utilisateur;
  _detailStatistiqueState(this.id_utilisateur);
  final List<Tab> mytabs = [
    // Tab(
    //   text: "solde",
    // ),
    Tab(
      text: "depense",
    ),
    Tab(
      text: "Rapports",
    )
  ];
  int? total;
  int? totalRevenus;
  List<charts.Series<diagram, String>>? _seriedata;
  List<depensesCats>? allDepensesCats;
  int? count;
  int? count2;
  List<depensesCats>? allrevenus;
  int? rvenusCount;
  int? depensesCount;
  //List<operation_sortir>? alldepenses;
  static var revenus;
  static var depenses;
  List<argent>? allargentCompte;
  static var diagramdata;
  SQL_Helper helper = SQL_Helper();
  TextEditingController dateDebut = TextEditingController();
  TextEditingController dateFin = TextEditingController();
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

  String nomRessource = "Specifie un compte";
  updateCategories(String nomRess) async {
    if (nomRess != "Specifie un compte") {
      ressource? res = await helper.getSpecifyRessource(nomRess);
      int idres = res!.id_ress!;
      compte? cmp = await helper.getSpecifyCompte(idres);
      int id_cmp = cmp!.id!;
      final Future<Database>? db = helper.initialiseDataBase();
      var ourDb = db;
      if (ourDb != null) {
        ourDb.then((database) {
          Future<List<depensesCats>> depenses =
              helper.getSpecifyDepensesCats(id_cmp, this.id_utilisateur!);

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
              helper.getAllDepensesCats(this.id_utilisateur!);

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
    if (nomRess != "Specifie un compte") {
      ressource? res = await helper.getSpecifyRessource(nomRess);
      int idres = res!.id_ress!;
      compte? cmp = await helper.getSpecifyCompte(idres);
      int id_cmp = cmp!.id!;
      final Future<Database>? db = helper.initialiseDataBase();
      var ourDb = db;
      if (ourDb != null) {
        ourDb.then((database) {
          Future<List<depensesCats>> revenies =
              helper.getSpecifyRevenusCats(id_cmp, this.id_utilisateur!);

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
              helper.getAllRevenusCats(this.id_utilisateur!);

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
    if (nomRess == "Specifie un compte") {
      final Future<Database>? db = helper.initialiseDataBase();
      var ourDb = db;
      if (ourDb != null) {
        ourDb.then((database) {
          Future<List<depensesCats>> revenies =
              helper.getAllRevenusrecherche(debut, fin, this.id_utilisateur!);

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
          Future<List<depensesCats>> revenies =
              helper.getSpecifyRevenusrecherche(
                  debut, fin, id_cmp, this.id_utilisateur!);

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
    if (nomRess == "Specifie un compte") {
      final Future<Database>? db = helper.initialiseDataBase();
      var ourDb = db;
      if (ourDb != null) {
        ourDb.then((database) {
          Future<List<depensesCats>> depense =
              helper.getRechercheDepenses(debut, fin, this.id_utilisateur!);

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
          Future<List<depensesCats>> depense =
              helper.getSpecifyRechercheDepenses(
                  debut, fin, id_cmp, this.id_utilisateur!);

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

  getTousArgent(String nomRess) async {
    if (nomRess != "Specifie un compte") {
      ressource? res = await helper.getSpecifyRessource(nomRess);
      int idRes = res!.id_ress!;
      int a = this.id_utilisateur!;
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
      int a = this.id_utilisateur!;
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

  @override
  Widget build(BuildContext context) {
    print(this.id_utilisateur);
    if (allrevenus == null) {
      getAllRevenusCats(nomRessource);
    }
    if (allDepensesCats == null) {
      updateCategories(nomRessource);
      // getUniqueDepenses();
    } else {
      _seriedata = [];
      generatedData();
    }
    // if (this.allargentCompte == null) {
    //   getTousArgent(nomRessource);
    // }
    // diagramdata = this.allargentCompte;
    print(diagramdata);
    // print(allDepensesCats!.length);
    // print(allrevenus!.length);
    revenus = getUniqueRevenus();
    rvenusCount = revenus.length;
    depenses = getUniqueDepenses();
    depensesCount = depenses.length;
    //depenses = this.alldepenses;
    total = getTotal();
    totalRevenus = getTotalRevenus();
    return MaterialApp(
        home: DefaultTabController(
      length: mytabs.length,
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          leading: IconButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            icon: BackButtonIcon(),
          ),
          title: Text("Statistiques"),
          bottom: TabBar(
            tabs: mytabs,
          ),
        ),
        body: TabBarView(
          children: [
            //first container
            // Column(
            //   children: [
            //     Padding(
            //       padding: EdgeInsets.only(top: 30, left: 10),
            //       child: FutureBuilder(
            //           future: getComptesRessource(this.id_utilisateur!),
            //           builder: (BuildContext context,
            //               AsyncSnapshot<List<compteRessource>> snapshot) {
            //             if (!snapshot.hasData) {
            //               return CircularProgressIndicator();
            //             } else {
            //               return DropdownButton<String>(
            //                 items: snapshot.data!
            //                     .map((cmpRes) => DropdownMenuItem<String>(
            //                           child: Text(cmpRes.nom_ress!),
            //                           value: cmpRes.nom_ress,
            //                         ))
            //                     .toList(),
            //                 onChanged: (String? value) {
            //                   setState(() {
            //                     nomRessource = value!;
            //                   });
            //                   getTousArgent(nomRessource);
            //                 },
            //                 isExpanded: true,
            //                 //value: currentNomCat,
            //                 hint: Text(
            //                   '$nomRessource',
            //                   style: TextStyle(
            //                     fontSize: 17,
            //                     //fontWeight: FontWeight.bold
            //                   ),
            //                 ),
            //               );
            //             }
            //           }),
            //     ),
            //     Padding(
            //       padding: const EdgeInsets.only(top: 40),
            //       child: Container(
            //         height: MediaQuery.of(context).size.height - 300,
            //         child: SfCartesianChart(
            //           primaryXAxis: CategoryAxis(),
            //           title: ChartTitle(text: 'Evolution de solde quotidienne'),
            //           legend: Legend(isVisible: true),
            //           tooltipBehavior: TooltipBehavior(enable: true),
            //           series: <ChartSeries<argent, int>>[
            //             LineSeries(
            //                 dataSource: diagramdata,
            //                 xValueMapper: (argent diag, _) =>
            //                     DateTime.parse(diag.date!).day,
            //                 yValueMapper: (argent diag, _) => diag.montant,
            //                 name: 'Solde',
            //                 dataLabelSettings:
            //                     DataLabelSettings(isVisible: true))
            //           ],
            //         ),
            //       ),
            //     ),
            //   ],
            // ),
            //end of first container

            //start second container
            Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.only(top: 30, left: 10),
                    child: FutureBuilder(
                        future: getComptesRessource(this.id_utilisateur!),
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
                                  nomRessource = value!;
                                });
                                updateCategories(nomRessource);
                              },
                              isExpanded: true,
                              //value: currentNomCat,
                              hint: Text(
                                '$nomRessource',
                                style: TextStyle(
                                  fontSize: 17,
                                  //fontWeight: FontWeight.bold
                                ),
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
                  // Container(
                  //   decoration: BoxDecoration(
                  //       border: Border.all(width: 3, color: Colors.blueAccent),
                  //       borderRadius: BorderRadius.all(Radius.circular(3))),
                  //   child:
                  // Column(
                  //     children: [

                  Padding(
                    padding: const EdgeInsets.only(top: 5, left: 20, right: 20),
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    rechercheRapport(this.id_utilisateur!)));
                      },
                      child: Row(
                        children: [
                          Icon(Icons.search),
                          SizedBox(
                            width: 20,
                          ),
                          Text('Rechercher')
                        ],
                      ),
                    ),
                  ),
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
