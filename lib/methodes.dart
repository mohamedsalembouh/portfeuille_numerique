import 'package:flutter/material.dart';
import 'package:portfeuille_numerique/budget.dart';
import 'package:portfeuille_numerique/db/sql_helper.dart';
import 'package:portfeuille_numerique/dettes.dart';
import 'package:portfeuille_numerique/homePage.dart';
import 'package:portfeuille_numerique/models/argent.dart';
import 'package:portfeuille_numerique/models/compteRessource.dart';
import 'package:portfeuille_numerique/models/utilisateur.dart';
import 'package:portfeuille_numerique/notification.dart';
import 'package:portfeuille_numerique/objectifs.dart';
import 'package:portfeuille_numerique/operation.dart';
import 'package:portfeuille_numerique/parametres.dart';
import 'package:portfeuille_numerique/partageGroupe.dart';
import 'package:portfeuille_numerique/signin.dart';
import 'package:portfeuille_numerique/statistiques.dart';
import 'package:sqflite/sqflite.dart';
import 'package:toast/toast.dart';

import 'models/compte.dart';
import 'models/ressource.dart';

PreferredSize appbarfunction(
    BuildContext context, List<Tab> tabs, String title, utilisateur usr) {
  return PreferredSize(
    preferredSize: Size.fromHeight(100),
    child: AppBar(
      bottom: TabBar(tabs: tabs),
      title: Text(title),
      actions: [
        Padding(
          padding: EdgeInsets.only(right: 20),
          child: GestureDetector(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => notification(usr, 0)));
            },
            child: Icon(Icons.notifications),
          ),
        ),
        Padding(
          padding: EdgeInsets.only(right: 20),
          child: GestureDetector(
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => parametrage(usr)));
            },
            child: Icon(Icons.settings),
          ),
        ),
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

Widget drowerfunction(
  BuildContext context,
  utilisateur? user,
) {
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
            leading: Icon(Icons.home),
            title: Text("Accueil", style: TextStyle(fontSize: 20)),
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
          title: Text("Dettes", style: TextStyle(fontSize: 20)),
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
          title: Text("Budgets", style: TextStyle(fontSize: 20)),
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
          title: Text("Objectifs", style: TextStyle(fontSize: 20)),
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
          title: Text("Statistiques", style: TextStyle(fontSize: 20)),
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
                MaterialPageRoute(builder: (context) => parametrage(user)));
          },
        ),
        ListTile(
          leading: Icon(
            Icons.help,
            size: 20,
          ),
          title: Text("Aide", style: TextStyle(fontSize: 20)),
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

SQL_Helper helper = SQL_Helper();
// Future<int?> getsoldeUser(int id_utilisateur) async {
//   int? solde;
//   compte? comp = await helper.getCompteUser(id_utilisateur);
//   if (comp == null) {
//     solde = 0;
//   } else {
//     solde = comp.solde;
//   }
//   return solde;
// }

void showText(BuildContext context, String title, String msg) {
  AlertDialog alterdialogue = AlertDialog(
    title: Text(title),
    content: Text(msg),
  );
  showDialog(context: context, builder: (_) => alterdialogue);
}

Widget myBottomNavBar() {
  return BottomNavigationBar(
    items: [
      BottomNavigationBarItem(
        icon: Icon(Icons.home),
        title: Text("Acceuil"),
      ),
      BottomNavigationBarItem(icon: Icon(Icons.help), title: Text("Aide")),
    ],
    //backgroundColor: Colors.purpleAccent,
  );
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


// getListSoldes(List<diagrameSolde> y, String typeSolde, int idUser) async {
//   compte? comp = await helper.getCompteUser(idUser, typeSolde);
//   y.add(diagrameSolde(DateTime.parse(comp!.date!), comp.solde, comp.type));
//   return y;
// }


  // void updateSolde( String email,String pass,int? a,int? k) async {
  //  // updateCategories();
  //  // allcat = await getNomCategorie();
  //   utilisateur? user = await helper.getUser(email, pass);
  //   a = user!.id;
  //   //h = user.nom;
  //   final Future<Database>? db = helper.initialiseDataBase();
  //   var our_db = db;
  //   if (our_db != null) {
  //     our_db.then((database) {
  //       Future<int?> solde = getsoldeUser(a!);
  //       solde.then((reloadsolde) {
  //         setState(() {
  //           k = reloadsolde;
  //         });
  //       });
  //     });
  //   }
  // }














//snackbar 
//ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));