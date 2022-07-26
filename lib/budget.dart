import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:portfeuille_numerique/db/sql_helper.dart';
import 'package:portfeuille_numerique/formBudget.dart';
import 'package:portfeuille_numerique/methodes.dart';
import 'package:portfeuille_numerique/models/budgete.dart';
import 'package:portfeuille_numerique/models/catBudget.dart';
import 'package:portfeuille_numerique/models/depensesCats.dart';
import 'package:portfeuille_numerique/models/operation_sortir.dart';
import 'package:portfeuille_numerique/models/utilisateur.dart';
import 'package:portfeuille_numerique/services/local_notification_service.dart';
import 'package:sqflite/sqflite.dart';

import 'models/categorie.dart';

class budget extends StatefulWidget {
  utilisateur? usr;
  int? selectedPage;
  // budget({Key? key}) : super(key: key);
  budget(this.usr, this.selectedPage);
  @override
  State<budget> createState() => _budgetState(this.usr, this.selectedPage);
}

class _budgetState extends State<budget> {
  final List<Tab> mytabs = [
    Tab(
      text: "En cours",
    ),
    Tab(
      text: "Complet",
    ),
    Tab(
      text: "Notification",
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
  late final LocalNotificationService service;
  @override
  void initState() {
    // TODO: implement initState
    service = LocalNotificationService();
    service.initialize();
    listenToNotification();
    super.initState();
  }

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

  @override
  Widget build(BuildContext context) {
    if (this.allbudgets == null) {
      getAllBudgets();
    }
    budgets = this.allbudgets;
    //faireNotifications();
    return MaterialApp(
      home: DefaultTabController(
        initialIndex: selectedPage!,
        length: mytabs.length,
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          appBar: appbar2function(mytabs, "Budgets"),
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
                              color: Colors.white,
                              elevation: 2.0,
                              child: ListTile(
                                isThreeLine: true,
                                // leading: Icon(Icons.category),
                                title: Text("${budgets[pos].nombdg}"),
                                subtitle: Column(
                                  children: [
                                    Text("montant : ${budgets[pos].montant}"),
                                    Text("categorie : ${budgets[pos].nomcat}"),
                                  ],
                                ),
                                trailing: Column(
                                  children: [
                                    Text(" Date debut : $dateDebut"),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Text("Date Fin : $dateFin")
                                  ],
                                ),
                                onTap: () {
                                  AlertDialog alertDialog = AlertDialog(
                                    //title: Icon(Icons.finish),
                                    content: Text("Terminez cette budget "),
                                    actions: [
                                      TextButton(
                                        child: Text(
                                          "Annuler",
                                        ),
                                        onPressed: () {
                                          Navigator.of(context,
                                                  rootNavigator: true)
                                              .pop();
                                        },
                                      ),
                                      TextButton(
                                        child: Text(
                                          "Terminer",
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
                            );
                          } else {
                            return Container();
                          }
                        }),
                  ),
                  Padding(
                    padding: EdgeInsets.only(bottom: 20),
                    child: Align(
                      alignment: Alignment.bottomRight,
                      child: FloatingActionButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => formbudget(this.usr)));
                        },
                        child: Icon(Icons.add),
                      ),
                    ),
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
                              color: Colors.white,
                              elevation: 2.0,
                              child: ListTile(
                                isThreeLine: true,
                                //leading: Icon(Icons.check),
                                title: Text("${budgets[pos].nombdg}"),
                                subtitle: Column(
                                  children: [
                                    Text("montant : ${budgets[pos].montant}"),
                                    Text("categorie : ${budgets[pos].nomcat}"),
                                  ],
                                ),
                                trailing: Column(
                                  children: [
                                    Text(" Date debut : $dateDebut"),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Text("Date Fin : $dateFin")
                                  ],
                                ),
                                onTap: () {
                                  AlertDialog alertDialog = AlertDialog(
                                    title: Icon(Icons.delete),
                                    content: Text("Supprimez cette budget "),
                                    actions: [
                                      TextButton(
                                        child: Text(
                                          "Annuler",
                                        ),
                                        onPressed: () {
                                          Navigator.of(context,
                                                  rootNavigator: true)
                                              .pop();
                                        },
                                      ),
                                      TextButton(
                                        child: Text(
                                          "Suprimez",
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
                              return Card(
                                  child: Text(
                                      "Vous avez depasez le budget : ${budgets[pos].nombdg} "));
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
        ),
      ),
    );
  }

  faireNotifications() async {
    SQL_Helper helper = SQL_Helper();
    utilisateur? user =
        await helper.getUser(this.usr!.email!, this.usr!.password!);
    int a = user!.id!;
    List<categorie> allcategories = await helper.getAllcategories();
    allcategories.forEach((cat) async {
      List<depensesCats> depenses =
          await helper.getSpecifiedDepenses(a, cat.nomcat!);
      List<catBudget> budgets =
          await helper.getAllSpecifiedBudgets(a, cat.nomcat!);
      int allmnt = 0;
      for (depensesCats a in depenses) {
        allmnt = allmnt + a.montant!;
      }
      for (catBudget bdg in budgets) {
        if (bdg.status == 0) {
          DateTime debut = DateTime.parse(bdg.date_debut!);
          DateTime fin = DateTime.parse(bdg.date_fin!);
          DateTime now =
              DateTime.parse(DateFormat("yyyy-MM-dd").format(DateTime.now()));
          if (bdg.montant! < allmnt &&
              now.compareTo(debut) > 0 &&
              now.compareTo(fin) < 0) {
            service.showNotificationWithPayload(
                id: bdg.id!,
                title: "Hiiii",
                body: "vous etes depasez le budget ${bdg.nombdg}",
                payload: 'payload navigation');
          }
        }
      }
    });
  }

  void listenToNotification() =>
      service.onNotificationClick.stream.listen((onNotificationListener));
  void onNotificationListener(String? payload) {
    if (payload != null && payload.isNotEmpty) {
      print("payload $payload");
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => budget(usr, 2)));
    }
  }
}
