import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:portfeuille_numerique/budget.dart';
import 'package:portfeuille_numerique/categories.dart';
import 'package:portfeuille_numerique/dettes.dart';
import 'package:portfeuille_numerique/methodes.dart';
import 'package:portfeuille_numerique/models/compte.dart';
import 'package:portfeuille_numerique/models/utilisateur.dart';
import 'package:portfeuille_numerique/objectifs.dart';
import 'package:portfeuille_numerique/operation.dart';
import 'package:sqflite/sqflite.dart';
import 'db/sql_helper.dart';
import 'profileUser.dart';

class homepage extends StatefulWidget {
  homepage.withNull({Key? key}) : super(key: key);
  String? email;
  String? pass;

  homepage(this.email, this.pass);

  @override
  State<homepage> createState() => _homepageState(this.email, this.pass);
}

class _homepageState extends State<homepage> {
  String? email;
  String? pass;
  int? k;
  int? a;
  static var m;

  TextEditingController f_solde = TextEditingController();
  _homepageState(this.email, this.pass);

  List<charts.Series<Task, String>>? _seriedata;
  _generatedData() {
    var piedata = [
      Task("work", 40000, Colors.red),
      Task("achats", 200000, Colors.green),
      // Task("ventes", 40000, Colors.orange),
      // Task("hhhh", 40000, Colors.yellow),
    ];
    _seriedata!.add(
      charts.Series(
          data: piedata,
          domainFn: (Task task, _) => task.task,
          measureFn: (Task task, _) => task.taskvalue,
          colorFn: (Task task, _) =>
              charts.ColorUtil.fromDartColor(task.colorval),
          id: 'Daily task',
          labelAccessorFn: (Task row, _) => '${row.taskvalue}'),
    );
  }

  final List<Tab> mytabs = [
    Tab(
      text: "Comptes",
    ),
    Tab(
      text: "Budget et objectif",
    )
  ];
  // initializea() async {
  //   utilisateur? user = await helper.getUser(this.email!, this.pass!);
  //   a = user!.id;
  // }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _seriedata = [];
    _generatedData();
  }

  SQL_Helper helper = new SQL_Helper();

  insertSolde() async {
    utilisateur? user = await helper.getUser(this.email!, this.pass!);
    a = user!.id;
    compte new_cmp = new compte(int.parse(f_solde.text), a);
    compte? exist_cmp = await helper.getCompteUser(a!);
    if (exist_cmp != null) {
      helper.update_compte(new_cmp);
    } else {
      await helper.insert_compte(new_cmp);
    }
  }

  Future<compte?> getcompteUser(int id_utilisateur) async {
    Future<compte?> comp = helper.getCompteUser(id_utilisateur);
    return comp;
  }

  Future<int?> getsoldeUser(int id_utilisateur) async {
    int? solde;
    compte? comp = await helper.getCompteUser(id_utilisateur);
    if (comp == null) {
      solde = 0;
    } else {
      solde = comp.solde;
    }
    return solde;
  }

  printthing() {
    print("hello");
  }

  void updateSolde() async {
    utilisateur? user = await helper.getUser(this.email!, this.pass!);
    a = user!.id;
    final Future<Database>? db = helper.initialiseDataBase();
    var our_db = db;
    if (our_db != null) {
      our_db.then((database) {
        Future<int?> solde = getsoldeUser(a!);
        solde.then((reloadsolde) {
          setState(() {
            this.k = reloadsolde;
          });
        });
      });
    }
    // m = this.k;
  }

  @override
  Widget build(BuildContext context) {
    if (k == null) {
      updateSolde();
    } else {
      _seriedata = [];
      _generatedData();
    }
    // updateSolde();
    //updateSolde();
    //printthing();
    m = this.k;
    return MaterialApp(
      home: DefaultTabController(
        length: mytabs.length,
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          appBar: appbarfunction(mytabs, "Accueil"),
          drawer: drowerfunction(context),
          body: TabBarView(
            children: [
              Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    //add column for solde et button
                    Column(
                      children: [
                        Padding(
                          padding: EdgeInsets.only(top: 20),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              // Title(color: Colors.red, child: Text("hi")),
                              Text(
                                "Votre Solde est ",
                                style: TextStyle(fontSize: 25),
                              ),
                              Container(
                                width: 200,
                                height: 50,
                                child: TextField(
                                  enabled: false,
                                  keyboardType: TextInputType.number,
                                  decoration: InputDecoration(
                                      hintText: '$m',
                                      border: OutlineInputBorder()),
                                  style: TextStyle(
                                    fontSize: 30,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: 20),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(" "),
                              RaisedButton(
                                onPressed: () {
                                  AlertDialog alertDialog = AlertDialog(
                                    title: Text("Ajouter un niveaux solde"),
                                    content: SizedBox(
                                      width: 200,
                                      child: TextField(
                                        controller: f_solde,
                                        keyboardType: TextInputType.number,
                                        decoration: InputDecoration(
                                            hintText: '0',
                                            border: OutlineInputBorder()),
                                        style: TextStyle(fontSize: 20),
                                      ),
                                    ),
                                    actions: [
                                      TextButton(
                                        child: Text(
                                          "Annuler",
                                          style: TextStyle(color: Colors.red),
                                        ),
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                      ),
                                      TextButton(
                                        child: Text("Enregistrer"),
                                        onPressed: () {
                                          insertSolde();
                                          setState(() {
                                            updateSolde();
                                          });

                                          Navigator.pop(context);
                                        },
                                      ),
                                    ],
                                  );
                                  showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return alertDialog;
                                      });
                                },
                                padding: EdgeInsets.all(5),
                                color: Colors.red,
                                textColor: Colors.white,
                                child: Text("Modifier le solde"),
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                    //fermer column solde et botton

                    //add new column for statistiques

                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(top: 40),
                          child: Row(
                            children: [
                              Text(
                                "Statistiques sur les depenses",
                                style: TextStyle(fontSize: 20),
                              ),
                            ],
                          ),
                        ),
                        //ajouter ici le diagramme circulaire
                        Container(
                          width: 400,
                          height: 400,
                          child: charts.PieChart(
                            _seriedata,
                            animate: true,
                            animationDuration: Duration(seconds: 5),
                            // behaviors: [
                            //   new charts.DatumLegend(
                            //     outsideJustification:
                            //         charts.OutsideJustification.endDrawArea,
                            //     horizontalFirst: false,
                            //     desiredMaxRows: 2,
                            //     cellPadding:
                            //         new EdgeInsets.only(right: 4, bottom: 4),
                            //     entryTextStyle: charts.TextStyleSpec(
                            //       color: charts
                            //           .MaterialPalette.purple.shadeDefault,
                            //       fontSize: 11,
                            //     ),
                            //   )
                            // ],
                            defaultRenderer: new charts.ArcRendererConfig(
                                arcWidth: 100,
                                arcRendererDecorators: [
                                  new charts.ArcLabelDecorator(
                                      labelPosition:
                                          charts.ArcLabelPosition.inside)
                                ]),
                          ),
                        ),
                      ],
                    ),
                    //fermer column statistiques
                    //add column vue

                    // Column(
                    //   //crossAxisAlignment: CrossAxisAlignment.start,
                    //   children: [
                    //     Padding(
                    //       padding: EdgeInsets.only(top: 40),
                    //       child: Row(
                    //         children: [
                    //           Text(
                    //             "Vue sur les dernieres transactions ",
                    //             style: TextStyle(fontSize: 20),
                    //           )
                    //         ],
                    //       ),
                    //     ),
                    //     Container(
                    //       // width: 100,
                    //       height: 160,
                    //       color: Colors.grey,
                    //       child: ListView.builder(
                    //           padding: EdgeInsets.zero,
                    //           itemCount: 10,
                    //           scrollDirection: Axis.vertical,
                    //           itemBuilder: (context, index) {
                    //             return ListTile(
                    //               title: Text("${index + 1}"),
                    //               // leading: Icon(Icons.home),
                    //             );
                    //           }),
                    //     ),
                    //   ],
                    // ),
                    //fermer column vue

                    Container(
                      //  width: MediaQuery.of(context).size.width,
                      //   height: MediaQuery.of(context).size.height,
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
                                    builder: (context) => operation()));
                          },
                        ),
                      ),
                    )
                  ],
                ),
              ),
              //la page budgets et objectifs
              Column(
                children: [
                  Expanded(
                    child: Column(
                      children: [
                        Expanded(
                          child: ListView(
                            children: [
                              ListTile(
                                title: Text("Les Budgets"),
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                            child: ListView(
                          children: [
                            ListTile(
                              title: Text("Les objectifs "),
                            ),
                          ],
                        ))
                      ],
                    ),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}

class Task {
  String? task;
  double? taskvalue;
  Color? colorval;

  Task(this.task, this.taskvalue, this.colorval);
}
