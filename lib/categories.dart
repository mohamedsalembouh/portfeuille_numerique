import 'package:flutter/material.dart';
import 'package:portfeuille_numerique/db/sql_helper.dart';
import 'package:portfeuille_numerique/methodes.dart';
import 'package:portfeuille_numerique/models/categorie.dart';
import 'package:portfeuille_numerique/models/utilisateur.dart';
import 'package:portfeuille_numerique/operation.dart';
import 'package:sqflite/sqflite.dart';

class listCategories extends StatefulWidget {
  listCategories({Key? key}) : super(key: key);
  int? k;
  listCategories.withNumber(this.k);

  @override
  State<listCategories> createState() => _listCategoriesState(this.k);
}

class _listCategoriesState extends State<listCategories> {
  SQL_Helper helper = SQL_Helper();
  List<categorie>? allCategories;
  int count = 0;
  static var staticList;
  List categorieList = [];
  int? k;
  _listCategoriesState(this.k);

  //List<categorie>? achatCategorieList;
  Future<List<categorie>> achatsCategorie() async {
    List<categorie> achatCategorieList = await helper.getAllcategories();
    return achatCategorieList;
  }

  void updateListView() {
    final Future<Database>? db = helper.initialiseDataBase();
    var a = db;
    if (a != null) {
      a.then((database) {
        Future<List<categorie>> categories = achatsCategorie();
        categories.then((theList) {
          setState(() {
            this.allCategories = theList;
            this.count = theList.length;
          });
        });
      });
    }
  }

  String currentNomCat = "Choisir une categorie";
  categorie? _currentCategorie;
  String h = "choisir une categorie";
  @override
  Widget build(BuildContext context) {
    if (allCategories == null) {
      allCategories = [];
      updateListView();
    }
    //updateListView();
    staticList = this.allCategories;
    // print(staticList[3].nom);
    // print(count);
    //allCategories! = achatsCategorie();

    return Scaffold(
      appBar: appbar3function("Categories"),
      body: FutureBuilder(
          future: achatsCategorie(),
          builder:
              (BuildContext context, AsyncSnapshot<List<categorie>> snapshot) {
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
                hint: Text('$currentNomCat'),
              );
            }
          }),

      //
      // FutureBuilder(
      //   future: achatsCategorie(),
      //   builder: (context, snapshot) {
      //     if (snapshot.data != null) {
      //       //return ListView.builder(
      //       // itemCount: count,
      //       //itemBuilder: (context, index) {
      //       //String dropdownValue = staticList[0].nom;

      //       return DropdownButton<categorie>(
      //         items:snapshot.data!.map(()=>DropdownMenuItem(child: ,value: ,))
      //         );

      //       //           return Card(
      //       //             color: Colors.white,
      //       //             elevation: 2.0,
      //       //             child: ListTile(
      //       //               title: Text('${staticList[index].nom}'),
      //       //               onTap: () {
      //       //                 var nomCategorie = staticList[index].nom;
      //       //                 if (this.k == 0) {
      //       //                   Navigator.push(
      //       //                       context,
      //       //                       MaterialPageRoute(
      //       //                           builder: (context) =>
      //       //                               operation.withnom(0, nomCategorie)));
      //       //                 } else {
      //       //                   Navigator.push(
      //       //                       context,
      //       //                       MaterialPageRoute(
      //       //                           builder: (context) =>
      //       //                               operation.withnom(1, nomCategorie)));
      //       //                 }
      //       //                 // print(nomCategorie);
      //       //               },
      //       //             ),
      //       //           );
      //     }
      //     ;
      //     // );
      //     // } else {
      //     return Text("no data");
      //     // }
      //   },
      // ),
    );
  }
}
