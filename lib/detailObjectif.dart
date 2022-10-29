import 'package:flutter/material.dart';
import 'package:portfeuille_numerique/db/sql_helper.dart';
import 'package:sqflite/sqflite.dart';

import 'models/objective.dart';

class detailObjectif extends StatefulWidget {
  // const detailObjectif({ Key? key }) : super(key: key);
  int? id_utilisateur;
  detailObjectif(this.id_utilisateur);
  @override
  State<detailObjectif> createState() =>
      _detailObjectifState(this.id_utilisateur);
}

class _detailObjectifState extends State<detailObjectif> {
  int? id_utilisateur;
  _detailObjectifState(this.id_utilisateur);
  final List<Tab> mytabs = [
    Tab(
      text: "En cours",
    ),
    Tab(
      text: "Complet",
    )
  ];
  List<objective>? allobjectifs;
  int count = 0;
  static var allobjective;
  SQL_Helper helper = SQL_Helper();

  getAllObjectif() async {
    final Future<Database>? db = helper.initialiseDataBase();
    var ourDb = db;
    if (ourDb != null) {
      ourDb.then((database) {
        Future<List<objective>> objs =
            helper.getAllObjectivfs(this.id_utilisateur!);
        objs.then((theList) {
          setState(() {
            this.allobjectifs = theList;
            this.count = theList.length;
          });
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (this.allobjectifs == null) {
      getAllObjectif();
    }
    allobjective = this.allobjectifs;
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
            title: Text("Les objectifs"),
            bottom: TabBar(
              tabs: mytabs,
            ),
          ),
          body: TabBarView(
            children: [
              Column(
                children: [
                  Expanded(
                      child: ListView.builder(
                          itemCount: count,
                          itemBuilder: (context, pos) {
                            if (allobjective[pos].montant_donnee !=
                                allobjective[pos].montant_cible) {
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
                                    title: Text(
                                        "${allobjective[pos].nom_objective}"),
                                    subtitle: Text(
                                      "montant donnee : ${allobjective[pos].montant_donnee}",
                                    ),
                                    trailing: Text(
                                      "montant cible : ${allobjective[pos].montant_cible}",
                                    ),
                                  ),
                                ),
                              );
                            } else {
                              return Container();
                            }
                          })),
                ],
              ),
              //l'autre page
              Column(
                children: [
                  Expanded(
                      child: ListView.builder(
                          itemCount: count,
                          itemBuilder: (context, pos) {
                            if (allobjective[pos].montant_donnee ==
                                allobjective[pos].montant_cible) {
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
                                    title: Text(
                                        "${allobjective[pos].nom_objective}"),
                                    subtitle: Text(
                                      "montant donnee : ${allobjective[pos].montant_donnee}",
                                      // style: TextStyle(color: Colors.amberAccent),
                                    ),
                                    trailing: Text(
                                      "montant cible : ${allobjective[pos].montant_cible}",
                                      //style: TextStyle(color: Colors.green),
                                    ),
                                  ),
                                ),
                              );
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
}
