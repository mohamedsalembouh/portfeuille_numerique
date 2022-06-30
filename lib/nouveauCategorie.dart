import 'package:flutter/material.dart';
import 'package:portfeuille_numerique/db/sql_helper.dart';
import 'package:portfeuille_numerique/methodes.dart';
import 'package:portfeuille_numerique/models/categorie.dart';
import 'package:toast/toast.dart';

class nouveauCategorie extends StatefulWidget {
  const nouveauCategorie({Key? key}) : super(key: key);

  @override
  State<nouveauCategorie> createState() => _nouveauCategorieState();
}

class _nouveauCategorieState extends State<nouveauCategorie> {
  TextEditingController catnom = TextEditingController();
  TextEditingController cattype = TextEditingController();
  final _formKey = new GlobalKey<FormState>();

  insertCategorie(String nom, String coleur) async {
    categorie cat = new categorie(nom, coleur);
    SQL_Helper helper = new SQL_Helper();
    final form = _formKey.currentState!;
    if (form.validate()) {
      int result = await helper.insert_categorie(cat);
      if (result == 0) {
        print("not inserted");
      } else {
        print("inserted");
        showText(context, "", "La categorie est ajouté");
        catnom.clear();
        colorValue = "Coleur";
      }
    }
  }

  String colorValue = 'Coleur';
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
                            "Nouveaux Categorie",
                            style: TextStyle(fontSize: 20),
                          ),
                        ),
                        Padding(
                          padding:
                              EdgeInsets.only(bottom: 10, left: 20, top: 10),
                          // const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                          child: TextFormField(
                            controller: catnom,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "entree le nom de categorie";
                              }
                              return null;
                            },
                            decoration: const InputDecoration(
                              border: UnderlineInputBorder(),
                              labelText: "Nom Categorie",
                            ),
                          ),
                        ),
                        Container(
                          width: 300,
                          height: 50,
                          margin: EdgeInsets.only(top: 20),
                          child: DropdownButton<String>(
                            items: <String>['Vert', 'Rouge', 'Jaune', 'Rose']
                                .map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
                            }).toList(),
                            onChanged: (String? value) {
                              setState(() {
                                colorValue = value!;
                              });
                            },
                            isExpanded: true,
                            //value: currentNomCat,
                            hint: Text('$colorValue'),
                            //style: TextStyle(fontSize: 18),
                          ),
                          // TextField(
                          //   controller: cattype,
                          //   decoration: InputDecoration(
                          //       hintText: 'type categorie', border: OutlineInputBorder()),
                          //   style: TextStyle(fontSize: 20),
                          // ),
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
                                    if (colorValue != "Coleur") {
                                      insertCategorie(catnom.text, colorValue);
                                    } else {
                                      Toast.show("Choisir un coleur");
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
            ],
          )),
    );
  }
}
