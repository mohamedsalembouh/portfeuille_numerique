import 'package:flutter/material.dart';
import 'package:portfeuille_numerique/budget.dart';
import 'package:portfeuille_numerique/db/sql_helper.dart';
import 'package:portfeuille_numerique/dettes.dart';
import 'package:portfeuille_numerique/homePage.dart';
import 'package:portfeuille_numerique/models/argent.dart';
import 'package:portfeuille_numerique/models/compteRessource.dart';
import 'package:portfeuille_numerique/models/utilisateur.dart';
import 'package:portfeuille_numerique/objectifs.dart';
import 'package:portfeuille_numerique/parametres.dart';
import 'package:portfeuille_numerique/partageGroupe.dart';
import 'package:portfeuille_numerique/statistiques.dart';
import 'models/ressource.dart';
import 'package:get/get.dart';

Widget drowerfunction(
  BuildContext context,
  utilisateur? user,
) {
  return Drawer(
    child: ListView(
      padding: EdgeInsets.only(top: 50),
      children: [
        Container(
          color: Colors.blue[500],
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
            leading: Icon(Icons.home),
            title: Text("10".tr, style: TextStyle(fontSize: 20)),
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => homepage(user)));
            },
          ),
        ),
        ListTile(
          leading: Icon(
            Icons.calendar_today_outlined,
            size: 20,
          ),
          title: Text("a".tr, style: TextStyle(fontSize: 20)),
          onTap: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => alldettes(user, 0)));
          },
        ),
        ListTile(
          leading: Icon(
            Icons.category,
            size: 20,
          ),
          title: Text("b".tr, style: TextStyle(fontSize: 20)),
          onTap: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => budget(user, 0)));
          },
        ),
        ListTile(
          leading: Icon(
            Icons.emoji_objects,
            size: 20,
          ),
          title: Text("c".tr, style: TextStyle(fontSize: 20)),
          onTap: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => objectif(user, 0)));
          },
        ),
        ListTile(
          leading: Icon(
            Icons.bar_chart_sharp,
            size: 20,
          ),
          title: Text("d".tr, style: TextStyle(fontSize: 20)),
          onTap: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => statistique(user)));
          },
        ),
        ListTile(
          leading: Icon(
            Icons.group,
            size: 20,
          ),
          title: Text("e".tr, style: TextStyle(fontSize: 20)),
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
          title: Text("f".tr, style: TextStyle(fontSize: 20)),
          onTap: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => parametrage(user)));
          },
        ),
        ListTile(
          leading: Icon(
            Icons.help,
            size: 20,
          ),
          title: Text("g".tr, style: TextStyle(fontSize: 20)),
          onTap: () {},
        ),
        Padding(
          padding: EdgeInsets.only(
            top: 20,
          ),
          child: ListTile(
            leading: Icon(
              Icons.logout,
              size: 20,
            ),
            title: ElevatedButton(
              child: Text(
                "h".tr,
                style: TextStyle(color: Colors.black),
              ),
              onPressed: () {
                // Navigator.push(context,
                //     MaterialPageRoute(builder: (context) => signinPage()));
                Navigator.pushReplacementNamed(context, "/logout");
              },
              style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
            ),
            // onTap: () {
            //   // Navigator.push(context,
            //   //     MaterialPageRoute(builder: (context) => signinPage()));
            //   Navigator.pushReplacementNamed(context, "/logout");
            // },
          ),
        ),
      ],
    ),
  );
}

validateEmail(String email) {
  final mailReg = new RegExp(
      r"^[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'*+/=?^_`{|}~-]+)*@(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])");
  return mailReg.hasMatch(email);
}

SQL_Helper helper = SQL_Helper();

void showText(BuildContext context, String title, String msg) {
  AlertDialog alterdialogue = AlertDialog(
    title: Text(title),
    content: Text(msg),
  );
  showDialog(context: context, builder: (_) => alterdialogue);
}

getRessources(int idUser) {
  Future<List<ressource>> allRessources = helper.getAllRessource(idUser);
  return allRessources;
}

getComptesRessource(int idUser) {
  Future<List<compteRessource>> allCmpRes =
      helper.getAllCompteRessource(idUser);
  return allCmpRes;
}

insertArgent(
    int montant, String date, int idRessource, int idUtilisateur) async {
  argent arg = argent(montant, date, idRessource, idUtilisateur);
  int result = await helper.insert_argent(arg);
  if (result > 0) {
    print("hhhh inserted");
  }
}















//snackbar 
//ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));