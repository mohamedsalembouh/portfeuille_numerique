import 'package:flutter/material.dart';
import 'package:get/get.dart';
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
        showText(context, "", "m18".tr);
      } else {
        print("not updated");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Column(children: [
          Form(
            key: _formKey,
            child: Column(
              children: [
                SizedBox(
                  height: 30,
                ),
                Center(
                  child: Text(
                    "134".tr,
                    style: TextStyle(fontSize: 20),
                  ),
                ),
                SizedBox(
                  height: 30,
                ),
                Padding(
                  padding: EdgeInsets.only(right: 10, left: 10),
                  // const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                  child: TextFormField(
                    controller: newnom,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "va".tr;
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                        labelText: "133".tr,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(20.0)),
                          borderSide: BorderSide(color: Colors.white),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(20.0)),
                          borderSide: BorderSide(color: Colors.black),
                        )),
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
                          style:
                              ElevatedButton.styleFrom(shape: StadiumBorder()),
                        ),
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width / 3,
                        height: MediaQuery.of(context).size.height / 13,
                        child: ElevatedButton(
                          onPressed: () {
                            updateNom(context, newnom.text);
                          },
                          child: Text('27'.tr),
                          style:
                              ElevatedButton.styleFrom(shape: StadiumBorder()),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ]),
      ),
    );
  }
}
