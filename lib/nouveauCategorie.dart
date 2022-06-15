import 'package:flutter/material.dart';
import 'package:portfeuille_numerique/db/sql_helper.dart';
import 'package:portfeuille_numerique/models/categorie.dart';

class nouveauCategorie extends StatefulWidget {
  const nouveauCategorie({Key? key}) : super(key: key);

  @override
  State<nouveauCategorie> createState() => _nouveauCategorieState();
}

class _nouveauCategorieState extends State<nouveauCategorie> {
  TextEditingController catnom = TextEditingController();
  TextEditingController cattype = TextEditingController();

  insertCategorie(String nom, String coleur) async {
    categorie cat = new categorie(nom, coleur);
    SQL_Helper helper = new SQL_Helper();
    int result = await helper.insert_categorie(cat);
    if (result == 0) {
      print("not inserted");
    } else {
      print("inserted");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: EdgeInsets.only(top: 40, left: 20),
        child: Column(
          children: [
            Container(
              width: 300,
              height: 50,
              child: TextField(
                controller: catnom,
                decoration: InputDecoration(
                    hintText: 'nom categorie', border: OutlineInputBorder()),
                style: TextStyle(fontSize: 20),
              ),
            ),
            Container(
              width: 300,
              height: 50,
              margin: EdgeInsets.only(top: 20),
              child: TextField(
                controller: cattype,
                decoration: InputDecoration(
                    hintText: 'type categorie', border: OutlineInputBorder()),
                style: TextStyle(fontSize: 20),
              ),
            ),
            // ignore: deprecated_member_use
            Padding(
              padding: EdgeInsets.only(top: 20),
              child: RaisedButton(
                onPressed: () {
                  insertCategorie(catnom.text, cattype.text);
                  // print(catnom.text);
                },
                child: Text(
                  "Ajouter",
                  style: TextStyle(color: Colors.white),
                ),
                color: Colors.green,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
