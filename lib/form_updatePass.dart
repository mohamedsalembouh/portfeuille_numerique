import 'package:flutter/material.dart';
import 'package:get/get.dart';
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
          showText(context, "", "m17".tr);
        }
      } else {
        showText(context, "m12".tr, "m4".tr);
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
                key: _formKey2,
                child: Column(
                  children: [
                    SizedBox(
                      height: 30,
                    ),
                    Center(
                      child: Text(
                        "130".tr,
                        style: TextStyle(fontSize: 20),
                      ),
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 10, left: 10),
                      child: TextFormField(
                        controller: newpass,
                        obscureText: true,
                        decoration: InputDecoration(
                            labelText: "131".tr,
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
                      padding: const EdgeInsets.only(right: 10, left: 10),
                      child: TextFormField(
                        controller: conf_pass,
                        obscureText: true,
                        decoration: InputDecoration(
                            labelText: "132".tr,
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
                                updatePassword(
                                    context, newpass.text, conf_pass.text);
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
