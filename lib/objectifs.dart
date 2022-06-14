import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:portfeuille_numerique/methodes.dart';
import 'package:portfeuille_numerique/newObjectif.dart';

import 'models/utilisateur.dart';

class objectif extends StatefulWidget {
  // const objectif({Key? key}) : super(key: key);
  utilisateur? usr;
  objectif(this.usr);
  @override
  State<objectif> createState() => _objectifState(this.usr);
}

class _objectifState extends State<objectif> {
  final List<Tab> mytabs = [
    Tab(
      text: "En cours",
    ),
    Tab(
      text: "Complet",
    )
  ];
  utilisateur? usr;
  _objectifState(this.usr);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: DefaultTabController(
        length: mytabs.length,
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          appBar: appbar2function(mytabs, "Objectifs"),
          drawer: drowerfunction(context, this.usr),
          body: TabBarView(
            children: [
              Column(
                children: [
                  Container(
                    child: Expanded(
                      child: ListView(
                        children: [
                          Container(
                            width: 100,
                            height: 100,
                            color: Colors.lightBlue.shade100,
                            margin: EdgeInsets.only(top: 20),
                            child: ListTile(
                              contentPadding: EdgeInsets.all(10),
                              leading: Icon(Icons.home),
                              title: Text("nom objectif"),
                              subtitle: Text("Montant enregistre"),
                              trailing: Text("montant totale"),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(left: 350),
                      child: FloatingActionButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => new_objectif()));
                        },
                        child: Icon(Icons.add),
                      ),
                    ),
                  ),
                ],
              ),
              //l'autre page
              Container(),
            ],
          ),
        ),
      ),
    );
  }
}
