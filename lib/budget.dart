import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:portfeuille_numerique/formBudget.dart';
import 'package:portfeuille_numerique/methodes.dart';
import 'package:portfeuille_numerique/models/budgete.dart';
import 'package:portfeuille_numerique/models/catBudget.dart';
import 'package:portfeuille_numerique/models/utilisateur.dart';
import 'package:sqflite/sqflite.dart';

import 'models/categorie.dart';

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
  List<catBudget>? allbudgets;
  int count = 0;
  static var budgets;
  _budgetState(this.usr);

  getAllBudgets() async {
    utilisateur? user =
        await helper.getUser(this.usr!.email!, this.usr!.password!);
    int id = user!.id!;
    final Future<Database>? db = helper.initialiseDataBase();
    var ourDb = db;
    if (ourDb != null) {
      ourDb.then((database) {
        Future<List<catBudget>> empDettes = helper.getAllBudgets(id);
        empDettes.then((theList) {
          setState(() {
            this.allbudgets = theList;
            this.count = theList.length;
          });
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (this.allbudgets == null) {
      getAllBudgets();
    }
    budgets = this.allbudgets;
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
                  Expanded(
                    child: ListView.builder(
                        itemCount: count,
                        itemBuilder: (context, pos) {
                          DateTime debut =
                              DateTime.parse(budgets[pos].date_debut!);
                          String dateDebut =
                              DateFormat("dd-MM-yyyy").format(debut);
                          DateTime fin = DateTime.parse(budgets[pos].date_fin!);
                          String dateFin = DateFormat("dd-MM-yyyy").format(fin);
                          return Card(
                            color: Colors.white,
                            //elevation: 2.0,
                            child: ListTile(
                                isThreeLine: true,
                                // leading: Icon(Icons.category),
                                title: Text("${budgets[pos].nombdg}"),
                                subtitle: Column(
                                  children: [
                                    Text("montant : ${budgets[pos].montant}"),
                                    Text("categorie : ${budgets[pos].nomcat}"),
                                  ],
                                ),
                                trailing: Column(
                                  children: [
                                    Text(" Date debut : $dateDebut"),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Text("Date Fin : $dateFin")
                                  ],
                                )),
                          );
                        }),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 350),
                    child: FloatingActionButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => formbudget(this.usr)));
                      },
                      child: Icon(Icons.add),
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
