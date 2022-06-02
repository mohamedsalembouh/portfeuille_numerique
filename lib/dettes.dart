import 'package:flutter/material.dart';
import 'package:portfeuille_numerique/methodes.dart';
import 'package:portfeuille_numerique/operationDettes.dart';

class alldettes extends StatefulWidget {
  const alldettes({Key? key}) : super(key: key);

  @override
  State<alldettes> createState() => _alldettesState();
}

class _alldettesState extends State<alldettes> {
  final List<Tab> mytabs = [
    Tab(
      text: "Actif",
    ),
    Tab(
      text: "Clos",
    )
  ];
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: DefaultTabController(
        length: mytabs.length,
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          appBar: appbar2function(mytabs, "Dettes"),
          drawer: drowerfunction(context),
          body: TabBarView(
            children: [
              Column(
                children: [
                  Padding(
                      padding: EdgeInsets.only(top: 20),
                      child: Text(
                        "pettes dettes",
                        style: TextStyle(color: Colors.red),
                      )),
                  Container(
                    child: Expanded(
                      child: ListView(
                        children: [
                          ListTile(
                            title: Text("titre"),
                            subtitle: Text("Nom person et date"),
                            trailing: Text("Montant"),
                          )
                        ],
                      ),
                    ),
                  ),
                  Padding(
                      padding: EdgeInsets.only(top: 20),
                      child: Text(
                        "Emprunte dettes",
                        style: TextStyle(color: Colors.green),
                      )),
                  Container(
                    child: Expanded(
                      child: ListView(
                        children: [
                          ListTile(
                            title: Text("titre"),
                            subtitle: Text("Nom person et date"),
                            trailing: Text("Montant"),
                          )
                        ],
                      ),
                    ),
                  ),
                  Container(
                    //  width: MediaQuery.of(context).size.width,
                    //   height: MediaQuery.of(context).size.height,
                    child: Expanded(
                      child: Padding(
                        padding: EdgeInsets.only(left: 350, bottom: 20),
                        child: FloatingActionButton(
                          child: Icon(
                            Icons.add,
                            size: 20,
                          ),
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => operdatte()));
                          },
                        ),
                      ),
                    ),
                  )
                ],
              ),
              //objectif()
              Container(
                child: ListView(
                  children: [
                    ListTile(
                      title: Text("titre"),
                      subtitle: Text("Nom person"),
                      trailing: Text("20000"),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
