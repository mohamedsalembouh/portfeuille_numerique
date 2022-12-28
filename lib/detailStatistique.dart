import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:portfeuille_numerique/db/sql_helper.dart';
import 'package:portfeuille_numerique/statistiques.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:sqflite/sqflite.dart';
import 'models/argent.dart';
import 'models/compte.dart';
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

  // @override
  // void initState() {
  //   // TODO: implement initState
  //   super.initState();
  //   updateCategories(nomRessource);
  //   _seriedata = [];
  //   // _generatedData();
  //   generatedData();
  // }

  // generatedData() async {
  //   Color col;
  //   var piedata = <diagram>[];

  //   if (allDepensesCats != null) {
  //     for (int i = 0; i < count!; i++) {
  //       if (allDepensesCats![i].coleur == "vert") {
  //         col = Colors.green;
  //       } else if (allDepensesCats![i].coleur == "rouge") {
  //         col = Colors.red;
  //       } else if (allDepensesCats![i].coleur == "jaune") {
  //         col = Colors.yellow;
  //       } else if (allDepensesCats![i].coleur == "rose") {
  //         col = Colors.pink;
  //       } else if (allDepensesCats![i].coleur == 'blue') {
  //         col = Colors.blue;
  //       } else if (allDepensesCats![i].coleur == 'orange') {
  //         col = Colors.orange;
  //       } else if (allDepensesCats![i].coleur == 'gris') {
  //         col = Colors.grey;
  //       } else if (allDepensesCats![i].coleur == 'marron') {
  //         col = Colors.brown;
  //       } else if (allDepensesCats![i].coleur == 'violet') {
  //         col = Colors.purple;
  //       } else {
  //         col = Colors.black;
  //       }

  //       int tot = 0;
  //       for (int j = 0; j < count!; j++) {
  //         if (allDepensesCats![j].nomcat == allDepensesCats![i].nomcat &&
  //             i != j) {
  //           tot = tot + allDepensesCats![j].montant!;
  //         }
  //       }
  //       piedata.add(diagram(allDepensesCats![i].nomcat,
  //           allDepensesCats![i].montant! + tot, col));
  //     }
  //     var ids = Set();
  //     piedata.retainWhere((element) => ids.add(element.nomCat));
  //   } else {
  //     piedata.add(diagram("aa", 345, Colors.black));
  //   }

  //   _seriedata!.add(
  //     charts.Series(
  //         data: piedata,
  //         domainFn: (diagram task, _) => task.nomCat!,
  //         measureFn: (diagram task, _) => task.montant,
  //         colorFn: (diagram task, _) =>
  //             charts.ColorUtil.fromDartColor(task.colorval!),
  //         id: 'Daily task',
  //         labelAccessorFn: (diagram row, _) => '${row.montant}'),
  //   );
  //   piedata2 = piedata;
  // }

  // getTotal() {
  //   int to = 0;
  //   for (int i = 0; i < piedata2.length; i++) {
  //     to = to + piedata2[i].montant!;
  //   }
  //   return to;
  // }

  getTotalDepenses() {
    var unqdep = getUniqueDepenses();
    int to = 0;
    for (int i = 0; i < unqdep.length; i++) {
      to = (to + unqdep[i].montant!) as int;
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

  @override
  Widget build(BuildContext context) {
    print(this.id_utilisateur);
    if (allrevenus == null) {
      getAllRevenusCats(nomRessource);
    }
    if (allDepensesCats == null) {
      updateCategories(nomRessource);
    }
    print(diagramdata);
    revenus = getUniqueRevenus();
    rvenusCount = revenus.length;
    depenses = getUniqueDepenses();
    depensesCount = depenses.length;
    total = getTotalDepenses();
    totalRevenus = getTotalRevenus();
    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            icon: BackButtonIcon(),
          ),
          title: Text("71".tr),
        ),
        body: Container(
          child: Column(
            children: [
              Padding(
                  padding: EdgeInsets.only(top: 20),
                  child: Card(
                    child: Text(
                      "75".tr,
                      style: TextStyle(fontSize: 18),
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
                          child: ListTile(
                            title: Text("${depenses[pos].nomcat}"),
                            trailing: Text("${depenses[pos].montant}"),
                          ),
                        );
                      })),
            ],
          ),
        ));
  }
}
