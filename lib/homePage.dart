import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:portfeuille_numerique/budget.dart';
import 'package:portfeuille_numerique/categories.dart';
import 'package:portfeuille_numerique/dettes.dart';
import 'package:portfeuille_numerique/objectifs.dart';
import 'package:portfeuille_numerique/operation.dart';
import 'profileUser.dart';

class homepage extends StatefulWidget {
  const homepage({Key? key}) : super(key: key);

  @override
  State<homepage> createState() => _homepageState();
}

class _homepageState extends State<homepage> {
  List<charts.Series<Task, String>>? _seriedata;
  _generatedData() {
    var piedata = [
      Task("work", 40000, Colors.red),
      Task("achats", 200000, Colors.green),
      // Task("ventes", 40000, Colors.orange),
      // Task("hhhh", 40000, Colors.yellow),
    ];
    _seriedata!.add(
      charts.Series(
          data: piedata,
          domainFn: (Task task, _) => task.task,
          measureFn: (Task task, _) => task.taskvalue,
          colorFn: (Task task, _) =>
              charts.ColorUtil.fromDartColor(task.colorval),
          id: 'Daily task',
          labelAccessorFn: (Task row, _) => '${row.taskvalue}'),
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _seriedata = [];
    _generatedData();
  }

  final List<Tab> mytabs = [
    Tab(
      text: "Comptes",
    ),
    Tab(
      text: "Budget et objectif",
    )
  ];
  // var currentpage = DrawerSections.dashboard;
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: DefaultTabController(
        length: mytabs.length,
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          appBar: appbarfunction(mytabs, "Accueil"),
          drawer: drowerfunction(context),
          body: TabBarView(
            children: [
              Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    //add column for solde et button
                    Column(
                      children: [
                        Padding(
                          padding: EdgeInsets.only(top: 20),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              // Title(color: Colors.red, child: Text("hi")),
                              Text(
                                "Votre Solde est ",
                                style: TextStyle(fontSize: 25),
                              ),
                              // Text(
                              //   "20000",
                              //   style: TextStyle(
                              //     fontSize: 40,
                              //     backgroundColor: Colors.green,
                              //   ),
                              // ),
                              Container(
                                width: 200,
                                height: 50,
                                child: TextField(
                                  enabled: false,
                                  keyboardType: TextInputType.number,
                                  decoration: InputDecoration(
                                      hintText: '20000',
                                      border: OutlineInputBorder()),
                                  style: TextStyle(
                                    fontSize: 30,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: 20),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(" "),
                              RaisedButton(
                                onPressed: () {
                                  onclick(context);
                                },
                                padding: EdgeInsets.all(5),
                                color: Colors.red,
                                textColor: Colors.white,
                                child: Text("Modifier le solde"),
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                    //fermer column solde et botton

                    //add new column for statistiques

                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(top: 40),
                          child: Row(
                            children: [
                              Text(
                                "Statistiques sur les depenses",
                                style: TextStyle(fontSize: 20),
                              ),
                            ],
                          ),
                        ),
                        //ajouter ici le diagramme circulaire
                        Container(
                          width: 400,
                          height: 400,
                          child: charts.PieChart(
                            _seriedata,
                            animate: true,
                            animationDuration: Duration(seconds: 5),
                            // behaviors: [
                            //   new charts.DatumLegend(
                            //     outsideJustification:
                            //         charts.OutsideJustification.endDrawArea,
                            //     horizontalFirst: false,
                            //     desiredMaxRows: 2,
                            //     cellPadding:
                            //         new EdgeInsets.only(right: 4, bottom: 4),
                            //     entryTextStyle: charts.TextStyleSpec(
                            //       color: charts
                            //           .MaterialPalette.purple.shadeDefault,
                            //       fontSize: 11,
                            //     ),
                            //   )
                            // ],
                            defaultRenderer: new charts.ArcRendererConfig(
                                arcWidth: 100,
                                arcRendererDecorators: [
                                  new charts.ArcLabelDecorator(
                                      labelPosition:
                                          charts.ArcLabelPosition.inside)
                                ]),
                          ),
                        ),
                      ],
                    ),
                    //fermer column statistiques
                    //add column vue

                    // Column(
                    //   //crossAxisAlignment: CrossAxisAlignment.start,
                    //   children: [
                    //     Padding(
                    //       padding: EdgeInsets.only(top: 40),
                    //       child: Row(
                    //         children: [
                    //           Text(
                    //             "Vue sur les dernieres transactions ",
                    //             style: TextStyle(fontSize: 20),
                    //           )
                    //         ],
                    //       ),
                    //     ),
                    //     Container(
                    //       // width: 100,
                    //       height: 160,
                    //       color: Colors.grey,
                    //       child: ListView.builder(
                    //           padding: EdgeInsets.zero,
                    //           itemCount: 10,
                    //           scrollDirection: Axis.vertical,
                    //           itemBuilder: (context, index) {
                    //             return ListTile(
                    //               title: Text("${index + 1}"),
                    //               // leading: Icon(Icons.home),
                    //             );
                    //           }),
                    //     ),
                    //   ],
                    // ),
                    //fermer column vue

                    Container(
                      //  width: MediaQuery.of(context).size.width,
                      //   height: MediaQuery.of(context).size.height,
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
                                    builder: (context) => operation()));
                          },
                        ),
                      ),
                    )
                  ],
                ),
              ),
              objectif()
            ],
          ),
        ),
      ),
    );
  }

  void onclick(BuildContext context) {
    AlertDialog alertDialog = AlertDialog(
      title: Text("Ajouter un niveaux solde"),
      content: SizedBox(
        width: 200,
        child: TextField(
          keyboardType: TextInputType.number,
          decoration:
              InputDecoration(hintText: '0', border: OutlineInputBorder()),
          style: TextStyle(fontSize: 20),
        ),
      ),
      actions: [
        TextButton(
          child: Text(
            "Annuler",
            style: TextStyle(color: Colors.red),
          ),
          onPressed: () {},
        ),
        TextButton(
          child: Text("Enregistrer"),
          onPressed: () {},
        ),
      ],
    );
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return alertDialog;
        });
  }

  // Widget drowerList() {
  //   return Container(
  //     padding: EdgeInsets.only(top: 15),
  //     child: Column(
  //       children: [
  //         //menuItem()
  //         ],
  //     ),
  //   );
  // }

  // Widget menuItem() {
  //   return Material(
  //     child: InkWell(
  //       onTap: () {},
  //       child: Padding(
  //         padding: EdgeInsets.all(15),
  //         child: Row(
  //           // mainAxisAlignment: MainAxisAlignment.start,
  //           children: [
  //             Expanded(
  //                 child: Icon(
  //               icon,
  //               color: Colors.black,
  //               size: 40,
  //             )),
  //             Expanded(
  //                 flex: 3,
  //                 child: Text(
  //                   title,
  //                   style: TextStyle(color: Colors.black, fontSize: 20),
  //                 )),
  //           ],
  //         ),
  //       ),
  //     ),
  //   );
  // }
}

class Task {
  String? task;
  double? taskvalue;
  Color? colorval;

  Task(this.task, this.taskvalue, this.colorval);
}

PreferredSize appbarfunction(List<Tab> x, String title) {
  return PreferredSize(
    preferredSize: Size.fromHeight(100),
    child: AppBar(
      // toolbarHeight: 100,
      bottom: TabBar(tabs: x),
      title: Text(title),
      actions: [
        Padding(
          padding: EdgeInsets.only(right: 20),
          child: GestureDetector(
            onTap: () {},
            child: Icon(Icons.notifications),
          ),
        ),
        Padding(
          padding: EdgeInsets.only(right: 20),
          child: GestureDetector(
            onTap: () {},
            child: Icon(Icons.settings),
          ),
        )
      ],
    ),
  );
}

Widget drowerfunction(BuildContext context) {
  return Drawer(
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
          onTap: () {
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => alldettes()));
          },
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
          title: Text("Partage en groupe", style: TextStyle(fontSize: 20)),
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
  );
}
