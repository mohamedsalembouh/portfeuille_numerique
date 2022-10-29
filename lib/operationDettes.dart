import 'package:flutter/material.dart';
import 'package:portfeuille_numerique/form_emprunteDatte.dart';
import 'package:portfeuille_numerique/form_pretteDate.dart';
import 'package:portfeuille_numerique/models/utilisateur.dart';
import 'package:get/get.dart';

class operdatte extends StatefulWidget {
  utilisateur? usr;

  //const operdatte({Key? key}) : super(key: key);
  operdatte(this.usr);
  @override
  State<operdatte> createState() => _operdatteState(this.usr);
}

class _operdatteState extends State<operdatte> {
  utilisateur? usr;
  //List<diagrameSolde>? allUpdateSolde;
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
                  "41".tr,
                  style: TextStyle(fontSize: 25),
                )
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.only(),
            child: Column(
              // mainAxisAlignment: MainAxisAlignment.,
              children: [
                // RaisedButton(
                //   onPressed: () {
                //     Navigator.push(
                //         context,
                //         MaterialPageRoute(
                //             builder: (context) => form_prette(this.usr)));
                //   },
                //   child: Text(
                //     "Prette dettes",
                //     style: TextStyle(),
                //   ),
                //   color: Colors.red,
                // ),
                Row(
                  children: [
                    Container(
                      // margin: EdgeInsets.all(30),
                      width: MediaQuery.of(context).size.width,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => form_prette(this.usr)));
                        },
                        child: Text(
                          "42".tr,
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                      decoration: BoxDecoration(
                        color: Colors.blue,
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                  ],
                ),

                Row(
                  children: [
                    Container(
                      margin: EdgeInsets.only(top: 30),
                      width: MediaQuery.of(context).size.width,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      formemprunte(this.usr)));
                        },
                        child: Text(
                          "43".tr,
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                      decoration: BoxDecoration(
                        color: Colors.blue,
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
