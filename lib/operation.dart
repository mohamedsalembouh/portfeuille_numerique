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
  String? currentNomCat;
  String? currentNomCat2;
  String? TypeCompte;
  String? TypeCompte2;

  insertRevenus(String value, String description, String date) async {
    final form = _formKey1.currentState!;
    // final form = _formKey.currentState;
    // if (form!.validate()) {
    // if (montant == 0) {
    //   Toast.show("entrer montant");
    // }
    if (currentNomCat != "21".tr) {
      if (form.validate()) {
        if (TypeCompte != "25".tr) {
          int montant = int.parse(value);
          categorie? cat = await helper.getSpecifyCategorie(currentNomCat!);
          int idCat = cat!.id!;
          // DateTime maintenant = DateTime.now();
          // String date_maintenant = DateFormat("yyyy-MM-dd").format(maintenant);
          ressource? res = await helper.getSpecifyRessource(TypeCompte!);
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

  insertDepense(String value, String description, String date) async {
    final form = _formKey2.currentState!;
    if (currentNomCat != "21".tr) {
      if (form.validate()) {
        if (TypeCompte != "25".tr) {
          ressource? res = await helper.getSpecifyRessource(TypeCompte2!);
          int id_res = res!.id_ress!;
          compte? cmp = await helper.getSpecifyCompte(id_res);
          int id_compte = cmp!.id!;
          int montant = int.parse(value);
          compte? comp = await helper.getCompteUser(numero!, id_res);
          if (comp != null) {
            int solde = comp.solde!;
            if (solde > montant) {
              categorie? cat =
                  await helper.getSpecifyCategorie(currentNomCat2!);
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
                  "vous n'avez pas de solde sufficant pour cette operation dans $TypeCompte2");
            }
          } else {
            showText(context, "désolé",
                "vous n'avez pas de solde dans $TypeCompte2");
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
        // resizeToAvoidBottomInset: false,

        drawer: drowerfunction(context, usr),
        appBar: AppBar(bottom: TabBar(tabs: mytabs), title: Text("17".tr)),
        // drawer: drowerfunction(context),
        body: TabBarView(
          children: [
            SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Column(
                children: [
                  // Card(
                  //   margin: EdgeInsets.only(top: 40),
                  //   child: Container(
                  //     width: MediaQuery.of(context).size.width - 50,
                  //     color: Colors.white70,
                  //     child:
                  Form(
                    key: _formKey1,
                    child: Column(
                      children: [
                        SizedBox(
                          height: 20,
                        ),
                        Text(
                          "20".tr,
                          style: TextStyle(fontSize: 20),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 10, right: 10),
                          child: FutureBuilder(
                              future: achatsCategorie(),
                              builder: (BuildContext context,
                                  AsyncSnapshot<List<categorie>> snapshot) {
                                if (!snapshot.hasData) {
                                  return CircularProgressIndicator();
                                } else {
                                  return DropdownButtonFormField(
                                    decoration: InputDecoration(
                                        // labelText: "Destination",
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(20.0)),
                                          borderSide:
                                              BorderSide(color: Colors.white),
                                        ),
                                        enabledBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(20.0)),
                                          borderSide:
                                              BorderSide(color: Colors.black),
                                        )),
                                    isExpanded: true,
                                    elevation: 16,
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(5.0)),
                                    value: currentNomCat,
                                    hint: Text("21".tr),
                                    items: snapshot.data!
                                        .map((cat) => DropdownMenuItem<String>(
                                              child: Text(cat.nomcat!),
                                              value: cat.nomcat,
                                            ))
                                        .toList(),
                                    onChanged: (String? value) {
                                      setState(() {
                                        currentNomCat = value!;
                                      });
                                    },
                                    validator: (value) {
                                      if (value == null) {
                                        return "va".tr;
                                      }
                                      return null;
                                    },
                                  );
                                }
                              }),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Padding(
                          padding: EdgeInsets.only(left: 10, right: 10),
                          // const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                          child: TextFormField(
                            controller: entreeMontant,
                            keyboardType: TextInputType.number,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "va".tr;
                              }
                              return null;
                            },
                            decoration: InputDecoration(
                                labelText: "22".tr,
                                border: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(20.0)),
                                  borderSide: BorderSide(color: Colors.white),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(20.0)),
                                  borderSide: BorderSide(color: Colors.black),
                                )),
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Padding(
                          padding: EdgeInsets.only(right: 10, left: 10),

                          //const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                          child: TextFormField(
                            controller: entreeDesc,
                            decoration: InputDecoration(
                                labelText: "23".tr,
                                border: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(20.0)),
                                  borderSide: BorderSide(color: Colors.white),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(20.0)),
                                  borderSide: BorderSide(color: Colors.black),
                                )),
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Padding(
                          padding: EdgeInsets.only(left: 10, right: 10),
                          //const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                          child: TextFormField(
                            controller: date1,
                            readOnly: true,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "va".tr;
                              }
                              return null;
                            },
                            //keyboardType: TextInputType.datetime,
                            decoration: InputDecoration(
                                labelText: "24".tr,
                                border: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(20.0)),
                                  borderSide: BorderSide(color: Colors.white),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(20.0)),
                                  borderSide: BorderSide(color: Colors.black),
                                )),
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
                        SizedBox(
                          height: 20,
                        ),
                        Padding(
                          padding: EdgeInsets.only(right: 10, left: 10),
                          child: FutureBuilder(
                              future: getComptesRessource(this.usr!.id!),
                              builder: (BuildContext context,
                                  AsyncSnapshot<List<compteRessource>>
                                      snapshot) {
                                if (!snapshot.hasData) {
                                  return CircularProgressIndicator();
                                } else {
                                  return DropdownButtonFormField(
                                    decoration: InputDecoration(
                                        // labelText: "Destination",
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(20.0)),
                                          borderSide:
                                              BorderSide(color: Colors.white),
                                        ),
                                        enabledBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(20.0)),
                                          borderSide:
                                              BorderSide(color: Colors.black),
                                        )),
                                    isExpanded: true,
                                    elevation: 16,
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(5.0)),
                                    value: TypeCompte,
                                    hint: Text("25".tr),
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
                                    validator: (value) {
                                      if (value == null) {
                                        return "va".tr;
                                      }
                                      return null;
                                    },
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
                                child: SizedBox(
                                  width: MediaQuery.of(context).size.width / 3,
                                  height:
                                      MediaQuery.of(context).size.height / 12,
                                  child: ElevatedButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    child: Text("26".tr),
                                    style: ElevatedButton.styleFrom(
                                        shape: StadiumBorder()),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(),
                                child: SizedBox(
                                  width: MediaQuery.of(context).size.width / 3,
                                  height:
                                      MediaQuery.of(context).size.height / 13,
                                  child: ElevatedButton(
                                    onPressed: () {
                                      insertRevenus(
                                        entreeMontant.text,
                                        entreeDesc.text,
                                        date1.text,
                                      );

                                      // Navigator.pop(context, myData);
                                    },
                                    child: Text("27".tr),
                                    style: ElevatedButton.styleFrom(
                                        shape: StadiumBorder()),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  // ),
                  //),
                ],
              ),
            ),
            //le deuscieme tab
            SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Column(
                children: [
                  // Card(
                  //   margin: EdgeInsets.only(top: 40),
                  //   child: Container(
                  //     width: MediaQuery.of(context).size.width - 50,
                  //     color: Colors.white70,
                  //     child:
                  Form(
                    key: _formKey2,
                    child: Column(
                      children: [
                        SizedBox(
                          height: 20,
                        ),
                        Text(
                          "28".tr,
                          style: TextStyle(fontSize: 20),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 10, right: 10),
                          child: FutureBuilder(
                              future: achatsCategorie(),
                              builder: (BuildContext context,
                                  AsyncSnapshot<List<categorie>> snapshot) {
                                if (!snapshot.hasData) {
                                  return CircularProgressIndicator();
                                } else {
                                  return DropdownButtonFormField(
                                    decoration: InputDecoration(
                                        // labelText: "Destination",
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(20.0)),
                                          borderSide:
                                              BorderSide(color: Colors.white),
                                        ),
                                        enabledBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(20.0)),
                                          borderSide:
                                              BorderSide(color: Colors.black),
                                        )),
                                    isExpanded: true,
                                    elevation: 16,
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(5.0)),
                                    value: currentNomCat2,
                                    hint: Text("21".tr),
                                    items: snapshot.data!
                                        .map((cat) => DropdownMenuItem<String>(
                                              child: Text(cat.nomcat!),
                                              value: cat.nomcat,
                                            ))
                                        .toList(),
                                    onChanged: (String? value) {
                                      setState(() {
                                        currentNomCat2 = value!;
                                      });
                                    },
                                    validator: (value) {
                                      if (value == null) {
                                        return "va".tr;
                                      }
                                      return null;
                                    },
                                  );
                                }
                              }),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Padding(
                          padding: EdgeInsets.only(right: 10, left: 10),
                          // const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                          child: TextFormField(
                            controller: sortirMontant,
                            keyboardType: TextInputType.number,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "va".tr;
                              }
                              return null;
                            },
                            decoration: InputDecoration(
                                labelText: "22".tr,
                                border: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(20.0)),
                                  borderSide: BorderSide(color: Colors.white),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(20.0)),
                                  borderSide: BorderSide(color: Colors.black),
                                )),
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Padding(
                          padding: EdgeInsets.only(right: 10, left: 10),

                          //const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                          child: TextFormField(
                            controller: sortirDesc,
                            decoration: InputDecoration(
                                labelText: "23".tr,
                                border: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(20.0)),
                                  borderSide: BorderSide(color: Colors.white),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(20.0)),
                                  borderSide: BorderSide(color: Colors.black),
                                )),
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Padding(
                          padding: EdgeInsets.only(left: 10, right: 10),
                          //const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                          child: TextFormField(
                            controller: date2,
                            readOnly: true,
                            // validator: (value) {
                            //   if (value == null || value.isEmpty) {
                            //     return "entrer la date de debut";
                            //   }
                            //   return null;
                            // },
                            //keyboardType: TextInputType.datetime,
                            decoration: InputDecoration(
                                labelText: "24".tr,
                                border: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(20.0)),
                                  borderSide: BorderSide(color: Colors.white),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(20.0)),
                                  borderSide: BorderSide(color: Colors.black),
                                )),
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
                        SizedBox(
                          height: 20,
                        ),
                        Padding(
                          padding: EdgeInsets.only(right: 10, left: 10),
                          child: FutureBuilder(
                              future: getComptesRessource(this.usr!.id!),
                              builder: (BuildContext context,
                                  AsyncSnapshot<List<compteRessource>>
                                      snapshot) {
                                if (!snapshot.hasData) {
                                  return CircularProgressIndicator();
                                } else {
                                  return DropdownButtonFormField(
                                    decoration: InputDecoration(
                                        // labelText: "Destination",
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(20.0)),
                                          borderSide:
                                              BorderSide(color: Colors.white),
                                        ),
                                        enabledBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(20.0)),
                                          borderSide:
                                              BorderSide(color: Colors.black),
                                        )),
                                    isExpanded: true,
                                    elevation: 16,
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(5.0)),
                                    value: TypeCompte2,
                                    hint: Text("25".tr),
                                    items: snapshot.data!
                                        .map((cmpRes) =>
                                            DropdownMenuItem<String>(
                                              child: Text(cmpRes.nom_ress!),
                                              value: cmpRes.nom_ress,
                                            ))
                                        .toList(),
                                    onChanged: (String? value) {
                                      setState(() {
                                        TypeCompte2 = value!;
                                      });
                                    },
                                    validator: (value) {
                                      if (value == null) {
                                        return "va".tr;
                                      }
                                      return null;
                                    },
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
                                child: SizedBox(
                                  width: MediaQuery.of(context).size.width / 3,
                                  height:
                                      MediaQuery.of(context).size.height / 12,
                                  child: ElevatedButton(
                                    onPressed: () {
                                      Navigator.of(context, rootNavigator: true)
                                          .pop();
                                    },
                                    child: Text("26".tr),
                                    style: ElevatedButton.styleFrom(
                                        shape: StadiumBorder()),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(),
                                child: SizedBox(
                                  width: MediaQuery.of(context).size.width / 3,
                                  height:
                                      MediaQuery.of(context).size.height / 13,
                                  child: ElevatedButton(
                                    onPressed: () {
                                      insertDepense(
                                        sortirMontant.text,
                                        sortirDesc.text,
                                        date2.text,
                                      );

                                      // Navigator.pop(context, myData);
                                    },
                                    child: Text("27".tr),
                                    style: ElevatedButton.styleFrom(
                                        shape: StadiumBorder()),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  //   ),
                  // ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
