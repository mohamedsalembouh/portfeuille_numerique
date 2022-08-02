import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:intl/intl.dart';
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
import 'package:portfeuille_numerique/services/local_notification_service.dart';
import 'package:portfeuille_numerique/statistiques.dart';
import 'package:sqflite/sqflite.dart';
import 'package:toast/toast.dart';
import 'db/sql_helper.dart';
import 'models/argent.dart';
import 'models/catBudget.dart';
import 'models/emprunte_dette.dart';
import 'profileUser.dart';

class homepage extends StatefulWidget {
  homepage.withNull({Key? key}) : super(key: key);
  String? email;
  String? pass;
  utilisateur? user;
  List<diagrameSolde>? allUpdateSolde;
  // homepage(this.email, this.pass);
  homepage(this.user, this.allUpdateSolde);

  @override
  // State<homepage> createState() => _homepageState(this.email, this.pass);
  State<homepage> createState() =>
      _homepageState(this.user, this.allUpdateSolde!);
}

class _homepageState extends State<homepage> {
  // String? email;
  // String? pass;
  utilisateur? user;
  int? k1;
  int? k2;
  int? k3;
  int? allSolde;
  // int? a;
  static var m1;
  static var m2;
  static var m3;
  static var m_total;
  Map? myresult;
  // static var h;
  int? total;
  List<diagrameSolde> allUpdateSolde = [];
  _homepageState(this.user, this.allUpdateSolde);
  TextEditingController f_solde = TextEditingController();
  // _homepageState(this.email, this.pass);

  String TypeCompte = "Choisissez le type de solde";
  SQL_Helper helper = new SQL_Helper();
  List<charts.Series<diagram, String>?>? _seriedata;
  List<depensesCats>? allDepenses;
  static var depenses;
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
          if (allDepenses![j].nomcat == allDepenses![i].nomcat && i != j) {
            tot = tot + allDepenses![j].montant!;
          }
        }
        piedata.add(diagram(
            allDepenses![i].nomcat, allDepenses![i].montant! + tot, col));
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
      text: "Depenses",
    )
  ];
  late final LocalNotificationService service;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    updateCategories();
    _seriedata = [];
    generatedData();
    service = LocalNotificationService();
    service.initialize();
    listenToNotification();
  }

  insertSolde(String typeCmp) async {
    // utilisateur? user =
    //     await helper.getUser(this.user!.email!, this.user!.password!);
    // a = user!.id;
    if (TypeCompte != "Choisissez le type de solde") {
      DateTime maintenant = DateTime.now();
      String date_maintenant = DateFormat("yyyy-MM-dd").format(maintenant);
      compte new_cmp = new compte(
          int.parse(f_solde.text), typeCmp, date_maintenant, this.user!.id!);
      compte? exist_cmp = await helper.getCompteUser(this.user!.id!, typeCmp);
      if (exist_cmp != null) {
        helper.update_compte(new_cmp);
        argent arg = argent(
            new_cmp.solde, new_cmp.date, new_cmp.type, new_cmp.id_utilisateur);
        helper.insert_argent(arg);
        allUpdateSolde
            .add(diagrameSolde(maintenant, int.parse(f_solde.text), typeCmp));
      } else {
        helper.insert_compte(new_cmp);
        argent arg = argent(
            new_cmp.solde, new_cmp.date, new_cmp.type, new_cmp.id_utilisateur);
        helper.insert_argent(arg);
        allUpdateSolde
            .add(diagrameSolde(maintenant, int.parse(f_solde.text), typeCmp));
      }

      updateSoldeBankily();
      updateSoldeBank();
      updateSoldeCompte();
      updateSoldeGlobale();
      Navigator.pop(context);
    } else {
      Toast.show("Choisissez le type de solde");
    }
    // this.allUpdateSolde =
    //     getListSoldes(allUpdateSolde!, typeCmp, this.user!.id!);
  }

  // Future<compte?> getcompteUser(int id_utilisateur) async {
  //   Future<compte?> comp = helper.getCompteUser(id_utilisateur);
  //   return comp;
  // }

  Future<int?> getsoldeUser(int id_utilisateur, String typeCmp) async {
    int? solde;
    compte? comp = await helper.getCompteUser(id_utilisateur, typeCmp);
    if (comp == null) {
      solde = 0;
    } else {
      solde = comp.solde;
    }
    return solde;
  }

  Future<int?> getAllsoldeUser(int id_utilisateur) async {
    int soldes = 0;
    List<compte> comptes = await helper.getAllComptesUser(id_utilisateur);
    comptes.forEach((compte) {
      soldes = soldes + compte.solde!;
    });
    return soldes;
  }

  updateCategories() async {
    // utilisateur? user =
    //     await helper.getUser(this.user!.email!, this.user!.password!);
    // a = user!.id;
    final Future<Database>? db = helper.initialiseDataBase();
    var ourDb = db;
    if (ourDb != null) {
      ourDb.then((database) {
        Future<List<depensesCats>> depenses =
            helper.getAllDepensesCats(this.user!.id!);

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

  void updateSoldeBankily() async {
    updateCategories();
    // utilisateur? user =
    //     await helper.getUser(this.user!.email!, this.user!.password!);
    // a = user!.id;
    // h = user.nom;
    final Future<Database>? db = helper.initialiseDataBase();
    var our_db = db;
    if (our_db != null) {
      our_db.then((database) {
        Future<int?> solde = getsoldeUser(this.user!.id!, "Bankily");
        solde.then((reloadsolde) {
          setState(() {
            this.k1 = reloadsolde;
          });
        });
      });
    }
  }

  void updateSoldeBank() async {
    updateCategories();
    // utilisateur? user =
    //     await helper.getUser(this.user!.email!, this.user!.password!);
    // a = user!.id;
    // h = user.nom;
    final Future<Database>? db = helper.initialiseDataBase();
    var our_db = db;
    if (our_db != null) {
      our_db.then((database) {
        Future<int?> solde = getsoldeUser(this.user!.id!, "Bank");
        solde.then((reloadsolde) {
          setState(() {
            this.k2 = reloadsolde;
          });
        });
      });
    }
  }

  void updateSoldeCompte() async {
    updateCategories();
    // utilisateur? user =
    //     await helper.getUser(this.user!.email!, this.user!.password!);
    // a = user!.id;
    // h = user.nom;
    final Future<Database>? db = helper.initialiseDataBase();
    var our_db = db;
    if (our_db != null) {
      our_db.then((database) {
        Future<int?> solde = getsoldeUser(this.user!.id!, "Compte");
        solde.then((reloadsolde) {
          setState(() {
            this.k3 = reloadsolde;
          });
        });
      });
    }
  }

  void updateSoldeGlobale() async {
    updateCategories();
    // utilisateur? user =
    //     await helper.getUser(this.user!.email!, this.user!.password!);
    // a = user!.id;
    // h = user.nom;
    final Future<Database>? db = helper.initialiseDataBase();
    var our_db = db;
    if (our_db != null) {
      our_db.then((database) {
        Future<int?> soldes = getAllsoldeUser(this.user!.id!);
        soldes.then((reloadsolde) {
          setState(() {
            this.allSolde = reloadsolde;
          });
        });
      });
    }
  }

  modifySolde(int val, int montant, int valTypeCmp) async {
    DateTime maintenant = DateTime.now();
    String date_maintenant = DateFormat("yyyy-MM-dd").format(maintenant);
    String? typeCmp;
    if (valTypeCmp == 0) {
      typeCmp = "Compte";
    } else if (valTypeCmp == 1) {
      typeCmp = "Bankily";
    } else {
      typeCmp = "Bank";
    }
    compte? cmp = await helper.getCompteUser(this.user!.id!, typeCmp);
    if (val == 0) {
      if (cmp != null) {
        int solde = cmp.solde!;
        int newMontant = solde + montant;
        //print(newMontant);
        compte updateComp =
            compte(newMontant, typeCmp, date_maintenant, this.user!.id!);
        helper.update_compte(updateComp);
        argent arg = argent(updateComp.solde, updateComp.date, updateComp.type,
            updateComp.id_utilisateur);
        helper.insert_argent(arg);
        allUpdateSolde.add(diagrameSolde(maintenant, newMontant, typeCmp));
      } else {
        compte newCompte =
            compte(montant, typeCmp, date_maintenant, this.user!.id!);
        helper.insert_compte(newCompte);
        argent arg = argent(newCompte.solde, newCompte.date, newCompte.type,
            newCompte.id_utilisateur);
        helper.insert_argent(arg);
        allUpdateSolde.add(diagrameSolde(maintenant, montant, typeCmp));
      }
    } else {
      if (cmp != null) {
        int solde = cmp.solde!;
        int newMontant = solde - montant;
        //print(newMontant);
        compte updateComp =
            compte(newMontant, typeCmp, date_maintenant, this.user!.id!);
        helper.update_compte(updateComp);
        argent arg = argent(updateComp.solde, updateComp.date, updateComp.type,
            updateComp.id_utilisateur);
        helper.insert_argent(arg);
        allUpdateSolde.add(diagrameSolde(maintenant, montant, typeCmp));
      } else {
        //showText(context, "désolé", "vous n'avez pas de solde");
      }
    }
    updateSoldeBankily();
    updateSoldeBank();
    updateSoldeCompte();
    updateSoldeGlobale();

    // this.allUpdateSolde =
    //     getListSoldes(this.allUpdateSolde!, typeCmp, this.user!.id!);
  }

  TextEditingController dateDebut = TextEditingController();

  @override
  Widget build(BuildContext context) {
    if (k1 == null || k2 == null || k3 == null || allSolde == null) {
      updateSoldeBankily();
      updateSoldeBank();
      updateSoldeCompte();
      updateSoldeGlobale();
    } else {
      _seriedata = [];
      generatedData();
    }
    m1 = this.k1;
    m2 = this.k2;
    m3 = this.k3;
    m_total = this.allSolde;
    depenses = this.allDepenses;
    // utilisateur usr = utilisateur(h, this.user!.email!, this.user!.password!);
    if (allDepenses != null) {
      print(allDepenses!.length);
    } else {
      print("videeeee depenses");
    }
    print(allUpdateSolde);
    faireNotifications();
    faireNotificationDettes();
    //print(allDepenses![0].date);
    // print("alldepenses = ${allDepenses!.length}");
    return MaterialApp(
      home: DefaultTabController(
        length: mytabs.length,
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          appBar: appbarfunction(context, mytabs, "Accueil", this.user!),
          drawer: drowerfunction(context, this.user, this.allUpdateSolde),
          body: TabBarView(
            children: [
              Container(
                //height: MediaQuery.of(context).size.height ,
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
                                      hintText: '$allSolde',
                                      border: OutlineInputBorder()),
                                  style: TextStyle(
                                    fontSize: 30,
                                  ),
                                ),

                                // width: 200,
                                // height: 50,
                                // child: Padding(
                                //   padding: EdgeInsets.only(),
                                //   child: ListTile(
                                //     title: Card(
                                //       //margin: EdgeInsets.only(left: 20),
                                //       child: Center(
                                //         child: Text(
                                //           "$allSolde",
                                //           style: TextStyle(fontSize: 30),
                                //         ),
                                //       ),
                                //     ),
                                //     onTap: () {
                                //       print(allSolde);
                                //       print(m1);
                                //       print(m2);
                                //       print(m3);
                                //       AlertDialog alertDialog = AlertDialog(
                                //         title: Text(""),
                                //         content: Container(
                                //           height: 200,
                                //           child: Column(
                                //             children: [
                                //               Card(
                                //                   child:
                                //                       Text("Bankily :  $m1")),
                                //               Text("$m2"),
                                //               Text("$m3"),
                                //             ],
                                //           ),
                                //         ),
                                //       );
                                //       showDialog(
                                //           context: context,
                                //           builder: (BuildContext context) {
                                //             return alertDialog;
                                //           });
                                //     },
                                //   ),
                                // ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                            padding: EdgeInsets.only(top: 10),
                            child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  // Text(" "),
                                  RaisedButton(
                                    onPressed: () {
                                      print(allSolde);
                                      print(m1);
                                      print(m2);
                                      print(m3);
                                      AlertDialog alertDialog = AlertDialog(
                                        title: Text(""),
                                        content: Container(
                                          height: 200,
                                          child: Column(
                                            children: [
                                              Card(
                                                child: ListTile(
                                                  title: Text("Compte"),
                                                  trailing: Text("$m3"),
                                                ),
                                              ),
                                              Card(
                                                child: ListTile(
                                                  title: Text("Bank"),
                                                  trailing: Text("$m2"),
                                                ),
                                              ),
                                              Card(
                                                child: ListTile(
                                                  title: Text("Bankily"),
                                                  trailing: Text("$m1"),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      );
                                      showDialog(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return alertDialog;
                                          });
                                    },
                                    padding: EdgeInsets.all(5),
                                    // color: Colors.red,
                                    //textColor: Colors.white,
                                    child:
                                        Text("Afficher Les Details de solde"),
                                  )
                                ])),
                        Padding(
                          padding: EdgeInsets.only(top: 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              // Text(" "),
                              RaisedButton(
                                onPressed: () {
                                  AlertDialog alertDialog = AlertDialog(
                                      title: Text("Ajouter un nouveaux solde"),
                                      content: StatefulBuilder(builder:
                                          (BuildContext context,
                                              StateSetter setState) {
                                        return Container(
                                          height: 300,
                                          child: Column(
                                            children: [
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    top: 10),
                                                child: SizedBox(
                                                  //width: 200,
                                                  child: TextField(
                                                    controller: f_solde,
                                                    keyboardType:
                                                        TextInputType.number,
                                                    decoration: InputDecoration(
                                                        hintText: '0',
                                                        border:
                                                            OutlineInputBorder()),
                                                    style:
                                                        TextStyle(fontSize: 20),
                                                  ),
                                                ),
                                              ),
                                              Padding(
                                                padding: EdgeInsets.only(
                                                    bottom: 20, top: 40),
                                                child: DropdownButton<String>(
                                                  items: <String>[
                                                    'Compte',
                                                    'Bankily',
                                                    'Bank'
                                                  ].map<
                                                          DropdownMenuItem<
                                                              String>>(
                                                      (String value) {
                                                    return DropdownMenuItem<
                                                        String>(
                                                      value: value,
                                                      child: Text(value),
                                                    );
                                                  }).toList(),
                                                  onChanged: (String? value) {
                                                    print(TypeCompte);
                                                    setState(() {
                                                      TypeCompte = value!;
                                                    });
                                                  },
                                                  isExpanded: true,
                                                  //value: currentNomCat,
                                                  hint: Text('$TypeCompte'),
                                                  //style: TextStyle(fontSize: 18),
                                                ),
                                              ),
                                              Padding(
                                                padding:
                                                    EdgeInsets.only(top: 10),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceAround,
                                                  children: [
                                                    ElevatedButton(
                                                      child: Text(
                                                        "Annuler",
                                                        // style: TextStyle(
                                                        //     color: Colors.red),
                                                      ),
                                                      onPressed: () {
                                                        Navigator.pop(context);
                                                      },
                                                    ),
                                                    ElevatedButton(
                                                      child:
                                                          Text("Enregistrer"),
                                                      onPressed: () {
                                                        insertSolde(TypeCompte);
                                                      },
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        );
                                      }));
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
                          padding: EdgeInsets.only(top: 20),
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
                          padding: EdgeInsets.only(top: 5),
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
                        padding: EdgeInsets.only(
                          left: 350,
                        ),
                        child: FloatingActionButton(
                          child: Icon(
                            Icons.add,
                            size: 20,
                          ),
                          onPressed: () async {
                            myresult = await Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => operation(this.user,
                                        this.user!.id!, this.allUpdateSolde)));

                            if (myresult != null) {
                              // updateSolde();
                              updateCategories();
                              modifySolde(
                                  myresult![0], myresult![1], myresult![2]);
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
                        // Row(
                        //   mainAxisAlignment: MainAxisAlignment.spaceAround,
                        //   children: [
                        //     Padding(
                        //       padding: EdgeInsets.only(bottom: 10),
                        //       //const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                        //       child: TextFormField(
                        //         controller: dateDebut,
                        //         validator: (value) {
                        //           if (value == null || value.isEmpty) {
                        //             return "entrer la date de debut";
                        //           }
                        //           return null;
                        //         },
                        //         //keyboardType: TextInputType.datetime,
                        //         decoration: InputDecoration(
                        //           border: UnderlineInputBorder(),
                        //           labelText: "Date debut ",
                        //           icon: Icon(Icons.calendar_today_outlined),
                        //         ),
                        //         onTap: () async {
                        //           DateTime? pickeddate = await showDatePicker(
                        //               context: context,
                        //               initialDate: DateTime.now(),
                        //               firstDate: DateTime(2000),
                        //               lastDate: DateTime(2050));

                        //           if (pickeddate == null) {
                        //             pickeddate = DateTime.now();
                        //           }
                        //           setState(() {
                        //             dateDebut.text = DateFormat("yyyy-MM-dd")
                        //                 .format(pickeddate!);
                        //           });
                        //         },
                        //       ),
                        //     ),
                        //   ],
                        // ),
                        Expanded(
                            child: ListView.builder(
                                itemCount: count,
                                itemBuilder: (context, pos) {
                                  return Card(
                                    child: ListTile(
                                        isThreeLine: true,
                                        title: Text("${depenses[pos].nomcat}"),
                                        subtitle:
                                            Text("${depenses[pos].montant}"),
                                        trailing: Column(
                                          children: [
                                            Text("${depenses[pos].date}"),
                                            Text(
                                                "${depenses[pos].type_compte}"),
                                          ],
                                        )),
                                  );
                                })),
                      ],
                    ),
                  )
                ],
              )
            ],
          ),
          //bottomNavigationBar: myBottomNavBar(),
        ),
      ),
    );
  }

  faireNotifications() async {
    SQL_Helper helper = SQL_Helper();
    List<categorie> allcategories = await helper.getAllcategories();
    allcategories.forEach((cat) async {
      List<depensesCats> depenses =
          await helper.getSpecifiedDepenses(this.user!.id!, cat.nomcat!);
      List<catBudget> budgets =
          await helper.getAllSpecifiedBudgets(this.user!.id!, cat.nomcat!);
      int allmnt = 0;
      for (depensesCats a in depenses) {
        allmnt = allmnt + a.montant!;
      }
      for (catBudget bdg in budgets) {
        if (bdg.status == 0) {
          DateTime debut = DateTime.parse(bdg.date_debut!);
          DateTime fin = DateTime.parse(bdg.date_fin!);
          DateTime now =
              DateTime.parse(DateFormat("yyyy-MM-dd").format(DateTime.now()));
          if (bdg.montant! < allmnt &&
              now.compareTo(debut) > 0 &&
              now.compareTo(fin) < 0) {
            service.showNotificationWithPayload(
                id: bdg.id!,
                title: "Attension",
                body: "vous avez depassé le budget ${bdg.nombdg}",
                payload: 'payload budget');
          }
        }
      }
    });
  }

  faireNotificationDettes() async {
    List<emprunte_dette> empruntes =
        await helper.getAllEmprunteDettes(this.user!.id!);
    empruntes.forEach((emprunte) {
      if (emprunte.status == 0) {
        DateTime dateEcheance = DateTime.parse(emprunte.date_echeance!);

        DateTime dateMaintenant =
            DateTime.parse(DateFormat("yyyy-MM-dd").format(DateTime.now()));
        if (dateEcheance.difference(dateMaintenant).inDays == 3) {
          service.showNotificationWithPayload(
              id: emprunte.id!,
              title: "Attension",
              body:
                  "Vous avez donnee a ${emprunte.nom} ${emprunte.montant} apres 3 jours",
              payload: "payload dette");
        } else if (dateEcheance.difference(dateMaintenant).inDays == 2) {
          service.showNotificationWithPayload(
              id: emprunte.id!,
              title: "Attension",
              body:
                  "Vous avez donnee a ${emprunte.nom} ${emprunte.montant} apres 2 jours",
              payload: "payload dette");
        } else if (dateEcheance.difference(dateMaintenant).inDays == 1) {
          service.showNotificationWithPayload(
              id: emprunte.id!,
              title: "Attension",
              body:
                  "Vous avez donnee a ${emprunte.nom} ${emprunte.montant} apres 1 jours",
              payload: "payload dette");
        } else if (dateEcheance.difference(dateMaintenant).inDays == 0) {
          service.showNotificationWithPayload(
              id: emprunte.id!,
              title: "Attension",
              body:
                  "Vous avez donnee a ${emprunte.nom} ${emprunte.montant} Aujordhui",
              payload: "payload dette");
        }
      }
    });
  }

  void listenToNotification() =>
      service.onNotificationClick.stream.listen((onNotificationListener));
  void onNotificationListener(String? payload) {
    if (payload != null && payload.isNotEmpty) {
      print("payload $payload");
      if (payload == "payload budget") {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => budget(user, 2, this.allUpdateSolde)));
      } else if (payload == "payload dette") {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => alldettes(user, 2, this.allUpdateSolde)));
      }
    }
  }

  // void listenToNotification2() =>
  //     service.onNotificationClick.stream.listen((onNotificationListener2));
  // void onNotificationListener2(String? payload) {
  //   if (payload != null && payload.isNotEmpty) {
  //     print("payload $payload");
  //     Navigator.push(
  //         context, MaterialPageRoute(builder: (context) => alldettes(user, 2)));
  //   }
  // }
}

class diagram {
  String? nomCat;
  int? montant;
  Color? colorval;
  diagram.withnull();
  diagram(this.nomCat, this.montant, this.colorval);
}
