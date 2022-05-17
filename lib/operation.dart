import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:portfeuille_numerique/categories.dart';
import 'package:portfeuille_numerique/dettes.dart';
import 'package:portfeuille_numerique/homePage.dart';

class operation extends StatefulWidget {
  const operation({Key? key}) : super(key: key);

  @override
  State<operation> createState() => _operationState();
}

class _operationState extends State<operation> {
  final List<Tab> mytabs = [
    Tab(
      text: "Entree",
    ),
    Tab(
      text: "Depenses",
    )
  ];
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "",
      home: DefaultTabController(
        length: mytabs.length,
        child: Scaffold(
          appBar: appbarfunction(mytabs, "Operations"),
          drawer: drowerfunction(context),
          body: TabBarView(
            children: [
              Column(
                children: [
                  Padding(
                    padding: EdgeInsets.only(top: 40),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Icon(Icons.add),
                        Container(
                          width: 300,
                          height: 50,
                          child: TextField(
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                                hintText: '0', border: OutlineInputBorder()),
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
                    padding: EdgeInsets.only(top: 40),
                    child: Row(
                      children: [
                        RaisedButton(
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => listCategories()));
                          },
                          child: Text(
                            "Choisir une categorie",
                            style: TextStyle(color: Colors.orange),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 40),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        RaisedButton(
                          onPressed: () {},
                          child: Text(
                            "Cancel",
                            style: TextStyle(color: Colors.white),
                          ),
                          color: Colors.red,
                        ),
                        RaisedButton(
                          onPressed: () {},
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
              Column(
                children: [
                  Padding(
                    padding: EdgeInsets.only(top: 40),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Icon(Icons.remove),
                        Container(
                          width: 300,
                          height: 50,
                          child: TextField(
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                                hintText: '0', border: OutlineInputBorder()),
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
                    padding: EdgeInsets.only(top: 40),
                    child: Row(
                      children: [
                        RaisedButton(
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => listCategories()));
                          },
                          child: Text("Choisir une categorie"),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 40),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        RaisedButton(
                          onPressed: () {},
                          child: Text(
                            "Cancel",
                            style: TextStyle(color: Colors.white),
                          ),
                          color: Colors.red,
                        ),
                        RaisedButton(
                          onPressed: () {},
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
