import 'package:flutter/material.dart';
import 'package:portfeuille_numerique/db/sql_helper.dart';
import 'package:portfeuille_numerique/models/partag.dart';
import 'package:portfeuille_numerique/partageGroupe.dart';
import 'package:sqflite/sqflite.dart';

import 'methodes.dart';
import 'models/utilisateur.dart';

class formPartage extends StatefulWidget {
  //const formPartage({Key? key}) : super(key: key);
  utilisateur? usr;
  formPartage(this.usr);
  @override
  State<formPartage> createState() => _formPartageState(this.usr);
}

class _formPartageState extends State<formPartage> {
  utilisateur? usr;
  _formPartageState(this.usr);
  final _formKey = new GlobalKey<FormState>();
  TextEditingController email = TextEditingController();
  SQL_Helper helper = SQL_Helper();

  inseretPartage(String emailPersonne) async {
    final form = _formKey.currentState!;
    if (form.validate()) {
      utilisateur? usere = await helper.getUserByEmail(emailPersonne);
      if (usere != null) {
        partag prt = partag(emailPersonne, this.usr!.email, this.usr!.id);
        int result = await helper.insert_partage(prt);
        if (result > 0) {
          print("ok partage");
          showText(context, "OK", "vous avez partage votre compte");
          email.clear();
        }
      } else {
        showText(context, "Sorry", "cette utilisateur n'existe pas");
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
                            "Donnees l'acces a votre compte a un personne",
                            style: TextStyle(fontSize: 15),
                          ),
                        ),
                        Padding(
                          padding:
                              EdgeInsets.only(bottom: 10, left: 20, top: 10),
                          // const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                          child: TextFormField(
                            controller: email,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "entree email";
                              }
                              if (!validateEmail(value)) {
                                return 'SVP entrer valide email';
                              }
                              return null;
                            },
                            decoration: const InputDecoration(
                              border: UnderlineInputBorder(),
                              labelText: "email",
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
                                    inseretPartage(email.text);
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                partage(this.usr)));
                                  },
                                  child: Text('Partage'),
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
