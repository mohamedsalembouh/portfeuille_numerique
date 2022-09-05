import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:portfeuille_numerique/resultasRecherche.dart';

import 'methodes.dart';
import 'models/compteRessource.dart';
import 'models/utilisateur.dart';

class rechercheRapport extends StatefulWidget {
  // const rechercheRapport({Key? key}) : super(key: key);
  int? idUser;
  rechercheRapport(this.idUser);

  @override
  State<rechercheRapport> createState() => _rechercheRapportState(this.idUser);
}

class _rechercheRapportState extends State<rechercheRapport> {
  int? idUser;
  _rechercheRapportState(this.idUser);
  TextEditingController dateDebut = TextEditingController();
  TextEditingController dateFin = TextEditingController();
  String nomRessource = "Specifie un compte";

  @override
  Widget build(BuildContext context) {
    print(nomRessource);
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 30),
            child: Container(
              child: Card(
                //color: Colors.white70,
                child: Form(
                  child: Column(
                    children: [
                      Text(
                          "Recherche par date ou par sepicific compte ou par les deux "),
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

                            setState(() {
                              dateDebut.text =
                                  DateFormat("yyyy-MM-dd").format(pickeddate!);
                            });
                          },
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 10, bottom: 10),
                        //const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                        child: TextFormField(
                          controller: dateFin,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "entrer la date d'echeance";
                            }
                            return null;
                          },
                          //keyboardType: TextInputType.datetime,
                          decoration: const InputDecoration(
                            border: UnderlineInputBorder(),
                            labelText: "Date fin ",
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
                                dateFin.text =
                                    DateFormat("yyyy-MM-dd").format(pickeddate);
                              });
                            }
                          },
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 10, left: 10, bottom: 10),
                        child: FutureBuilder(
                            future: getComptesRessource(this.idUser!),
                            builder: (BuildContext context,
                                AsyncSnapshot<List<compteRessource>> snapshot) {
                              if (!snapshot.hasData) {
                                return CircularProgressIndicator();
                              } else {
                                return DropdownButton<String>(
                                  items: snapshot.data!
                                      .map((cmpRes) => DropdownMenuItem<String>(
                                            child: Text(cmpRes.nom_ress!),
                                            value: cmpRes.nom_ress,
                                          ))
                                      .toList(),
                                  onChanged: (String? value) {
                                    setState(() {
                                      nomRessource = value!;
                                    });
                                  },

                                  isExpanded: true,
                                  //value: currentNomCat,
                                  hint: Text(
                                    '$nomRessource',
                                    style: TextStyle(
                                      fontSize: 17,
                                      //fontWeight: FontWeight.bold
                                    ),
                                  ),
                                );
                              }
                            }),
                      ),
                      ElevatedButton(
                          onPressed: () {
                            if (dateDebut.text.isEmpty &&
                                dateFin.text.isEmpty &&
                                nomRessource == "Specifie un compte") {
                              showText(context, "SVP",
                                  "choissisez un date ou specifie un compte");
                            } else {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => resultasRecherche(
                                          this.idUser!,
                                          dateDebut.text,
                                          dateFin.text,
                                          nomRessource)));
                            }
                          },
                          child: Text("Rechercher"))
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
