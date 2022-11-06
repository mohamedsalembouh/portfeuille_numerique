import 'package:flutter/material.dart';
import 'package:portfeuille_numerique/dettes.dart';
import 'package:portfeuille_numerique/main.dart';
import 'package:portfeuille_numerique/methodes.dart';
import 'package:portfeuille_numerique/models/prette_dette.dart';
import 'package:portfeuille_numerique/models/utilisateur.dart';
import 'package:intl/intl.dart';
import 'package:toast/toast.dart';
import 'models/compte.dart';
import 'models/compteRessource.dart';
import 'models/ressource.dart';
import 'package:get/get.dart';

class form_prette extends StatefulWidget {
  // const form_prette({Key? key}) : super(key: key);
  utilisateur? usr;
  form_prette(this.usr);

  @override
  State<form_prette> createState() => _form_pretteState(this.usr);
}

class _form_pretteState extends State<form_prette> {
  utilisateur? usr;
  // List<diagrameSolde> allUpdateSolde = [];
  _form_pretteState(this.usr);
  final _formKey = GlobalKey<FormState>();
  TextEditingController nom = TextEditingController();
  TextEditingController objet = TextEditingController();
  TextEditingController montant = TextEditingController();
  TextEditingController dateDebut = TextEditingController();
  TextEditingController dateEcheance = TextEditingController();
  //String defaultDateDebut = DateFormat("yyy-MM-dd").format(DateTime.now());

  insertPretteDette(String nom, String objectif, String montant,
      String dateDebut, String dateEcheance) async {
    DateTime maintenant = DateTime.now();
    String date_maintenant = DateFormat("yyyy-MM-dd").format(maintenant);
    final form = _formKey.currentState;
    utilisateur? user =
        await helper.getUser(this.usr!.email!, this.usr!.password!);
    int a = user!.id!;
    ressource? res = await helper.getSpecifyRessource(typeCmp!);
    int id_res = res!.id_ress!;
    compte? cmp = await helper.getSpecifyCompte(id_res);
    int id_compte = cmp!.id!;

    if (form!.validate()) {
      prette_dette pretteDette;
      if (sharedpref!.getBool("statusDette") == true) {
        pretteDette = prette_dette(nom, objectif, int.parse(montant),
            date_maintenant, dateDebut, dateEcheance, 0, 0, id_compte, a);
      } else {
        pretteDette = prette_dette(nom, objectif, int.parse(montant),
            date_maintenant, dateDebut, dateEcheance, 0, 1, id_compte, a);
      }
      int x = await helper.insert_pretteDatte(pretteDette);
      if (x > 0) {
        print("inserted ");
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => alldettes(usr, 0)));
      } else {
        print("not inserted");
      }
    }
  }

  String? typeCmp;
  minsSolde(String value) async {
    DateTime maintenant = DateTime.now();
    String date_maintenant = DateFormat("yyyy-MM-dd").format(maintenant);
    final form = _formKey.currentState;
    if (form!.validate()) {
      if (typeCmp != "25".tr) {
        ressource? res = await helper.getSpecifyRessource(typeCmp!);
        int id_res = res!.id_ress!;
        int mnt = int.parse(value);

        compte? cmp = await helper.getCompteUser(this.usr!.id!, id_res);
        if (cmp != null) {
          int solde = cmp.solde!;
          if (solde > mnt) {
            int newSolde = solde - mnt;
            compte updateCompte =
                compte(newSolde, date_maintenant, id_res, this.usr!.id);
            helper.update_compte(updateCompte);
            insertArgent(updateCompte.solde!, updateCompte.date!,
                updateCompte.id_ressource!, updateCompte.id_utilisateur!);
            insertPretteDette(nom.text, objet.text, montant.text,
                dateDebut.text, dateEcheance.text);
          } else {
            showText(context, "désolé",
                "Le montant que vous entree est plus grand que votre solde dans $typeCmp");
          }
        } else {
          showText(context, "désolé", "Vous n'avez pas de solde dans $typeCmp");
        }
      } else {
        Toast.show("t2".tr);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          //title: Text("Prette dettes"),
          ),
      body: SingleChildScrollView(
        child: Column(
          children: [
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
                        "44".tr,
                        style: TextStyle(fontSize: 25),
                      ),
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 10, left: 10),
                      child: TextFormField(
                        controller: nom,
                        decoration: InputDecoration(
                            labelText: "45".tr,
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
                        },
                      ),
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 10, left: 10),
                      child: TextFormField(
                        controller: objet,
                        decoration: InputDecoration(
                            labelText: "46".tr,
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
                      height: 30,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 10, left: 10),
                      child: TextFormField(
                        controller: montant,
                        keyboardType: TextInputType.number,
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
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "va".tr;
                          }
                        },
                      ),
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 10, right: 10),
                      child: TextFormField(
                        controller: dateDebut,
                        readOnly: true,
                        onTap: () async {
                          DateTime? pickedDate = await showDatePicker(
                              context: context,
                              initialDate: DateTime.now(),
                              firstDate: DateTime(1950),
                              lastDate: DateTime(2050));

                          if (pickedDate != null) {
                            dateDebut.text =
                                DateFormat('yyyy-MM-dd').format(pickedDate);
                          }
                        },
                        decoration: InputDecoration(
                            labelText: "47".tr,
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
                        },
                      ),
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 10, left: 10),
                      child: TextFormField(
                        controller: dateEcheance,
                        readOnly: true,
                        onTap: () async {
                          DateTime? pickedDate = await showDatePicker(
                              context: context,
                              initialDate: DateTime.now(),
                              firstDate: DateTime(1950),
                              lastDate: DateTime(2050));

                          if (pickedDate != null) {
                            dateEcheance.text =
                                DateFormat('yyyy-MM-dd').format(pickedDate);
                          }
                        },
                        decoration: InputDecoration(
                            labelText: "48".tr,
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
                                value: typeCmp,
                                hint: Text("25".tr),
                                items: snapshot.data!
                                    .map((cmpRes) => DropdownMenuItem<String>(
                                          child: Text(cmpRes.nom_ress!),
                                          value: cmpRes.nom_ress,
                                        ))
                                    .toList(),
                                onChanged: (String? value) {
                                  setState(() {
                                    typeCmp = value!;
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
                                minsSolde(montant.text);
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
          ],
        ),
      ),
    );
  }
}
