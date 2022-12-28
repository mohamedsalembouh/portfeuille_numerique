import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:portfeuille_numerique/db/sql_helper.dart';
import 'package:sqflite/sqflite.dart';

import 'models/emprunte_dette.dart';
import 'models/prette_dette.dart';

class detailDettes extends StatefulWidget {
  // const detailDettes({Key? key}) : super(key: key);
  int? id_utilisateur;
  detailDettes(this.id_utilisateur);

  @override
  State<detailDettes> createState() => _detailDettesState(this.id_utilisateur);
}

class _detailDettesState extends State<detailDettes> {
  int? id_utilisateur;
  _detailDettesState(this.id_utilisateur);
  List<prette_dette>? pretesdettes;
  int count1 = 0;
  static var prettees;
  List<emprunte_dette>? empruntesdettes;
  int count2 = 0;
  static var empruntees;
  final List<Tab> mytabs = [
    Tab(
      text: "30".tr,
    ),
    Tab(
      text: "31".tr,
    ),
  ];
  SQL_Helper helper = SQL_Helper();
  getAllPretteDette() async {
    final Future<Database>? db = helper.initialiseDataBase();
    var ourDb = db;
    if (ourDb != null) {
      ourDb.then((database) {
        Future<List<prette_dette>> pretteDettes =
            helper.getAllPrettesDettes(this.id_utilisateur!);
        pretteDettes.then((theList) {
          setState(() {
            this.pretesdettes = theList;
            this.count1 = theList.length;
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
            helper.getAllEmprunteDettes(this.id_utilisateur!);
        empDettes.then((theList) {
          setState(() {
            this.empruntesdettes = theList;
            this.count2 = theList.length;
          });
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (this.pretesdettes == null) {
      getAllPretteDette();
    }
    if (this.empruntesdettes == null) {
      getAllEmprunteDette();
    }

    prettees = this.pretesdettes;
    empruntees = this.empruntesdettes;
    return DefaultTabController(
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
          //toolbarHeight: 100,
          bottom: TabBar(tabs: mytabs),
          title: Text("a".tr),
        ),
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
                        itemCount: count1,
                        itemBuilder: (context, pos) {
                          DateTime debut =
                              DateTime.parse(prettees[pos].date_debut!);
                          String dateDebut =
                              DateFormat("dd-MM-yyyy").format(debut);
                          DateTime fin =
                              DateTime.parse(prettees[pos].date_echeance!);
                          String dateFin = DateFormat("dd-MM-yyyy").format(fin);
                          String maintenant =
                              DateFormat("yyyy-MM-dd").format(DateTime.now());
                          DateTime dateMaintenant = DateTime.parse(maintenant);
                          // if (dateMaintenant.compareTo(fin) < 0) {
                          if (prettees[pos].status == 0) {
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
                                  title: Text("${prettees[pos].nom}"),
                                  subtitle: Text("${prettees[pos].montant}"),
                                  trailing: Text("48".tr + "$dateFin"),
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
                              DateTime.parse(empruntees[pos].date_debut!);
                          String dateDebut =
                              DateFormat("dd-MM-yyyy").format(debut);
                          DateTime fin =
                              DateTime.parse(empruntees[pos].date_echeance!);
                          String dateFin = DateFormat("dd-MM-yyyy").format(fin);
                          String maintenant =
                              DateFormat("yyyy-MM-dd").format(DateTime.now());
                          DateTime dateMaintenant = DateTime.parse(maintenant);

                          if (empruntees[pos].status == 0) {
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
                                  title: Text("${empruntees[pos].nom}"),
                                  subtitle: Text("${empruntees[pos].montant}"),
                                  trailing: Text("48".tr + "$dateFin"),
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
                        itemCount: count1,
                        itemBuilder: (context, pos) {
                          DateTime debut =
                              DateTime.parse(prettees[pos].date_debut!);
                          String dateDebut =
                              DateFormat("dd-MM-yyyy").format(debut);
                          DateTime fin =
                              DateTime.parse(prettees[pos].date_echeance!);
                          String dateFin = DateFormat("dd-MM-yyyy").format(fin);
                          String maintenant =
                              DateFormat("yyyy-MM-dd").format(DateTime.now());
                          DateTime dateMaintenant = DateTime.parse(maintenant);
                          // if (dateMaintenant.compareTo(fin) >= 0) {
                          if (prettees[pos].status == 1) {
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
                                  title: Text("${prettees[pos].nom}"),
                                  subtitle: Text("${prettees[pos].montant}"),
                                  trailing: Text("48".tr + "$dateFin"),
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
                              DateTime.parse(empruntees[pos].date_debut!);
                          String dateDebut =
                              DateFormat("dd-MM-yyyy").format(debut);
                          DateTime fin =
                              DateTime.parse(empruntees[pos].date_echeance!);
                          String dateFin = DateFormat("dd-MM-yyyy").format(fin);
                          String maintenant =
                              DateFormat("yyyy-MM-dd").format(DateTime.now());
                          DateTime dateMaintenant = DateTime.parse(maintenant);
                          if (empruntees[pos].status == 1) {
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
                                  title: Text("${empruntees[pos].nom}"),
                                  subtitle: Text("${empruntees[pos].montant}"),
                                  trailing: Text("48".tr + "$dateFin"),
                                ),
                              ),
                            );
                          } else {
                            return Container();
                          }
                        })),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
