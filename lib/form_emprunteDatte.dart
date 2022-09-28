import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:portfeuille_numerique/db/sql_helper.dart';
import 'package:portfeuille_numerique/dettes.dart';
import 'package:portfeuille_numerique/main.dart';
import 'package:portfeuille_numerique/models/emprunte_dette.dart';
import 'package:portfeuille_numerique/models/utilisateur.dart';
import 'package:toast/toast.dart';
import 'methodes.dart';
import 'models/compte.dart';
import 'models/compteRessource.dart';
import 'models/ressource.dart';
import 'package:get/get.dart';

class formemprunte extends StatefulWidget {
  utilisateur? usr;

  //const formemprunte({Key? key}) : super(key: key);
  formemprunte(this.usr);

  @override
  State<formemprunte> createState() => _formemprunteState(this.usr);
}

class _formemprunteState extends State<formemprunte> {
  utilisateur? usr;
  // List<diagrameSolde> allUpdateSolde = [];
  _formemprunteState(this.usr);
  final _formKey = GlobalKey<FormState>();
  TextEditingController nom = TextEditingController();
  TextEditingController objet = TextEditingController();
  TextEditingController montant = TextEditingController();
  TextEditingController dateDebut = TextEditingController();
  TextEditingController dateEcheance = TextEditingController();
  SQL_Helper helper = SQL_Helper();
  //String defaultDateDebut = DateFormat("yyy-MM-dd").format(DateTime.now());
  String TypeCompte = "25".tr;

  insertEmprunteDette(String nom, String objectif, String montant,
      String dateDebut, String dateEcheance) async {
    DateTime maintenant = DateTime.now();
    String date_maintenant = DateFormat("yyyy-MM-dd").format(maintenant);
    final form = _formKey.currentState;

    // DateTime now = DateTime.now();
    // String dateDebut = now.toString();

    if (form!.validate()) {
      if (TypeCompte != "25".tr) {
        ressource? res = await helper.getSpecifyRessource(TypeCompte);
        int id_res = res!.id_ress!;
        compte? cmp = await helper.getSpecifyCompte(id_res);
        int id_compte = cmp!.id!;
        emprunte_dette emprunteDette;
        if (sharedpref!.getBool("statusDette") == true) {
          emprunteDette = emprunte_dette(
              nom,
              objectif,
              int.parse(montant),
              date_maintenant,
              dateDebut,
              dateEcheance,
              0,
              0,
              id_compte,
              this.usr!.id);
        } else {
          emprunteDette = emprunte_dette(
              nom,
              objectif,
              int.parse(montant),
              date_maintenant,
              dateDebut,
              dateEcheance,
              0,
              1,
              id_compte,
              this.usr!.id);
        }
        int x = await helper.insert_EmprunteDatte(emprunteDette);
        if (x > 0) {
          print("inserted ");
          PlusSolde(int.parse(montant), TypeCompte);
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => alldettes(usr, 0)));
        } else {
          print("not inserted");
        }
      } else {
        Toast.show("t2".tr);
      }
    }
  }

  PlusSolde(int mnt, String typeCmp) async {
    DateTime maintenant = DateTime.now();
    String date_maintenant = DateFormat("yyyy-MM-dd").format(maintenant);
    utilisateur? user =
        await helper.getUser(this.usr!.email!, this.usr!.password!);
    int a = user!.id!;
    ressource? res = await helper.getSpecifyRessource(typeCmp);
    int id_res = res!.id_ress!;
    compte? cmp = await helper.getCompteUser(a, id_res);
    if (cmp != null) {
      int solde = cmp.solde!;
      int newSolde = solde + mnt;
      compte updateCompte = compte(newSolde, date_maintenant, id_res, a);
      helper.update_compte(updateCompte);
      insertArgent(updateCompte.solde!, updateCompte.date!,
          updateCompte.id_ressource!, updateCompte.id_utilisateur!);
    } else {
      compte newCompte = compte(mnt, date_maintenant, id_res, a);
      helper.insert_compte(newCompte);
      insertArgent(newCompte.solde!, newCompte.date!, newCompte.id_ressource!,
          newCompte.id_utilisateur!);
    }
    // this.allUpdateSolde =
    //     getListSoldes(this.allUpdateSolde!, typeCmp, this.usr!.id!);
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
                                  "49".tr,
                                  style: TextStyle(fontSize: 25),
                                )),
                            Padding(
                              padding: EdgeInsets.only(bottom: 10, left: 10),
                              // padding: EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                              child: TextFormField(
                                controller: nom,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return "entrer nom de ce que vous avez empruntez";
                                  }
                                  return null;
                                },
                                decoration: InputDecoration(
                                  border: UnderlineInputBorder(),
                                  labelText: "50".tr,
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
                                    return "entrer le montant que vous avez empruntez";
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
                                            TypeCompte = value!;
                                          });
                                        },
                                        isExpanded: true,
                                        //value: currentNomCat,
                                        hint: Text(
                                          '$TypeCompte',
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
                                        insertEmprunteDette(
                                            nom.text,
                                            objet.text,
                                            montant.text,
                                            dateDebut.text,
                                            dateEcheance.text);
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

  // utilisateur? usr;
  // _formemprunteState(this.usr);
  // @override
  // Widget build(BuildContext context) {
  //   return Scaffold(
  //     appBar: AppBar(
  //       title: Text("Emprunte dettes"),
  //     ),
  //     body: Column(
  //       children: [
  //         Container(
  //           child: Column(
  //             crossAxisAlignment: CrossAxisAlignment.start,
  //             children: <Widget>[
  //               const Padding(
  //                 padding: EdgeInsets.symmetric(horizontal: 8, vertical: 16),
  //                 child: TextField(
  //                   decoration: InputDecoration(
  //                     border: UnderlineInputBorder(),
  //                     hintText: 'A qui avez vous emprunte',
  //                   ),
  //                 ),
  //               ),
  //               Padding(
  //                 padding:
  //                     const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
  //                 child: TextFormField(
  //                   decoration: const InputDecoration(
  //                     border: UnderlineInputBorder(),
  //                     labelText: "L'objet de cette dette",
  //                   ),
  //                 ),
  //               ),
  //               Padding(
  //                 padding:
  //                     const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
  //                 child: TextFormField(
  //                   decoration: const InputDecoration(
  //                     border: UnderlineInputBorder(),
  //                     labelText: "Montant",
  //                   ),
  //                 ),
  //               ),
  //               Padding(
  //                 padding:
  //                     const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
  //                 child: TextFormField(
  //                   decoration: const InputDecoration(
  //                     border: UnderlineInputBorder(),
  //                     labelText: "Date ",
  //                   ),
  //                 ),
  //               ),
  //               Padding(
  //                 padding:
  //                     const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
  //                 child: TextFormField(
  //                   decoration: const InputDecoration(
  //                     border: UnderlineInputBorder(),
  //                     labelText: "Date d'echeance ",
  //                   ),
  //                 ),
  //               ),
  //               Padding(
  //                 padding: EdgeInsets.only(top: 20, left: 200),
  //                 child: Row(
  //                   children: [
  //                     Padding(
  //                       padding: EdgeInsets.only(right: 30),
  //                       child: ElevatedButton(
  //                         onPressed: () {},
  //                         child: Text('Cancel'),
  //                       ),
  //                     ),
  //                     Padding(
  //                       padding: EdgeInsets.only(),
  //                       child: ElevatedButton(
  //                         onPressed: () {},
  //                         child: Text('Submit'),
  //                       ),
  //                     ),
  //                   ],
  //                 ),
  //               )
  //             ],
  //           ),
  //         ),
  //       ],
  //     ),
  //   );
  // }
}
