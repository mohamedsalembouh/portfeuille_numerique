import 'package:flutter/material.dart';
import 'package:portfeuille_numerique/db/sql_helper.dart';
import 'package:portfeuille_numerique/methodes.dart';
import 'package:portfeuille_numerique/models/categorie.dart';
import 'package:portfeuille_numerique/models/utilisateur.dart';

class listCategories extends StatefulWidget {
  const listCategories({Key? key}) : super(key: key);

  @override
  State<listCategories> createState() => _listCategoriesState();
}

class _listCategoriesState extends State<listCategories> {
  SQL_Helper helper = SQL_Helper();
  //List<categorie>? achatCategorieList;
  Future<List<categorie>> achatsCategorie() async {
    List<categorie> achatCategorieList = await helper.getAllcategories();
    return achatCategorieList;
  }

  @override
  Widget build(BuildContext context) {
    //achatCategorieList! =  helper.getAllcategories("achats");
    return Scaffold(
      appBar: appbar3function("Categories"),
      body: FutureBuilder(
        future: achatsCategorie(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            // return ListView.builder(

            // itemBuilder:,
            // itemCount: snapshot.data.sn,
            // );
            return Column(
              children: [
                Text("hhhhhh"),
                RaisedButton(
                  onPressed: () async {
                    // List<utilisateur> all =
                    //     await helper.readData("SELECT * FROM utilisateur");
                    // print(all);
                    // print("SELECT * FROM utilisateur");
                  },
                  child: Text("afiche"),
                )
              ],
            );
          } else {
            return Column(
              children: [Text("nooooo")],
            );
          }
        },

        // child: ListView(
        //   children: const <Widget>[
        //     ListTile(
        //         title: Text(
        //       'les categories',
        //       style: TextStyle(fontSize: 20),
        //     )),
        //     Card(
        //       child: ListTile(
        //         title: Text('categorie1'),
        //       ),
        //     ),
        //     Card(
        //       child: ListTile(
        //         title: Text('One-line with trailing widget'),
        //         leading: FlutterLogo(),
        //       ),
        //     ),
        //     Card(
        //       child: ListTile(
        //         title: Text('categorie2'),
        //       ),
        //     ),
        //     Card(
        //       child: ListTile(
        //         title: Text('One-line with trailing widget'),
        //         leading: FlutterLogo(),
        //       ),
        //     ),
        //     Card(
        //       child: ListTile(
        //         title: Text('categorie3'),
        //       ),
        //     ),
        //     Card(
        //       child: ListTile(
        //         title: Text('One-line with trailing widget'),
        //         leading: FlutterLogo(),
        //       ),
        //     ),
        //   ],
        // ),
      ),
    );
  }
}
