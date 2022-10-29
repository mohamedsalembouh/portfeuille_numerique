import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:portfeuille_numerique/form_objectif.dart';
import 'package:portfeuille_numerique/methodes.dart';
import 'package:portfeuille_numerique/models/compte.dart';
import 'package:portfeuille_numerique/models/objective.dart';
import 'package:portfeuille_numerique/services/local_notification_service.dart';
import 'package:sqflite/sqflite.dart';
import 'package:toast/toast.dart';
import 'models/compteRessource.dart';
import 'models/ressource.dart';
import 'models/utilisateur.dart';
import 'package:get/get.dart';

class objectif extends StatefulWidget {
  // const objectif({Key? key}) : super(key: key);
  utilisateur? usr;
  int? selectedpage;
  objectif(this.usr, this.selectedpage);
  @override
  State<objectif> createState() => _objectifState(this.usr, this.selectedpage);
}

class _objectifState extends State<objectif> {
  utilisateur? usr;
  int? selectedpage;
  // List<diagrameSolde> allUpdateSolde = [];
  _objectifState(this.usr, this.selectedpage);
  TextEditingController mnt_donnee = TextEditingController();
  final List<Tab> mytabs = [
    Tab(
      text: "51".tr,
    ),
    Tab(
      text: "52".tr,
    )
  ];
  final _formKey = GlobalKey<FormState>();
  late final LocalNotificationService service;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    service = LocalNotificationService();
    service.initialize();
    listenToNotification();
  }

  List<objective>? allobjectif;
  int count = 0;
  static var allobjectives;
  String? TypeCompte;
  Icon? monIcon;

  getAllObjectif() async {
    utilisateur? user =
        await helper.getUser(this.usr!.email!, this.usr!.password!);
    int id = user!.id!;
    final Future<Database>? db = helper.initialiseDataBase();
    var ourDb = db;
    if (ourDb != null) {
      ourDb.then((database) {
        Future<List<objective>> objs = helper.getAllObjectivfs(id);
        objs.then((theList) {
          setState(() {
            this.allobjectif = theList;
            this.count = theList.length;
          });
        });
      });
    }
  }

  augmeterMontant(int idobj, int mnt) async {
    DateTime maintenant = DateTime.now();
    String date_maintenant = DateFormat("yyyy-MM-dd").format(maintenant);
    if (TypeCompte != "25".tr) {
      ressource? res = await helper.getSpecifyRessource(TypeCompte!);
      int id_res = res!.id_ress!;
      compte? cmp = await helper.getCompteUser(this.usr!.id!, id_res);
      if (cmp != null) {
        int solde = cmp.solde!;
        if (mnt <= solde) {
          objective? obj =
              await helper.getSpecifyObjectif(idobj, this.usr!.id!);
          if (obj != null) {
            int old_mnt = obj.montant_donnee!;
            int new_mnt = old_mnt + mnt;
            if (new_mnt <= obj.montant_cible!) {
              objective update_obj = objective.withId(
                  obj.id,
                  obj.nom_objective,
                  obj.montant_cible,
                  new_mnt,
                  date_maintenant,
                  obj.status_notification,
                  obj.id_compte,
                  obj.id_utilisateur);
              int? x = await helper.update_objective(update_obj);
              int newSolde = solde - mnt;
              compte updateCompte =
                  compte(newSolde, date_maintenant, id_res, this.usr!.id!);
              int y = await helper.update_compte(updateCompte);

              if (x != 0 && y != 0) {
                insertArgent(updateCompte.solde!, updateCompte.date!,
                    updateCompte.id_ressource!, updateCompte.id_utilisateur!);
                getAllObjectif();
                Navigator.of(context, rootNavigator: true).pop();
                shownot(update_obj);
                faireNotificationObjectif(update_obj);
                mnt_donnee.clear();
              } else {
                print("not updated");
              }
            } else {
              showText(context, "SVP",
                  "cette valeur est plus grand que le montant cible");
            }
          }
        } else {
          showText(context, "Desole",
              "Le montant que vous voulez entre est plus grand que votre solde dans $TypeCompte");
        }
      }
    } else {
      Toast.show("t2".tr);
    }
  }

  supprimerObjectif(int idObj) async {
    utilisateur? user =
        await helper.getUser(this.usr!.email!, this.usr!.password!);
    int a = user!.id!;
    int result = await helper.deleteObjective(idObj, a);
    if (result != 0) {
      print("deleted one");
      getAllObjectif();
    }
  }

  shownot(objective obj) {
    if (obj.montant_cible == obj.montant_donnee) {
      showText(context, "Félicitation",
          "L'objectif ${obj.nom_objective} est realise");
    }
  }

  faireNotificationObjectif(objective obj) async {
    if (obj.status_notification == 0) {
      if (obj.montant_donnee == obj.montant_cible) {
        service.showNotificationWithPayload(
            id: obj.id!,
            title: "Félicitation",
            body: "L'objectif ${obj.nom_objective} est realise",
            payload: "payload objectif");
      }
    }
  }

  void listenToNotification() =>
      service.onNotificationClick.stream.listen((onNotificationListener));
  void onNotificationListener(String? payload) {
    if (payload != null && payload.isNotEmpty) {
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => objectif(usr, 1)));
    }
  }

  int indexTab = 0;
  @override
  Widget build(BuildContext context) {
    // getAllObjectif();
    if (this.allobjectif == null) {
      getAllObjectif();
    }
    allobjectives = this.allobjectif;
    print(allobjectives);
    return DefaultTabController(
      length: mytabs.length,
      initialIndex: this.selectedpage!,
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
          title: Text("c".tr),
          actions: [
            Padding(
              padding: EdgeInsets.only(right: 20),
              child: GestureDetector(
                onTap: () {},
                child: Icon(Icons.search),
              ),
            )
          ],
        ),
        drawer: drowerfunction(context, this.usr),
        body: TabBarView(
          children: [
            Column(
              children: [
                Expanded(
                    child: ListView.builder(
                        itemCount: count,
                        itemBuilder: (context, pos) {
                          // if (allobjectives[pos].montant_donnee ==
                          //     allobjectives[pos].montant_cible) {
                          //   monIcon = Icon(Icons.check);
                          // }
                          // status(x) {
                          //   if (x == allobjectives[pos].montant_cible) {
                          //     return Icon(
                          //       Icons.check,
                          //     );
                          //   }
                          // }

                          if (allobjectives[pos].montant_donnee !=
                              allobjectives[pos].montant_cible) {
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
                                  // leading:
                                  //     status(allobjectives[pos].montant_donnee),
                                  title: Text(
                                      "${allobjectives[pos].nom_objective}"),
                                  subtitle: Text(
                                    "63".tr +
                                        " : " +
                                        "${allobjectives[pos].montant_donnee}",
                                    // style: TextStyle(color: Colors.amberAccent),
                                  ),
                                  trailing: Text(
                                    "62".tr +
                                        " : " +
                                        "${allobjectives[pos].montant_cible}",
                                    //style: TextStyle(color: Colors.green),
                                  ),
                                  onTap: () {
                                    print(
                                        allobjectives[pos].status_notification);
                                    AlertDialog alertDialog = AlertDialog(
                                        title: Text("58".tr),
                                        content: SingleChildScrollView(
                                          child: StatefulBuilder(builder:
                                              (BuildContext context,
                                                  StateSetter setState) {
                                            return Container(
                                              child: Form(
                                                key: _formKey,
                                                child: Column(
                                                  children: [
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              left: 10,
                                                              right: 10),
                                                      child: TextFormField(
                                                        controller: mnt_donnee,
                                                        keyboardType:
                                                            TextInputType
                                                                .number,
                                                        decoration:
                                                            InputDecoration(
                                                                labelText: "0",
                                                                border:
                                                                    OutlineInputBorder(
                                                                  borderRadius:
                                                                      BorderRadius.all(
                                                                          Radius.circular(
                                                                              20.0)),
                                                                  borderSide:
                                                                      BorderSide(
                                                                          color:
                                                                              Colors.white),
                                                                ),
                                                                enabledBorder:
                                                                    OutlineInputBorder(
                                                                  borderRadius:
                                                                      BorderRadius.all(
                                                                          Radius.circular(
                                                                              20.0)),
                                                                  borderSide:
                                                                      BorderSide(
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
                                                    ),
                                                    SizedBox(
                                                      height: 30,
                                                    ),
                                                    Padding(
                                                      padding: EdgeInsets.only(
                                                          right: 10, left: 10),
                                                      child: FutureBuilder(
                                                          future:
                                                              getComptesRessource(
                                                                  this
                                                                      .usr!
                                                                      .id!),
                                                          builder: (BuildContext
                                                                  context,
                                                              AsyncSnapshot<
                                                                      List<
                                                                          compteRessource>>
                                                                  snapshot) {
                                                            if (!snapshot
                                                                .hasData) {
                                                              return CircularProgressIndicator();
                                                            } else {
                                                              return DropdownButtonFormField(
                                                                decoration:
                                                                    InputDecoration(
                                                                        // labelText: "Destination",
                                                                        border:
                                                                            OutlineInputBorder(
                                                                          borderRadius:
                                                                              BorderRadius.all(Radius.circular(20.0)),
                                                                          borderSide:
                                                                              BorderSide(color: Colors.white),
                                                                        ),
                                                                        enabledBorder:
                                                                            OutlineInputBorder(
                                                                          borderRadius:
                                                                              BorderRadius.all(Radius.circular(20.0)),
                                                                          borderSide:
                                                                              BorderSide(color: Colors.black),
                                                                        )),
                                                                isExpanded:
                                                                    true,
                                                                elevation: 16,
                                                                borderRadius: BorderRadius
                                                                    .all(Radius
                                                                        .circular(
                                                                            5.0)),
                                                                value:
                                                                    TypeCompte,
                                                                hint: Text(
                                                                    "25".tr),
                                                                items: snapshot
                                                                    .data!
                                                                    .map((cmpRes) =>
                                                                        DropdownMenuItem<
                                                                            String>(
                                                                          child:
                                                                              Text(cmpRes.nom_ress!),
                                                                          value:
                                                                              cmpRes.nom_ress,
                                                                        ))
                                                                    .toList(),
                                                                onChanged:
                                                                    (String?
                                                                        value) {
                                                                  setState(() {
                                                                    TypeCompte =
                                                                        value!;
                                                                  });
                                                                },
                                                                validator:
                                                                    (value) {
                                                                  if (value ==
                                                                      null) {
                                                                    return "Le champ est obligatoire";
                                                                  }
                                                                  return null;
                                                                },
                                                              );
                                                            }
                                                          }),
                                                    ),
                                                    SizedBox(
                                                      height: 30,
                                                    ),
                                                    Padding(
                                                      padding:
                                                          EdgeInsets.only(),
                                                      child: Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceAround,
                                                        children: [
                                                          // SizedBox(
                                                          //   width: MediaQuery.of(
                                                          //               context)
                                                          //           .size
                                                          //           .width /
                                                          //       3,
                                                          //   height: MediaQuery.of(
                                                          //               context)
                                                          //           .size
                                                          //           .height /
                                                          //       13,
                                                          //   child: ElevatedButton(
                                                          //     onPressed: () {
                                                          //       Navigator.pop(
                                                          //           context);
                                                          //     },
                                                          //     child:
                                                          //         Text('26'.tr),
                                                          //     style: ElevatedButton
                                                          //         .styleFrom(
                                                          //             shape:
                                                          //                 StadiumBorder()),
                                                          //   ),
                                                          // ),
                                                          SizedBox(
                                                            width: MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .width /
                                                                2,
                                                            height: MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .height /
                                                                13,
                                                            child:
                                                                ElevatedButton(
                                                              onPressed: () {
                                                                augmeterMontant(
                                                                  allobjectives[
                                                                          pos]
                                                                      .id,
                                                                  int.parse(
                                                                      mnt_donnee
                                                                          .text),
                                                                );
                                                              },
                                                              child:
                                                                  Text('27'.tr),
                                                              style: ElevatedButton
                                                                  .styleFrom(
                                                                      shape:
                                                                          StadiumBorder()),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            );
                                          }),
                                        ));
                                    showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return alertDialog;
                                        });
                                  },
                                  onLongPress: () {
                                    AlertDialog alertDialog = AlertDialog(
                                      title: Icon(Icons.delete),
                                      content: Text("59".tr +
                                          "${allobjectives[pos].nom_objective}"),
                                      actions: [
                                        TextButton(
                                          child: Text(
                                            "26".tr,
                                          ),
                                          onPressed: () {
                                            Navigator.of(context,
                                                    rootNavigator: true)
                                                .pop();
                                          },
                                        ),
                                        TextButton(
                                          child: Text(
                                            "38".tr,
                                            style: TextStyle(color: Colors.red),
                                          ),
                                          onPressed: () {
                                            supprimerObjectif(
                                                allobjectives[pos].id);
                                            Navigator.of(context,
                                                    rootNavigator: true)
                                                .pop();
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
                                ),
                              ),
                            );
                          } else {
                            return Container();
                          }
                        })),
              ],
            ),
            //l'autre page
            Column(
              children: [
                Expanded(
                    child: ListView.builder(
                        itemCount: count,
                        itemBuilder: (context, pos) {
                          if (allobjectives[pos].montant_donnee ==
                              allobjectives[pos].montant_cible) {
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
                                  leading: Icon(Icons.check),
                                  title: Text(
                                      "${allobjectives[pos].nom_objective}"),
                                  subtitle: Text(
                                    "63".tr +
                                        " : " +
                                        "${allobjectives[pos].montant_donnee}",
                                    // style: TextStyle(color: Colors.amberAccent),
                                  ),
                                  trailing: Text(
                                    "62".tr +
                                        " : " +
                                        "${allobjectives[pos].montant_cible}",
                                    //style: TextStyle(color: Colors.green),
                                  ),
                                  onTap: () {
                                    AlertDialog alertDialog = AlertDialog(
                                      title: Icon(Icons.delete),
                                      content: Text("59".tr +
                                          "${allobjectives[pos].nom_objective}"),
                                      actions: [
                                        TextButton(
                                          child: Text(
                                            "26".tr,
                                          ),
                                          onPressed: () {
                                            Navigator.of(context,
                                                    rootNavigator: true)
                                                .pop();
                                          },
                                        ),
                                        TextButton(
                                          child: Text(
                                            "38".tr,
                                            style: TextStyle(color: Colors.red),
                                          ),
                                          onPressed: () {
                                            supprimerObjectif(
                                                allobjectives[pos].id);
                                            Navigator.of(context,
                                                    rootNavigator: true)
                                                .pop();
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
                                ),
                              ),
                            );
                          } else {
                            return Container();
                          }
                        }))
              ],
            )
          ],
        ),
        floatingActionButton: indexTab == 0
            ? FloatingActionButton(
                child: Icon(
                  Icons.add,
                  size: 20,
                ),
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => form_objectif(usr)));
                },
              )
            : null,
      ),
    );
  }
}
