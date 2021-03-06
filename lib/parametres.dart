import 'package:flutter/material.dart';
import 'package:portfeuille_numerique/nouveauCategorie.dart';

class parametrage extends StatefulWidget {
  const parametrage({Key? key}) : super(key: key);

  @override
  State<parametrage> createState() => _parametrageState();
}

class _parametrageState extends State<parametrage> {
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
                          ),
                          SizedBox(
                            height: 30,
                          ),
                          ListTile(
                            title: Text("Notifications"),
                            leading: Icon(Icons.notifications),
                            subtitle: Text(
                                "Configurez les notifications que vous souhaitez recevoir "),
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
