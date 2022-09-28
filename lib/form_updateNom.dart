import 'package:flutter/material.dart';
import 'package:portfeuille_numerique/models/utilisateur.dart';

import 'db/sql_helper.dart';
import 'methodes.dart';

class form_updateNom extends StatelessWidget {
  //const form_updateNom({Key? key}) : super(key: key);
  utilisateur? usr;
  form_updateNom(this.usr);
  TextEditingController newnom = TextEditingController();
  final _formKey = new GlobalKey<FormState>();
  SQL_Helper helper = SQL_Helper();

  updateNom(BuildContext context, String nom) async {
    final form = _formKey.currentState!;
    if (form.validate()) {
      int x = await helper.update_nom(nom, this.usr!.id!);
      if (x != 0) {
        print("updated");
        Navigator.of(context).pop();
        showText(context, "", "votre nom est change");
      } else {
        print("not updated");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 40),
            child: Card(
              child: Container(
                width: MediaQuery.of(context).size.width - 50,
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.only(bottom: 20),
                        child: Text(
                          "Changer votre nom",
                          style: TextStyle(fontSize: 20),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(bottom: 10, left: 20, top: 10),
                        // const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                        child: TextFormField(
                          controller: newnom,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "entree le nouveaux nom";
                            }
                            return null;
                          },
                          decoration: const InputDecoration(
                            border: UnderlineInputBorder(),
                            labelText: "Nouveau nom",
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
                                  updateNom(context, newnom.text);
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
          ),
        ],
      ),
    );
  }
}
