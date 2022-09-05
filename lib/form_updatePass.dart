import 'package:flutter/material.dart';
import 'package:portfeuille_numerique/models/utilisateur.dart';

import 'db/sql_helper.dart';
import 'methodes.dart';

class form_updatePass extends StatelessWidget {
  // const form_updatePass({Key? key}) : super(key: key);
  utilisateur? usr;
  form_updatePass(this.usr);
  TextEditingController newpass = TextEditingController();
  TextEditingController conf_pass = TextEditingController();
  SQL_Helper helper = SQL_Helper();
  final _formKey2 = new GlobalKey<FormState>();

  updatePassword(BuildContext context, String pass1, String pass2) async {
    final form2 = _formKey2.currentState!;
    if (form2.validate()) {
      if (pass1 == pass2) {
        int y = await helper.update_password(pass1, this.usr!.id!);
        if (y != 0) {
          print("updated");
          Navigator.pop(context);
          showText(context, "", "votre mot de pass est change");
        }
      } else {
        showText(context, "SVP",
            "Les deux mots de passes ne sont pas correspondant");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: [
          Card(
            child: Container(
              width: MediaQuery.of(context).size.width - 50,
              child: Form(
                key: _formKey2,
                child: Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(bottom: 20),
                      child: Text(
                        "Changer votre Mot de passe",
                        style: TextStyle(fontSize: 20),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(bottom: 10, left: 20, top: 10),
                      // const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                      child: TextFormField(
                        controller: newpass,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "entree le nouveaux Mot de pass";
                          }
                          return null;
                        },
                        decoration: const InputDecoration(
                          border: UnderlineInputBorder(),
                          labelText: "Nouveaux Mot de passe",
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(bottom: 10, left: 20, top: 10),
                      // const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                      child: TextFormField(
                        controller: conf_pass,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "entree le nouveaux Mot de pass";
                          }
                          return null;
                        },
                        decoration: const InputDecoration(
                          border: UnderlineInputBorder(),
                          labelText: "Confirmer Mot de passe",
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
                                updatePassword(
                                    context, newpass.text, conf_pass.text);
                              },
                              child: Text('Modifier'),
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
    );
  }
}
