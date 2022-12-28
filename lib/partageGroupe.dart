import 'package:flutter/material.dart';
import 'package:portfeuille_numerique/detailCompte.dart';
import 'package:portfeuille_numerique/form_partage.dart';
import 'package:portfeuille_numerique/methodes.dart';
import 'package:portfeuille_numerique/models/utilisateur.dart';
import 'package:sqflite/sqflite.dart';

import 'models/partag.dart';
import 'package:get/get.dart';

class partage extends StatefulWidget {
  utilisateur? usr;
  partage(this.usr);
  @override
  State<partage> createState() => _partageState(this.usr);
}

class _partageState extends State<partage> {
  utilisateur? usr;
  _partageState(this.usr);
  List<partag>? allJepartageavec;
  List<partag>? allOntPartagemoi;
  int count1 = 0;
  int count2 = 0;
  static var partages1;
  static var partages2;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  getAllPersonnesPartages() {
    final Future<Database>? db = helper.initialiseDataBase();
    var ourDb = db;
    if (ourDb != null) {
      ourDb.then((database) {
        Future<List<partag>> partages = helper.getAllPartag(this.usr!.id!);
        partages.then((theList) {
          setState(() {
            this.allJepartageavec = theList;
            this.count1 = theList.length;
          });
        });
      });
    }
  }

  getAllPersonnesPartagesavecmoi() {
    final Future<Database>? db = helper.initialiseDataBase();
    var ourDb = db;
    if (ourDb != null) {
      ourDb.then((database) {
        Future<List<partag>> partages = helper.getAllPartag2(this.usr!.email!);
        partages.then((theList) {
          setState(() {
            this.allOntPartagemoi = theList;
            this.count2 = theList.length;
          });
        });
      });
    }
  }

  deletePartage(int id) async {
    int? result = await helper.deletepartag(id);
    if (result != 0) {
      getAllPersonnesPartages();
    }
  }

  @override
  Widget build(BuildContext context) {
    if (this.allJepartageavec == null) {
      getAllPersonnesPartages();
    }
    if (this.allOntPartagemoi == null) {
      getAllPersonnesPartagesavecmoi();
    }
    partages1 = this.allJepartageavec;
    partages2 = this.allOntPartagemoi;
    return Scaffold(
        appBar: AppBar(
          title: Text("e".tr),
        ),
        drawer: drowerfunction(context, usr),
        body: Column(children: [
          Padding(
            padding: const EdgeInsets.only(top: 10),
            child: ListTile(
              title: Text("65".tr),
            ),
          ),
          Expanded(
              child: ListView.builder(
                  itemCount: count1,
                  itemBuilder: (context, pos) {
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
                          title: Text("${partages1[pos].email_personne}"),
                          onTap: () {
                            AlertDialog alertDialog = AlertDialog(
                              title: Icon(Icons.delete),
                              content: Text("145".tr),
                              actions: [
                                TextButton(
                                  child: Text(
                                    "26".tr,
                                  ),
                                  onPressed: () {
                                    Navigator.of(context, rootNavigator: true)
                                        .pop();
                                  },
                                ),
                                TextButton(
                                  child: Text(
                                    "38".tr,
                                    style: TextStyle(color: Colors.red),
                                  ),
                                  onPressed: () {
                                    deletePartage(partages1[pos].id);
                                    Navigator.of(context, rootNavigator: true)
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
                  })),
          Padding(
            padding: const EdgeInsets.only(top: 10),
            child: ListTile(
              title: Text("66".tr),
            ),
          ),
          Expanded(
              child: ListView.builder(
                  itemCount: count2,
                  itemBuilder: (context, pos) {
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
                          title: Text("${partages2[pos].email_utilisateur}"),
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => detailCompte(
                                        partages2[pos].id_utilisateur)));
                          },
                        ),
                      ),
                    );
                  })),
        ]),
        floatingActionButton: FloatingActionButton(
          child: Icon(
            Icons.add,
            size: 20,
          ),
          onPressed: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => formPartage(this.usr)));
          },
        ));
  }
}
