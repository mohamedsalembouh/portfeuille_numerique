import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:portfeuille_numerique/budget.dart';
import 'package:portfeuille_numerique/db/sql_helper.dart';
import 'package:portfeuille_numerique/models/budgete.dart';
import 'package:portfeuille_numerique/models/utilisateur.dart';
import 'package:toast/toast.dart';

import 'models/categorie.dart';

class formbudget extends StatefulWidget {
  //const formbudget({Key? key}) : super(key: key);
  utilisateur? usr;
  formbudget(this.usr);
  @override
  State<formbudget> createState() => _formbudgetState(this.usr);
}

class _formbudgetState extends State<formbudget> {
  utilisateur? usr;
  _formbudgetState(this.usr);
  TextEditingController nom = TextEditingController();
  TextEditingController montant = TextEditingController();
  TextEditingController dateDebut = TextEditingController();
  TextEditingController dateFin = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  SQL_Helper helper = SQL_Helper();
  String currentNomCat = "Choisir une categorie";
  Future<List<categorie>> achatsCategorie() async {
    List<categorie> achatCategorieList = await helper.getAllcategories();
    return achatCategorieList;
  }

  insrererBudget(String nom, String value, String dateDebut, String dateFin,
      String CatNom) async {
    final form = _formKey.currentState!;
    if (form.validate()) {
      utilisateur? user =
          await helper.getUser(this.usr!.email!, this.usr!.password!);
      int a = user!.id!;
      int montant = int.parse(value);
      categorie? cat = await helper.getSpecifyCategorie(CatNom);
      int idCat = cat!.id!;
      budgete bdg = budgete(nom, montant, dateDebut, dateFin, idCat, a);
      int x = await helper.insert_Budget(bdg);
      if (x > 0) {
        print("ok inserted");
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => budget(usr)));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
          //title: Text("Nouveaux budget"),
          ),
      body: Column(
        children: [
          Container(
            child: Padding(
              padding: EdgeInsets.only(top: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Center(
                    child: Card(
                      child: Container(
                        color: Colors.white70,
                        width: MediaQuery.of(context).size.width - 50,
                        child: Form(
                          key: _formKey,
                          child: Column(
                            children: [
                              Padding(
                                  padding: EdgeInsets.only(bottom: 20),
                                  child: Text(
                                    "Nouveaux Budget",
                                    style: TextStyle(fontSize: 25),
                                  )),
                              Padding(
                                padding: EdgeInsets.only(bottom: 10, left: 10),
                                // padding: EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                                child: TextFormField(
                                  controller: nom,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return "entrer le nom du budget";
                                    }
                                    return null;
                                  },
                                  decoration: const InputDecoration(
                                    border: UnderlineInputBorder(),
                                    labelText: "Nom du budget",
                                  ),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(bottom: 10, left: 10),

                                //const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                                child: TextFormField(
                                  controller: montant,
                                  keyboardType: TextInputType.number,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return "entrer le montant que vous voulez specifiez";
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
                                padding: EdgeInsets.only(left: 10, bottom: 10),
                                //const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                                child: TextFormField(
                                  controller: dateDebut,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return "entrer la date de debut";
                                    }
                                    return null;
                                  },
                                  //keyboardType: TextInputType.datetime,
                                  decoration: InputDecoration(
                                    border: UnderlineInputBorder(),
                                    labelText: "Date debut ",
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
                                      dateDebut.text = DateFormat("yyyy-MM-dd")
                                          .format(pickeddate!);
                                    });
                                  },
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(left: 10),
                                //const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                                child: TextFormField(
                                  controller: dateFin,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return "entrer la date de Fin";
                                    }
                                    return null;
                                  },
                                  //keyboardType: TextInputType.datetime,
                                  decoration: const InputDecoration(
                                    border: UnderlineInputBorder(),
                                    labelText: "Date de Fin ",
                                    icon: Icon(Icons.calendar_today_outlined),
                                  ),
                                  onTap: () async {
                                    DateTime? pickeddate = await showDatePicker(
                                        context: context,
                                        initialDate: DateTime.now(),
                                        firstDate: DateTime(2000),
                                        lastDate: DateTime(2050));

                                    if (pickeddate != null) {
                                      setState(() {
                                        dateFin.text = DateFormat("yyyy-MM-dd")
                                            .format(pickeddate);
                                      });
                                    }
                                  },
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(top: 30, left: 10),
                                child: FutureBuilder(
                                    future: achatsCategorie(),
                                    builder: (BuildContext context,
                                        AsyncSnapshot<List<categorie>>
                                            snapshot) {
                                      if (!snapshot.hasData) {
                                        return CircularProgressIndicator();
                                      } else {
                                        return DropdownButton<String>(
                                          items: snapshot.data!
                                              .map((cat) =>
                                                  DropdownMenuItem<String>(
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
                                                //fontSize: 20,
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
                                          if (currentNomCat !=
                                              "Choisir une categorie") {
                                            insrererBudget(
                                                nom.text,
                                                montant.text,
                                                dateDebut.text,
                                                dateFin.text,
                                                currentNomCat);
                                          } else {
                                            Toast.show("Choisir une categorie");
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
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
