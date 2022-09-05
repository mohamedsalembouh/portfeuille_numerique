import 'package:flutter/material.dart';
import 'package:portfeuille_numerique/models/utilisateur.dart';
import 'package:portfeuille_numerique/nouveauCategorie.dart';
import 'package:portfeuille_numerique/nouveauxRessource.dart';
import 'package:portfeuille_numerique/parametre_notification.dart';
import 'package:portfeuille_numerique/parametre_profile.dart';

class parametrage extends StatelessWidget {
  utilisateur? usr;
  parametrage(this.usr);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Parametres"),
        ),
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
                            title: Text("Profil de l'utilisateur"),
                            leading: Icon(Icons.account_box),
                            subtitle: Text(
                                "Modifier l'image de profil , le nom ou le mot de passe , se deconnecter ou supprimer des donnees"),
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          parametre_profile(usr)));
                            },
                          ),
                          SizedBox(
                            height: 30,
                          ),
                          ListTile(
                            title: Text("Notifications"),
                            leading: Icon(Icons.notifications),
                            subtitle: Text(
                                "Configurez les notifications que vous souhaitez recevoir "),
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          parametre_notification(usr)));
                            },
                          ),
                          SizedBox(
                            height: 30,
                          ),
                          ListTile(
                            title: Text("Categories"),
                            leading: Icon(Icons.account_box),
                            subtitle: Text("Ajoutez des  categories"),
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          nouveauCategorie()));
                            },
                          ),
                          ListTile(
                            title: Text("Ressources"),
                            leading: Icon(Icons.account_box),
                            subtitle: Text("Ajoutez des Nouveaux Ressources"),
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          nouveauxRessource(usr)));
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
