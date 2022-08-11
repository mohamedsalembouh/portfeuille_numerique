import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:portfeuille_numerique/form_objectif.dart';
import 'package:portfeuille_numerique/methodes.dart';
import 'package:portfeuille_numerique/models/compte.dart';
import 'package:portfeuille_numerique/models/objective.dart';
import 'package:portfeuille_numerique/newObjectif.dart';
import 'package:portfeuille_numerique/statistiques.dart';
import 'package:sqflite/sqflite.dart';
import 'package:toast/toast.dart';

import 'models/argent.dart';
import 'models/compteRessource.dart';
import 'models/ressource.dart';
import 'models/utilisateur.dart';

class objectif extends StatefulWidget {
  // const objectif({Key? key}) : super(key: key);
  utilisateur? usr;

  objectif(this.usr);
  @override
  State<objectif> createState() => _objectifState(this.usr);
}

class _objectifState extends State<objectif> {
  utilisateur? usr;
  // List<diagrameSolde> allUpdateSolde = [];
  _objectifState(this.usr);
  TextEditingController mnt_donnee = TextEditingController();
  final List<Tab> mytabs = [
    Tab(
      text: "En cours",
    ),
    Tab(
      text: "Complet",
    )
  ];

  List<objective>? allobjectif;
  int count = 0;
  static var allobjectives;
  String TypeCompte = "Choisissez le type de solde";
  Icon? monIcon;
  getAllObjectif() async {
    utilisateur? user =
        await helper.getUser(this.usr!.email!, this.usr!.password!);
    int id = user!.id!;
    final Future<Database>? db = helper.initialiseDataBase();
    var ourDb = db;
    if (ourDb != null) {
      ourDb.then((database) {
        Future<List<objective>> objs = helper.getAllObjectivfs(id);
        objs.then((theList) {
          setState(() {
            this.allobjectif = theList;
            this.count = theList.length;
          });
        });
      });
    }
  }

  augmeterMontant(int idobj, int mnt) async {
    DateTime maintenant = DateTime.now();
    String date_maintenant = DateFormat("yyyy-MM-dd").format(maintenant);
    if (TypeCompte != "Choisissez le type de solde") {
      ressource? res = await helper.getSpecifyRessource(TypeCompte);
      int id_res = res!.id_ress!;
      utilisateur? user =
          await helper.getUser(this.usr!.email!, this.usr!.password!);
      int a = user!.id!;
      compte? cmp = await helper.getCompteUser(a, id_res);
      if (cmp != null) {
        int solde = cmp.solde!;
        if (mnt < solde) {
          objective? obj = await helper.getSpecifyObjectif(idobj, a);
          if (obj != null) {
            int old_mnt = obj.montant_donnee!;
            int new_mnt = old_mnt + mnt;
            if (new_mnt <= obj.montant_cible!) {
              objective update_obj = objective.withId(
                  obj.id,
                  obj.nom_objective,
                  obj.montant_cible,
                  new_mnt,
                  date_maintenant,
                  obj.id_compte,
                  obj.id_utilisateur);
              int? x = await helper.update_objective(update_obj);
              int newSolde = solde - mnt;
              compte updateCompte =
                  compte(newSolde, date_maintenant, id_res, a);
              int y = await helper.update_compte(updateCompte);

              if (x != 0 && y != 0) {
                insertArgent(updateCompte.solde!, updateCompte.date!,
                    updateCompte.id_ressource!, updateCompte.id_utilisateur!);
                getAllObjectif();
                Navigator.of(context, rootNavigator: true).pop();
                mnt_donnee.clear();
              } else {
                print("not updated");
              }
            } else {
              showText(context, "SVP",
                  "cette valeur est plus grand que le montant cible");
            }
          }
        } else {
          showText(context, "Desole",
              "Le montant que vous voulez entre est plus grand que votre solde dans $TypeCompte");
        }
      }
    } else {
      Toast.show("Choisissez le type de solde");
    }
    // this.allUpdateSolde =
    //     getListSoldes(this.allUpdateSolde!, TypeCompte, this.usr!.id!);
  }

  supprimerObjectif(int idObj) async {
    utilisateur? user =
        await helper.getUser(this.usr!.email!, this.usr!.password!);
    int a = user!.id!;
    int result = await helper.deleteObjective(idObj, a);
    if (result != 0) {
      print("deleted one");
      getAllObjectif();
    }
  }

  @override
  Widget build(BuildContext context) {
    // getAllObjectif();
    if (this.allobjectif == null) {
      getAllObjectif();
    }
    allobjectives = this.allobjectif;
    print(allobjectives);
    return MaterialApp(
      home: DefaultTabController(
        length: mytabs.length,
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          appBar: appbar2function(mytabs, "Objectifs"),
          drawer: drowerfunction(context, this.usr),
          body: TabBarView(
            children: [
              Column(
                children: [
                  Expanded(
                      child: ListView.builder(
                          itemCount: count,
                          itemBuilder: (context, pos) {
                            // if (allobjectives[pos].montant_donnee ==
                            //     allobjectives[pos].montant_cible) {
                            //   monIcon = Icon(Icons.check);
                            // }
                            // status(x) {
                            //   if (x == allobjectives[pos].montant_cible) {
                            //     return Icon(
                            //       Icons.check,
                            //     );
                            //   }
                            // }

                            if (allobjectives[pos].montant_donnee !=
                                allobjectives[pos].montant_cible) {
                              return Card(
                                margin: EdgeInsets.only(top: 5),
                                color: Colors.white,
                                child: ListTile(
                                  // leading:
                                  //     status(allobjectives[pos].montant_donnee),
                                  title: Text(
                                      "${allobjectives[pos].nom_objective}"),
                                  subtitle: Text(
                                    "montant donnee : ${allobjectives[pos].montant_donnee}",
                                    // style: TextStyle(color: Colors.amberAccent),
                                  ),
                                  trailing: Text(
                                    "montant cible : ${allobjectives[pos].montant_cible}",
                                    //style: TextStyle(color: Colors.green),
                                  ),
                                  onTap: () {
                                    AlertDialog alertDialog = AlertDialog(
                                        title:
                                            Text("Augmentez le montant donnee"),
                                        content: StatefulBuilder(builder:
                                            (BuildContext context,
                                                StateSetter setState) {
                                          return Container(
                                            height: 300,
                                            child: Column(
                                              children: [
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          top: 10),
                                                  child: SizedBox(
                                                    //width: 200,
                                                    child: TextField(
                                                      controller: mnt_donnee,
                                                      keyboardType:
                                                          TextInputType.number,
                                                      decoration: InputDecoration(
                                                          hintText: '0',
                                                          border:
                                                              OutlineInputBorder()),
                                                      style: TextStyle(
                                                          fontSize: 20),
                                                    ),
                                                  ),
                                                ),
                                                Padding(
                                                  padding: EdgeInsets.only(
                                                      top: 30, left: 10),
                                                  child: FutureBuilder(
                                                      future:
                                                          getComptesRessource(
                                                              this.usr!.id!),
                                                      builder: (BuildContext
                                                              context,
                                                          AsyncSnapshot<
                                                                  List<
                                                                      compteRessource>>
                                                              snapshot) {
                                                        if (!snapshot.hasData) {
                                                          return CircularProgressIndicator();
                                                        } else {
                                                          return DropdownButton<
                                                              String>(
                                                            items: snapshot
                                                                .data!
                                                                .map((cmpRes) =>
                                                                    DropdownMenuItem<
                                                                        String>(
                                                                      child: Text(
                                                                          cmpRes
                                                                              .nom_ress!),
                                                                      value: cmpRes
                                                                          .nom_ress,
                                                                    ))
                                                                .toList(),
                                                            onChanged: (String?
                                                                value) {
                                                              setState(() {
                                                                TypeCompte =
                                                                    value!;
                                                              });
                                                            },
                                                            isExpanded: true,
                                                            //value: currentNomCat,
                                                            hint: Text(
                                                              '$TypeCompte',
                                                              style: TextStyle(
                                                                fontSize: 17,
                                                                //fontWeight: FontWeight.bold
                                                              ),
                                                            ),
                                                          );
                                                        }
                                                      }),
                                                ),
                                                Padding(
                                                  padding:
                                                      EdgeInsets.only(top: 10),
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceAround,
                                                    children: [
                                                      ElevatedButton(
                                                        child: Text(
                                                          "Annuler",
                                                          // style: TextStyle(
                                                          //     color: Colors.red),
                                                        ),
                                                        onPressed: () {
                                                          Navigator.of(context,
                                                                  rootNavigator:
                                                                      true)
                                                              .pop();
                                                        },
                                                      ),
                                                      ElevatedButton(
                                                        child:
                                                            Text("Enregistrer"),
                                                        onPressed: () {
                                                          augmeterMontant(
                                                            allobjectives[pos]
                                                                .id,
                                                            int.parse(mnt_donnee
                                                                .text),
                                                          );
                                                        },
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          );
                                        }));
                                    showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return alertDialog;
                                        });
                                  },
                                  onLongPress: () {
                                    AlertDialog alertDialog = AlertDialog(
                                      title: Icon(Icons.delete),
                                      content: Text(
                                          "Supprimer l'objectif : ${allobjectives[pos].nom_objective}"),
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
                                            supprimerObjectif(
                                                allobjectives[pos].id);
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
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => form_objectif(usr)));
                      },
                      child: Icon(Icons.add),
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
                            if (allobjectives[pos].montant_donnee ==
                                allobjectives[pos].montant_cible) {
                              return Card(
                                color: Colors.white,
                                child: ListTile(
                                  leading: Icon(Icons.check),
                                  title: Text(
                                      "${allobjectives[pos].nom_objective}"),
                                  subtitle: Text(
                                    "montant donnee : ${allobjectives[pos].montant_donnee}",
                                    // style: TextStyle(color: Colors.amberAccent),
                                  ),
                                  trailing: Text(
                                    "montant cible : ${allobjectives[pos].montant_cible}",
                                    //style: TextStyle(color: Colors.green),
                                  ),
                                  onLongPress: () {
                                    AlertDialog alertDialog = AlertDialog(
                                      title: Text(
                                          "Supprimer ${allobjectives[pos].nom_objective}"),
                                      content: Icon(Icons.delete),
                                      actions: [
                                        TextButton(
                                          child: Text(
                                            "Annuler",
                                            style: TextStyle(color: Colors.red),
                                          ),
                                          onPressed: () {
                                            Navigator.of(context,
                                                    rootNavigator: true)
                                                .pop();
                                          },
                                        ),
                                        TextButton(
                                          child: Text("Supprimer"),
                                          onPressed: () {
                                            supprimerObjectif(
                                                allobjectives[pos].id);
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
