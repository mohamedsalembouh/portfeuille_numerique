import 'package:flutter/material.dart';
import 'package:portfeuille_numerique/budget.dart';
import 'package:portfeuille_numerique/dettes.dart';
import 'package:portfeuille_numerique/homePage.dart';
import 'package:portfeuille_numerique/models/utilisateur.dart';
import 'package:portfeuille_numerique/objectifs.dart';
import 'package:portfeuille_numerique/operation.dart';
import 'package:portfeuille_numerique/parametres.dart';
import 'package:portfeuille_numerique/partageGroupe.dart';
import 'package:portfeuille_numerique/signin.dart';
import 'package:portfeuille_numerique/statistiques.dart';
import 'package:toast/toast.dart';

PreferredSize appbarfunction(List<Tab> tabs, String title) {
  return PreferredSize(
    preferredSize: Size.fromHeight(100),
    child: AppBar(
      bottom: TabBar(tabs: tabs),
      title: Text(title),
      actions: [
        Padding(
          padding: EdgeInsets.only(right: 20),
          child: GestureDetector(
            onTap: () {},
            child: Icon(Icons.notifications),
          ),
        ),
        Padding(
          padding: EdgeInsets.only(right: 20),
          child: GestureDetector(
            onTap: () {},
            child: Icon(Icons.settings),
          ),
        )
      ],
    ),
  );
}

PreferredSize appbar2function(List<Tab> tabs, String title) {
  return PreferredSize(
    preferredSize: Size.fromHeight(100),
    child: AppBar(
      toolbarHeight: 100,
      bottom: TabBar(tabs: tabs),
      title: Text(title),
      actions: [
        Padding(
          padding: EdgeInsets.only(right: 20),
          child: GestureDetector(
            onTap: () {},
            child: Icon(Icons.search),
          ),
        )
      ],
    ),
  );
}

PreferredSize appbar3function(String title) {
  return PreferredSize(
    preferredSize: Size.fromHeight(100),
    child: AppBar(
      title: Text(title),
      actions: [
        Padding(
          padding: EdgeInsets.only(right: 20),
          child: GestureDetector(
            onTap: () {},
            child: Icon(Icons.search),
          ),
        )
      ],
    ),
  );
}

Widget drowerfunction(BuildContext context, utilisateur? user) {
  return Drawer(
    child: ListView(
      padding: EdgeInsets.only(top: 50),
      children: [
        Container(
          color: Colors.green[500],
          width: double.infinity,
          //height: 250,
          padding: EdgeInsets.only(top: 20),
          child: DrawerHeader(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              image: DecorationImage(
                  scale: 1.5,
                  image: AssetImage(
                    'assets/images/img_profile.jpg',
                  )),
            ),
            padding: EdgeInsets.only(
              top: 137,
              left: 100,
            ),
            child: Text(
              "${user!.nom}",
              style: TextStyle(fontSize: 20),
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.only(top: 20),
          child: ListTile(
            leading: Icon(Icons.dashboard_outlined),
            title: Text("Accueil", style: TextStyle(fontSize: 20)),
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          homepage(user.email, user.password)));
            },
          ),
        ),
        ListTile(
          leading: Icon(
            Icons.train,
            size: 20,
          ),
          title: Text("Dettes", style: TextStyle(fontSize: 20)),
          onTap: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => alldettes(user)));
          },
        ),
        ListTile(
          leading: Icon(
            Icons.train,
            size: 20,
          ),
          title: Text("Budgets", style: TextStyle(fontSize: 20)),
          onTap: () {
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => budget(user)));
          },
        ),
        ListTile(
          leading: Icon(
            Icons.train,
            size: 20,
          ),
          title: Text("Objectifs", style: TextStyle(fontSize: 20)),
          onTap: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => objectif(user)));
          },
        ),
        ListTile(
          leading: Icon(
            Icons.train,
            size: 20,
          ),
          title: Text("Statistiques", style: TextStyle(fontSize: 20)),
          onTap: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => statistique(user)));
          },
        ),
        ListTile(
          leading: Icon(
            Icons.train,
            size: 20,
          ),
          title: Text("Partage en groupe", style: TextStyle(fontSize: 20)),
          onTap: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => partage(user)));
          },
        ),
        ListTile(
          leading: Icon(
            Icons.settings,
            size: 20,
          ),
          title: Text("Parametres", style: TextStyle(fontSize: 20)),
          onTap: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => parametrage()));
          },
        ),
        Padding(
          padding: EdgeInsets.only(top: 20, left: 120),
          child: ListTile(
            // leading: Icon(
            //   Icons.settings,
            //   size: 20,
            // ),
            title: Text("Deconnection",
                style: TextStyle(
                    fontSize: 20,
                    backgroundColor: Colors.black,
                    color: Colors.white)),
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => signinPage()));
            },
          ),
        ),
      ],
    ),
  );
}

void onclick(BuildContext context) {
  AlertDialog alertDialog = AlertDialog(
    title: Text("Ajouter un niveaux solde"),
    content: SizedBox(
      width: 200,
      child: TextField(
        keyboardType: TextInputType.number,
        decoration:
            InputDecoration(hintText: '0', border: OutlineInputBorder()),
        style: TextStyle(fontSize: 20),
      ),
    ),
    actions: [
      TextButton(
        child: Text(
          "Annuler",
          style: TextStyle(color: Colors.red),
        ),
        onPressed: () {},
      ),
      TextButton(
        child: Text("Enregistrer"),
        onPressed: () {},
      ),
    ],
  );
  showDialog(
      context: context,
      builder: (BuildContext context) {
        return alertDialog;
      });
}

validateEmail(String email) {
  final mailReg = new RegExp(
      r"^[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'*+/=?^_`{|}~-]+)*@(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])");
  return mailReg.hasMatch(email);
}
















//snackbar 
//ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));