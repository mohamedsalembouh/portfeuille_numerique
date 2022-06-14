import 'package:flutter/material.dart';
import 'package:portfeuille_numerique/formBudget.dart';
import 'package:portfeuille_numerique/methodes.dart';
import 'package:portfeuille_numerique/models/utilisateur.dart';

class budget extends StatefulWidget {
  utilisateur? usr;
  // budget({Key? key}) : super(key: key);
  budget(this.usr);
  @override
  State<budget> createState() => _budgetState(this.usr);
}

class _budgetState extends State<budget> {
  final List<Tab> mytabs = [
    Tab(
      text: "En cours",
    ),
    Tab(
      text: "deja realises",
    )
  ];
  utilisateur? usr;
  _budgetState(this.usr);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: DefaultTabController(
        length: mytabs.length,
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          appBar: appbar2function(mytabs, "Budgets"),
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
                            color: Colors.lightBlue.shade200,
                            margin: EdgeInsets.only(top: 20),
                            child: ListTile(
                              contentPadding: EdgeInsets.all(10),
                              leading: Icon(Icons.home),
                              title: Text("nom budget"),
                              subtitle: Text("categorie et periode"),
                              trailing: Text("montant"),
                            ),
                          )
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
                                  builder: (context) => formbudget()));
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
