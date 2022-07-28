import 'package:flutter/material.dart';
import 'package:portfeuille_numerique/db/sql_helper.dart';
import 'package:portfeuille_numerique/models/compte.dart';
import 'package:portfeuille_numerique/models/objective.dart';
import 'package:portfeuille_numerique/models/utilisateur.dart';
import 'package:portfeuille_numerique/objectifs.dart';
import 'package:toast/toast.dart';

import 'methodes.dart';

class form_objectif extends StatefulWidget {
  //const form_objectif({Key? key}) : super(key: key);
  utilisateur? usr;
  form_objectif(this.usr);

  @override
  State<form_objectif> createState() => _form_objectifState(this.usr);
}

class _form_objectifState extends State<form_objectif> {
  utilisateur? usr;
  _form_objectifState(this.usr);
  final _formKey = GlobalKey<FormState>();
  TextEditingController nomObj = TextEditingController();
  TextEditingController montantCible = TextEditingController();
  TextEditingController montantEnregistree = TextEditingController();
  SQL_Helper helper = SQL_Helper();

  insertObjectif(String nomobj, String value1, String value2) async {
    final form = _formKey.currentState!;
    if (form.validate()) {
      if (TypeCompte != "Choisissez le type de solde") {
        utilisateur? user =
            await helper.getUser(this.usr!.email!, this.usr!.password!);
        int a = user!.id!;
        int mntCible = int.parse(value1);
        int mntEnregistree = int.parse(value2);
        compte? cmp = await helper.getCompteUser(a, TypeCompte);
        if (cmp != null) {
          int solde = cmp.solde!;
          if (mntEnregistree < solde) {
            objective obj = objective(nomobj, mntCible, mntEnregistree, a);
            int result = await helper.insert_objectif(obj);
            int newSolde = solde - mntEnregistree;
            compte updateCompte = compte(newSolde, TypeCompte, a);
            int result2 = await helper.update_compte(updateCompte);
            if (result != 0 && result2 != 0) {
              print("ok objective enregistre");
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => objectif(usr)));
            }
          } else {
            showText(context, "Desole",
                "Le montant que vous voulez enregistree est plus grand que votre solde");
          }
        }
      } else {
        Toast.show("Choisissez le type de solde");
      }
    }
  }

  String TypeCompte = "Choisissez le type de solde";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
            //title: Text("Nouveaux objectif"),
            ),
        body: Column(children: [
          Padding(
            padding: EdgeInsets.only(top: 40),
            child: Container(
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
                                    "Nouveaux Objectif",
                                    style: TextStyle(fontSize: 25),
                                  )),
                              Padding(
                                padding: EdgeInsets.only(bottom: 10, left: 10),
                                // padding: EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                                child: TextFormField(
                                  controller: nomObj,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return "entrer le nom de l'objectif";
                                    }
                                    return null;
                                  },
                                  decoration: const InputDecoration(
                                    border: UnderlineInputBorder(),
                                    labelText: "Nom de l'objectif",
                                  ),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(bottom: 10, left: 10),

                                //const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                                child: TextFormField(
                                  controller: montantCible,
                                  keyboardType: TextInputType.number,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return "entrer le montant cible";
                                    }
                                    return null;
                                  },
                                  decoration: const InputDecoration(
                                    border: UnderlineInputBorder(),
                                    labelText: "Montant cible",
                                  ),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(bottom: 10, left: 10),

                                //const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                                child: TextFormField(
                                  controller: montantEnregistree,
                                  keyboardType: TextInputType.number,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return "entrer le montant enregistre";
                                    }
                                    return null;
                                  },
                                  decoration: const InputDecoration(
                                    border: UnderlineInputBorder(),
                                    labelText: "Montant enregistre",
                                  ),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(left: 10, top: 10),
                                child: DropdownButton<String>(
                                  items: <String>['Compte', 'Bankily', 'Bank']
                                      .map<DropdownMenuItem<String>>(
                                          (String value) {
                                    return DropdownMenuItem<String>(
                                      value: value,
                                      child: Text(value),
                                    );
                                  }).toList(),
                                  onChanged: (String? value) {
                                    setState(() {
                                      TypeCompte = value!;
                                    });
                                  },
                                  isExpanded: true,
                                  //value: currentNomCat,
                                  hint: Text('$TypeCompte'),
                                  //style: TextStyle(fontSize: 18),
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
                                          insertObjectif(
                                            nomObj.text,
                                            montantCible.text,
                                            montantEnregistree.text,
                                          );
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
          )
        ]));
  }
}
