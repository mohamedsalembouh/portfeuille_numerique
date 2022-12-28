import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:intl/intl.dart';
import 'package:portfeuille_numerique/budget.dart';
import 'package:portfeuille_numerique/dettes.dart';
import 'package:portfeuille_numerique/methodes.dart';
import 'package:portfeuille_numerique/models/categorie.dart';
import 'package:portfeuille_numerique/models/compte.dart';
import 'package:portfeuille_numerique/models/compteRessource.dart';
import 'package:portfeuille_numerique/models/depensesCats.dart';
import 'package:portfeuille_numerique/models/prette_dette.dart';
import 'package:portfeuille_numerique/models/utilisateur.dart';
import 'package:portfeuille_numerique/notification.dart';
import 'package:portfeuille_numerique/operation.dart';
import 'package:portfeuille_numerique/parametres.dart';
import 'package:portfeuille_numerique/services/local_notification_service.dart';
import 'package:sqflite/sqflite.dart';
import 'package:toast/toast.dart';
import 'db/sql_helper.dart';
import 'models/catBudget.dart';
import 'models/emprunte_dette.dart';
import 'models/ressource.dart';
import 'package:get/get.dart';

class homepage extends StatefulWidget {
  homepage.withNull({Key? key}) : super(key: key);
  String? email;
  String? pass;
  utilisateur? user;
  homepage(this.user);

  @override
  State<homepage> createState() => _homepageState(this.user);
}

class _homepageState extends State<homepage> {
  utilisateur? user;
  int? k1;
  int? k2;
  int? k3;
  int? allSolde;
  Map? myresult;
  int? total;
  _homepageState(this.user);
  TextEditingController f_solde = TextEditingController();

  String? TypeCompte;
  SQL_Helper helper = new SQL_Helper();
  List<charts.Series<diagram, String>?>? _seriedata;
  List<depensesCats>? allDepenses;
  static var depenses;
  int count = 0;
  var piedata2 = <diagram>[];
  List<cmpress> monliste = [];

  generatedData() async {
    Color col;
    var piedata = <diagram>[];

    if (allDepenses != null) {
      for (int i = 0; i < count; i++) {
        if (allDepenses![i].coleur == "vert") {
          col = Colors.green;
        } else if (allDepenses![i].coleur == "rouge") {
          col = Colors.red;
        } else if (allDepenses![i].coleur == "jaune") {
          col = Colors.yellow;
        } else if (allDepenses![i].coleur == "rose") {
          col = Colors.pink;
        } else if (allDepenses![i].coleur == 'blue') {
          col = Colors.blue;
        } else if (allDepenses![i].coleur == 'orange') {
          col = Colors.orange;
        } else if (allDepenses![i].coleur == 'gris') {
          col = Colors.grey;
        } else if (allDepenses![i].coleur == 'marron') {
          col = Colors.brown;
        } else if (allDepenses![i].coleur == 'violet') {
          col = Colors.purple;
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
      }
      var ids = Set();
      piedata.retainWhere((element) => ids.add(element.nomCat));
    } else {
      piedata.add(diagram("aa", 345, Colors.black));
    }

    _seriedata!.add(
      charts.Series(
        data: piedata,
        domainFn: (diagram task, _) => task.nomCat!,
        measureFn: (diagram task, _) => task.montant,
        colorFn: (diagram task, _) =>
            charts.ColorUtil.fromDartColor(task.colorval!),
        id: 'Daily task',
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
      text: "11".tr,
    ),
    Tab(
      text: "12".tr,
    )
  ];
  late final LocalNotificationService service;
  final _formKey = new GlobalKey<FormState>();
  @override
  void initState() {
    super.initState();
    updateCategories();
    _seriedata = [];
    generatedData();
    service = LocalNotificationService();
    service.initialize();
    listenToNotification();
  }

  insertSolde(String fSolde) async {
    if (TypeCompte != "25".tr) {
      ressource? res = await helper.getSpecifyRessource(TypeCompte!);
      int id_res = res!.id_ress!;
      DateTime maintenant = DateTime.now();
      String date_maintenant = DateFormat("yyyy-MM-dd").format(maintenant);
      compte new_cmp = new compte(
          int.parse(fSolde), date_maintenant, id_res, this.user!.id!);
      compte? exist_cmp = await helper.getCompteUser(this.user!.id!, id_res);
      if (exist_cmp != null) {
        helper.update_compte(new_cmp);
      } else {
        helper.insert_compte(new_cmp);
      }
      insertArgent(new_cmp.solde!, new_cmp.date!, new_cmp.id_ressource!,
          new_cmp.id_utilisateur!);
      updateSoldeGlobale();
      updateEverySolde();
      Navigator.pop(context);
    } else {
      Toast.show("t2".tr);
    }
  }

  Future<int?> getsoldeUser(int id_utilisateur, int id_res) async {
    int? solde;
    compte? comp = await helper.getCompteUser(id_utilisateur, id_res);
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

  void updateEverySolde() async {
    List<cmpress> localliste = [];
    List<compteRessource> comptesRessources =
        await helper.getAllCompteRessource(this.user!.id!);
    comptesRessources.forEach((element) async {
      int? solde = await getsoldeUser(this.user!.id!, element.id!);
      cmpress compres = cmpress(element.nom_ress, solde);
      localliste.add(compres);
    });
    monliste = localliste;
  }

  void updateSoldeGlobale() async {
    updateCategories();
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

  modifySolde(int val, int montant, int id_res) async {
    DateTime maintenant = DateTime.now();
    String date_maintenant = DateFormat("yyyy-MM-dd").format(maintenant);
    compte? cmp = await helper.getCompteUser(this.user!.id!, id_res);
    if (val == 0) {
      if (cmp != null) {
        int solde = cmp.solde!;
        int newMontant = solde + montant;
        compte updateComp =
            compte(newMontant, date_maintenant, id_res, this.user!.id!);
        helper.update_compte(updateComp);
        insertArgent(updateComp.solde!, updateComp.date!,
            updateComp.id_ressource!, updateComp.id_utilisateur!);
      } else {
        compte newCompte =
            compte(montant, date_maintenant, id_res, this.user!.id!);
        helper.insert_compte(newCompte);
        insertArgent(newCompte.solde!, newCompte.date!, newCompte.id_ressource!,
            newCompte.id_utilisateur!);
      }
    } else {
      if (cmp != null) {
        int solde = cmp.solde!;
        int newMontant = solde - montant;
        compte updateComp =
            compte(newMontant, date_maintenant, id_res, this.user!.id!);
        helper.update_compte(updateComp);
        insertArgent(updateComp.solde!, updateComp.date!,
            updateComp.id_ressource!, updateComp.id_utilisateur!);
      } else {}
    }
    updateSoldeGlobale();
    updateEverySolde();
  }

  TextEditingController dateDebut = TextEditingController();

  int indexTab = 0;

  @override
  Widget build(BuildContext context) {
    if (allSolde == null) {
      updateSoldeGlobale();
      updateEverySolde();
    } else {
      _seriedata = [];
      generatedData();
    }
    depenses = this.allDepenses;
    if (allDepenses != null) {
      print(allDepenses!.length);
    } else {
      print("videeeee depenses");
    }
    faireNotifications();
    faireNotificationDettes1();
    return DefaultTabController(
      length: mytabs.length,
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          bottom: TabBar(
              onTap: (value) {
                setState(() {
                  indexTab = value;
                });
              },
              tabs: mytabs),
          title: Text("10".tr),
          actions: [
            Padding(
              padding: EdgeInsets.only(right: 20),
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => notification(user, 0)));
                },
                child: Icon(Icons.notifications),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(right: 20),
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => parametrage(user)));
                },
                child: Icon(Icons.settings),
              ),
            ),
          ],
        ),
        drawer: drowerfunction(context, this.user),
        body: TabBarView(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(top: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          // SizedBox(
                          // child:
                          // Text(
                          //   "13".tr,
                          //   style: TextStyle(fontSize: 25),
                          // ),
                          // ),
                          // SizedBox(
                          // width: (3 * MediaQuery.of(context).size.width) / 4,
                          // height: 50,
                          // child:
                          Container(
                            width: 300,
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
                          ),
                          // ),
                          // SizedBox(
                          //   width: 20,
                          // ),
                          // SizedBox(
                          //     // width: MediaQuery.of(context).size.width / 4 - 20,
                          //     child:
                          Text(
                            "144".tr,
                            style: TextStyle(fontSize: 20),
                          )
                          // ),
                        ],
                      ),
                    ),
                    Padding(
                        padding: EdgeInsets.only(top: 10),
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              // Text(" "),
                              ElevatedButton(
                                onPressed: () {
                                  print(allSolde);

                                  AlertDialog alertDialog = AlertDialog(
                                    title: Text(""),
                                    content: Container(
                                      width: 100,
                                      height: 400,
                                      child: Column(
                                        children: [
                                          Expanded(
                                            child: ListView.builder(
                                                itemCount: monliste.length,
                                                itemBuilder: (context, pos) {
                                                  print(monliste[pos].nom);
                                                  print(monliste[pos].solde);
                                                  return Card(
                                                    elevation: 8,
                                                    shape:
                                                        RoundedRectangleBorder(
                                                      side: BorderSide(
                                                        color: Colors.white
                                                            .withOpacity(1),
                                                      ),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              20.0),
                                                    ),
                                                    child: ListTile(
                                                      title: Text(
                                                          "${monliste[pos].nom}"),
                                                      subtitle: Text(
                                                          "${monliste[pos].solde}"),
                                                    ),
                                                  );
                                                }),
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
                                child: Text("14".tr),
                                style: ElevatedButton.styleFrom(
                                    shape: StadiumBorder()),
                              )
                            ])),
                    Padding(
                      padding: EdgeInsets.only(top: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          ElevatedButton(
                            onPressed: () {
                              AlertDialog alertDialog = AlertDialog(
                                  title: Text("29".tr),
                                  content: SingleChildScrollView(
                                    child: StatefulBuilder(builder:
                                        (BuildContext context,
                                            StateSetter setState) {
                                      return Container(
                                          child: Column(children: [
                                        Padding(
                                          padding: const EdgeInsets.only(),
                                          child: Form(
                                            key: _formKey,
                                            child: Column(
                                              children: [
                                                SizedBox(
                                                  height: 20,
                                                ),
                                                TextFormField(
                                                  controller: f_solde,
                                                  keyboardType:
                                                      TextInputType.number,
                                                  decoration: InputDecoration(
                                                      labelText: "solde",
                                                      border:
                                                          OutlineInputBorder(
                                                        borderRadius:
                                                            BorderRadius.all(
                                                                Radius.circular(
                                                                    20.0)),
                                                        borderSide: BorderSide(
                                                            color:
                                                                Colors.white),
                                                      ),
                                                      enabledBorder:
                                                          OutlineInputBorder(
                                                        borderRadius:
                                                            BorderRadius.all(
                                                                Radius.circular(
                                                                    20.0)),
                                                        borderSide: BorderSide(
                                                            color:
                                                                Colors.black),
                                                      )),
                                                  validator: (value) {
                                                    if (value!.isEmpty) {
                                                      return "Le champ est obligatoire";
                                                    }
                                                    return null;
                                                  },
                                                ),
                                                SizedBox(
                                                  height: 30,
                                                ),
                                                FutureBuilder(
                                                    future: getRessources(
                                                        this.user!.id!),
                                                    builder: (BuildContext
                                                            context,
                                                        AsyncSnapshot<
                                                                List<ressource>>
                                                            snapshot) {
                                                      if (!snapshot.hasData) {
                                                        return CircularProgressIndicator();
                                                      } else {
                                                        return DropdownButtonFormField(
                                                          decoration:
                                                              InputDecoration(
                                                                  border:
                                                                      OutlineInputBorder(
                                                                    borderRadius:
                                                                        BorderRadius.all(
                                                                            Radius.circular(20.0)),
                                                                    borderSide:
                                                                        BorderSide(
                                                                            color:
                                                                                Colors.white),
                                                                  ),
                                                                  enabledBorder:
                                                                      OutlineInputBorder(
                                                                    borderRadius:
                                                                        BorderRadius.all(
                                                                            Radius.circular(20.0)),
                                                                    borderSide:
                                                                        BorderSide(
                                                                            color:
                                                                                Colors.black),
                                                                  )),
                                                          isExpanded: true,
                                                          elevation: 16,
                                                          borderRadius:
                                                              BorderRadius.all(
                                                                  Radius
                                                                      .circular(
                                                                          5.0)),
                                                          value: TypeCompte,
                                                          hint: Text("25".tr),
                                                          onChanged: (value) {
                                                            setState(() {
                                                              TypeCompte = value
                                                                  as String;
                                                            });
                                                          },
                                                          items: snapshot.data!
                                                              .map((res) =>
                                                                  DropdownMenuItem<
                                                                      String>(
                                                                    child: Text(
                                                                        res.nom_ress!),
                                                                    value: res
                                                                        .nom_ress,
                                                                  ))
                                                              .toList(),
                                                          validator: (value) {
                                                            if (value == null) {
                                                              return "le champ est obligatoire";
                                                            }
                                                            return null;
                                                          },
                                                        );
                                                      }
                                                    }),
                                                SizedBox(
                                                  height: 30,
                                                ),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceAround,
                                                  children: [
                                                    SizedBox(
                                                      width:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width /
                                                              2,
                                                      height:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .height /
                                                              13,
                                                      child: ElevatedButton(
                                                        child: Text("27".tr),
                                                        style: ElevatedButton
                                                            .styleFrom(
                                                                shape:
                                                                    StadiumBorder()),
                                                        onPressed: () {
                                                          final form = _formKey
                                                              .currentState!;
                                                          if (form.validate()) {
                                                            insertSolde(
                                                              f_solde.text,
                                                            );
                                                            f_solde.clear();
                                                          }
                                                        },
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                        )
                                      ]));
                                    }),
                                  ));
                              showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return alertDialog;
                                  });
                            },
                            child: Text(
                              "15".tr,
                            ),
                            style: ElevatedButton.styleFrom(
                                shape: StadiumBorder()),
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
                            "16".tr,
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
                          List.from(_seriedata!),
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
                                color: charts.MaterialPalette.black,
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
              ],
            ),

            //la page des depenses
            Column(
              children: [
                Expanded(
                  child: Column(
                    children: [
                      Expanded(
                          child: ListView.builder(
                              itemCount: count,
                              itemBuilder: (context, pos) {
                                return Card(
                                  elevation: 8,
                                  shape: RoundedRectangleBorder(
                                    side: BorderSide(
                                      color: Colors.white.withOpacity(1),
                                    ),
                                    borderRadius: BorderRadius.circular(20.0),
                                  ),
                                  child: ListTile(
                                    isThreeLine: true,
                                    title: Text("${depenses[pos].nomcat}"),
                                    subtitle: Column(
                                      children: [
                                        Text("22".tr +
                                            " : " +
                                            "${depenses[pos].montant}"),
                                        depenses[pos].description != ""
                                            ? Text("23".tr +
                                                " : " +
                                                "${depenses[pos].description}")
                                            : Container(),
                                      ],
                                    ),
                                    trailing: Text("${depenses[pos].date}"),
                                  ),
                                );
                              })),
                    ],
                  ),
                )
              ],
            ),
          ],
        ),
        floatingActionButton: indexTab == 0
            ? FloatingActionButton(
                child: Icon(
                  Icons.add,
                  size: 20,
                ),
                onPressed: () async {
                  myresult = await Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              operation(this.user, this.user!.id!)));

                  if (myresult != null) {
                    // updateSolde();
                    updateCategories();
                    modifySolde(myresult![0], myresult![1], myresult![2]);
                  }
                },
              )
            : null,
      ),
    );
  }

  faireNotifications() async {
    SQL_Helper helper = SQL_Helper();
    List<categorie> allcategories =
        await helper.getAllcategories(this.user!.id!);
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
        if (bdg.status == 0 && bdg.status_notification == 0) {
          DateTime debut = DateTime.parse(bdg.date_debut!);
          DateTime fin = DateTime.parse(bdg.date_fin!);
          DateTime now =
              DateTime.parse(DateFormat("yyyy-MM-dd").format(DateTime.now()));
          if (bdg.montant! < allmnt &&
              now.compareTo(debut) > 0 &&
              now.compareTo(fin) < 0) {
            service.showNotificationWithPayload(
                id: bdg.id!,
                title: "128".tr,
                body: "125".tr + "${bdg.nombdg}",
                payload: 'payload budget');
          }
        }
      }
    });
  }

  faireNotificationDettes1() async {
    List<emprunte_dette> empruntes =
        await helper.getAllEmprunteDettes(this.user!.id!);
    empruntes.forEach((emprunte) {
      if (emprunte.status == 0 && emprunte.status_notification == 0) {
        DateTime dateEcheance = DateTime.parse(emprunte.date_echeance!);

        DateTime dateMaintenant =
            DateTime.parse(DateFormat("yyyy-MM-dd").format(DateTime.now()));
        if (dateEcheance.difference(dateMaintenant).inDays == 3) {
          service.showNotificationWithPayload(
              id: emprunte.id!,
              title: "128".tr,
              body: "124".tr + "${emprunte.nom} ${emprunte.montant}" + "122".tr,
              payload: "payload dette");
        } else if (dateEcheance.difference(dateMaintenant).inDays == 2) {
          service.showNotificationWithPayload(
              id: emprunte.id!,
              title: "128".tr,
              body: "124".tr + "${emprunte.nom} ${emprunte.montant}" + "121".tr,
              payload: "payload dette");
        } else if (dateEcheance.difference(dateMaintenant).inDays == 1) {
          service.showNotificationWithPayload(
              id: emprunte.id!,
              title: "128".tr,
              body: "124".tr + "${emprunte.nom} ${emprunte.montant}" + "120".tr,
              payload: "payload dette");
        } else if (dateEcheance.difference(dateMaintenant).inDays == 0) {
          service.showNotificationWithPayload(
              id: emprunte.id!,
              title: "128".tr,
              body: "124".tr + "${emprunte.nom} ${emprunte.montant}" + "123".tr,
              payload: "payload dette");
        }
      }
    });
  }

  faireNotificationDettes2() async {
    List<prette_dette> prettes =
        await helper.getAllPrettesDettes(this.user!.id!);
    prettes.forEach((prete) {
      if (prete.status == 0 && prete.status_notification == 0) {
        DateTime dateEcheance = DateTime.parse(prete.date_echeance!);

        DateTime dateMaintenant =
            DateTime.parse(DateFormat("yyyy-MM-dd").format(DateTime.now()));
        if (dateEcheance.difference(dateMaintenant).inDays == 3) {
          service.showNotificationWithPayload(
              id: prete.id!,
              title: "128".tr,
              body: "${prete.nom}" + "119".tr + "${prete.montant}" + "122".tr,
              payload: "payload dette");
        } else if (dateEcheance.difference(dateMaintenant).inDays == 2) {
          service.showNotificationWithPayload(
              id: prete.id!,
              title: "128".tr,
              body: " ${prete.nom}" + "119".tr + "${prete.montant}" + "121".tr,
              payload: "payload dette");
        } else if (dateEcheance.difference(dateMaintenant).inDays == 1) {
          service.showNotificationWithPayload(
              id: prete.id!,
              title: "128".tr,
              body: "${prete.nom}" + "119".tr + "${prete.montant}" + "120".tr,
              payload: "payload dette");
        } else if (dateEcheance.difference(dateMaintenant).inDays == 0) {
          service.showNotificationWithPayload(
              id: prete.id!,
              title: "128".tr,
              body: " ${prete.nom}" + "119".tr + "${prete.montant}" + "123".tr,
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
            context, MaterialPageRoute(builder: (context) => budget(user, 2)));
      } else if (payload == "payload dette") {
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => alldettes(user, 2)));
      }
    }
  }
}

class diagram {
  String? nomCat;
  int? montant;
  Color? colorval;
  diagram.withnull();
  diagram(this.nomCat, this.montant, this.colorval);
}

class cmpress {
  int? solde;
  String? nom;
  cmpress(this.nom, this.solde);
}
