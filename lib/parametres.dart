import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:portfeuille_numerique/methodes.dart';
import 'package:portfeuille_numerique/models/utilisateur.dart';
import 'package:portfeuille_numerique/nouveauCategorie.dart';
import 'package:portfeuille_numerique/nouveauxRessource.dart';
import 'package:portfeuille_numerique/parametre_notification.dart';
import 'package:portfeuille_numerique/parametre_profile.dart';
import 'package:portfeuille_numerique/updateLangue.dart';

class parametrage extends StatelessWidget {
  utilisateur? usr;
  parametrage(this.usr);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("f".tr),
        ),
        drawer: drowerfunction(context, this.usr),
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
                            title: Text("91".tr),
                            leading: Icon(Icons.account_box),
                            subtitle: Text("92".tr),
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          parametre_profile(this.usr)));
                            },
                          ),
                          SizedBox(
                            height: 30,
                          ),
                          ListTile(
                            title: Text("93".tr),
                            leading: Icon(Icons.notifications),
                            subtitle: Text("94".tr),
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          parametre_notification(this.usr)));
                            },
                          ),
                          SizedBox(
                            height: 30,
                          ),
                          ListTile(
                            title: Text("95".tr),
                            leading: Icon(Icons.account_box),
                            subtitle: Text("96".tr),
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          nouveauCategorie(this.usr)));
                            },
                          ),
                          ListTile(
                            title: Text("97".tr),
                            leading: Icon(Icons.account_box),
                            subtitle: Text("98".tr),
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          nouveauxRessource(this.usr)));
                            },
                          ),
                          ListTile(
                            title: Text("99".tr),
                            leading: Icon(Icons.account_box),
                            subtitle: Text("100".tr),
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => updateLangue()));
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
