import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:portfeuille_numerique/form_recherche.dart';
import 'package:portfeuille_numerique/methodes.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:portfeuille_numerique/models/argent.dart';
import 'package:portfeuille_numerique/models/compte.dart';
import 'package:portfeuille_numerique/models/depensesCats.dart';
import 'package:portfeuille_numerique/models/emprunte_dette.dart';
import 'package:portfeuille_numerique/models/objective.dart';
import 'package:portfeuille_numerique/models/operation_entree.dart';
import 'package:portfeuille_numerique/models/operation_sortir.dart';
import 'package:portfeuille_numerique/models/prette_dette.dart';
import 'package:portfeuille_numerique/models/ressource.dart';
import 'package:portfeuille_numerique/models/utilisateur.dart';
import 'package:portfeuille_numerique/objectifs.dart';
import 'package:sqflite/sqflite.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import 'models/compteRessource.dart';
import 'package:get/get.dart';

class statistique extends StatefulWidget {
  //const statistique({Key? key}) : super(key: key);

  utilisateur? usr;

  statistique(this.usr);
  @override
  State<statistique> createState() => _statistiqueState(this.usr);
}

class _statistiqueState extends State<statistique> {
  utilisateur? usr;
  //List<diagrameSolde> allUpdateSolde = [];
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

  String nomRessource = "72".tr;
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
  // List<diagrameSolde> diagramData =
  // [
  //   diagrameSolde(DateTime.parse("2000-10-02"), 35, "bb"),
  //   diagrameSolde(DateTime.parse("2000-10-03"), 28, "bb"),
  //   diagrameSolde(DateTime.parse("2000-10-05"), 34, "bb"),
  //   diagrameSolde(DateTime.parse("2000-10-07"), 32, "bb"),
  //   diagrameSolde(DateTime.parse("2000-10-09"), 40, "bb"),
  // ];

  List<argent>? allargentCompte;
  List<argent>? allargentBankily;
  List<argent>? allargentBank;
  static var diagramdata;
  static var diagramDataBank;
  static var diagramDataBankily;
  static var diagramDataCompte;
  // fullListes() {
  //   allUpdateSolde.forEach((element) {
  //     diagramData.add(element);
  //     // if (element.type == "Bankily") {
  //     //   diagramDataBankily.add(element);
  //     // } else if (element.type == "Bank") {
  //     //   diagramDataBank.add(element);
  //     // } else {
  //     //   diagramDataCompte.add(element);
  //     // }
  //   });
  // }

  // getAllMontant(int id) async {
  //   List<compte> Soldes = await helper.getAllComptesUser(id);
  //   List<operation_entree> revenus = await helper.getAllRevenus(id);
  //   List<operation_sortir> depenses = await helper.getAllDepenses(id);
  //   List<prette_dette> prettes = await helper.getAllPrettesDettes(id);
  //   List<emprunte_dette> empruntes = await helper.getAllEmprunteDettes(id);
  //   List<objective> objectifs = await helper.getAllObjectivfs(id);
  //   Soldes.forEach((element) {
  //     allUpdateSolde
  //         .add(diagrameSolde.aaa(DateTime.parse(element.date!), element.solde));
  //   });
  //   revenus.forEach((element) {
  //     allUpdateSolde.add(
  //         diagrameSolde.aaa(DateTime.parse(element.date!), element.montant));
  //   });
  //   depenses.forEach((element) {
  //     allUpdateSolde.add(
  //         diagrameSolde.aaa(DateTime.parse(element.date!), element.montant));
  //   });
  //   prettes.forEach((element) {
  //     allUpdateSolde.add(
  //         diagrameSolde.aaa(DateTime.parse(element.date!), element.montant));
  //   });
  //   empruntes.forEach((element) {
  //     allUpdateSolde.add(
  //         diagrameSolde.aaa(DateTime.parse(element.date!), element.montant));
  //   });
  //   objectifs.forEach((element) {
  //     allUpdateSolde.add(diagrameSolde.aaa(
  //         DateTime.parse(element.date!), element.montant_donnee));
  //   });
  //   diagramData = allUpdateSolde;
  // }

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
    updateCategories(nomRessource);
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
      getAllRevenusCats(nomRessource);
    }
    if (allDepensesCats == null) {
      updateCategories(nomRessource);
    } else {
      _seriedata = [];
      generatedData();
    }
    if (this.allargentCompte == null) {
      getTousArgent(nomRessource);
    }
    diagramdata = this.allargentCompte;
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
                  padding: EdgeInsets.only(top: 30, left: 10),
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
                                nomRessource = value!;
                              });
                              getTousArgent(nomRessource);
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
                Padding(
                  padding: const EdgeInsets.only(top: 40),
                  child: Container(
                    height: MediaQuery.of(context).size.height - 300,
                    child: SfCartesianChart(
                      primaryXAxis: CategoryAxis(),
                      title: ChartTitle(text: 'Evolution de solde quotidienne'),
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
                  // Padding(
                  //   padding: EdgeInsets.only(top: 40, bottom: 20),
                  //   child: Row(
                  //     mainAxisAlignment: MainAxisAlignment.spaceAround,
                  //     children: [
                  //       Text(
                  //         "Le total de depenses  :",
                  //         style: TextStyle(fontSize: 20),
                  //       ),
                  //       Text(
                  //         "$total",
                  //         style: TextStyle(fontSize: 20, color: Colors.green),
                  //       ),
                  //     ],
                  //   ),
                  // ),
                  Padding(
                    padding: EdgeInsets.only(top: 30, left: 10),
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
                  // Row(
                  //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  //   children: [
                  //     Container(
                  //       width: 200,
                  //       child: Padding(
                  //         padding: EdgeInsets.only(),
                  //         //const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                  //         child: TextFormField(
                  //           // initialValue:
                  //           //     DateFormat("yyyy-MM-dd").format(DateTime.now()),
                  //           controller: dateDebut,
                  //           decoration: InputDecoration(
                  //             border: UnderlineInputBorder(),
                  //             labelText: "Date debut ",
                  //             icon: Icon(Icons.calendar_today_outlined),
                  //           ),
                  //           onTap: () async {
                  //             DateTime? pickeddate = await showDatePicker(
                  //                 context: context,
                  //                 initialDate: DateTime.now(),
                  //                 firstDate: DateTime(2000),
                  //                 lastDate: DateTime(2050));

                  //             setState(() {
                  //               dateDebut.text = DateFormat("yyyy-MM-dd")
                  //                   .format(pickeddate!);
                  //             });
                  //           },
                  //         ),
                  //       ),
                  //     ),
                  //     Container(
                  //       width: 200,
                  //       child: Padding(
                  //         padding: EdgeInsets.only(),
                  //         //const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                  //         child: TextFormField(
                  //           // initialValue:
                  //           //     DateFormat("yyyy-MM-dd").format(DateTime.now()),
                  //           controller: dateFin,
                  //           //keyboardType: TextInputType.datetime,
                  //           decoration: InputDecoration(
                  //             border: UnderlineInputBorder(),
                  //             labelText: "Date Fin ",
                  //             icon: Icon(Icons.calendar_today_outlined),
                  //           ),
                  //           onTap: () async {
                  //             DateTime? pickeddate = await showDatePicker(
                  //                 context: context,
                  //                 initialDate: DateTime.now(),
                  //                 firstDate: DateTime(2000),
                  //                 lastDate: DateTime(2050));

                  //             setState(() {
                  //               dateFin.text = DateFormat("yyyy-MM-dd")
                  //                   .format(pickeddate!);
                  //             });
                  //           },
                  //         ),
                  //       ),
                  //     ),
                  //   ],
                  // ),

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
                          Text('Rechercher')
                        ],
                      ),
                      style: ElevatedButton.styleFrom(shape: StadiumBorder()),
                    ),
                  ),
                  // Padding(
                  //   padding: EdgeInsets.only(top: 10, left: 10),
                  //   child: FutureBuilder(
                  //       future: getComptesRessource(this.usr!.id!),
                  //       builder: (BuildContext context,
                  //           AsyncSnapshot<List<compteRessource>> snapshot) {
                  //         if (!snapshot.hasData) {
                  //           return CircularProgressIndicator();
                  //         } else {
                  //           return DropdownButton<String>(
                  //             items: snapshot.data!
                  //                 .map((cmpRes) => DropdownMenuItem<String>(
                  //                       child: Text(cmpRes.nom_ress!),
                  //                       value: cmpRes.nom_ress,
                  //                     ))
                  //                 .toList(),
                  //             onChanged: (String? value) {
                  //               setState(() {
                  //                 nomRessource = value!;
                  //                 // dateDebut.clear();
                  //                 // dateFin.clear();
                  //               });
                  //               updateCategories(nomRessource);
                  //               getAllRevenusCats(nomRessource);
                  //               dateDebut.clear();
                  //               dateFin.clear();
                  //             },

                  //             isExpanded: true,
                  //             //value: currentNomCat,
                  //             hint: Text(
                  //               '$nomRessource',
                  //               style: TextStyle(
                  //                 fontSize: 17,
                  //                 //fontWeight: FontWeight.bold
                  //               ),
                  //             ),
                  //           );
                  //         }
                  //       }),
                  // ),

                  // ],
                  //   ),
                  // ),
                  Padding(
                      padding: EdgeInsets.only(top: 20),
                      child: Card(
                        child: Text(
                          "Registre des revenus et depense ",
                          style: TextStyle(fontSize: 20),
                        ),
                      )),
                  Padding(
                    padding: EdgeInsets.only(top: 10),
                    child: ListTile(
                      title: Text(
                        "Revenus",
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
                        // if (dateDebut.text == "choisisez un date" ||
                        //     dateFin.text == "choisisez un date") {

                        //   return Card(
                        //     color: Colors.white,
                        //     //elevation: 2.0,
                        //     child: ListTile(
                        //       title: Text("${revenus[pos].nomcat}"),
                        //       trailing: Text("${revenus[pos].montant}"),
                        //     ),
                        //   );
                        // } else {
                        //   DateTime datebetween =
                        //       DateTime.parse(revenus[pos].date!);
                        //   DateTime debut = DateTime.parse(dateDebut.text);
                        //   DateTime fin = DateTime.parse(dateFin.text);
                        //   if (datebetween.compareTo(debut) > 0 &&
                        //       datebetween.compareTo(fin) < 0) {
                        //    // totl = (totl + revenus[pos].montant) as int;

                        //     return Card(
                        //       color: Colors.white,
                        //       //elevation: 2.0,
                        //       child: ListTile(
                        //         title: Text("${revenus[pos].nomcat}"),
                        //         trailing: Text("${revenus[pos].montant}"),
                        //       ),
                        //     );
                        //   } else {
                        //     return Container();
                        //   }
                        // }
                      },
                    ),
                  ),
                  ListTile(
                    title: Text(
                      "depenses",
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
                            // DateTime datebetween =
                            //     DateTime.parse(depenses[pos].date!);
                            // String date1 = DateFormat("yyyy-MM-dd")
                            //     .format(DateTime.parse(dateDebut.text));
                            // DateTime debut = DateTime.parse(dateDebut.text);
                            // String date2 = DateFormat("yyyy-MM-dd")
                            //     .format(DateTime.parse(dateFin.text));
                            // DateTime fin = DateTime.parse(dateFin.text);
                            // if ((datebetween.compareTo(debut) > 0 &&
                            //         datebetween.compareTo(fin) < 0) ||
                            //     (debut.compareTo(fin) == 0)) {
                            // if (dateDebut.text == "choisisez un date" ||
                            //     dateFin.text == "choisisez un date") {
                            //   return Card(
                            //     child: ListTile(
                            //       title: Text("${depenses[pos].nomcat}"),
                            //       trailing: Text("${depenses[pos].montant}"),
                            //     ),
                            //   );
                            // } else {
                            //   DateTime datebetween =
                            //       DateTime.parse(revenus[pos].date!);
                            //   DateTime debut = DateTime.parse(dateDebut.text);
                            //   DateTime fin = DateTime.parse(dateFin.text);
                            //   if (datebetween.compareTo(debut) > 0 &&
                            //       datebetween.compareTo(fin) < 0) {
                            //     return Card(
                            //       child: ListTile(
                            //         title: Text("${depenses[pos].nomcat}"),
                            //         trailing: Text("${depenses[pos].montant}"),
                            //       ),
                            //     );
                            //   } else {
                            //     return Container();
                            //   }
                            // }

                            // } else {
                            //   return Container();
                            // }
                            // return Card(
                            //   child: ListTile(
                            //     title: Text("${depenses[pos].nomcat}"),
                            //     trailing: Text("${depenses[pos].montant}"),
                            //   ),
                            // );
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
