import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:portfeuille_numerique/categories.dart';
import 'package:portfeuille_numerique/db/sql_helper.dart';
import 'package:portfeuille_numerique/dettes.dart';
import 'package:portfeuille_numerique/methodes.dart';
import 'package:portfeuille_numerique/models/categorie.dart';
import 'package:portfeuille_numerique/models/operation_entree.dart';
import 'package:portfeuille_numerique/models/operation_sortir.dart';
import 'package:toast/toast.dart';

class operation extends StatefulWidget {
  operation({Key? key}) : super(key: key);
  String? nomCategorie;
  int selectedPage = 0;
  operation.withnom(this.selectedPage, this.nomCategorie);
  @override
  State<operation> createState() =>
      _operationState(this.selectedPage, this.nomCategorie);
}

class _operationState extends State<operation> {
  final _formKey = new GlobalKey<FormState>();
  TextEditingController entreeMontant = TextEditingController();
  TextEditingController entreeDesc = TextEditingController();
  TextEditingController sortirMontant = TextEditingController();
  TextEditingController sortirDesc = TextEditingController();
  String? nomcategorie;
  int? selectedPage;
  _operationState(this.selectedPage, this.nomcategorie);
  final List<Tab> mytabs = [
    Tab(
      text: "Entree",
    ),
    Tab(
      text: "Depenses",
    )
  ];

  SQL_Helper helper = new SQL_Helper();
  String currentNomCat = "Choisir une categorie";
  insertRevenus(int montant, String description) async {
    // final form = _formKey.currentState;
    // if (form!.validate()) {
    // if (montant == 0) {
    //   Toast.show("entrer montant");
    // }
    if (currentNomCat != "Choisir une categorie") {
      categorie? cat = await helper.getSpecifyCategorie(currentNomCat);
      int idCat = cat!.id!;
      operation_entree entree =
          new operation_entree(montant, description, idCat);
      int a = await helper.insertOperationEntree(entree);
      if (a != 0) {
        print("operation inserted");
      } else {
        print("not inserted");
      }
    } else {
      print("no categorie");
      Toast.show("choisis une categorie SVP");
    }
  }

  insertDepense(int montant, String description) async {
    categorie? cat = await helper.getSpecifyCategorie(currentNomCat);
    int idCat = cat!.id!;
    operation_sortir sortir = new operation_sortir(montant, description, idCat);
    int a = await helper.insertOperationSortir(sortir);
    if (a != 0) {
      print("operation sortir inserted");
    } else {
      print("not inserted");
    }
  }

  Future<List<categorie>> achatsCategorie() async {
    List<categorie> achatCategorieList = await helper.getAllcategories();
    return achatCategorieList;
  }

  //categorie? _currentCategorie;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "",
      home: DefaultTabController(
        initialIndex: selectedPage!,
        length: mytabs.length,
        child: Scaffold(
          appBar: AppBar(
              toolbarHeight: 100,
              bottom: TabBar(tabs: mytabs),
              title: Text("Operations")),
          // drawer: drowerfunction(context),
          body: TabBarView(
            children: [
              Column(
                children: [
                  Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.only(top: 30, bottom: 10),
                        child: FutureBuilder(
                            future: achatsCategorie(),
                            builder: (BuildContext context,
                                AsyncSnapshot<List<categorie>> snapshot) {
                              if (!snapshot.hasData) {
                                return CircularProgressIndicator();
                              } else {
                                return DropdownButton<String>(
                                  items: snapshot.data!
                                      .map((cat) => DropdownMenuItem<String>(
                                            child: Text(cat.nom!),
                                            value: cat.nom,
                                          ))
                                      .toList(),
                                  onChanged: (String? value) {
                                    setState(() {
                                      currentNomCat = value!;
                                    });
                                  },
                                  isExpanded: true,
                                  //value: currentNomCat,
                                  hint: Text(
                                    '$currentNomCat',
                                    style: TextStyle(
                                      fontSize: 20,
                                      //fontWeight: FontWeight.bold
                                    ),
                                  ),
                                );
                              }
                            }),
                      ),
                      // SizedBox(height: 20.0),
                      // _currentCategorie != null
                      //     ? Text("Name: " + _currentCategorie!.nom!)
                      //     : Text("No User selected"),
                      // Padding(
                      //   padding: EdgeInsets.only(),
                      //   child: Row(
                      //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      //     children: [
                      //       Row(
                      //         children: [
                      //           RaisedButton(
                      //             onPressed: () {
                      //               Navigator.push(
                      //                   context,
                      //                   MaterialPageRoute(
                      //                       builder: (context) =>
                      //                           listCategories.withNumber(0)));
                      //             },
                      //             child: Text(
                      //               "Choisir une categorie",
                      //               //style: TextStyle(color: Colors.orange),
                      //             ),
                      //           ),
                      //         ],
                      //       ),
                      //     ],
                      //   ),
                      // ),
                      Padding(
                        padding: EdgeInsets.only(top: 20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Icon(Icons.add),
                            Container(
                              width: 300,
                              height: 50,
                              child: TextFormField(
                                // initialValue: 1,
                                controller: entreeMontant,
                                keyboardType: TextInputType.number,
                                decoration: InputDecoration(
                                    hintText: 'Montant',
                                    border: OutlineInputBorder()),
                                style: TextStyle(fontSize: 20),
                              ),
                            ),
                            Text(
                              "MRU",
                              style: TextStyle(
                                  fontSize: 30, backgroundColor: Colors.green),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 20, right: 50),
                        child: Container(
                          width: 300,
                          height: 50,
                          child: TextFormField(
                            controller: entreeDesc,
                            decoration: InputDecoration(
                                hintText: 'description',
                                border: OutlineInputBorder()),
                            style: TextStyle(fontSize: 20),
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 40, right: 100),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            RaisedButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: Text(
                                "Cancel",
                                style: TextStyle(color: Colors.white),
                              ),
                              color: Colors.red,
                            ),
                            RaisedButton(
                              onPressed: () {
                                if (entreeMontant.text == "") {
                                  Toast.show("entree montant");
                                } else if (currentNomCat ==
                                    "Choisir une categorie") {
                                  Toast.show("choisir une categorie SVP");
                                } else {
                                  insertRevenus(int.parse(entreeMontant.text),
                                      entreeDesc.text);
                                  int montant = int.parse(entreeMontant.text);
                                  Map<int, int> myData = new Map();
                                  myData[0] = 0;
                                  myData[1] = montant;
                                  Navigator.of(context).pop(myData);
                                  // Navigator.pop(context, myData);
                                }
                                //insertRevenus(int.parse(entreeMontant.text),
                                //entreeDesc.text);
                                // Navigator.pop(context);
                                // print(nomcategorie);
                              },
                              child: Text(
                                "Save",
                                style: TextStyle(color: Colors.white),
                              ),
                              color: Colors.green,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              //le deuscieme tab
              Column(
                children: [
                  Padding(
                    padding: EdgeInsets.only(top: 30, bottom: 10),
                    child: FutureBuilder(
                        future: achatsCategorie(),
                        builder: (BuildContext context,
                            AsyncSnapshot<List<categorie>> snapshot) {
                          if (!snapshot.hasData) {
                            return CircularProgressIndicator();
                          } else {
                            return DropdownButton<String>(
                              items: snapshot.data!
                                  .map((cat) => DropdownMenuItem<String>(
                                        child: Text(cat.nom!),
                                        value: cat.nom,
                                      ))
                                  .toList(),
                              onChanged: (String? value) {
                                setState(() {
                                  currentNomCat = value!;
                                });
                              },
                              isExpanded: true,
                              //value: currentNomCat,
                              hint: Text(
                                '$currentNomCat',
                                style: TextStyle(
                                  fontSize: 20,
                                  //fontWeight: FontWeight.bold
                                ),
                              ),
                            );
                          }
                        }),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Icon(Icons.remove),
                        Container(
                          width: 300,
                          height: 50,
                          child: TextField(
                            controller: sortirMontant,
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                                hintText: 'Montant',
                                border: OutlineInputBorder()),
                            style: TextStyle(fontSize: 20),
                          ),
                        ),
                        Text(
                          "MRU",
                          style: TextStyle(
                              fontSize: 30, backgroundColor: Colors.green),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 20, right: 50),
                    child: Container(
                      width: 300,
                      height: 50,
                      child: TextField(
                        controller: sortirDesc,
                        decoration: InputDecoration(
                            hintText: 'description',
                            border: OutlineInputBorder()),
                        style: TextStyle(fontSize: 20),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 40, right: 100),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        RaisedButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: Text(
                            "Cancel",
                            style: TextStyle(color: Colors.white),
                          ),
                          color: Colors.red,
                        ),
                        RaisedButton(
                          onPressed: () {
                            if (sortirMontant.text == "") {
                              Toast.show("entree montant");
                            } else if (currentNomCat ==
                                "Choisir une categorie") {
                              Toast.show("choisir une categorie SVP");
                            } else {
                              insertDepense(int.parse(sortirMontant.text),
                                  sortirDesc.text);
                              int montant = int.parse(sortirMontant.text);
                              Map<int, int> myData = new Map();
                              myData[0] = 1;
                              myData[1] = montant;
                              Navigator.of(context).pop(myData);
                            }
                          },
                          child: Text(
                            "Save",
                            style: TextStyle(color: Colors.white),
                          ),
                          color: Colors.green,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
