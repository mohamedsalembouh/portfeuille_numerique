import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:portfeuille_numerique/db/sql_helper.dart';
import 'package:portfeuille_numerique/main.dart';
import 'package:portfeuille_numerique/models/compte.dart';
import 'package:portfeuille_numerique/models/objective.dart';
import 'package:portfeuille_numerique/models/utilisateur.dart';
import 'package:portfeuille_numerique/objectifs.dart';
import 'package:toast/toast.dart';
import 'methodes.dart';
import 'models/argent.dart';
import 'models/compteRessource.dart';
import 'models/ressource.dart';
import 'package:get/get.dart';

class form_objectif extends StatefulWidget {
  //const form_objectif({Key? key}) : super(key: key);
  utilisateur? usr;

  form_objectif(this.usr);

  @override
  State<form_objectif> createState() => _form_objectifState(this.usr);
}

class _form_objectifState extends State<form_objectif> {
  utilisateur? usr;
  //List<diagrameSolde> allUpdateSolde = [];
  _form_objectifState(this.usr);
  final _formKey = GlobalKey<FormState>();
  TextEditingController nomObj = TextEditingController();
  TextEditingController montantCible = TextEditingController();
  TextEditingController montantEnregistree = TextEditingController();
  SQL_Helper helper = SQL_Helper();
  String? TypeCompte;

  insertObjectif(String nomobj, String value1, String value2) async {
    DateTime maintenant = DateTime.now();
    String date_maintenant = DateFormat("yyyy-MM-dd").format(maintenant);
    final form = _formKey.currentState!;
    if (form.validate()) {
      if (TypeCompte != "25".tr) {
        ressource? res = await helper.getSpecifyRessource(TypeCompte!);
        int id_res = res!.id_ress!;
        compte? cmpe = await helper.getSpecifyCompte(id_res);
        int id_cmpe = cmpe!.id!;
        utilisateur? user =
            await helper.getUser(this.usr!.email!, this.usr!.password!);
        int a = user!.id!;
        int mntCible = int.parse(value1);
        int mntEnregistree = int.parse(value2);
        compte? cmp = await helper.getCompteUser(a, id_res);
        if (cmp != null) {
          int solde = cmp.solde!;
          if (mntEnregistree < solde) {
            objective obj;
            if (sharedpref!.getBool("statusObjectif") == true) {
              obj = objective(nomobj, mntCible, mntEnregistree, date_maintenant,
                  0, id_cmpe, a);
            } else {
              obj = objective(nomobj, mntCible, mntEnregistree, date_maintenant,
                  1, id_cmpe, a);
            }
            int result = await helper.insert_objectif(obj);
            int newSolde = solde - mntEnregistree;
            compte updateCompte = compte(newSolde, date_maintenant, id_res, a);
            insertArgent(updateCompte.solde!, updateCompte.date!,
                updateCompte.id_ressource!, updateCompte.id_utilisateur!);
            int result2 = await helper.update_compte(updateCompte);
            argent arg = argent(updateCompte.solde, updateCompte.date,
                updateCompte.id_ressource, updateCompte.id_utilisateur);
            helper.insert_argent(arg);
            if (result != 0 && result2 != 0) {
              print("ok objective enregistre");
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => objectif(usr, 0)));
            }
          } else {
            showText(context, "Desole",
                "Le montant que vous voulez enregistree est plus grand que votre solde ");
          }
        }
      } else {
        Toast.show("t2".tr);
      }
    }
    // this.allUpdateSolde =
    //     getListSoldes(this.allUpdateSolde!, TypeCompte, this.usr!.id!);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(),
        body: SingleChildScrollView(
          child: Column(children: [
            Container(
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    SizedBox(
                      height: 30,
                    ),
                    Center(
                      child: Text(
                        "60".tr,
                        style: TextStyle(fontSize: 25),
                      ),
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 10, left: 10),
                      child: TextFormField(
                        controller: nomObj,
                        decoration: InputDecoration(
                            labelText: "61".tr,
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
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "va".tr;
                          }
                          return null;
                        },
                      ),
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 10, left: 10),
                      child: TextFormField(
                        controller: montantCible,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                            labelText: "62".tr,
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
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "va".tr;
                          }
                          return null;
                        },
                      ),
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 10, left: 10),
                      child: TextFormField(
                        controller: montantEnregistree,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                            labelText: "63".tr,
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
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "va".tr;
                          }
                          return null;
                        },
                      ),
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    Padding(
                      padding: EdgeInsets.only(right: 10, left: 10),
                      child: FutureBuilder(
                          future: getComptesRessource(this.usr!.id!),
                          builder: (BuildContext context,
                              AsyncSnapshot<List<compteRessource>> snapshot) {
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
                                    .map((cmpRes) => DropdownMenuItem<String>(
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
                    SizedBox(
                      height: 30,
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 100),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          SizedBox(
                            width: MediaQuery.of(context).size.width / 3,
                            height: MediaQuery.of(context).size.height / 13,
                            child: ElevatedButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: Text('26'.tr),
                              style: ElevatedButton.styleFrom(
                                  shape: StadiumBorder()),
                            ),
                          ),
                          SizedBox(
                            width: MediaQuery.of(context).size.width / 3,
                            height: MediaQuery.of(context).size.height / 13,
                            child: ElevatedButton(
                              onPressed: () {
                                insertObjectif(
                                  nomObj.text,
                                  montantCible.text,
                                  montantEnregistree.text,
                                );
                              },
                              child: Text('27'.tr),
                              style: ElevatedButton.styleFrom(
                                  shape: StadiumBorder()),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ]),
        ));
  }
}
