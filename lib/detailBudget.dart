import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:portfeuille_numerique/db/sql_helper.dart';
import 'package:sqflite/sqflite.dart';
import 'package:get/get.dart';
import 'models/catBudget.dart';

class detailBudget extends StatefulWidget {
  //const detailBudget({ Key? key }) : super(key: key);
  int? id_utilisateur;
  detailBudget(this.id_utilisateur);
  @override
  State<detailBudget> createState() => _detailBudgetState(this.id_utilisateur);
}

class _detailBudgetState extends State<detailBudget> {
  int? id_utilisateur;
  _detailBudgetState(this.id_utilisateur);
  final List<Tab> mytabs = [
    Tab(
      text: "En cours",
    ),
    Tab(
      text: "Complet",
    ),
  ];
  SQL_Helper helper = SQL_Helper();
  List<catBudget>? allbudgeets;
  int count = 0;
  static var budgeets;

  getAllBudgets() async {
    final Future<Database>? db = helper.initialiseDataBase();
    var ourDb = db;
    if (ourDb != null) {
      ourDb.then((database) {
        Future<List<catBudget>> empDettes =
            helper.getAllBudgets(this.id_utilisateur!);
        empDettes.then((theList) {
          setState(() {
            this.allbudgeets = theList;
            this.count = theList.length;
          });
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (this.allbudgeets == null) {
      getAllBudgets();
    }
    budgeets = this.allbudgeets;
    return MaterialApp(
      home: DefaultTabController(
        length: mytabs.length,
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          appBar: AppBar(
            leading: IconButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              icon: BackButtonIcon(),
            ),
            title: Text("Les Budgets"),
            bottom: TabBar(
              tabs: mytabs,
            ),
          ),
          body: TabBarView(
            children: [
              Column(
                children: [
                  Expanded(
                    child: ListView.builder(
                        itemCount: count,
                        itemBuilder: (context, pos) {
                          DateTime debut =
                              DateTime.parse(budgeets[pos].date_debut!);
                          String dateDebut =
                              DateFormat("dd-MM-yyyy").format(debut);
                          DateTime fin =
                              DateTime.parse(budgeets[pos].date_fin!);
                          String dateFin = DateFormat("dd-MM-yyyy").format(fin);

                          if (budgeets[pos].status == 0) {
                            return Card(
                              elevation: 8,
                              shape: RoundedRectangleBorder(
                                side: BorderSide(
                                  color: Colors.white.withOpacity(1),
                                ),
                                borderRadius: BorderRadius.circular(20.0),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.only(top: 10),
                                child: ListTile(
                                  title: Column(
                                    children: [
                                      Text("${budgeets[pos].nombdg}"),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Text("22".tr +
                                          " : " +
                                          "${budgeets[pos].montant}"),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Text("64".tr +
                                          " : " +
                                          "${budgeets[pos].nomcat}"),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Text("47".tr + " : " + "$dateDebut"),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Text("57".tr + " : " + "$dateFin")
                                    ],
                                  ),
                                ),
                              ),
                            );
                          } else {
                            return Container();
                          }
                        }),
                  ),
                ],
              ),
              //l'autre page
              Column(
                children: [
                  Expanded(
                    child: ListView.builder(
                        itemCount: count,
                        itemBuilder: (context, pos) {
                          DateTime debut =
                              DateTime.parse(budgeets[pos].date_debut!);
                          String dateDebut =
                              DateFormat("dd-MM-yyyy").format(debut);
                          DateTime fin =
                              DateTime.parse(budgeets[pos].date_fin!);
                          String dateFin = DateFormat("dd-MM-yyyy").format(fin);

                          if (budgeets[pos].status == 1) {
                            return Card(
                              elevation: 8,
                              shape: RoundedRectangleBorder(
                                side: BorderSide(
                                  color: Colors.white.withOpacity(1),
                                ),
                                borderRadius: BorderRadius.circular(20.0),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.only(top: 10),
                                child: ListTile(
                                  isThreeLine: true,
                                  //leading: Icon(Icons.check),
                                  title: Column(
                                    children: [
                                      Text("${budgeets[pos].nombdg}"),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Text("22".tr +
                                          " : " +
                                          "${budgeets[pos].montant}"),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Text("64".tr +
                                          " : " +
                                          "${budgeets[pos].nomcat}"),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Text("47".tr + " : " + "$dateDebut"),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Text("57".tr + " : " + "$dateFin")
                                    ],
                                  ),
                                ),
                              ),
                            );
                          } else {
                            return Container();
                          }
                        }),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
