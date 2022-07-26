import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:portfeuille_numerique/db/sql_helper.dart';
import 'package:portfeuille_numerique/dettes.dart';
import 'package:portfeuille_numerique/models/emprunte_dette.dart';
import 'package:portfeuille_numerique/models/utilisateur.dart';

import 'models/compte.dart';

class formemprunte extends StatefulWidget {
  utilisateur? usr;
  //const formemprunte({Key? key}) : super(key: key);
  formemprunte(this.usr);

  @override
  State<formemprunte> createState() => _formemprunteState(this.usr);
}

class _formemprunteState extends State<formemprunte> {
  utilisateur? usr;
  _formemprunteState(this.usr);
  final _formKey = GlobalKey<FormState>();
  TextEditingController nom = TextEditingController();
  TextEditingController objet = TextEditingController();
  TextEditingController montant = TextEditingController();
  TextEditingController dateDebut = TextEditingController();
  TextEditingController dateEcheance = TextEditingController();
  SQL_Helper helper = SQL_Helper();
  //String defaultDateDebut = DateFormat("yyy-MM-dd").format(DateTime.now());

  insertEmprunteDette(String nom, String objectif, String montant,
      String dateDebut, String dateEcheance) async {
    final form = _formKey.currentState;
    utilisateur? user =
        await helper.getUser(this.usr!.email!, this.usr!.password!);
    int a = user!.id!;
    // DateTime now = DateTime.now();
    // String dateDebut = now.toString();

    if (form!.validate()) {
      emprunte_dette emprunteDette = emprunte_dette(
          nom, objectif, int.parse(montant), dateDebut, dateEcheance, 0, a);
      int x = await helper.insert_EmprunteDatte(emprunteDette);
      if (x > 0) {
        print("inserted ");
        PlusSolde(int.parse(montant));
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => alldettes(usr, 0)));
      } else {
        print("not inserted");
      }
    }
  }

  PlusSolde(int mnt) async {
    utilisateur? user =
        await helper.getUser(this.usr!.email!, this.usr!.password!);
    int a = user!.id!;
    compte? cmp = await helper.getCompteUser(a);
    if (cmp != null) {
      int solde = cmp.solde!;
      int newSolde = solde + mnt;
      compte updateCompte = compte(newSolde, a);
      helper.update_compte(updateCompte);
    } else {
      compte newCompte = compte(mnt, a);
      helper.insert_compte(newCompte);
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
                                  "Nouveaux Emprunte Dette",
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
                                decoration: const InputDecoration(
                                  border: UnderlineInputBorder(),
                                  labelText: "A qui avez vous emprunte",
                                ),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(bottom: 10, left: 10),
                              // const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                              child: TextFormField(
                                controller: objet,
                                decoration: const InputDecoration(
                                  border: UnderlineInputBorder(),
                                  labelText: "L'objet de cette dette",
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
                                decoration: const InputDecoration(
                                  border: UnderlineInputBorder(),
                                  labelText: "Montant",
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
                                  labelText: "Date debut ",
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
                              padding: EdgeInsets.only(left: 10),
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
                                decoration: const InputDecoration(
                                  border: UnderlineInputBorder(),
                                  labelText: "Date d'echeance ",
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
                              padding: EdgeInsets.only(top: 40, left: 100),
                              child: Row(
                                children: [
                                  Padding(
                                    padding: EdgeInsets.only(right: 30),
                                    child: ElevatedButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                      child: Text('Annuler'),
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
                                      child: Text('Enregistrer'),
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
