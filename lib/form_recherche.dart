import 'package:flutter/material.dart';
import 'package:get/get.dart';
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
  String nomRessource = "72".tr;

  @override
  Widget build(BuildContext context) {
    print(nomRessource);
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              child: Form(
                child: Column(
                  children: [
                    SizedBox(
                      height: 30,
                    ),
                    Center(
                      child: Text("78".tr),
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 10, right: 10),
                      //const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                      child: TextFormField(
                        controller: dateDebut,
                        readOnly: true,
                        decoration: InputDecoration(
                            labelText: "47".tr,
                            border: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(20.0)),
                              borderSide: BorderSide(color: Colors.white),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(20.0)),
                              borderSide: BorderSide(color: Colors.black),
                            )),
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
                    SizedBox(
                      height: 30,
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 10, right: 10),
                      //const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                      child: TextFormField(
                        controller: dateFin,
                        readOnly: true,
                        decoration: InputDecoration(
                            labelText: "48".tr,
                            border: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(20.0)),
                              borderSide: BorderSide(color: Colors.white),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(20.0)),
                              borderSide: BorderSide(color: Colors.black),
                            )),
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
                    SizedBox(
                      height: 30,
                    ),
                    Padding(
                      padding: EdgeInsets.only(right: 10, left: 10),
                      child: FutureBuilder(
                          future: getComptesRessource(this.idUser!),
                          builder: (BuildContext context,
                              AsyncSnapshot<List<compteRessource>> snapshot) {
                            if (!snapshot.hasData) {
                              return CircularProgressIndicator();
                            } else {
                              return DropdownButtonFormField<String>(
                                decoration: InputDecoration(
                                    // labelText: "Destination",
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(20.0)),
                                      borderSide:
                                          BorderSide(color: Colors.white),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(20.0)),
                                      borderSide:
                                          BorderSide(color: Colors.black),
                                    )),
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
                    SizedBox(
                      height: 30,
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width / 3,
                      height: MediaQuery.of(context).size.width / 6,
                      child: ElevatedButton(
                        onPressed: () {
                          if (dateDebut.text.isEmpty &&
                              dateFin.text.isEmpty &&
                              nomRessource == "72".tr) {
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
                        child: Text("74".tr),
                        style: ElevatedButton.styleFrom(shape: StadiumBorder()),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
