import 'package:flutter/material.dart';
import 'package:portfeuille_numerique/db/sql_helper.dart';
import 'package:portfeuille_numerique/detailBudget.dart';
import 'package:portfeuille_numerique/detailDettes.dart';
import 'package:portfeuille_numerique/detailObjectif.dart';
import 'package:portfeuille_numerique/detailStatistique.dart';
import 'package:portfeuille_numerique/models/compteRessource.dart';
import 'package:sqflite/sqflite.dart';
import 'package:get/get.dart';
import 'models/compte.dart';

class detailCompte extends StatefulWidget {
  //const detailCompte({Key? key}) : super(key: key);
  int? id_utilisateur;
  detailCompte(this.id_utilisateur);
  @override
  State<detailCompte> createState() => _detailCompteState(this.id_utilisateur);
}

class _detailCompteState extends State<detailCompte> {
  int? id_utilisateur;
  _detailCompteState(this.id_utilisateur);
  SQL_Helper helper = SQL_Helper();
  int? alsolde;
  List<compteRessource>? allcomptes;
  int len_comptes = 0;
  static var liste1;
  static var tous_solde;

  Future<int?> getAllsoldes(int iduser) async {
    int soldes = 0;
    List<compte> comptes = await helper.getAllComptesUser(iduser);
    comptes.forEach((compte) {
      soldes = soldes + compte.solde!;
    });
    return soldes;
  }

  void updateSoldeGeneral() async {
    final Future<Database>? db = helper.initialiseDataBase();
    var our_db = db;
    if (our_db != null) {
      our_db.then((database) {
        Future<int?> soldes = getAllsoldes(this.id_utilisateur!);
        soldes.then((reloadsolde) {
          setState(() {
            this.alsolde = reloadsolde;
          });
        });
      });
    }
  }

  getTousComptes() async {
    final Future<Database>? db = helper.initialiseDataBase();
    var ourDb = db;
    if (ourDb != null) {
      ourDb.then((database) {
        Future<List<compteRessource>> comptes =
            helper.getAllCompteRessource(this.id_utilisateur!);
        comptes.then((theList) {
          setState(() {
            this.allcomptes = theList;
            this.len_comptes = theList.length;
          });
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (this.allcomptes == null) {
      getTousComptes();
    }
    if (this.alsolde == null) {
      updateSoldeGeneral();
    }
    liste1 = this.allcomptes;
    tous_solde = this.alsolde;
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.only(top: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                // Title(color: Colors.red, child: Text("hi")),
                Text(
                  "86".tr,
                  style: TextStyle(fontSize: 25),
                ),
                Container(
                  width: 200,
                  height: 50,
                  child: TextField(
                    enabled: false,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                        hintText: '$tous_solde', border: OutlineInputBorder()),
                    style: TextStyle(
                      fontSize: 30,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
              padding: EdgeInsets.only(top: 10),
              child: Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                // Text(" "),
                SizedBox(
                  width: MediaQuery.of(context).size.width - 150,
                  child: ElevatedButton(
                    onPressed: () {
                      print(alsolde);

                      AlertDialog alertDialog = AlertDialog(
                        title: Text(""),
                        content: Container(
                          width: 100,
                          height: 200,
                          child: Column(
                            children: [
                              Expanded(
                                child: ListView.builder(
                                    itemCount: len_comptes,
                                    itemBuilder: (context, pos) {
                                      return Card(
                                        elevation: 8,
                                        shape: RoundedRectangleBorder(
                                          side: BorderSide(
                                            color: Colors.white.withOpacity(1),
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(20.0),
                                        ),
                                        child: ListTile(
                                          title:
                                              Text("${liste1[pos].nom_ress}"),
                                          subtitle:
                                              Text("${liste1[pos].solde}"),
                                        ),
                                      );
                                    }),
                              ),
                            ],
                          ),
                        ),
                      );
                      showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return alertDialog;
                          });
                    },
                    // padding: EdgeInsets.all(5),
                    // color: Colors.red,
                    //textColor: Colors.white,
                    child: Text("14".tr),
                    style: ElevatedButton.styleFrom(shape: StadiumBorder()),
                  ),
                )
              ])),
          Padding(
            padding: const EdgeInsets.only(top: 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                // Padding(
                //   padding: const EdgeInsets.all(8.0),
                //   child: ElevatedButton(
                //       onPressed: () {
                //         Navigator.push(
                //             context,
                //             MaterialPageRoute(
                //                 builder: (context) =>
                //                     detailDettes(this.id_utilisateur)));
                //       },
                //       child: Text("Voir les dettes")),
                // ),
                Padding(
                  padding: const EdgeInsets.only(left: 10, right: 10),
                  child: Row(
                    children: [
                      Container(
                        margin: EdgeInsets.only(top: 30),
                        width: MediaQuery.of(context).size.width - 50,
                        // height: MediaQuery.of(context).size.width / 6,
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        detailDettes(this.id_utilisateur)));
                          },
                          child: Text(
                            "87".tr,
                            style: TextStyle(color: Colors.white),
                          ),
                          style:
                              ElevatedButton.styleFrom(shape: StadiumBorder()),
                        ),
                        decoration: BoxDecoration(
                          color: Colors.blue,
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 10, right: 10),
                  child: Row(
                    children: [
                      Container(
                        margin: EdgeInsets.only(top: 30),
                        width: MediaQuery.of(context).size.width - 50,
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        detailBudget(this.id_utilisateur)));
                          },
                          child: Text(
                            "88".tr,
                            style: TextStyle(color: Colors.white),
                          ),
                          style:
                              ElevatedButton.styleFrom(shape: StadiumBorder()),
                        ),
                        decoration: BoxDecoration(
                          color: Colors.blue,
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 10, left: 10),
                  child: Row(
                    children: [
                      Container(
                        margin: EdgeInsets.only(top: 30),
                        width: MediaQuery.of(context).size.width - 50,
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        detailObjectif(this.id_utilisateur)));
                          },
                          child: Text(
                            "89".tr,
                            style: TextStyle(color: Colors.white),
                          ),
                          style:
                              ElevatedButton.styleFrom(shape: StadiumBorder()),
                        ),
                        decoration: BoxDecoration(
                          color: Colors.blue,
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 10, left: 10),
                  child: Row(
                    children: [
                      Container(
                        margin: EdgeInsets.only(top: 30),
                        width: MediaQuery.of(context).size.width - 50,
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => detailStatistique(
                                        this.id_utilisateur)));
                          },
                          child: Text(
                            "90".tr,
                            style: TextStyle(color: Colors.white),
                          ),
                          style:
                              ElevatedButton.styleFrom(shape: StadiumBorder()),
                        ),
                        decoration: BoxDecoration(
                          color: Colors.blue,
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
