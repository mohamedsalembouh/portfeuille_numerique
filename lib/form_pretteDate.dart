import 'package:flutter/material.dart';
import 'package:portfeuille_numerique/dettes.dart';
import 'package:portfeuille_numerique/methodes.dart';
import 'package:portfeuille_numerique/models/prette_dette.dart';
import 'package:portfeuille_numerique/models/utilisateur.dart';
import 'package:intl/intl.dart';

import 'models/compte.dart';

class form_prette extends StatefulWidget {
  // const form_prette({Key? key}) : super(key: key);
  utilisateur? usr;
  form_prette(this.usr);

  @override
  State<form_prette> createState() => _form_pretteState(this.usr);
}

class _form_pretteState extends State<form_prette> {
  utilisateur? usr;
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
    final form = _formKey.currentState;
    utilisateur? user =
        await helper.getUser(this.usr!.email!, this.usr!.password!);
    int a = user!.id!;
    // DateTime now = DateTime.now();
    // String dateDebut = now.toString();

    if (form!.validate()) {
      prette_dette pretteDette = prette_dette(
          nom, objectif, int.parse(montant), dateDebut, dateEcheance, a);
      int x = await helper.insert_pretteDatte(pretteDette);
      if (x > 0) {
        print("inserted ");
      } else {
        print("not inserted");
      }
    }
  }

  minsSolde(String value) async {
    int mnt = int.parse(value);
    utilisateur? user =
        await helper.getUser(this.usr!.email!, this.usr!.password!);
    int a = user!.id!;
    compte? cmp = await helper.getCompteUser(a);
    if (cmp != null) {
      int solde = cmp.solde!;
      if (solde > mnt) {
        int newSolde = solde - mnt;
        compte updateCompte = compte(newSolde, a);
        helper.update_compte(updateCompte);
        insertPretteDette(nom.text, objet.text, montant.text, dateDebut.text,
            dateEcheance.text);

        Navigator.push(
            context, MaterialPageRoute(builder: (context) => alldettes(usr)));
      } else {
        showText(context, "désolé",
            "Le montant que vous entree est plus grand que votre solde ");
      }
    } else {
      showText(context, "désolé", "Vous n'avez pas de solde");
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
                                  "Nouveaux Prette Dette",
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
                                decoration: const InputDecoration(
                                  border: UnderlineInputBorder(),
                                  labelText: "A qui avez vous prette",
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
                                    return "entrer le montant que vous avez prettez";
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
                                        minsSolde(montant.text);
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
}
