import 'package:flutter/material.dart';
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
          appBar: AppBar(
            toolbarHeight: 100,
            bottom: TabBar(tabs: mytabs),
            title: Text("Dettes"),
            actions: [
              Padding(
                padding: EdgeInsets.only(right: 20),
                child: GestureDetector(
                  onTap: () {},
                  child: Icon(Icons.search),
                ),
              )
            ],
          ),
          drawer: Drawer(
            child: ListView(
              padding: EdgeInsets.only(top: 50),
              children: [
                Container(
                  color: Colors.green[500],
                  width: double.infinity,
                  //height: 250,
                  padding: EdgeInsets.only(top: 20),
                  child: DrawerHeader(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      image: DecorationImage(
                          scale: 1.5,
                          image: AssetImage(
                            'assets/images/img_profile.jpg',
                          )),
                    ),
                    padding: EdgeInsets.only(top: 137, left: 30),
                    child: Text(
                      "medsalem@gmail.com",
                      style: TextStyle(fontSize: 20),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 20),
                  child: ListTile(
                    leading: Icon(Icons.dashboard_outlined),
                    title: Text("Accueil", style: TextStyle(fontSize: 20)),
                    onTap: () {},
                  ),
                ),
                ListTile(
                  leading: Icon(
                    Icons.home,
                    size: 20,
                  ),
                  title: Text("Transactions", style: TextStyle(fontSize: 20)),
                  onTap: () {
                    // Navigator.pop(context);
                  },
                ),
                ListTile(
                  leading: Icon(
                    Icons.train,
                    size: 20,
                  ),
                  title: Text("Dettes", style: TextStyle(fontSize: 20)),
                  onTap: () {},
                ),
                ListTile(
                  leading: Icon(
                    Icons.train,
                    size: 20,
                  ),
                  title: Text("Budgets", style: TextStyle(fontSize: 20)),
                  onTap: () {},
                ),
                ListTile(
                  leading: Icon(
                    Icons.train,
                    size: 20,
                  ),
                  title: Text("Objectifs", style: TextStyle(fontSize: 20)),
                  onTap: () {},
                ),
                ListTile(
                  leading: Icon(
                    Icons.train,
                    size: 20,
                  ),
                  title:
                      Text("Partage en groupe", style: TextStyle(fontSize: 20)),
                  onTap: () {},
                ),
                ListTile(
                  leading: Icon(
                    Icons.settings,
                    size: 20,
                  ),
                  title: Text("Parametres", style: TextStyle(fontSize: 20)),
                  onTap: () {},
                ),
              ],
            ),
          ),
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
