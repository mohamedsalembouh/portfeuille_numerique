import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:portfeuille_numerique/categories.dart';
import 'package:portfeuille_numerique/db/sql_helper.dart';
import 'package:portfeuille_numerique/dettes.dart';
import 'package:portfeuille_numerique/methodes.dart';
import 'package:portfeuille_numerique/models/categorie.dart';
import 'package:portfeuille_numerique/models/compteRessource.dart';
import 'package:portfeuille_numerique/models/operation_entree.dart';
import 'package:portfeuille_numerique/models/operation_sortir.dart';
import 'package:portfeuille_numerique/models/utilisateur.dart';
import 'package:portfeuille_numerique/services/local_notification_service.dart';
import 'package:portfeuille_numerique/statistiques.dart';
import 'package:sqflite/sqflite.dart';
import 'package:toast/toast.dart';
import 'package:get/get.dart';

import 'budget.dart';
import 'models/catBudget.dart';
import 'models/compte.dart';
import 'models/depensesCats.dart';
import 'models/ressource.dart';

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
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  final _formKey1 = new GlobalKey<FormState>();
  final _formKey2 = new GlobalKey<FormState>();
  TextEditingController entreeMontant = TextEditingController();
  TextEditingController entreeDesc = TextEditingController();
  TextEditingController sortirMontant = TextEditingController();
  TextEditingController sortirDesc = TextEditingController();
  TextEditingController date1 = TextEditingController(
      text: DateFormat("yyyy-MM-dd").format(DateTime.now()));
  TextEditingController date2 = TextEditingController(
      text: DateFormat("yyyy-MM-dd").format(DateTime.now()));
  // String? nomcategorie;
  // int? selectedPage;
  int? numero;
  utilisateur? usr;
  // List<diagrameSolde>? allUpdateSolde;
  _operationState(this.usr, this.numero);
  List<operation_sortir>? alldepenses;
  int? count;
  final List<Tab> mytabs = [
    Tab(
      text: "18".tr,
    ),
    Tab(
      text: "19".tr,
    )
  ];

  SQL_Helper helper = new SQL_Helper();
  String currentNomCat = "21".tr;
  String TypeCompte = "25".tr;

  insertRevenus(
      String value, String description, String date, String typeCmp) async {
    final form = _formKey1.currentState!;
    // final form = _formKey.currentState;
    // if (form!.validate()) {
    // if (montant == 0) {
    //   Toast.show("entrer montant");
    // }
    if (currentNomCat != "21".tr) {
      if (form.validate()) {
        if (typeCmp != "25".tr) {
          int montant = int.parse(value);
          categorie? cat = await helper.getSpecifyCategorie(currentNomCat);
          int idCat = cat!.id!;
          // DateTime maintenant = DateTime.now();
          // String date_maintenant = DateFormat("yyyy-MM-dd").format(maintenant);
          ressource? res = await helper.getSpecifyRessource(typeCmp);
          int id_res = res!.id_ress!;
          compte? cmp = await helper.getSpecifyCompte(id_res);
          int id_compte = cmp!.id!;
          operation_entree entree = new operation_entree(
              montant, description, date, idCat, id_compte, this.numero);
          int a = await helper.insertOperationEntree(entree);
          if (a != 0) {
            print("operation inserted");
            int montant = int.parse(entreeMontant.text);
            Map<int, int> myData = new Map();
            myData[0] = 0;
            myData[1] = montant;
            myData[2] = id_res;
            Navigator.of(context).pop(myData);
          } else {
            print("not inserted");
          }
        } else {
          Toast.show("t2".tr);
        }
      }
    } else {
      Toast.show("t1".tr);
    }
  }

  insertDepense(
      String value, String description, String date, String typeCmp) async {
    final form = _formKey2.currentState!;
    if (currentNomCat != "21".tr) {
      if (form.validate()) {
        if (typeCmp != "25".tr) {
          ressource? res = await helper.getSpecifyRessource(typeCmp);
          int id_res = res!.id_ress!;
          compte? cmp = await helper.getSpecifyCompte(id_res);
          int id_compte = cmp!.id!;
          int montant = int.parse(value);
          compte? comp = await helper.getCompteUser(numero!, id_res);
          if (comp != null) {
            int solde = comp.solde!;
            if (solde > montant) {
              categorie? cat = await helper.getSpecifyCategorie(currentNomCat);
              int idCat = cat!.id!;
              // DateTime maintenant = DateTime.now();
              // String date_maintenant =
              //     DateFormat("yyyy-MM-dd").format(maintenant);
              operation_sortir sortir = new operation_sortir(
                  montant, description, date, idCat, id_compte, this.numero);
              int a = await helper.insertOperationSortir(sortir);
              if (a != 0) {
                print("operation sortir inserted");
                Map<int, int> myData = new Map();
                myData[0] = 1;
                myData[1] = montant;
                myData[2] = id_res;
                Navigator.of(context, rootNavigator: true).pop(myData);
              } else {
                print("not inserted");
              }
            } else {
              showText(context, "désolé",
                  "vous n'avez pas de solde sufficant pour cette operation dans $typeCmp");
            }
          } else {
            showText(
                context, "désolé", "vous n'avez pas de solde dans $typeCmp");
          }
        } else {
          Toast.show("t2".tr);
        }
      }
    } else {
      Toast.show("t1".tr);
    }

    // updatedepenses();
    // print(this.count);
  }

  Future<List<categorie>> achatsCategorie() async {
    List<categorie> achatCategorieList =
        await helper.getAllcategories(this.usr!.id!);
    return achatCategorieList;
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      // initialIndex: selectedPage!,
      length: mytabs.length,
      child: Scaffold(
        resizeToAvoidBottomInset: false,

        drawer: drowerfunction(context, usr),
        appBar: AppBar(
            toolbarHeight: 100,
            bottom: TabBar(tabs: mytabs),
            title: Text("17".tr)),
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
                          Text(
                            "20".tr,
                            style: TextStyle(fontSize: 20),
                          ),
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
                                          .map(
                                              (cat) => DropdownMenuItem<String>(
                                                    child: Text(cat.nomcat!),
                                                    value: cat.nomcat,
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
                                  return "entree un montant";
                                }
                                return null;
                              },
                              decoration: InputDecoration(
                                border: UnderlineInputBorder(),
                                labelText: "22".tr,
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(bottom: 10, left: 10),

                            //const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                            child: TextFormField(
                              controller: entreeDesc,
                              decoration: InputDecoration(
                                border: UnderlineInputBorder(),
                                labelText: "23".tr,
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(left: 10, bottom: 10),
                            //const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                            child: TextFormField(
                              controller: date1,
                              // validator: (value) {
                              //   if (value == null || value.isEmpty) {
                              //     return "entrer la date de debut";
                              //   }
                              //   return null;
                              // },
                              //keyboardType: TextInputType.datetime,
                              decoration: InputDecoration(
                                border: UnderlineInputBorder(),
                                labelText: "24".tr,
                                icon: Icon(Icons.calendar_today_outlined),
                              ),
                              onTap: () async {
                                DateTime? pickeddate = await showDatePicker(
                                    context: context,
                                    initialDate: DateTime.now(),
                                    firstDate: DateTime(2000),
                                    lastDate: DateTime(2050));

                                if (pickeddate == null) {
                                  pickeddate = DateTime.now();
                                }
                                setState(() {
                                  date1.text = DateFormat("yyyy-MM-dd")
                                      .format(pickeddate!);
                                });
                              },
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(top: 30, left: 10),
                            child: FutureBuilder(
                                future: getComptesRessource(this.usr!.id!),
                                builder: (BuildContext context,
                                    AsyncSnapshot<List<compteRessource>>
                                        snapshot) {
                                  if (!snapshot.hasData) {
                                    return CircularProgressIndicator();
                                  } else {
                                    return DropdownButton<String>(
                                      items: snapshot.data!
                                          .map((cmpRes) =>
                                              DropdownMenuItem<String>(
                                                child: Text(cmpRes.nom_ress!),
                                                value: cmpRes.nom_ress,
                                              ))
                                          .toList(),
                                      onChanged: (String? value) {
                                        setState(() {
                                          TypeCompte = value!;
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
                            padding: EdgeInsets.only(top: 40, left: 100),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Padding(
                                  padding: EdgeInsets.only(),
                                  child: ElevatedButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    child: Text("26".tr),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(),
                                  child: ElevatedButton(
                                    onPressed: () {
                                      insertRevenus(
                                          entreeMontant.text,
                                          entreeDesc.text,
                                          date1.text,
                                          TypeCompte);

                                      // Navigator.pop(context, myData);
                                    },
                                    child: Text("27".tr),
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
                          Text(
                            "28".tr,
                            style: TextStyle(fontSize: 20),
                          ),
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
                                          .map(
                                              (cat) => DropdownMenuItem<String>(
                                                    child: Text(cat.nomcat!),
                                                    value: cat.nomcat,
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
                              decoration: InputDecoration(
                                border: UnderlineInputBorder(),
                                labelText: "22".tr,
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(bottom: 10, left: 10),

                            //const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                            child: TextFormField(
                              controller: sortirDesc,
                              decoration: InputDecoration(
                                border: UnderlineInputBorder(),
                                labelText: "23".tr,
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(left: 10, bottom: 10),
                            //const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                            child: TextFormField(
                              controller: date2,
                              // validator: (value) {
                              //   if (value == null || value.isEmpty) {
                              //     return "entrer la date de debut";
                              //   }
                              //   return null;
                              // },
                              //keyboardType: TextInputType.datetime,
                              decoration: InputDecoration(
                                border: UnderlineInputBorder(),
                                labelText: "24".tr,
                                icon: Icon(Icons.calendar_today_outlined),
                              ),
                              onTap: () async {
                                DateTime? pickeddate = await showDatePicker(
                                    context: context,
                                    initialDate: DateTime.now(),
                                    firstDate: DateTime(2000),
                                    lastDate: DateTime(2050));

                                if (pickeddate == null) {
                                  pickeddate = DateTime.now();
                                }
                                setState(() {
                                  date2.text = DateFormat("yyyy-MM-dd")
                                      .format(pickeddate!);
                                });
                              },
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(top: 30, left: 10),
                            child: FutureBuilder(
                                future: getComptesRessource(this.usr!.id!),
                                builder: (BuildContext context,
                                    AsyncSnapshot<List<compteRessource>>
                                        snapshot) {
                                  if (!snapshot.hasData) {
                                    return CircularProgressIndicator();
                                  } else {
                                    return DropdownButton<String>(
                                      items: snapshot.data!
                                          .map((cmpRes) =>
                                              DropdownMenuItem<String>(
                                                child: Text(cmpRes.nom_ress!),
                                                value: cmpRes.nom_ress,
                                              ))
                                          .toList(),
                                      onChanged: (String? value) {
                                        setState(() {
                                          TypeCompte = value!;
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
                            padding: EdgeInsets.only(top: 40, left: 100),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Padding(
                                  padding: EdgeInsets.only(right: 30),
                                  child: ElevatedButton(
                                    onPressed: () {
                                      Navigator.of(context, rootNavigator: true)
                                          .pop();
                                    },
                                    child: Text("26".tr),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(),
                                  child: ElevatedButton(
                                    onPressed: () {
                                      insertDepense(
                                          sortirMontant.text,
                                          sortirDesc.text,
                                          date2.text,
                                          TypeCompte);

                                      // Navigator.pop(context, myData);
                                    },
                                    child: Text("27".tr),
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
    );
  }
}
