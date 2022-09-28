import 'package:flutter/material.dart';
import 'package:portfeuille_numerique/dettes.dart';
import 'package:portfeuille_numerique/main.dart';
import 'package:portfeuille_numerique/methodes.dart';
import 'package:portfeuille_numerique/models/prette_dette.dart';
import 'package:portfeuille_numerique/models/utilisateur.dart';
import 'package:intl/intl.dart';
import 'package:toast/toast.dart';
import 'models/compte.dart';
import 'models/compteRessource.dart';
import 'models/ressource.dart';
import 'package:get/get.dart';

class form_prette extends StatefulWidget {
  // const form_prette({Key? key}) : super(key: key);
  utilisateur? usr;
  form_prette(this.usr);

  @override
  State<form_prette> createState() => _form_pretteState(this.usr);
}

class _form_pretteState extends State<form_prette> {
  utilisateur? usr;
  // List<diagrameSolde> allUpdateSolde = [];
  _form_pretteState(this.usr);
  final _formKey = GlobalKey<FormState>();
  TextEditingController nom = TextEditingController();
  TextEditingController objet = TextEditingController();
  TextEditingController montant = TextEditingController();
  TextEditingController dateDebut = TextEditingController();
  TextEditingController dateEcheance = TextEditingController();
  //String defaultDateDebut = DateFormat("yyy-MM-dd").format(DateTime.now());

  insertPretteDette(String nom, String objectif, String montant,
      String dateDebut, String dateEcheance) async {
    DateTime maintenant = DateTime.now();
    String date_maintenant = DateFormat("yyyy-MM-dd").format(maintenant);
    final form = _formKey.currentState;
    utilisateur? user =
        await helper.getUser(this.usr!.email!, this.usr!.password!);
    int a = user!.id!;
    ressource? res = await helper.getSpecifyRessource(typeCmp);
    int id_res = res!.id_ress!;
    compte? cmp = await helper.getSpecifyCompte(id_res);
    int id_compte = cmp!.id!;

    if (form!.validate()) {
      prette_dette pretteDette;
      if (sharedpref!.getBool("statusDette") == true) {
        pretteDette = prette_dette(nom, objectif, int.parse(montant),
            date_maintenant, dateDebut, dateEcheance, 0, 0, id_compte, a);
      } else {
        pretteDette = prette_dette(nom, objectif, int.parse(montant),
            date_maintenant, dateDebut, dateEcheance, 0, 1, id_compte, a);
      }
      int x = await helper.insert_pretteDatte(pretteDette);
      if (x > 0) {
        print("inserted ");
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => alldettes(usr, 0)));
      } else {
        print("not inserted");
      }
    }
  }

  String typeCmp = "25".tr;
  minsSolde(String value, String typecomp) async {
    DateTime maintenant = DateTime.now();
    String date_maintenant = DateFormat("yyyy-MM-dd").format(maintenant);
    final form = _formKey.currentState;
    if (form!.validate()) {
      if (typeCmp != "25".tr) {
        ressource? res = await helper.getSpecifyRessource(typeCmp);
        int id_res = res!.id_ress!;
        int mnt = int.parse(value);

        compte? cmp = await helper.getCompteUser(this.usr!.id!, id_res);
        if (cmp != null) {
          int solde = cmp.solde!;
          if (solde > mnt) {
            int newSolde = solde - mnt;
            compte updateCompte =
                compte(newSolde, date_maintenant, id_res, this.usr!.id);
            helper.update_compte(updateCompte);
            insertArgent(updateCompte.solde!, updateCompte.date!,
                updateCompte.id_ressource!, updateCompte.id_utilisateur!);
            insertPretteDette(nom.text, objet.text, montant.text,
                dateDebut.text, dateEcheance.text);
          } else {
            showText(context, "désolé",
                "Le montant que vous entree est plus grand que votre solde dans $typeCmp");
          }
        } else {
          showText(context, "désolé", "Vous n'avez pas de solde dans $typeCmp");
        }
      } else {
        Toast.show("t2".tr);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
          //title: Text("Prette dettes"),
          ),
      body: Column(
        children: [
          Container(
            child: Padding(
              padding: EdgeInsets.only(top: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Center(
                    child: Container(
                      color: Colors.white70,
                      width: MediaQuery.of(context).size.width - 50,
                      child: Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            Padding(
                                padding: EdgeInsets.only(bottom: 20),
                                child: Text(
                                  "44".tr,
                                  style: TextStyle(fontSize: 25),
                                )),
                            Padding(
                              padding: EdgeInsets.only(bottom: 10, left: 10),
                              // padding: EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                              child: TextFormField(
                                controller: nom,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return "entrer nom de ce que vous avez prette";
                                  }
                                  return null;
                                },
                                decoration: InputDecoration(
                                  border: UnderlineInputBorder(),
                                  labelText: "45".tr,
                                ),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(bottom: 10, left: 10),
                              // const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                              child: TextFormField(
                                controller: objet,
                                decoration: InputDecoration(
                                  border: UnderlineInputBorder(),
                                  labelText: "46".tr,
                                ),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(bottom: 10, left: 10),

                              //const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                              child: TextFormField(
                                controller: montant,
                                keyboardType: TextInputType.number,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return "entrer le montant que vous avez prettez";
                                  }
                                  return null;
                                },
                                decoration: InputDecoration(
                                  border: UnderlineInputBorder(),
                                  labelText: "22".tr,
                                ),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(left: 10, bottom: 10),
                              //const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                              child: TextFormField(
                                controller: dateDebut,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return "entrer la date de debut";
                                  }
                                  return null;
                                },
                                //keyboardType: TextInputType.datetime,
                                decoration: InputDecoration(
                                  border: UnderlineInputBorder(),
                                  labelText: "47".tr,
                                  icon: Icon(Icons.calendar_today_outlined),
                                ),
                                onTap: () async {
                                  DateTime? pickeddate = await showDatePicker(
                                      context: context,
                                      initialDate: DateTime.now(),
                                      firstDate: DateTime(2000),
                                      lastDate: DateTime(2050));

                                  if (pickeddate == null) {
                                    pickeddate = DateTime.now();
                                  }
                                  setState(() {
                                    dateDebut.text = DateFormat("yyyy-MM-dd")
                                        .format(pickeddate!);
                                  });
                                },
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(left: 10, bottom: 10),
                              //const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                              child: TextFormField(
                                controller: dateEcheance,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return "entrer la date d'echeance";
                                  }
                                  return null;
                                },
                                //keyboardType: TextInputType.datetime,
                                decoration: InputDecoration(
                                  border: UnderlineInputBorder(),
                                  labelText: "48".tr,
                                  icon: Icon(Icons.calendar_today_outlined),
                                ),
                                onTap: () async {
                                  DateTime? pickeddate = await showDatePicker(
                                      context: context,
                                      initialDate: DateTime.now(),
                                      firstDate: DateTime(2000),
                                      lastDate: DateTime(2050));

                                  if (pickeddate != null) {
                                    setState(() {
                                      dateEcheance.text =
                                          DateFormat("yyyy-MM-dd")
                                              .format(pickeddate);
                                    });
                                  }
                                },
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(top: 30, left: 10),
                              child: FutureBuilder(
                                  future: getComptesRessource(this.usr!.id!),
                                  builder: (BuildContext context,
                                      AsyncSnapshot<List<compteRessource>>
                                          snapshot) {
                                    if (!snapshot.hasData) {
                                      return CircularProgressIndicator();
                                    } else {
                                      return DropdownButton<String>(
                                        items: snapshot.data!
                                            .map((cmpRes) =>
                                                DropdownMenuItem<String>(
                                                  child: Text(cmpRes.nom_ress!),
                                                  value: cmpRes.nom_ress,
                                                ))
                                            .toList(),
                                        onChanged: (String? value) {
                                          setState(() {
                                            typeCmp = value!;
                                          });
                                        },
                                        isExpanded: true,
                                        //value: currentNomCat,
                                        hint: Text(
                                          '$typeCmp',
                                          style: TextStyle(
                                            fontSize: 17,
                                            //fontWeight: FontWeight.bold
                                          ),
                                        ),
                                      );
                                    }
                                  }),
                            ),
                            Padding(
                              padding: EdgeInsets.only(top: 40, left: 100),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  Padding(
                                    padding: EdgeInsets.only(right: 30),
                                    child: ElevatedButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                      child: Text('26'.tr),
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(),
                                    child: ElevatedButton(
                                      onPressed: () {
                                        minsSolde(montant.text, typeCmp);
                                      },
                                      child: Text('27'.tr),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
