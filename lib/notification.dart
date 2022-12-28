import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:portfeuille_numerique/db/sql_helper.dart';
import 'package:portfeuille_numerique/models/utilisateur.dart';
import 'package:sqflite/sqflite.dart';
import 'methodes.dart';
import 'models/catBudget.dart';
import 'models/depensesCats.dart';
import 'models/emprunte_dette.dart';
import 'models/objective.dart';
import 'models/prette_dette.dart';

class notification extends StatefulWidget {
  utilisateur? usr;
  int? selectedPage;
  notification(this.usr, this.selectedPage);

  @override
  State<notification> createState() =>
      _notificationState(this.usr, this.selectedPage);
}

class _notificationState extends State<notification> {
  utilisateur? usr;
  int? selectedPage;
  _notificationState(this.usr, this.selectedPage);

  final List<Tab> mytabs = [
    Tab(
      text: "dettes",
    ),
    Tab(
      text: "budgets et objectifs",
    )
  ];
  List<prette_dette>? pretedetes;
  int count = 0;
  static var prettes;
  List<emprunte_dette>? empruntedetes;
  int count2 = 0;
  static var empruntes;
  List<catBudget>? allbudgets;
  int count3 = 0;
  static var budgets;
  SQL_Helper helper = SQL_Helper();
  List<depensesCats>? mesDepenses;
  int long = 0;
  static var depenses;
  List<objective>? someobjectif;
  int count4 = 0;
  static var someobjectives;

  getAllPretteDette() async {
    final Future<Database>? db = helper.initialiseDataBase();
    var ourDb = db;
    if (ourDb != null) {
      ourDb.then((database) {
        Future<List<prette_dette>> pretDettes =
            helper.getAllPrettesDettes(this.usr!.id!);
        pretDettes.then((theList) {
          setState(() {
            this.pretedetes = theList;
            this.count = theList.length;
          });
        });
      });
    }
  }

  getAllEmprunteDette() async {
    final Future<Database>? db = helper.initialiseDataBase();
    var ourDb = db;
    if (ourDb != null) {
      ourDb.then((database) {
        Future<List<emprunte_dette>> empDettes =
            helper.getAllEmprunteDettes(this.usr!.id!);
        empDettes.then((theList) {
          setState(() {
            this.empruntedetes = theList;
            this.count2 = theList.length;
          });
        });
      });
    }
  }

  getAllBudgets() async {
    utilisateur? user =
        await helper.getUser(this.usr!.email!, this.usr!.password!);
    int id = user!.id!;
    final Future<Database>? db = helper.initialiseDataBase();
    var ourDb = db;
    if (ourDb != null) {
      ourDb.then((database) {
        Future<List<catBudget>> bdgs = helper.getsomesBudgets(
            id, DateFormat("yyyy-MM-dd").format(DateTime.now()));
        bdgs.then((theList) {
          setState(() {
            this.allbudgets = theList;
            this.count3 = theList.length;
          });
        });
      });
    }
  }

  getDepenses(String nomCat) async {
    final Future<Database>? db = helper.initialiseDataBase();
    var ourDb = db;
    if (ourDb != null) {
      ourDb.then((database) {
        Future<List<depensesCats>> dep =
            helper.getAllSpecifyDepense(nomCat, this.usr!.id!);
        dep.then((theList) {
          setState(() {
            this.mesDepenses = theList;
            this.long = theList.length;
          });
        });
      });
    }
  }

  someMontant(String nomCat) {
    if (this.mesDepenses == null) {
      getDepenses(nomCat);
    }
    depenses = this.mesDepenses;

    int k = this.long;
    int allMontant = 0;
    for (int i = 0; i < k; i++) {
      allMontant = (allMontant + depenses[i].montant) as int;
    }
    return allMontant;
  }

  getObjectifs() async {
    final Future<Database>? db = helper.initialiseDataBase();
    var ourDb = db;
    if (ourDb != null) {
      ourDb.then((database) {
        Future<List<objective>> objs = helper.getSomeObjectivfs(this.usr!.id!);
        objs.then((theList) {
          setState(() {
            this.someobjectif = theList;
            this.count4 = theList.length;
          });
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (this.pretedetes == null) {
      getAllPretteDette();
    }
    if (this.empruntedetes == null) {
      getAllEmprunteDette();
    }
    if (this.allbudgets == null) {
      getAllBudgets();
    }
    if (this.someobjectif == null) {
      getObjectifs();
    }
    someobjectives = this.someobjectif;
    budgets = this.allbudgets;
    prettes = this.pretedetes;
    empruntes = this.empruntedetes;
    return DefaultTabController(
      length: mytabs.length,
      initialIndex: selectedPage!,
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          bottom: TabBar(
            tabs: mytabs,
          ),
          title: Text("32".tr),
        ),
        drawer: drowerfunction(context, this.usr),
        body: TabBarView(
          children: [
            Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: Card(
                    child: Text(
                      "39".tr,
                      // style: TextStyle(color: Colors.green),
                    ),
                  ),
                ),
                Expanded(
                    child: ListView.builder(
                        itemCount: count,
                        itemBuilder: (context, pos) {
                          DateTime dateEcheance =
                              DateTime.parse(prettes[pos].date_echeance!);
                          String maintenant =
                              DateFormat("yyyy-MM-dd").format(DateTime.now());
                          DateTime dateMaintenant = DateTime.parse(maintenant);

                          if (prettes[pos].status == 0) {
                            if (dateEcheance
                                    .difference(dateMaintenant)
                                    .inDays ==
                                3) {
                              return Card(
                                  child: Padding(
                                padding: EdgeInsets.only(top: 20),
                                child: Text(
                                  " ${prettes[pos].nom}" +
                                      "119".tr +
                                      "${prettes[pos].montant}" +
                                      "122".tr,
                                  style: TextStyle(color: Colors.green),
                                ),
                              ));
                            } else if (dateEcheance
                                    .difference(dateMaintenant)
                                    .inDays ==
                                2) {
                              return Card(
                                  child: Padding(
                                padding: EdgeInsets.only(top: 20),
                                child: Text(
                                  " ${prettes[pos].nom}" +
                                      "119".tr +
                                      "${prettes[pos].montant}" +
                                      "121".tr,
                                  style: TextStyle(color: Colors.green),
                                ),
                              ));
                            } else if (dateEcheance
                                    .difference(dateMaintenant)
                                    .inDays ==
                                1) {
                              return Card(
                                  child: Padding(
                                padding: EdgeInsets.only(top: 20),
                                child: Text(
                                  " ${prettes[pos].nom}" +
                                      "119".tr +
                                      "${prettes[pos].montant}" +
                                      "120".tr,
                                  style: TextStyle(color: Colors.green),
                                ),
                              ));
                            } else if (dateEcheance
                                    .difference(dateMaintenant)
                                    .inDays ==
                                0) {
                              return Card(
                                  child: Padding(
                                padding: EdgeInsets.only(top: 20),
                                child: Text(
                                  " ${prettes[pos].nom}" +
                                      "119".tr +
                                      "${prettes[pos].montant}" +
                                      "123".tr,
                                  style: TextStyle(color: Colors.green),
                                ),
                              ));
                            } else {
                              return Container();
                            }
                          } else {
                            return Container();
                          }
                        })),
                Card(
                  child: Text(
                    "40".tr,
                    //  style: TextStyle(color: Colors.red),
                  ),
                ),
                Expanded(
                    child: ListView.builder(
                        itemCount: count2,
                        itemBuilder: (context, pos) {
                          DateTime dateEcheance =
                              DateTime.parse(empruntes[pos].date_echeance!);
                          String maintenant =
                              DateFormat("yyyy-MM-dd").format(DateTime.now());
                          DateTime dateMaintenant = DateTime.parse(maintenant);

                          if (empruntes[pos].status == 0) {
                            if (dateEcheance
                                    .difference(dateMaintenant)
                                    .inDays ==
                                3) {
                              return Card(
                                  child: Padding(
                                padding: EdgeInsets.only(top: 20),
                                child: Text(
                                  "124".tr +
                                      "${empruntes[pos].nom} ${empruntes[pos].montant}" +
                                      "122".tr,
                                  style: TextStyle(color: Colors.red),
                                ),
                              ));
                            } else if (dateEcheance
                                    .difference(dateMaintenant)
                                    .inDays ==
                                2) {
                              return Card(
                                  child: Padding(
                                padding: EdgeInsets.only(top: 20),
                                child: Text(
                                  "124".tr +
                                      "${empruntes[pos].nom} ${empruntes[pos].montant}" +
                                      "121".tr,
                                  style: TextStyle(color: Colors.red),
                                ),
                              ));
                            } else if (dateEcheance
                                    .difference(dateMaintenant)
                                    .inDays ==
                                1) {
                              return Card(
                                  child: Padding(
                                padding: EdgeInsets.only(top: 20),
                                child: Text(
                                  "124".tr +
                                      "${empruntes[pos].nom} ${empruntes[pos].montant}" +
                                      "120".tr,
                                  style: TextStyle(color: Colors.red),
                                ),
                              ));
                            } else if (dateEcheance
                                    .difference(dateMaintenant)
                                    .inDays ==
                                0) {
                              return Card(
                                  child: Padding(
                                padding: EdgeInsets.only(top: 20),
                                child: Text(
                                  "124".tr +
                                      "${empruntes[pos].nom} ${empruntes[pos].montant}" +
                                      "123".tr,
                                  style: TextStyle(color: Colors.red),
                                ),
                              ));
                            } else {
                              return Container();
                            }
                          } else {
                            return Container();
                          }
                        })),
              ],
            ),
            //l'autre page
            Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: Card(
                    child: Text(
                      "117".tr,
                      // style: TextStyle(color: Colors.green),
                    ),
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                      itemCount: count3,
                      itemBuilder: (context, pos) {
                        if (budgets[pos].status == 0) {
                          if (budgets[pos].montant <
                              someMontant(budgets[pos].nomcat)) {
                            return Card(
                                child:
                                    Text("125".tr + "${budgets[pos].nombdg} "));
                          } else {
                            return Container();
                          }
                        } else {
                          return Container();
                        }
                      }),
                ),
                Card(
                  child: Text(
                    "118".tr,
                  ),
                ),
                Expanded(
                    child: ListView.builder(
                        itemCount: count4,
                        itemBuilder: (context, pos) {
                          return Card(
                            child: Text("126".tr +
                                " " +
                                "${someobjectives[pos].nom_objective}" +
                                "127".tr),
                          );
                        }))
              ],
            )
          ],
        ),
      ),
    );
  }
}
