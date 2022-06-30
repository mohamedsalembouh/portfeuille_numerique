import 'package:flutter/material.dart';
import 'package:portfeuille_numerique/form_emprunteDatte.dart';
import 'package:portfeuille_numerique/form_pretteDate.dart';
import 'package:portfeuille_numerique/models/utilisateur.dart';

class operdatte extends StatefulWidget {
  utilisateur? usr;
  //const operdatte({Key? key}) : super(key: key);
  operdatte(this.usr);
  @override
  State<operdatte> createState() => _operdatteState(this.usr);
}

class _operdatteState extends State<operdatte> {
  utilisateur? usr;
  _operdatteState(this.usr);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(50),
            child: Row(
              children: [
                Text(
                  "Choisir une operation : ",
                  style: TextStyle(fontSize: 25),
                )
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.only(),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                RaisedButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => form_prette(this.usr)));
                  },
                  child: Text(
                    "Prette dettes",
                    style: TextStyle(),
                  ),
                  color: Colors.red,
                ),
                RaisedButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => formemprunte(this.usr)));
                  },
                  child: Text(
                    "Emprunte dettes",
                    style: TextStyle(),
                  ),
                  color: Colors.green,
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
