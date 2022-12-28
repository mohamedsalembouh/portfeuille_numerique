import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:portfeuille_numerique/db/sql_helper.dart';
import 'package:portfeuille_numerique/methodes.dart';
import 'package:portfeuille_numerique/models/ressource.dart';
import 'models/utilisateur.dart';

class nouveauxRessource extends StatefulWidget {
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
      ressource? rese = await helper.getRessourceByNom(nom, idUser);
      if (rese == null) {
        ressource res = ressource(nom, idUser);
        int result = await helper.insertRessource(res);
        if (result == 0) {
          print("not inserted");
        } else {
          print("inserted");
          showText(context, "", "m15".tr);
        }
      } else {
        showText(context, "m12".tr, "m16".tr);
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
                        "111".tr,
                        style: TextStyle(fontSize: 20),
                      ),
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 10, left: 10),
                      child: TextFormField(
                        controller: resnom,
                        decoration: InputDecoration(
                            labelText: "112".tr,
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
                                insrtRessource(resnom.text, this.usr!.id!);
                                resnom.clear();
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
