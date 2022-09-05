import 'package:flutter/material.dart';
import 'package:portfeuille_numerique/db/sql_helper.dart';
import 'package:portfeuille_numerique/methodes.dart';
import 'package:portfeuille_numerique/models/ressource.dart';

import 'models/utilisateur.dart';

class nouveauxRessource extends StatefulWidget {
  //const nouveauxRessource({ Key? key }) : super(key: key);
  utilisateur? usr;
  nouveauxRessource(this.usr);

  @override
  State<nouveauxRessource> createState() => _nouveauxRessourceState(this.usr);
}

class _nouveauxRessourceState extends State<nouveauxRessource> {
  utilisateur? usr;
  _nouveauxRessourceState(this.usr);
  final _formKey = new GlobalKey<FormState>();
  TextEditingController resnom = TextEditingController();

  insrtRessource(String name, int idUser) async {
    String nom = name.toUpperCase();
    SQL_Helper helper = SQL_Helper();
    final form = _formKey.currentState!;
    if (form.validate()) {
      ressource? rese = await helper.getRessourceByNom(nom);
      if (rese == null) {
        ressource res = ressource(nom, idUser);
        int result = await helper.insertRessource(res);
        if (result == 0) {
          print("not inserted");
        } else {
          print("inserted");
          showText(context, "", "La ressource est ajouté");
        }
      } else {
        showText(context, "SVP", "cette ressource existe deja");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
          padding: EdgeInsets.only(top: 40, left: 20),
          child: Column(
            children: [
              Card(
                child: Container(
                  width: MediaQuery.of(context).size.width - 50,
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        Padding(
                          padding: EdgeInsets.only(bottom: 20),
                          child: Text(
                            "Nouveaux Ressource",
                            style: TextStyle(fontSize: 20),
                          ),
                        ),
                        Padding(
                          padding:
                              EdgeInsets.only(bottom: 10, left: 20, top: 10),
                          // const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                          child: TextFormField(
                            controller: resnom,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "entree le nom de la ressource";
                              }
                              return null;
                            },
                            decoration: const InputDecoration(
                              border: UnderlineInputBorder(),
                              labelText: "Nom Ressource",
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
                                    insrtRessource(resnom.text, this.usr!.id!);
                                    resnom.clear();
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
          )),
    );
  }
}
