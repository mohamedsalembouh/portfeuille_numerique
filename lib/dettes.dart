import 'package:flutter/material.dart';
import 'package:portfeuille_numerique/methodes.dart';
import 'package:portfeuille_numerique/models/utilisateur.dart';
import 'package:portfeuille_numerique/operationDettes.dart';
import 'package:portfeuille_numerique/parametres.dart';
import 'package:portfeuille_numerique/partageGroupe.dart';
import 'package:portfeuille_numerique/statistiques.dart';

import 'budget.dart';
import 'homePage.dart';
import 'objectifs.dart';

class alldettes extends StatefulWidget {
  utilisateur? usr;
  //alldettes({Key? key}) : super(key: key);
  alldettes(this.usr);
  @override
  State<alldettes> createState() => _alldettesState(this.usr);
}

class _alldettesState extends State<alldettes> {
  final List<Tab> mytabs = [
    Tab(
      text: "Actif",
    ),
    Tab(
      text: "Clos",
    )
  ];
  utilisateur? usr;
  _alldettesState(this.usr);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: DefaultTabController(
        length: mytabs.length,
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          appBar: appbar2function(mytabs, "Dettes"),
          drawer: drowerfunction(context, usr),
          body: TabBarView(
            children: [
              Column(
                children: [
                  Padding(
                      padding: EdgeInsets.only(top: 20),
                      child: Text(
                        "pettes dettes",
                        style: TextStyle(color: Colors.red),
                      )),
                  Container(
                    child: Expanded(
                      child: ListView(
                        children: [
                          ListTile(
                            title: Text("titre"),
                            subtitle: Text("Nom person et date"),
                            trailing: Text("Montant"),
                          )
                        ],
                      ),
                    ),
                  ),
                  Padding(
                      padding: EdgeInsets.only(top: 20),
                      child: Text(
                        "Emprunte dettes",
                        style: TextStyle(color: Colors.green),
                      )),
                  Container(
                    child: Expanded(
                      child: ListView(
                        children: [
                          ListTile(
                            title: Text("titre"),
                            subtitle: Text("Nom person et date"),
                            trailing: Text("Montant"),
                          )
                        ],
                      ),
                    ),
                  ),
                  Container(
                    //  width: MediaQuery.of(context).size.width,
                    //   height: MediaQuery.of(context).size.height,
                    child: Expanded(
                      child: Padding(
                        padding: EdgeInsets.only(left: 350, bottom: 20),
                        child: FloatingActionButton(
                          child: Icon(
                            Icons.add,
                            size: 20,
                          ),
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => operdatte()));
                          },
                        ),
                      ),
                    ),
                  )
                ],
              ),
              //objectif()
              Container(
                child: ListView(
                  children: [
                    ListTile(
                      title: Text("titre"),
                      subtitle: Text("Nom person"),
                      trailing: Text("20000"),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
