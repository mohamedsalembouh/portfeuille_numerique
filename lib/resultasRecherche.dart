import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:portfeuille_numerique/db/sql_helper.dart';
import 'package:portfeuille_numerique/models/utilisateur.dart';
import 'package:sqflite/sqflite.dart';

import 'homePage.dart';
import 'models/compte.dart';
import 'models/depensesCats.dart';
import 'models/ressource.dart';

class resultasRecherche extends StatefulWidget {
  // const resultasRecherche({Key? key}) : super(key: key);
  int idUser;
  String? dateDebut;
  String? dateFin;
  String? nomRessource;
  resultasRecherche(
      this.idUser, this.dateDebut, this.dateFin, this.nomRessource);

  @override
  State<resultasRecherche> createState() => _resultasRechercheState(
      this.idUser, this.dateDebut, this.dateFin, this.nomRessource);
}

class _resultasRechercheState extends State<resultasRecherche> {
  int? idUser;
  String? dateDebut;
  String? dateFin;
  String? nomRessource;
  _resultasRechercheState(
      this.idUser, this.dateDebut, this.dateFin, this.nomRessource);
  List<depensesCats>? allDepensesCats;
  int? count;
  int? count2;
  List<depensesCats>? allrevenus;
  int? rvenusCount;
  int? depensesCount;
  int? total;
  int? totalRevenus;
  //List<operation_sortir>? alldepenses;
  static var revenus;
  static var depenses;
  SQL_Helper helper = SQL_Helper();
  var piedata2 = <diagram>[];
  String? txt;

  getUniqueRevenus() {
    var uniquerevenu = [];
    if (allrevenus != null) {
      for (int i = 0; i < count2!; i++) {
        int tot = 0;
        for (int j = 0; j < count2!; j++) {
          if (allrevenus![j].nomcat == allrevenus![i].nomcat && i != j) {
            tot = tot + allrevenus![j].montant!;
          }
        }
        uniquerevenu.add(depensesCats(
            allrevenus![i].id,
            allrevenus![i].montant! + tot,
            allrevenus![i].description,
            allrevenus![i].date,
            allrevenus![i].id_categorie,
            allrevenus![i].nomcat,
            allrevenus![i].coleur));
      }
    } else {}
    var ids = Set();
    uniquerevenu.retainWhere((element) => ids.add(element.nomcat));
    return uniquerevenu;
  }

  getUniqueDepenses() {
    var uniquedepenses = [];
    if (allDepensesCats != null) {
      for (int i = 0; i < count!; i++) {
        int tot = 0;
        for (int j = 0; j < count!; j++) {
          if (allDepensesCats![j].nomcat == allDepensesCats![i].nomcat &&
              i != j) {
            tot = tot + allDepensesCats![j].montant!;
          }
        }
        uniquedepenses.add(depensesCats(
            allDepensesCats![i].id,
            allDepensesCats![i].montant! + tot,
            allDepensesCats![i].description,
            allDepensesCats![i].date,
            allDepensesCats![i].id_categorie,
            allDepensesCats![i].nomcat,
            allDepensesCats![i].coleur));
      }
    } else {}
    var ids = Set();
    uniquedepenses.retainWhere((element) => ids.add(element.nomcat));
    return uniquedepenses;
  }

  getTotal() {
    var unqdep = getUniqueDepenses();
    int to = 0;
    for (int i = 0; i < unqdep.length; i++) {
      to = (to + unqdep[i].montant!) as int;
    }
    return to;
  }

  getTotalRevenus() {
    var unqRev = getUniqueRevenus();
    int to = 0;
    for (int i = 0; i < unqRev.length; i++) {
      to = (to + unqRev[i].montant!) as int;
    }
    return to;
  }

  getAllRevenusCats(String nomRess, String debut, String fin) async {
    final Future<Database>? db = helper.initialiseDataBase();
    var ourDb = db;

    if (nomRess != "Specifie un compte" && debut.isNotEmpty && fin.isNotEmpty) {
      ressource? res = await helper.getSpecifyRessource(nomRess);
      int idres = res!.id_ress!;
      compte? cmp = await helper.getSpecifyCompte(idres);
      int id_cmp = cmp!.id!;

      if (ourDb != null) {
        ourDb.then((database) {
          Future<List<depensesCats>> revenies = helper
              .getSpecifyRevenusrecherche(debut, fin, id_cmp, this.idUser!);

          revenies.then((theList) {
            setState(() {
              this.allrevenus = theList;
              if (allrevenus != null) {
                this.count2 = theList.length;
              }
            });
          });
        });
      }
    } else if (nomRess != "Specifie un compte" &&
        debut.isEmpty &&
        fin.isEmpty) {
      ressource? res = await helper.getSpecifyRessource(nomRess);
      int idres = res!.id_ress!;
      compte? cmp = await helper.getSpecifyCompte(idres);
      int id_cmp = cmp!.id!;
      if (ourDb != null) {
        ourDb.then((database) {
          Future<List<depensesCats>> revenies =
              helper.getAllRevenusCats1(id_cmp, this.idUser!);

          revenies.then((theList) {
            setState(() {
              this.allrevenus = theList;
              if (allrevenus != null) {
                this.count2 = theList.length;
              }
            });
          });
        });
      }
    } else if (nomRess == "Specifie un compte" &&
        debut.isNotEmpty &&
        fin.isNotEmpty) {
      if (ourDb != null) {
        ourDb.then((database) {
          Future<List<depensesCats>> revenies =
              helper.getAllRevenusCats2(debut, fin, this.idUser!);

          revenies.then((theList) {
            setState(() {
              this.allrevenus = theList;
              if (allrevenus != null) {
                this.count2 = theList.length;
              }
            });
          });
        });
      }
    } else if (nomRess == "Specifie un compte" &&
        debut.isNotEmpty &&
        fin.isEmpty) {
      if (ourDb != null) {
        ourDb.then((database) {
          Future<List<depensesCats>> revenies =
              helper.getAllRevenusCats3(debut, this.idUser!);
          revenies.then((theList) {
            setState(() {
              this.allrevenus = theList;
              if (allrevenus != null) {
                this.count2 = theList.length;
              }
            });
          });
        });
      }
    } else if (nomRess == "Specifie un compte" &&
        debut.isEmpty &&
        fin.isNotEmpty) {
      if (ourDb != null) {
        ourDb.then((database) {
          Future<List<depensesCats>> revenies =
              helper.getAllRevenusCats4(fin, this.idUser!);

          revenies.then((theList) {
            setState(() {
              this.allrevenus = theList;
              if (allrevenus != null) {
                this.count2 = theList.length;
              }
            });
          });
        });
      }
    } else if (nomRess != "Specifie un compte" &&
        debut.isNotEmpty &&
        fin.isEmpty) {
      ressource? res = await helper.getSpecifyRessource(nomRess);
      int idres = res!.id_ress!;
      compte? cmp = await helper.getSpecifyCompte(idres);
      int id_cmp = cmp!.id!;
      if (ourDb != null) {
        ourDb.then((database) {
          Future<List<depensesCats>> revenies =
              helper.getSpecifyRevenusrecherche2(debut, id_cmp, this.idUser!);

          revenies.then((theList) {
            setState(() {
              this.allrevenus = theList;
              if (allrevenus != null) {
                this.count2 = theList.length;
              }
            });
          });
        });
      }
    } else if (nomRess != "Specifie un compte" &&
        debut.isEmpty &&
        fin.isNotEmpty) {
      ressource? res = await helper.getSpecifyRessource(nomRess);
      int idres = res!.id_ress!;
      compte? cmp = await helper.getSpecifyCompte(idres);
      int id_cmp = cmp!.id!;
      if (ourDb != null) {
        ourDb.then((database) {
          Future<List<depensesCats>> revenies =
              helper.getSpecifyRevenusrecherche3(fin, id_cmp, this.idUser!);

          revenies.then((theList) {
            setState(() {
              this.allrevenus = theList;
              if (allrevenus != null) {
                this.count2 = theList.length;
              }
            });
          });
        });
      }
    }
  }

  getAllDepensesCats(String nomRess, String debut, String fin) async {
    final Future<Database>? db = helper.initialiseDataBase();
    var ourDb = db;

    if (nomRess != "Specifie un compte" && debut.isNotEmpty && fin.isNotEmpty) {
      String dt = DateFormat("dd-MM-yyyy").format(DateTime.parse(debut));
      String fn = DateFormat("dd-MM-yyyy").format(DateTime.parse(fin));
      ressource? res = await helper.getSpecifyRessource(nomRess);
      int idres = res!.id_ress!;
      compte? cmp = await helper.getSpecifyCompte(idres);
      int id_cmp = cmp!.id!;

      if (ourDb != null) {
        ourDb.then((database) {
          Future<List<depensesCats>> depense = helper
              .getSpecifyRechercheDepenses(debut, fin, id_cmp, this.idUser!);

          depense.then((theList) {
            setState(() {
              this.allDepensesCats = theList;
              if (allDepensesCats != null) {
                this.count = theList.length;
              }
            });
          });
        });
      }
    } else if (nomRess != "Specifie un compte" &&
        debut.isEmpty &&
        fin.isEmpty) {
      ressource? res = await helper.getSpecifyRessource(nomRess);
      int idres = res!.id_ress!;
      compte? cmp = await helper.getSpecifyCompte(idres);
      int id_cmp = cmp!.id!;
      if (ourDb != null) {
        ourDb.then((database) {
          Future<List<depensesCats>> depense =
              helper.getSpecifyDepensesCats(id_cmp, this.idUser!);

          depense.then((theList) {
            setState(() {
              this.allDepensesCats = theList;
              if (allDepensesCats != null) {
                this.count = theList.length;
              }
            });
          });
        });
      }
    } else if (nomRess == "Specifie un compte" &&
        debut.isNotEmpty &&
        fin.isNotEmpty) {
      String dt = DateFormat("dd-MM-yyyy").format(DateTime.parse(debut));
      String fn = DateFormat("dd-MM-yyyy").format(DateTime.parse(fin));
      if (ourDb != null) {
        ourDb.then((database) {
          Future<List<depensesCats>> depense =
              helper.getRechercheDepenses(debut, fin, this.idUser!);

          depense.then((theList) {
            setState(() {
              this.allDepensesCats = theList;
              if (allDepensesCats != null) {
                this.count = theList.length;
              }
            });
          });
        });
      }
    } else if (nomRess == "Specifie un compte" &&
        debut.isNotEmpty &&
        fin.isEmpty) {
      String dt = DateFormat("dd-MM-yyyy").format(DateTime.parse(debut));

      if (ourDb != null) {
        ourDb.then((database) {
          Future<List<depensesCats>> depense =
              helper.getRechercheDepenses2(debut, this.idUser!);

          depense.then((theList) {
            setState(() {
              this.allDepensesCats = theList;
              if (allDepensesCats != null) {
                this.count = theList.length;
              }
            });
          });
        });
      }
    } else if (nomRess == "Specifie un compte" &&
        debut.isEmpty &&
        fin.isNotEmpty) {
      String fn = DateFormat("dd-MM-yyyy").format(DateTime.parse(fin));
      if (ourDb != null) {
        ourDb.then((database) {
          Future<List<depensesCats>> depense =
              helper.getRechercheDepenses3(fin, this.idUser!);

          depense.then((theList) {
            setState(() {
              this.allDepensesCats = theList;
              if (allDepensesCats != null) {
                this.count = theList.length;
              }
            });
          });
        });
      }
    } else if (nomRess != "Specifie un compte" &&
        debut.isNotEmpty &&
        fin.isEmpty) {
      String dt = DateFormat("dd-MM-yyyy").format(DateTime.parse(debut));
      ressource? res = await helper.getSpecifyRessource(nomRess);
      int idres = res!.id_ress!;
      compte? cmp = await helper.getSpecifyCompte(idres);
      int id_cmp = cmp!.id!;
      if (ourDb != null) {
        ourDb.then((database) {
          Future<List<depensesCats>> depense =
              helper.getSpecifyDepensesCats2(debut, id_cmp, this.idUser!);

          depense.then((theList) {
            setState(() {
              this.allDepensesCats = theList;
              if (allDepensesCats != null) {
                this.count = theList.length;
              }
            });
          });
        });
      }
    } else if (nomRess != "Specifie un compte" &&
        debut.isEmpty &&
        fin.isNotEmpty) {
      String fn = DateFormat("dd-MM-yyyy").format(DateTime.parse(fin));
      ressource? res = await helper.getSpecifyRessource(nomRess);
      int idres = res!.id_ress!;
      compte? cmp = await helper.getSpecifyCompte(idres);
      int id_cmp = cmp!.id!;
      if (ourDb != null) {
        ourDb.then((database) {
          Future<List<depensesCats>> depense =
              helper.getSpecifyDepensesCats3(fin, id_cmp, this.idUser!);

          depense.then((theList) {
            setState(() {
              this.allDepensesCats = theList;
              if (allDepensesCats != null) {
                this.count = theList.length;
              }
            });
          });
        });
      }
    }
  }

  AlimenteTxt(String nomRess, String debut, String fin) {
    if (nomRess != "Specifie un compte" && debut.isNotEmpty && fin.isNotEmpty) {
      String dt = DateFormat("dd-MM-yyyy").format(DateTime.parse(debut));
      String fn = DateFormat("dd-MM-yyyy").format(DateTime.parse(fin));
      this.txt = "Rapport sur le solde dans '$nomRess' entre $dt et $fn";
    } else if (nomRess != "Specifie un compte" &&
        debut.isEmpty &&
        fin.isEmpty) {
      this.txt = "Rapport sur le solde dans '$nomRessource'";
    } else if (nomRess == "Specifie un compte" &&
        debut.isNotEmpty &&
        fin.isNotEmpty) {
      String dt = DateFormat("dd-MM-yyyy").format(DateTime.parse(debut));
      String fn = DateFormat("dd-MM-yyyy").format(DateTime.parse(fin));
      this.txt = "Rapport sur le solde entre $dt et $fn";
    } else if (nomRess == "Specifie un compte" &&
        debut.isNotEmpty &&
        fin.isEmpty) {
      String dt = DateFormat("dd-MM-yyyy").format(DateTime.parse(debut));
      this.txt = "Rapport sur le solde superieur a $dt";
    } else if (nomRess == "Specifie un compte" &&
        debut.isEmpty &&
        fin.isNotEmpty) {
      String fn = DateFormat("dd-MM-yyyy").format(DateTime.parse(fin));
      this.txt = "Rapport sur le solde inferieur a $fn";
    } else if (nomRess != "Specifie un compte" &&
        debut.isNotEmpty &&
        fin.isEmpty) {
      String dt = DateFormat("dd-MM-yyyy").format(DateTime.parse(debut));
      this.txt = "Rapport sur le solde superieur a $dt dans '$nomRessource'";
    } else if (nomRess != "Specifie un compte" &&
        debut.isEmpty &&
        fin.isNotEmpty) {
      String fn = DateFormat("dd-MM-yyyy").format(DateTime.parse(fin));
      this.txt = "Rapport sur le solde inferieur a $fn dans '$nomRessource'";
    }
  }

  @override
  Widget build(BuildContext context) {
    //print(nomRessource);
    AlimenteTxt(nomRessource!, dateDebut!, dateFin!);
    if (allrevenus == null) {
      getAllRevenusCats(nomRessource!, dateDebut!, dateFin!);
    }

    if (allDepensesCats == null) {
      getAllDepensesCats(nomRessource!, dateDebut!, dateFin!);
    }

    revenus = getUniqueRevenus();
    rvenusCount = revenus.length;
    depenses = getUniqueDepenses();
    depensesCount = depenses.length;
    total = getTotal();
    totalRevenus = getTotalRevenus();

    return Scaffold(
      appBar: AppBar(
        title: Text("Resultas"),
      ),
      body: Column(
        children: [
          Padding(
              padding: EdgeInsets.only(top: 20),
              child: Card(
                child: Text(
                  "$txt ",
                  style: TextStyle(fontSize: 18),
                ),
              )),
          Padding(
            padding: EdgeInsets.only(top: 10),
            child: ListTile(
              title: Text("Revenus"),
              trailing: Text("$totalRevenus"),
            ),
          ),
          Expanded(
            child: ListView.builder(
              //itemBuilder: ,
              itemCount: rvenusCount,
              itemBuilder: (context, pos) {
                return Card(
                  color: Colors.white,
                  //elevation: 2.0,
                  child: ListTile(
                    title: Text("${revenus[pos].nomcat}"),
                    trailing: Text("${revenus[pos].montant}"),
                  ),
                );
              },
            ),
          ),
          ListTile(
            title: Text("depenses"),
            trailing: Text("$total"),
          ),
          Expanded(
              child: ListView.builder(
                  itemCount: depensesCount,
                  itemBuilder: (context, pos) {
                    return Card(
                      child: ListTile(
                        title: Text("${depenses[pos].nomcat}"),
                        trailing: Text("${depenses[pos].montant}"),
                      ),
                    );
                  })),
        ],
      ),
    );
  }
}
