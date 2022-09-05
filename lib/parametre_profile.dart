import 'package:flutter/material.dart';
import 'package:portfeuille_numerique/form_updateNom.dart';
import 'package:portfeuille_numerique/form_updatePass.dart';
import 'package:portfeuille_numerique/models/utilisateur.dart';

class parametre_profile extends StatelessWidget {
  // const parametre_profile({Key? key}) : super(key: key);
  utilisateur? usr;
  parametre_profile(this.usr);
  // TextEditingController newnom = TextEditingController();
  // TextEditingController newpass = TextEditingController();
  // TextEditingController conf_pass = TextEditingController();
  // final _formKey = new GlobalKey<FormState>();
  // final _formKey2 = new GlobalKey<FormState>();
  // SQL_Helper helper = SQL_Helper();

  // updateNom(BuildContext context, String nom) async {
  //   final form = _formKey.currentState!;
  //   if (form.validate()) {
  //     int x = await helper.update_nom(nom, this.usr!.id!);
  //     if (x != 0) {
  //       print("updated");
  //       showText(context, "", "votre nom est change");
  //     } else {
  //       print("not updated");
  //     }
  //   }
  // }

  // updatePassword(BuildContext context, String pass1, String pass2) async {
  //   final form2 = _formKey2.currentState!;
  //   if (form2.validate()) {
  //     if (pass1 == pass2) {
  //       int y = await helper.update_password(pass1, this.usr!.id!);
  //       if (y != 0) {
  //         print("updated");
  //         showText(context, "", "votre mot de pass est change");
  //       }
  //     } else {
  //       showText(context, "SVP",
  //           "Les deux mots de passes ne sont pas correspondant");
  //     }
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(),
        resizeToAvoidBottomInset: false,
        body: Column(
          children: [
            Expanded(
              child: Column(
                children: [
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(top: 40),
                      child: ListView(
                        children: [
                          ListTile(
                            title: Text("Changer votre nom"),
                            leading: Icon(Icons.account_balance),
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          form_updateNom(usr)));
                            },
                          ),
                          ListTile(
                            title: Text("Changer votre Mot de passe"),
                            leading: Icon(Icons.password),
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          form_updatePass(usr)));
                            },
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            )
          ],
        ));
  }
}
