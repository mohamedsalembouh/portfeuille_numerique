import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:portfeuille_numerique/budget.dart';
import 'package:portfeuille_numerique/categories.dart';
import 'package:portfeuille_numerique/dettes.dart';
import 'package:portfeuille_numerique/methodes.dart';
import 'package:portfeuille_numerique/models/categorie.dart';
import 'package:portfeuille_numerique/models/compte.dart';
import 'package:portfeuille_numerique/models/depensesCats.dart';
import 'package:portfeuille_numerique/models/operation_sortir.dart';
import 'package:portfeuille_numerique/models/utilisateur.dart';
import 'package:portfeuille_numerique/objectifs.dart';
import 'package:portfeuille_numerique/operation.dart';
import 'package:portfeuille_numerique/parametres.dart';
import 'package:portfeuille_numerique/partageGroupe.dart';
import 'package:portfeuille_numerique/statistiques.dart';
import 'package:sqflite/sqflite.dart';
import 'package:toast/toast.dart';
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
  Map? myresult;
  static var h;
  int? total;
  TextEditingController f_solde = TextEditingController();
  _homepageState(this.email, this.pass);
  SQL_Helper helper = new SQL_Helper();
  List<charts.Series<diagram, String>?>? _seriedata;
  List<depensesCats>? allDepenses;
  int count = 0;
  var piedata2 = <diagram>[];

  generatedData() async {
    Color col;
    var piedata = <diagram>[];

    if (allDepenses != null) {
      for (int i = 0; i < count; i++) {
        if (allDepenses![i].coleur == "Vert") {
          col = Colors.green;
        } else if (allDepenses![i].coleur == "Rouge") {
          col = Colors.red;
        } else if (allDepenses![i].coleur == "Jaune") {
          col = Colors.yellow;
        } else if (allDepenses![i].coleur == "Rose") {
          col = Colors.pink;
        } else {
          col = Colors.black;
        }

        int tot = 0;
        for (int j = 0; j < count; j++) {
          if (allDepenses![j].nom == allDepenses![i].nom && i != j) {
            tot = tot + allDepenses![j].montant!;
          }
        }
        piedata.add(
            diagram(allDepenses![i].nom, allDepenses![i].montant! + tot, col));
        // total = total + allDepenses![i].montant!;
      }
      var ids = Set();
      piedata.retainWhere((element) => ids.add(element.nomCat));
    } else {
      piedata.add(diagram("aa", 345, Colors.black));
    }

    _seriedata!.add(
      charts.Series(
        data: piedata,
        domainFn: (diagram task, _) => task.nomCat,
        measureFn: (diagram task, _) => task.montant,
        colorFn: (diagram task, _) =>
            charts.ColorUtil.fromDartColor(task.colorval),
        id: 'Daily task',
        //labelAccessorFn: (diagram row, _) => '${row.montant}'
      ),
    );
    piedata2 = piedata;
  }

  getTotal() {
    int to = 0;
    for (int i = 0; i < piedata2.length; i++) {
      to = to + piedata2[i].montant!;
    }
    return to;
  }

  final List<Tab> mytabs = [
    Tab(
      text: "Comptes",
    ),
    Tab(
      text: "Budget et objectif",
    )
  ];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    updateCategories();
    _seriedata = [];
    generatedData();
  }

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

    updateSolde();
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

  updateCategories() async {
    utilisateur? user = await helper.getUser(this.email!, this.pass!);
    a = user!.id;
    final Future<Database>? db = helper.initialiseDataBase();
    var ourDb = db;
    if (ourDb != null) {
      ourDb.then((database) {
        Future<List<depensesCats>> depenses = helper.getAllDepensesCats(a!);

        depenses.then((theList) {
          setState(() {
            this.allDepenses = theList;
            if (allDepenses != null) {
              this.count = theList.length;
            }
          });
        });
      });
    }
  }

  void updateSolde() async {
    updateCategories();
    utilisateur? user = await helper.getUser(this.email!, this.pass!);
    a = user!.id;
    h = user.nom;
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
  }

  modifySolde(int val, int montant) async {
    utilisateur? user = await helper.getUser(this.email!, this.pass!);
    a = user!.id;
    compte? cmp = await helper.getCompteUser(a!);
    if (val == 0) {
      if (cmp != null) {
        int solde = cmp.solde!;
        int newMontant = solde + montant;
        //print(newMontant);
        compte updateComp = compte(newMontant, a);
        helper.update_compte(updateComp);
      } else {
        compte newCompte = compte(montant, a);
        helper.insert_compte(newCompte);
      }
    } else {
      if (cmp != null) {
        int solde = cmp.solde!;
        int newMontant = solde - montant;
        //print(newMontant);
        compte updateComp = compte(newMontant, a);
        helper.update_compte(updateComp);
      } else {
        //showText(context, "désolé", "vous n'avez pas de solde");
      }
    }
    updateSolde();
  }

  @override
  Widget build(BuildContext context) {
    if (k == null) {
      updateSolde();
    } else {
      _seriedata = [];
      generatedData();
    }
    m = this.k;
    utilisateur usr = utilisateur(h, this.email, this.pass);
    if (allDepenses != null) {
      print(allDepenses!.length);
      print(allDepenses);
    } else {
      print("videeeee depenses");
    }
    // print("alldepenses = ${allDepenses!.length}");
    return MaterialApp(
      home: DefaultTabController(
        length: mytabs.length,
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          appBar: appbarfunction(mytabs, "Accueil"),
          drawer: drowerfunction(context, usr),
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
                        Padding(
                          padding: EdgeInsets.only(top: 10),
                          child: Container(
                            width: 400,
                            height: 400,
                            child: charts.PieChart(
                              _seriedata,
                              animate: true,
                              animationDuration: Duration(seconds: 3),
                              defaultRenderer: new charts.ArcRendererConfig(
                                  // customRendererId: 'novoId',
                                  arcWidth: 100,
                                  arcRendererDecorators: [
                                    // new charts.ArcLabelDecorator(
                                    //     labelPosition:
                                    //         charts.ArcLabelPosition.inside)
                                  ]),
                              behaviors: [
                                new charts.DatumLegend(
                                  outsideJustification:
                                      charts.OutsideJustification.endDrawArea,
                                  horizontalFirst: false,
                                  desiredMaxRows: 2,
                                  cellPadding: EdgeInsets.only(
                                    right: 4,
                                    bottom: 4,
                                  ),
                                  entryTextStyle: charts.TextStyleSpec(
                                    color: charts
                                        .MaterialPalette.purple.shadeDefault,
                                    fontSize: 11,
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    //fermer column statistiques
                    //add column vue
                    //fermer column vue

                    Container(
                      child: Padding(
                        padding: EdgeInsets.only(left: 350, bottom: 20),
                        child: FloatingActionButton(
                          child: Icon(
                            Icons.add,
                            size: 20,
                          ),
                          onPressed: () async {
                            myresult = await Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => operation(usr, a)));

                            if (myresult != null) {
                              // updateSolde();
                              updateCategories();
                              modifySolde(myresult![0], myresult![1]);
                            }
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

class diagram {
  String? nomCat;
  int? montant;
  Color? colorval;
  diagram.withnull();
  diagram(this.nomCat, this.montant, this.colorval);
}
