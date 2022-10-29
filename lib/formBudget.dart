import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:portfeuille_numerique/budget.dart';
import 'package:portfeuille_numerique/db/sql_helper.dart';
import 'package:portfeuille_numerique/main.dart';
import 'package:portfeuille_numerique/models/budgete.dart';
import 'package:portfeuille_numerique/models/utilisateur.dart';
import 'package:toast/toast.dart';
import 'models/categorie.dart';
import 'package:get/get.dart';

class formbudget extends StatefulWidget {
  //const formbudget({Key? key}) : super(key: key);
  utilisateur? usr;

  formbudget(this.usr);
  @override
  State<formbudget> createState() => _formbudgetState(this.usr);
}

class _formbudgetState extends State<formbudget> {
  utilisateur? usr;
  // List<diagrameSolde>? allUpdateSolde;
  _formbudgetState(this.usr);
  TextEditingController nom = TextEditingController();
  TextEditingController montant = TextEditingController();
  TextEditingController dateDebut = TextEditingController();
  TextEditingController dateFin = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  SQL_Helper helper = SQL_Helper();
  String? currentNomCat;
  Future<List<categorie>> achatsCategorie() async {
    List<categorie> achatCategorieList =
        await helper.getAllcategories(this.usr!.id!);
    return achatCategorieList;
  }

  insrererBudget(
    String nom,
    String value,
    String dateDebut,
    String dateFin,
  ) async {
    final form = _formKey.currentState!;
    if (form.validate()) {
      utilisateur? user =
          await helper.getUser(this.usr!.email!, this.usr!.password!);
      int a = user!.id!;
      int montant = int.parse(value);
      categorie? cat = await helper.getSpecifyCategorie(currentNomCat!);
      int idCat = cat!.id!;
      budgete bdg;
      if (sharedpref!.getBool("statusBudget") == true) {
        bdg = budgete(nom, montant, dateDebut, dateFin, 0, 0, idCat, a);
      } else {
        bdg = budgete(nom, montant, dateDebut, dateFin, 0, 1, idCat, a);
      }
      int x = await helper.insert_Budget(bdg);
      if (x > 0) {
        print("ok inserted");
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => budget(usr, 0)));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
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
                        "55".tr,
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
                            labelText: "56".tr,
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
                            return "Le champ est obligatoire";
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
                            return "Le champ est obligatoire";
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
                            return "Le champ est obligatoire";
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
                        controller: dateFin,
                        readOnly: true,
                        onTap: () async {
                          DateTime? pickedDate = await showDatePicker(
                              context: context,
                              initialDate: DateTime.now(),
                              firstDate: DateTime(1950),
                              lastDate: DateTime(2050));

                          if (pickedDate != null) {
                            dateFin.text =
                                DateFormat('yyyy-MM-dd').format(pickedDate);
                          }
                        },
                        decoration: InputDecoration(
                            labelText: "57".tr,
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
                            return "Le champ est obligatoire";
                          }
                        },
                      ),
                    ),
                    SizedBox(
                      height: 30,
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
                                    return "Le champ est obligatoire";
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
                                insrererBudget(
                                  nom.text,
                                  montant.text,
                                  dateDebut.text,
                                  dateFin.text,
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
          ],
        ),
      ),
    );
  }
}
