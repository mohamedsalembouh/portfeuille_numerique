import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:portfeuille_numerique/methodes.dart';
import 'package:portfeuille_numerique/models/emprunte_dette.dart';
import 'package:portfeuille_numerique/models/utilisateur.dart';
import 'package:portfeuille_numerique/operationDettes.dart';
import 'package:portfeuille_numerique/parametres.dart';
import 'package:portfeuille_numerique/partageGroupe.dart';
import 'package:portfeuille_numerique/services/local_notification_service.dart';
import 'package:portfeuille_numerique/statistiques.dart';
import 'package:sqflite/sqflite.dart';

import 'budget.dart';
import 'homePage.dart';
import 'models/compte.dart';
import 'models/prette_dette.dart';
import 'objectifs.dart';

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
      text: "Actif",
    ),
    Tab(
      text: "Termine",
    ),
    Tab(
      text: "Notification",
    )
  ];
  utilisateur? usr;
  int? selectedPage;
  _alldettesState(this.usr, this.selectedPage);
  List<prette_dette>? pretedetes;
  int count = 0;
  static var prettes;
  List<emprunte_dette>? empruntedetes;
  int count2 = 0;
  int? so;
  static var solde;
  static var empruntes;
  late final LocalNotificationService service;
  @override
  void initState() {
    // TODO: implement initState
    service = LocalNotificationService();
    service.initialize();
    listenToNotification2();
    super.initState();
  }

  // void updateSolde() async {
  //   utilisateur? user =
  //       await helper.getUser(this.usr!.email!, this.usr!.password!);
  //   int a = user!.id!;
  //   final Future<Database>? db = helper.initialiseDataBase();
  //   var our_db = db;
  //   if (our_db != null) {
  //     our_db.then((database) {
  //       Future<int?> reloadsolde = getsoldeUser(a);
  //       reloadsolde.then((sol) {
  //         setState(() {
  //           this.so = sol;
  //         });
  //       });
  //     });
  //   }
  // }

  // Future<bool> oldSolde(int mnt) async {
  //   utilisateur? user =
  //       await helper.getUser(this.usr!.email!, this.usr!.password!);
  //   int a = user!.id!;
  //   compte? cmp = await helper.getCompteUser(a);
  //   if (cmp != null) {
  //     int solde = cmp.solde!;
  //     if (solde > mnt) {
  //       return true;
  //     } else {
  //       return false;
  //     }
  //   } else {
  //     return false;
  //   }
  // }

  minsSolde(int mnt, int idEmprunte, String typeCmp) async {
    utilisateur? user =
        await helper.getUser(this.usr!.email!, this.usr!.password!);
    int a = user!.id!;
    compte? cmp = await helper.getCompteUser(a, typeCmp);
    if (cmp != null) {
      int solde = cmp.solde!;
      if (solde > mnt) {
        int newSolde = solde - mnt;
        compte updateCompte = compte(newSolde, cmp.type, a);
        int? r1 = await helper.update_compte(updateCompte);
        int? r2 = await helper.update_EmprunteDette(idEmprunte);
        if (r1 != 0 && r2 != 0) {
          getAllEmprunteDette();
        }
      } else {
        showText(context, "Desole", "vous n'avez pas de solde sufficant");
      }
    }
  }

  PlusSolde(int mnt, int idPrette, String typeCmp) async {
    utilisateur? user =
        await helper.getUser(this.usr!.email!, this.usr!.password!);
    int a = user!.id!;
    compte? cmp = await helper.getCompteUser(a, typeCmp);
    if (cmp != null) {
      int solde = cmp.solde!;
      int newSolde = solde + mnt;
      compte updateCompte = compte(newSolde, cmp.type, a);
      int? res1 = await helper.update_compte(updateCompte);
      int? res2 = await helper.update_pretteDette(idPrette);
      if (res1 != 0 && res2 != 0) {
        getAllPretteDette();
      }
    }
  }

  getAllPretteDette() async {
    utilisateur? user =
        await helper.getUser(this.usr!.email!, this.usr!.password!);
    int a = user!.id!;
    final Future<Database>? db = helper.initialiseDataBase();
    var ourDb = db;
    if (ourDb != null) {
      ourDb.then((database) {
        Future<List<prette_dette>> pretteDettes = helper.getAllPrettesDettes(a);
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
    utilisateur? user =
        await helper.getUser(this.usr!.email!, this.usr!.password!);
    int a = user!.id!;
    final Future<Database>? db = helper.initialiseDataBase();
    var ourDb = db;
    if (ourDb != null) {
      ourDb.then((database) {
        Future<List<emprunte_dette>> empDettes = helper.getAllEmprunteDettes(a);
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

  // faireOperation(List<prette_dette> x) {
  //   String maintenant = DateFormat("yyyy-MM-dd").format(DateTime.now());
  //   DateTime dateMaintenant = DateTime.parse(maintenant);
  //   x.forEach((element) {
  //     DateTime fine = DateTime.parse(element.date_echeance!);
  //     if (dateMaintenant.compareTo(fine) >= 0) {
  //       PlusSolde(element.montant!);
  //     }
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    if (this.pretedetes == null) {
      getAllPretteDette();
    }
    if (this.empruntedetes == null) {
      getAllEmprunteDette();
    }
    // if (this.so == null) {
    //   updateSolde();
    // }

    prettes = this.pretedetes;
    empruntes = this.empruntedetes;
    solde = this.so;
    //faireNotificationDettes();

    //print(prettes);
    return MaterialApp(
      home: DefaultTabController(
        length: mytabs.length,
        initialIndex: selectedPage!,
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          appBar: appbar2function(mytabs, "Dettes"),
          drawer: drowerfunction(context, usr),
          body: TabBarView(
            children: [
              Column(
                children: [
                  Padding(
                      padding: EdgeInsets.only(top: 20),
                      child: Text(
                        "prettes dettes",
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
                            String dateFin =
                                DateFormat("dd-MM-yyyy").format(fin);
                            String maintenant =
                                DateFormat("yyyy-MM-dd").format(DateTime.now());
                            DateTime dateMaintenant =
                                DateTime.parse(maintenant);
                            // if (dateMaintenant.compareTo(fin) < 0) {
                            if (prettes[pos].status == 0) {
                              return Card(
                                color: Colors.white,
                                //elevation: 2.0,
                                child: ListTile(
                                  title: Text("${prettes[pos].nom}"),
                                  subtitle: Text("${prettes[pos].montant}"),
                                  trailing: Text("date d'echeance : $dateFin"),
                                  onTap: () {
                                    AlertDialog alertDialog = AlertDialog(
                                      // title: Icon(Icons.home),
                                      content: Text("Terminer cette dette"),
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
                                            PlusSolde(
                                                prettes[pos].montant,
                                                prettes[pos].id,
                                                prettes[pos].type_compte);

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
                          })),
                  Padding(
                      padding: EdgeInsets.only(top: 20),
                      child: Text(
                        "Emprunte dettes",
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
                            String dateFin =
                                DateFormat("dd-MM-yyyy").format(fin);
                            String maintenant =
                                DateFormat("yyyy-MM-dd").format(DateTime.now());
                            DateTime dateMaintenant =
                                DateTime.parse(maintenant);

                            if (empruntes[pos].status == 0) {
                              return Card(
                                color: Colors.white,
                                //elevation: 2.0,
                                child: ListTile(
                                  title: Text("${empruntes[pos].nom}"),
                                  subtitle: Text("${empruntes[pos].montant}"),
                                  trailing: Text("date d'echeance : $dateFin"),
                                  onTap: () {
                                    AlertDialog alertDialog = AlertDialog(
                                      //title: Icon(Icons.home),
                                      content: Text("Terminer cette dette"),
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
                                            minsSolde(
                                                empruntes[pos].montant,
                                                empruntes[pos].id,
                                                empruntes[pos].type_compte);

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
                          })),
                  Padding(
                    padding: EdgeInsets.only(left: 350, bottom: 20),
                    child: FloatingActionButton(
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
                    ),
                  ),
                ],
              ),
              //les dettes termine
              Column(
                children: [
                  Padding(
                      padding: EdgeInsets.only(top: 20),
                      child: Text(
                        "prettes dettes",
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
                            String dateFin =
                                DateFormat("dd-MM-yyyy").format(fin);
                            String maintenant =
                                DateFormat("yyyy-MM-dd").format(DateTime.now());
                            DateTime dateMaintenant =
                                DateTime.parse(maintenant);
                            // if (dateMaintenant.compareTo(fin) >= 0) {
                            if (prettes[pos].status == 1) {
                              //PlusSolde(prettes[pos].montant);
                              return Card(
                                color: Colors.white,
                                //elevation: 2.0,
                                child: ListTile(
                                  leading: Icon(Icons.check),
                                  title: Text("${prettes[pos].nom}"),
                                  subtitle: Text("${prettes[pos].montant}"),
                                  trailing: Text("date d'echeance : $dateFin"),
                                  onTap: () {
                                    AlertDialog alertDialog = AlertDialog(
                                      title: Icon(Icons.delete),
                                      content: Text("Supprimer cette dette "),
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
                                            "Supprimer",
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
                              );
                            } else {
                              return Container();
                            }
                          })),
                  Padding(
                      padding: EdgeInsets.only(top: 20),
                      child: Text(
                        "Emprunte dettes",
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
                            String dateFin =
                                DateFormat("dd-MM-yyyy").format(fin);
                            String maintenant =
                                DateFormat("yyyy-MM-dd").format(DateTime.now());
                            DateTime dateMaintenant =
                                DateTime.parse(maintenant);
                            if (empruntes[pos].status == 1) {
                              // minsSolde(empruntes[pos].montant);
                              return Card(
                                color: Colors.white,
                                //elevation: 2.0,
                                child: ListTile(
                                  leading: Icon(Icons.check),
                                  title: Text("${empruntes[pos].nom}"),
                                  subtitle: Text("${empruntes[pos].montant}"),
                                  trailing: Text("date d'echeance : $dateFin"),
                                  onTap: () {
                                    AlertDialog alertDialog = AlertDialog(
                                      title: Icon(Icons.delete),
                                      content: Text("Supprimer cette dette "),
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
                                            "Supprimer",
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
                  Expanded(
                      child: ListView.builder(
                          itemCount: count2,
                          itemBuilder: (context, pos) {
                            DateTime dateEcheance =
                                DateTime.parse(empruntes[pos].date_echeance!);
                            String maintenant =
                                DateFormat("yyyy-MM-dd").format(DateTime.now());
                            DateTime dateMaintenant =
                                DateTime.parse(maintenant);

                            if (empruntes[pos].status == 0) {
                              if (dateEcheance
                                      .difference(dateMaintenant)
                                      .inDays ==
                                  3) {
                                return Card(
                                    child: Padding(
                                  padding: EdgeInsets.only(top: 20),
                                  child: Text(
                                      "Vous allez donnez a ${empruntes[pos].nom} ${empruntes[pos].montant} apres 3 jours "),
                                ));
                              } else if (dateEcheance
                                      .difference(dateMaintenant)
                                      .inDays ==
                                  2) {
                                return Card(
                                    child: Padding(
                                  padding: EdgeInsets.only(top: 20),
                                  child: Text(
                                      "Vous allez donnez a ${empruntes[pos].nom} ${empruntes[pos].montant} apres 2 jours "),
                                ));
                              } else if (dateEcheance
                                      .difference(dateMaintenant)
                                      .inDays ==
                                  1) {
                                return Card(
                                    child: Padding(
                                  padding: EdgeInsets.only(top: 20),
                                  child: Text(
                                      "Vous allez donnez a ${empruntes[pos].nom} ${empruntes[pos].montant} apres 1 jours "),
                                ));
                              } else if (dateEcheance
                                      .difference(dateMaintenant)
                                      .inDays ==
                                  0) {
                                return Card(
                                    child: Padding(
                                  padding: EdgeInsets.only(top: 20),
                                  child: Text(
                                      "Vous allez donnez a ${empruntes[pos].nom} ${empruntes[pos].montant}  Ajourdhui "),
                                ));
                              } else {
                                return Container();
                              }
                            } else {
                              return Container();
                            }
                          }))
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  faireNotificationDettes() async {
    List<emprunte_dette> empruntes =
        await helper.getAllEmprunteDettes(this.usr!.id!);
    empruntes.forEach((emprunte) {
      if (emprunte.status == 0) {
        DateTime dateEcheance = DateTime.parse(emprunte.date_echeance!);

        DateTime dateMaintenant =
            DateTime.parse(DateFormat("yyyy-MM-dd").format(DateTime.now()));
        if (dateEcheance.difference(dateMaintenant).inDays == 3) {
          service.showNotificationWithPayload(
              id: emprunte.id!,
              title: "Attension",
              body:
                  "Vous avez donnee a ${emprunte.nom} ${emprunte.montant} apres 3 jours",
              payload: "payload navigation");
        } else if (dateEcheance.difference(dateMaintenant).inDays == 2) {
          service.showNotificationWithPayload(
              id: emprunte.id!,
              title: "Attension",
              body:
                  "Vous avez donnee a ${emprunte.nom} ${emprunte.montant} apres 2 jours",
              payload: "payload navigation");
        } else if (dateEcheance.difference(dateMaintenant).inDays == 1) {
          service.showNotificationWithPayload(
              id: emprunte.id!,
              title: "Attension",
              body:
                  "Vous avez donnee a ${emprunte.nom} ${emprunte.montant} apres 1 jours",
              payload: "payload navigation");
        } else if (dateEcheance.difference(dateMaintenant).inDays == 0) {
          service.showNotificationWithPayload(
              id: emprunte.id!,
              title: "Attension",
              body:
                  "Vous avez donnee a ${emprunte.nom} ${emprunte.montant} Aujordhui",
              payload: "payload navigation");
        }
      }
    });
  }

  // allprettes(List<prette_dette> allPretes) {
  //   int k = allPretes.length;
  //   List<prette_dette> y = [];
  //   for (int i = 0; i < k; i++) {
  //     DateTime debut = DateTime.parse(allPretes[i].date_debut!);
  //     String dateDebut = DateFormat("dd-MM-yyyy").format(debut);
  //     DateTime fin = DateTime.parse(allPretes[i].date_echeance!);
  //     String dateFin = DateFormat("dd-MM-yyyy").format(fin);
  //     prette_dette pr = prette_dette(allPretes[i].nom, allPretes[i].objectif,
  //         allPretes[i].montant, dateDebut, dateFin, allPretes[i].id_compte);
  //   }
  // }
  void listenToNotification2() =>
      service.onNotificationClick.stream.listen((onNotificationListener2));
  void onNotificationListener2(String? payload) {
    if (payload != null && payload.isNotEmpty) {
      print("payload $payload");
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => alldettes(usr, 2)));
    }
  }
}
