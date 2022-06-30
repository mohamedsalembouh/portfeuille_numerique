import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:portfeuille_numerique/categories.dart';
import 'package:portfeuille_numerique/db/sql_helper.dart';
import 'package:portfeuille_numerique/dettes.dart';
import 'package:portfeuille_numerique/methodes.dart';
import 'package:portfeuille_numerique/models/categorie.dart';
import 'package:portfeuille_numerique/models/operation_entree.dart';
import 'package:portfeuille_numerique/models/operation_sortir.dart';
import 'package:portfeuille_numerique/models/utilisateur.dart';
import 'package:sqflite/sqflite.dart';
import 'package:toast/toast.dart';

import 'models/compte.dart';

class operation extends StatefulWidget {
  //operation({Key? key}) : super(key: key);
  //String? nomCategorie;
  int? numero;
  utilisateur? usr;
  operation(this.usr, this.numero);
  @override
  State<operation> createState() => _operationState(this.usr, this.numero);
}

class _operationState extends State<operation> {
  final _formKey1 = new GlobalKey<FormState>();
  final _formKey2 = new GlobalKey<FormState>();
  TextEditingController entreeMontant = TextEditingController();
  TextEditingController entreeDesc = TextEditingController();
  TextEditingController sortirMontant = TextEditingController();
  TextEditingController sortirDesc = TextEditingController();
  // String? nomcategorie;
  // int? selectedPage;
  int? numero;
  utilisateur? usr;
  _operationState(this.usr, this.numero);
  List<operation_sortir>? alldepenses;
  int? count;
  final List<Tab> mytabs = [
    Tab(
      text: "Entree",
    ),
    Tab(
      text: "Depenses",
    )
  ];

  SQL_Helper helper = new SQL_Helper();
  String currentNomCat = "Choisir une categorie";

  // updatedepenses() async {
  //   utilisateur? user =
  //       await helper.getUser(this.usr!.email!, this.usr!.password!);
  //   int a = user!.id!;
  //   final Future<Database>? db = helper.initialiseDataBase();
  //   var our_db = db;
  //   if (our_db != null) {
  //     our_db.then((database) {
  //       Future<List<operation_sortir>> depenses = helper.getAllDepenses(a);
  //       depenses.then((theList) {
  //         setState(() {
  //           this.alldepenses = theList;
  //           count = theList.length;
  //         });
  //       });
  //     });
  //   }
  // }

  insertRevenus(String value, String description) async {
    final form = _formKey1.currentState!;
    // final form = _formKey.currentState;
    // if (form!.validate()) {
    // if (montant == 0) {
    //   Toast.show("entrer montant");
    // }
    if (form.validate()) {
      int montant = int.parse(value);
      categorie? cat = await helper.getSpecifyCategorie(currentNomCat);
      int idCat = cat!.id!;
      operation_entree entree =
          new operation_entree(montant, description, idCat, this.numero);
      int a = await helper.insertOperationEntree(entree);
      if (a != 0) {
        print("operation inserted");
      } else {
        print("not inserted");
      }
    }
  }

  insertDepense(String value, String description) async {
    final form = _formKey2.currentState!;
    if (form.validate()) {
      int montant = int.parse(value);
      compte? comp = await helper.getCompteUser(numero!);
      if (comp != null) {
        int solde = comp.solde!;
        if (solde > montant) {
          categorie? cat = await helper.getSpecifyCategorie(currentNomCat);
          int idCat = cat!.id!;
          operation_sortir sortir =
              new operation_sortir(montant, description, idCat, this.numero);
          int a = await helper.insertOperationSortir(sortir);
          if (a != 0) {
            print("operation sortir inserted");
          } else {
            print("not inserted");
          }

          Map<int, int> myData = new Map();
          myData[0] = 1;
          myData[1] = montant;
          Navigator.of(context).pop(myData);
        } else {
          showText(context, "désolé",
              "vous n'avez pas de solde sufficant pour cette operation");
        }
      } else {
        showText(context, "désolé", "vous n'avez pas de solde");
      }
    }

    // updatedepenses();
    // print(this.count);
  }

  Future<List<categorie>> achatsCategorie() async {
    List<categorie> achatCategorieList = await helper.getAllcategories();
    return achatCategorieList;
  }

  // modifySoldemoins(String value) async {
  //   int montant = int.parse(value);
  //   utilisateur? user =
  //       await helper.getUser(this.usr!.email!, this.usr!.password!);
  //   int a = user!.id!;
  //   compte? cmp = await helper.getCompteUser(a);

  //   // if (cmp != null) {
  //   //   int solde = cmp.solde!;
  //   //   int newMontant = solde + montant;
  //   //   //print(newMontant);
  //   //   compte updateComp = compte(newMontant, a);
  //   //   helper.update_compte(updateComp);
  //   // } else {
  //   //   compte newCompte = compte(montant, a);
  //   //   helper.insert_compte(newCompte);
  //   // }

  //   if (cmp != null) {
  //     int solde = cmp.solde!;
  //     int newMontant = solde - montant;
  //     //print(newMontant);
  //     compte updateComp = compte(newMontant, a);
  //     helper.update_compte(updateComp);
  //     if (currentNomCat == "Choisir une categorie") {
  //       Toast.show("choisir une categorie SVP");
  //     } else {
  //       insertDepense(sortirMontant.text, sortirDesc.text);
  //       // Navigator.of(context).pop(montant);
  //     }
  //   } else {
  //     showText(context, "désolé", "vous n'avez pas de solde");
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    // updatedepenses();
    print(this.numero);
    return MaterialApp(
      title: "",
      home: DefaultTabController(
        // initialIndex: selectedPage!,
        length: mytabs.length,
        child: Scaffold(
          resizeToAvoidBottomInset: false,

          drawer: drowerfunction(context, usr),
          appBar: AppBar(
              toolbarHeight: 100,
              bottom: TabBar(tabs: mytabs),
              title: Text("Operations")),
          // drawer: drowerfunction(context),
          body: TabBarView(
            children: [
              Column(
                children: [
                  Card(
                    margin: EdgeInsets.only(top: 40),
                    child: Container(
                      width: MediaQuery.of(context).size.width - 50,
                      color: Colors.white70,
                      child: Form(
                        key: _formKey1,
                        child: Column(
                          children: [
                            Padding(
                              padding: EdgeInsets.only(top: 30, left: 10),
                              child: FutureBuilder(
                                  future: achatsCategorie(),
                                  builder: (BuildContext context,
                                      AsyncSnapshot<List<categorie>> snapshot) {
                                    if (!snapshot.hasData) {
                                      return CircularProgressIndicator();
                                    } else {
                                      return DropdownButton<String>(
                                        items: snapshot.data!
                                            .map((cat) =>
                                                DropdownMenuItem<String>(
                                                  child: Text(cat.nom!),
                                                  value: cat.nom,
                                                ))
                                            .toList(),
                                        onChanged: (String? value) {
                                          setState(() {
                                            currentNomCat = value!;
                                          });
                                        },
                                        isExpanded: true,
                                        //value: currentNomCat,
                                        hint: Text(
                                          '$currentNomCat',
                                          style: TextStyle(
                                            fontSize: 20,
                                            //fontWeight: FontWeight.bold
                                          ),
                                        ),
                                      );
                                    }
                                  }),
                            ),
                            Padding(
                              padding: EdgeInsets.only(bottom: 10, left: 10),
                              // const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                              child: TextFormField(
                                controller: entreeMontant,
                                keyboardType: TextInputType.number,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return "entree une montant";
                                  }
                                  return null;
                                },
                                decoration: const InputDecoration(
                                  border: UnderlineInputBorder(),
                                  labelText: "Montant",
                                ),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(bottom: 10, left: 10),

                              //const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                              child: TextFormField(
                                controller: entreeDesc,
                                decoration: const InputDecoration(
                                  border: UnderlineInputBorder(),
                                  labelText: "Description",
                                ),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(top: 40, left: 100),
                              child: Row(
                                children: [
                                  Padding(
                                    padding: EdgeInsets.only(right: 30),
                                    child: ElevatedButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                      child: Text('Annuler'),
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(),
                                    child: ElevatedButton(
                                      onPressed: () {
                                        if (currentNomCat ==
                                            "Choisir une categorie") {
                                          Toast.show(
                                              "choisir une categorie SVP");
                                        } else {
                                          insertRevenus(entreeMontant.text,
                                              entreeDesc.text);
                                          int montant =
                                              int.parse(entreeMontant.text);
                                          Map<int, int> myData = new Map();
                                          myData[0] = 0;
                                          myData[1] = montant;
                                          Navigator.of(context).pop(myData);
                                          // Navigator.pop(context, myData);
                                        }
                                      },
                                      child: Text('Enregistrer'),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              //le deuscieme tab
              Column(
                children: [
                  Card(
                    margin: EdgeInsets.only(top: 40),
                    child: Container(
                      width: MediaQuery.of(context).size.width - 50,
                      color: Colors.white70,
                      child: Form(
                        key: _formKey2,
                        child: Column(
                          children: [
                            Padding(
                              padding: EdgeInsets.only(top: 30, left: 10),
                              child: FutureBuilder(
                                  future: achatsCategorie(),
                                  builder: (BuildContext context,
                                      AsyncSnapshot<List<categorie>> snapshot) {
                                    if (!snapshot.hasData) {
                                      return CircularProgressIndicator();
                                    } else {
                                      return DropdownButton<String>(
                                        items: snapshot.data!
                                            .map((cat) =>
                                                DropdownMenuItem<String>(
                                                  child: Text(cat.nom!),
                                                  value: cat.nom,
                                                ))
                                            .toList(),
                                        onChanged: (String? value) {
                                          setState(() {
                                            currentNomCat = value!;
                                          });
                                        },
                                        isExpanded: true,
                                        //value: currentNomCat,
                                        hint: Text(
                                          '$currentNomCat',
                                          style: TextStyle(
                                            fontSize: 20,
                                            //fontWeight: FontWeight.bold
                                          ),
                                        ),
                                      );
                                    }
                                  }),
                            ),
                            Padding(
                              padding: EdgeInsets.only(bottom: 10, left: 10),
                              // const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                              child: TextFormField(
                                controller: sortirMontant,
                                keyboardType: TextInputType.number,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return "entree une montant";
                                  }
                                  return null;
                                },
                                decoration: const InputDecoration(
                                  border: UnderlineInputBorder(),
                                  labelText: "Montant",
                                ),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(bottom: 10, left: 10),

                              //const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                              child: TextFormField(
                                controller: sortirDesc,
                                decoration: const InputDecoration(
                                  border: UnderlineInputBorder(),
                                  labelText: "Description",
                                ),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(top: 40, left: 100),
                              child: Row(
                                children: [
                                  Padding(
                                    padding: EdgeInsets.only(right: 30),
                                    child: ElevatedButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                      child: Text('Annuler'),
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(),
                                    child: ElevatedButton(
                                      onPressed: () {
                                        if (currentNomCat ==
                                            "Choisir une categorie") {
                                          Toast.show(
                                              "choisir une categorie SVP");
                                        } else {
                                          insertDepense(sortirMontant.text,
                                              sortirDesc.text);

                                          // Navigator.pop(context, myData);
                                        }
                                      },
                                      child: Text('Enregistrer'),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
