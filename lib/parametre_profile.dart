import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:portfeuille_numerique/form_updateNom.dart';
import 'package:portfeuille_numerique/form_updatePass.dart';
import 'package:portfeuille_numerique/models/utilisateur.dart';

class parametre_profile extends StatelessWidget {
  utilisateur? usr;
  parametre_profile(this.usr);

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
                          Card(
                            elevation: 5,
                            shape: RoundedRectangleBorder(
                              side: BorderSide(
                                color: Colors.white.withOpacity(1),
                              ),
                              borderRadius: BorderRadius.circular(20.0),
                            ),
                            child: ListTile(
                              title: Text("101".tr),
                              //leading: Icon(Icons.),
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            form_updateNom(usr)));
                              },
                            ),
                          ),
                          Card(
                            elevation: 5,
                            shape: RoundedRectangleBorder(
                              side: BorderSide(
                                color: Colors.white.withOpacity(1),
                              ),
                              borderRadius: BorderRadius.circular(20.0),
                            ),
                            child: ListTile(
                              title: Text("102".tr),
                              //leading: Icon(Icons.password),
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            form_updatePass(usr)));
                              },
                            ),
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
