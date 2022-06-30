import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:portfeuille_numerique/methodes.dart';
import 'package:portfeuille_numerique/models/emprunte_dette.dart';
import 'package:portfeuille_numerique/models/utilisateur.dart';
import 'package:portfeuille_numerique/operationDettes.dart';
import 'package:portfeuille_numerique/parametres.dart';
import 'package:portfeuille_numerique/partageGroupe.dart';
import 'package:portfeuille_numerique/statistiques.dart';
import 'package:sqflite/sqflite.dart';

import 'budget.dart';
import 'homePage.dart';
import 'models/prette_dette.dart';
import 'objectifs.dart';

class alldettes extends StatefulWidget {
  utilisateur? usr;
  //alldettes({Key? key}) : super(key: key);
  alldettes(this.usr);
  @override
  State<alldettes> createState() => _alldettesState(this.usr);
}

class _alldettesState extends State<alldettes> {
  final List<Tab> mytabs = [
    Tab(
      text: "Actif",
    ),
    Tab(
      text: "Termine",
    )
  ];
  utilisateur? usr;
  _alldettesState(this.usr);
  List<prette_dette>? pretedetes;
  int count = 0;
  static var prettes;
  List<emprunte_dette>? empruntedetes;
  int count2 = 0;
  static var empruntes;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
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

    // print(count);
    // print(count2);

    //print(prettes);
    return MaterialApp(
      home: DefaultTabController(
        length: mytabs.length,
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
                            return Card(
                              color: Colors.white,
                              //elevation: 2.0,
                              child: ListTile(
                                title: Text("${prettes[pos].nom}"),
                                subtitle: Text("${prettes[pos].montant}"),
                                trailing: Text("date d'echeance : $dateFin"),
                              ),
                            );
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
                            return Card(
                              color: Colors.white,
                              //elevation: 2.0,
                              child: ListTile(
                                title: Text("${empruntes[pos].nom}"),
                                subtitle: Text("${empruntes[pos].montant}"),
                                trailing: Text("date d'echeance : $dateFin"),
                              ),
                            );
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
              //objectif()
              Container(
                child: ListView(
                  children: [
                    ListTile(
                      title: Text("titre"),
                      subtitle: Text("Nom person"),
                      trailing: Text("20000"),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
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
}
