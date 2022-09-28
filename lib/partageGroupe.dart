import 'package:flutter/material.dart';
import 'package:portfeuille_numerique/budget.dart';
import 'package:portfeuille_numerique/detailCompte.dart';
import 'package:portfeuille_numerique/form_partage.dart';
import 'package:portfeuille_numerique/methodes.dart';
import 'package:portfeuille_numerique/models/utilisateur.dart';
import 'package:portfeuille_numerique/services/local_notification_service.dart';
import 'package:portfeuille_numerique/statistiques.dart';
import 'package:sqflite/sqflite.dart';

import 'models/partag.dart';
import 'package:get/get.dart';

class partage extends StatefulWidget {
  // const partage({Key? key}) : super(key: key);
  utilisateur? usr;
  partage(this.usr);
  @override
  State<partage> createState() => _partageState(this.usr);
}

class _partageState extends State<partage> {
  utilisateur? usr;
  //List<diagrameSolde>? allUpdateSolde;
  _partageState(this.usr);
  List<partag>? allJepartageavec;
  List<partag>? allOntPartagemoi;
  int count1 = 0;
  int count2 = 0;
  static var partages1;
  static var partages2;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  getAllPersonnesPartages() {
    final Future<Database>? db = helper.initialiseDataBase();
    var ourDb = db;
    if (ourDb != null) {
      ourDb.then((database) {
        Future<List<partag>> partages = helper.getAllPartag(this.usr!.id!);
        partages.then((theList) {
          setState(() {
            this.allJepartageavec = theList;
            this.count1 = theList.length;
          });
        });
      });
    }
  }

  getAllPersonnesPartagesavecmoi() {
    final Future<Database>? db = helper.initialiseDataBase();
    var ourDb = db;
    if (ourDb != null) {
      ourDb.then((database) {
        Future<List<partag>> partages = helper.getAllPartag2(this.usr!.email!);
        partages.then((theList) {
          setState(() {
            this.allOntPartagemoi = theList;
            this.count2 = theList.length;
          });
        });
      });
    }
  }

  // getUser(int id) async {
  //   utilisateur? usere = await helper.getUserByID(id);
  //   String mail = usere!.email!;
  // }

  @override
  Widget build(BuildContext context) {
    if (this.allJepartageavec == null) {
      getAllPersonnesPartages();
    }
    if (this.allOntPartagemoi == null) {
      getAllPersonnesPartagesavecmoi();
    }
    partages1 = this.allJepartageavec;
    partages2 = this.allOntPartagemoi;
    return Scaffold(
        appBar: AppBar(
          title: Text("e".tr),
        ),
        drawer: drowerfunction(context, usr),
        body: Column(children: [
          Padding(
            padding: const EdgeInsets.only(top: 10),
            child: ListTile(
              title: Text("65".tr),
            ),
          ),
          Expanded(
              child: ListView.builder(
                  itemCount: count1,
                  itemBuilder: (context, pos) {
                    return Card(
                      child: ListTile(
                        title: Text("${partages1[pos].email_personne}"),
                      ),
                    );
                  })),
          Padding(
            padding: const EdgeInsets.only(top: 10),
            child: ListTile(
              title: Text("66".tr),
            ),
          ),
          Expanded(
              child: ListView.builder(
                  itemCount: count2,
                  itemBuilder: (context, pos) {
                    return Card(
                      child: ListTile(
                        title: Text("${partages2[pos].email_utilisateur}"),
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => detailCompte(
                                      partages2[pos].id_utilisateur)));
                        },
                      ),
                    );
                  })),
        ]),
        floatingActionButton: FloatingActionButton(
          child: Icon(
            Icons.add,
            size: 20,
          ),
          onPressed: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => formPartage(this.usr)));
          },
        ));
  }

  // void listenToNotification() =>
  //     service.onNotificationClick.stream.listen((onNotificationListener));
  // void onNotificationListener(String? payload) {
  //   if (payload != null && payload.isNotEmpty) {
  //     print("payload $payload");
  //     Navigator.push(
  //         context,
  //         MaterialPageRoute(
  //             builder: (context) => budget(usr, 2, this.allUpdateSolde)));
  //   }
  // }
}
