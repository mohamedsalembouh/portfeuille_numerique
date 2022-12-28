import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:portfeuille_numerique/methodes.dart';
import 'package:portfeuille_numerique/models/emprunte_dette.dart';
import 'package:portfeuille_numerique/models/utilisateur.dart';
import 'package:portfeuille_numerique/operationDettes.dart';
import 'package:sqflite/sqflite.dart';
import 'models/compte.dart';
import 'models/prette_dette.dart';
import 'package:get/get.dart';

class alldettes extends StatefulWidget {
  utilisateur? usr;
  int? selectedPage;
  //alldettes({Key? key}) : super(key: key);
  alldettes(this.usr, this.selectedPage);
  @override
  State<alldettes> createState() =>
      _alldettesState(this.usr, this.selectedPage);
}

class _alldettesState extends State<alldettes> {
  final List<Tab> mytabs = [
    Tab(
      text: "30".tr,
    ),
    Tab(
      text: "31".tr,
    ),
    Tab(
      text: "32".tr,
    )
  ];
  utilisateur? usr;
  int? selectedPage;
  // List<diagrameSolde>? allUpdateSolde;
  _alldettesState(this.usr, this.selectedPage);
  List<prette_dette>? pretedetes;
  int count = 0;
  static var prettes;
  List<emprunte_dette>? empruntedetes;
  int count2 = 0;
  int? so;
  static var solde;
  static var empruntes;

  minsSolde(int mnt, int idEmprunte, int idCmp) async {
    DateTime maintenant = DateTime.now();
    String date_maintenant = DateFormat("yyyy-MM-dd").format(maintenant);
    utilisateur? user =
        await helper.getUser(this.usr!.email!, this.usr!.password!);
    int a = user!.id!;
    compte? cmp = await helper.getCompteUserById(idCmp, a);
    if (cmp != null) {
      int solde = cmp.solde!;
      if (solde > mnt) {
        int newSolde = solde - mnt;
        compte updateCompte =
            compte(newSolde, date_maintenant, cmp.id_ressource, a);
        int? r1 = await helper.update_compte(updateCompte);
        int? r2 = await helper.update_EmprunteDette(idEmprunte);
        if (r1 != 0 && r2 != 0) {
          insertArgent(updateCompte.solde!, updateCompte.date!,
              updateCompte.id_ressource!, updateCompte.id_utilisateur!);
          getAllEmprunteDette();
        }
      } else {
        showText(context, "m5".tr, "m8".tr);
      }
    }
  }

  PlusSolde(int mnt, int idPrette, int idCmp) async {
    DateTime maintenant = DateTime.now();
    String date_maintenant = DateFormat("yyyy-MM-dd").format(maintenant);
    utilisateur? user =
        await helper.getUser(this.usr!.email!, this.usr!.password!);
    int a = user!.id!;
    compte? cmp = await helper.getCompteUserById(idCmp, a);
    if (cmp != null) {
      int solde = cmp.solde!;
      int newSolde = solde + mnt;
      compte updateCompte =
          compte(newSolde, date_maintenant, cmp.id_ressource, a);
      int? res1 = await helper.update_compte(updateCompte);
      int? res2 = await helper.update_pretteDette(idPrette);
      if (res1 != 0 && res2 != 0) {
        insertArgent(updateCompte.solde!, updateCompte.date!,
            updateCompte.id_ressource!, updateCompte.id_utilisateur!);
        getAllPretteDette();
      }
    }
  }

  getAllPretteDette() async {
    final Future<Database>? db = helper.initialiseDataBase();
    var ourDb = db;
    if (ourDb != null) {
      ourDb.then((database) {
        Future<List<prette_dette>> pretteDettes =
            helper.getAllPrettesDettes(this.usr!.id!);
        pretteDettes.then((theList) {
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

  deletePrete(int id) async {
    int? result = await helper.deletePreteDette(id);
    if (result != 0) {
      getAllPretteDette();
    }
  }

  deleteEmprunte(int id) async {
    int? result = await helper.deleteEmprunteDette(id);
    if (result != 0) {
      getAllEmprunteDette();
    }
  }

  int indexTab = 0;
  @override
  Widget build(BuildContext context) {
    if (this.pretedetes == null) {
      getAllPretteDette();
    }
    if (this.empruntedetes == null) {
      getAllEmprunteDette();
    }

    prettes = this.pretedetes;
    empruntes = this.empruntedetes;
    solde = this.so;

    return DefaultTabController(
      length: mytabs.length,
      initialIndex: selectedPage!,
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
          title: Text("a".tr),
        ),
        drawer: drowerfunction(context, usr),
        body: TabBarView(
          children: [
            Column(
              children: [
                Padding(
                    padding: EdgeInsets.only(top: 20),
                    child: Text(
                      "33".tr,
                      style: TextStyle(color: Colors.red, fontSize: 20),
                    )),
                Expanded(
                    child: ListView.builder(
                        itemCount: count,
                        itemBuilder: (context, pos) {
                          DateTime debut =
                              DateTime.parse(prettes[pos].date_debut!);
                          String dateDebut =
                              DateFormat("dd-MM-yyyy").format(debut);
                          DateTime fin =
                              DateTime.parse(prettes[pos].date_echeance!);
                          String dateFin = DateFormat("dd-MM-yyyy").format(fin);
                          String maintenant =
                              DateFormat("yyyy-MM-dd").format(DateTime.now());
                          DateTime dateMaintenant = DateTime.parse(maintenant);
                          // if (dateMaintenant.compareTo(fin) < 0) {
                          if (prettes[pos].status == 0) {
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
                                  title: Text("${prettes[pos].nom}"),
                                  subtitle: Column(
                                    children: [
                                      Text("${prettes[pos].montant}"),
                                      prettes[pos].objectif != ''
                                          ? Text("${prettes[pos].objectif}")
                                          : Container()
                                    ],
                                  ),
                                  trailing: Text("48".tr + " : " + "$dateFin"),
                                  onTap: () {
                                    AlertDialog alertDialog = AlertDialog(
                                      // title: Icon(Icons.home),
                                      content: Text("35".tr),
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
                                            PlusSolde(
                                                prettes[pos].montant,
                                                prettes[pos].id,
                                                prettes[pos].id_compte);

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
                        })),
                Padding(
                    padding: EdgeInsets.only(top: 20),
                    child: Text(
                      "34".tr,
                      style: TextStyle(color: Colors.green, fontSize: 20),
                    )),
                Expanded(
                    child: ListView.builder(
                        itemCount: count2,
                        itemBuilder: (context, pos) {
                          DateTime debut =
                              DateTime.parse(empruntes[pos].date_debut!);
                          String dateDebut =
                              DateFormat("dd-MM-yyyy").format(debut);
                          DateTime fin =
                              DateTime.parse(empruntes[pos].date_echeance!);
                          String dateFin = DateFormat("dd-MM-yyyy").format(fin);
                          String maintenant =
                              DateFormat("yyyy-MM-dd").format(DateTime.now());
                          DateTime dateMaintenant = DateTime.parse(maintenant);

                          if (empruntes[pos].status == 0) {
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
                                  title: Text("${empruntes[pos].nom}"),
                                  subtitle: Column(children: [
                                    Text("${empruntes[pos].montant}"),
                                    empruntes[pos].objectif != ''
                                        ? Text("${empruntes[pos].objectif}")
                                        : Container()
                                  ]),
                                  trailing: Text("48".tr + " : " + "$dateFin"),
                                  onTap: () {
                                    AlertDialog alertDialog = AlertDialog(
                                      //title: Icon(Icons.home),
                                      content: Text("35".tr),
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
                                            minsSolde(
                                                empruntes[pos].montant,
                                                empruntes[pos].id,
                                                empruntes[pos].id_compte);

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
                        })),
              ],
            ),
            //les dettes termine
            Column(
              children: [
                Padding(
                    padding: EdgeInsets.only(top: 20),
                    child: Text(
                      "33".tr,
                      style: TextStyle(color: Colors.red, fontSize: 20),
                    )),
                Expanded(
                    child: ListView.builder(
                        itemCount: count,
                        itemBuilder: (context, pos) {
                          DateTime debut =
                              DateTime.parse(prettes[pos].date_debut!);
                          String dateDebut =
                              DateFormat("dd-MM-yyyy").format(debut);
                          DateTime fin =
                              DateTime.parse(prettes[pos].date_echeance!);
                          String dateFin = DateFormat("dd-MM-yyyy").format(fin);
                          String maintenant =
                              DateFormat("yyyy-MM-dd").format(DateTime.now());
                          DateTime dateMaintenant = DateTime.parse(maintenant);
                          // if (dateMaintenant.compareTo(fin) >= 0) {
                          if (prettes[pos].status == 1) {
                            //PlusSolde(prettes[pos].montant);
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
                                  title: Text("${prettes[pos].nom}"),
                                  subtitle: Text("${prettes[pos].montant}"),
                                  trailing: Text("48".tr + " : " + "$dateFin"),
                                  onTap: () {
                                    AlertDialog alertDialog = AlertDialog(
                                      title: Icon(Icons.delete),
                                      content: Text("37".tr),
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
                                            deletePrete(prettes[pos].id);
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
                        })),
                Padding(
                    padding: EdgeInsets.only(top: 20),
                    child: Text(
                      "34".tr,
                      style: TextStyle(color: Colors.green, fontSize: 20),
                    )),
                Expanded(
                    child: ListView.builder(
                        itemCount: count2,
                        itemBuilder: (context, pos) {
                          DateTime debut =
                              DateTime.parse(empruntes[pos].date_debut!);
                          String dateDebut =
                              DateFormat("dd-MM-yyyy").format(debut);
                          DateTime fin =
                              DateTime.parse(empruntes[pos].date_echeance!);
                          String dateFin = DateFormat("dd-MM-yyyy").format(fin);
                          String maintenant =
                              DateFormat("yyyy-MM-dd").format(DateTime.now());
                          DateTime dateMaintenant = DateTime.parse(maintenant);
                          if (empruntes[pos].status == 1) {
                            // minsSolde(empruntes[pos].montant);
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
                                  title: Text("${empruntes[pos].nom}"),
                                  subtitle: Text("${empruntes[pos].montant}"),
                                  trailing: Text("48".tr + " : " + "$dateFin"),
                                  onTap: () {
                                    AlertDialog alertDialog = AlertDialog(
                                      title: Icon(Icons.delete),
                                      content: Text("37".tr),
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
                                            deleteEmprunte(empruntes[pos].id);
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
                        })),
              ],
            ),
            //Notifications
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
            )
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
                          builder: (context) => operdatte(this.usr)));
                },
              )
            : null,
      ),
    );
  }
}
