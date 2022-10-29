import 'package:flutter/material.dart';
import 'package:portfeuille_numerique/db/sql_helper.dart';
import 'package:portfeuille_numerique/methodes.dart';
import 'package:portfeuille_numerique/models/categorie.dart';
import 'package:portfeuille_numerique/models/utilisateur.dart';
import 'package:toast/toast.dart';

class nouveauCategorie extends StatefulWidget {
  //const nouveauCategorie({Key? key}) : super(key: key);
  utilisateur? usr;
  nouveauCategorie(this.usr);
  @override
  State<nouveauCategorie> createState() => _nouveauCategorieState(this.usr);
}

class _nouveauCategorieState extends State<nouveauCategorie> {
  utilisateur? usr;
  _nouveauCategorieState(this.usr);
  TextEditingController catnom = TextEditingController();
  TextEditingController cattype = TextEditingController();
  final _formKey = new GlobalKey<FormState>();

  insertCategorie(String name, String coleur) async {
    String nom = name.toUpperCase();
    categorie cat = new categorie(nom, coleur, this.usr!.id!);
    SQL_Helper helper = new SQL_Helper();
    final form = _formKey.currentState!;
    if (form.validate()) {
      categorie? cate = await helper.getCategorieeByNom(nom, this.usr!.id!);
      if (cate == null) {
        int result = await helper.insert_categorie(cat);
        if (result == 0) {
          print("not inserted");
        } else {
          print("inserted");
          showText(context, "", "La categorie est ajouté");
          catnom.clear();
          colorValue = "Coleur";
        }
      } else {
        showText(context, "SVP", "cette nom existe deja ");
      }
    }
  }

  String? colorValue;
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
                        "Nouveaux Categorie",
                        style: TextStyle(fontSize: 20),
                      ),
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 10, left: 10),
                      child: TextFormField(
                        controller: catnom,
                        decoration: InputDecoration(
                            labelText: "Nom categorie",
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
                      padding: const EdgeInsets.only(left: 10, right: 10),
                      child: DropdownButtonFormField(
                        decoration: InputDecoration(
                            // labelText: "Destination",
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
                        isExpanded: true,
                        elevation: 16,
                        borderRadius: BorderRadius.all(Radius.circular(5.0)),
                        value: colorValue,
                        hint: Text("choissir un couleur"),
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
                        validator: (value) {
                          if (value == null) {
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
                              child: Text('Annuler'),
                              style: ElevatedButton.styleFrom(
                                  shape: StadiumBorder()),
                            ),
                          ),
                          SizedBox(
                            width: MediaQuery.of(context).size.width / 3,
                            height: MediaQuery.of(context).size.height / 13,
                            child: ElevatedButton(
                              onPressed: () {
                                insertCategorie(catnom.text, colorValue!);
                              },
                              child: Text('enregistrer'),
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
