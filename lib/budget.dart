import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:portfeuille_numerique/formBudget.dart';
import 'package:portfeuille_numerique/methodes.dart';
import 'package:portfeuille_numerique/models/catBudget.dart';
import 'package:portfeuille_numerique/models/depensesCats.dart';
import 'package:portfeuille_numerique/models/utilisateur.dart';
import 'package:sqflite/sqflite.dart';
import 'package:get/get.dart';

class budget extends StatefulWidget {
  utilisateur? usr;
  int? selectedPage;
  budget(this.usr, this.selectedPage);
  @override
  State<budget> createState() => _budgetState(this.usr, this.selectedPage);
}

class _budgetState extends State<budget> {
  final List<Tab> mytabs = [
    Tab(
      text: "51".tr,
    ),
    Tab(
      text: "52".tr,
    ),
    Tab(
      text: "32".tr,
    )
  ];
  utilisateur? usr;
  int? selectedPage;
  _budgetState(this.usr, this.selectedPage);
  List<catBudget>? allbudgets;
  int count = 0;
  static var budgets;
  List<depensesCats>? mesDepenses;
  int long = 0;
  static var depenses;

  getAllBudgets() async {
    utilisateur? user =
        await helper.getUser(this.usr!.email!, this.usr!.password!);
    int id = user!.id!;
    final Future<Database>? db = helper.initialiseDataBase();
    var ourDb = db;
    if (ourDb != null) {
      ourDb.then((database) {
        Future<List<catBudget>> empDettes = helper.getAllBudgets(id);
        empDettes.then((theList) {
          setState(() {
            this.allbudgets = theList;
            this.count = theList.length;
          });
        });
      });
    }
  }

  termineBudget(int id) async {
    int result = await helper.update_budget(id);
    if (result != 0) {
      getAllBudgets();
    }
  }

  SuprimezBudget(int id) async {
    int result = await helper.deleteBudget(id);
    if (result != 0) {
      getAllBudgets();
    }
  }

  getDepenses(String nomCat) async {
    utilisateur? user =
        await helper.getUser(this.usr!.email!, this.usr!.password!);
    int id = user!.id!;
    final Future<Database>? db = helper.initialiseDataBase();
    var ourDb = db;
    if (ourDb != null) {
      ourDb.then((database) {
        Future<List<depensesCats>> dep =
            helper.getAllSpecifyDepense(nomCat, id);
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

  int indexTab = 0;
  @override
  Widget build(BuildContext context) {
    if (this.allbudgets == null) {
      getAllBudgets();
    }
    budgets = this.allbudgets;
    //faireNotifications();
    return DefaultTabController(
      initialIndex: selectedPage!,
      length: mytabs.length,
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          bottom: TabBar(
              onTap: (value) {
                setState(() {
                  indexTab = value;
                });
              },
              tabs: mytabs),
          title: Text("b".tr),
        ),
        drawer: drowerfunction(context, this.usr),
        body: TabBarView(
          children: [
            Column(
              children: [
                Expanded(
                  child: ListView.builder(
                      itemCount: count,
                      itemBuilder: (context, pos) {
                        DateTime debut =
                            DateTime.parse(budgets[pos].date_debut!);
                        String dateDebut =
                            DateFormat("dd-MM-yyyy").format(debut);
                        DateTime fin = DateTime.parse(budgets[pos].date_fin!);
                        String dateFin = DateFormat("dd-MM-yyyy").format(fin);

                        if (budgets[pos].status == 0) {
                          return Card(
                            elevation: 8,
                            shape: RoundedRectangleBorder(
                              side: BorderSide(
                                color: Colors.white.withOpacity(1),
                              ),
                              borderRadius: BorderRadius.circular(20.0),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.only(top: 10),
                              child: ListTile(
                                title: Column(
                                  children: [
                                    Text("${budgets[pos].nombdg}"),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Text("22".tr +
                                        " : " +
                                        "${budgets[pos].montant}"),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Text("64".tr +
                                        " : " +
                                        "${budgets[pos].nomcat}"),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Text("47".tr + " : " + "$dateDebut"),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Text("57".tr + " : " + "$dateFin")
                                  ],
                                ),
                                onTap: () {
                                  AlertDialog alertDialog = AlertDialog(
                                    //title: Icon(Icons.finish),
                                    content: Text("53".tr),
                                    actions: [
                                      TextButton(
                                        child: Text(
                                          "26".tr,
                                        ),
                                        onPressed: () {
                                          Navigator.of(context,
                                                  rootNavigator: true)
                                              .pop();
                                        },
                                      ),
                                      TextButton(
                                        child: Text(
                                          "36".tr,
                                          style: TextStyle(color: Colors.red),
                                        ),
                                        onPressed: () {
                                          termineBudget(budgets[pos].id);
                                          Navigator.of(context,
                                                  rootNavigator: true)
                                              .pop();
                                        },
                                      ),
                                    ],
                                  );
                                  showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return alertDialog;
                                      });
                                },
                              ),
                            ),
                          );
                        } else {
                          return Container();
                        }
                      }),
                ),
              ],
            ),
            //l'autre page
            Column(
              children: [
                Expanded(
                  child: ListView.builder(
                      itemCount: count,
                      itemBuilder: (context, pos) {
                        DateTime debut =
                            DateTime.parse(budgets[pos].date_debut!);
                        String dateDebut =
                            DateFormat("dd-MM-yyyy").format(debut);
                        DateTime fin = DateTime.parse(budgets[pos].date_fin!);
                        String dateFin = DateFormat("dd-MM-yyyy").format(fin);

                        if (budgets[pos].status == 1) {
                          return Card(
                            elevation: 8,
                            shape: RoundedRectangleBorder(
                              side: BorderSide(
                                color: Colors.white.withOpacity(1),
                              ),
                              borderRadius: BorderRadius.circular(20.0),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.only(top: 10),
                              child: ListTile(
                                leading: Icon(Icons.check),
                                title: Column(
                                  children: [
                                    Text("${budgets[pos].nombdg}"),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Text("22".tr +
                                        " : " +
                                        "${budgets[pos].montant}"),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Text("64".tr +
                                        " : " +
                                        "${budgets[pos].nomcat}"),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Text("47".tr + " : " + "$dateDebut"),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Text("57".tr + " : " + "$dateFin")
                                  ],
                                ),
                                onTap: () {
                                  AlertDialog alertDialog = AlertDialog(
                                    title: Icon(Icons.delete),
                                    content: Text("54".tr),
                                    actions: [
                                      TextButton(
                                        child: Text(
                                          "26".tr,
                                        ),
                                        onPressed: () {
                                          Navigator.of(context,
                                                  rootNavigator: true)
                                              .pop();
                                        },
                                      ),
                                      TextButton(
                                        child: Text(
                                          "38".tr,
                                          style: TextStyle(color: Colors.red),
                                        ),
                                        onPressed: () {
                                          SuprimezBudget(budgets[pos].id);
                                          Navigator.of(context,
                                                  rootNavigator: true)
                                              .pop();
                                        },
                                      ),
                                    ],
                                  );
                                  showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return alertDialog;
                                      });
                                },
                              ),
                            ),
                          );
                        } else {
                          return Container();
                        }
                      }),
                ),
              ],
            ),
            Column(
              children: [
                Expanded(
                  child: ListView.builder(
                      itemCount: count,
                      itemBuilder: (context, pos) {
                        DateTime debut =
                            DateTime.parse(budgets[pos].date_debut!);
                        DateTime fin = DateTime.parse(budgets[pos].date_fin!);
                        DateTime now = DateTime.parse(
                            DateFormat("yyyy-MM-dd").format(DateTime.now()));
                        if (budgets[pos].status == 0) {
                          int allmnt = someMontant(budgets[pos].nomcat);
                          if (budgets[pos].montant < allmnt &&
                              now.compareTo(debut) > 0 &&
                              now.compareTo(fin) < 0) {
                            return Padding(
                              padding: const EdgeInsets.only(top: 20),
                              child: Card(
                                  child: Text(
                                      "125".tr + "${budgets[pos].nombdg} ")),
                            );
                          } else {
                            return Container();
                          }
                        } else {
                          return Container();
                        }
                      }),
                )
              ],
            ),
          ],
        ),
        floatingActionButton: indexTab == 0
            ? FloatingActionButton(
                child: Icon(
                  Icons.add,
                  size: 20,
                ),
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => formbudget(this.usr)));
                },
              )
            : null,
      ),
    );
  }
}
