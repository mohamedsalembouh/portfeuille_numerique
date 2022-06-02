import 'package:flutter/material.dart';
import 'package:portfeuille_numerique/form_objectif.dart';

class new_objectif extends StatefulWidget {
  const new_objectif({Key? key}) : super(key: key);

  @override
  State<new_objectif> createState() => _new_objectifState();
}

class _new_objectifState extends State<new_objectif> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Nouveaux objectif"),
      ),
      body: Column(
        children: [
          Expanded(
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                  child: TextField(
                    decoration: InputDecoration(
                      border: UnderlineInputBorder(),
                      hintText: 'Nom objectif',
                    ),
                  ),
                ),
                RaisedButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => form_objectif()));
                  },
                  child: Text("Creer un objectif"),
                ),
                // Expanded(
                //   child: ListView(
                //     // mainAxisAlignment: MainAxisAlignment.spaceAround,
                //     children: [
                //       ListTile(
                //         title: Icon(Icons.cast_for_education_outlined),
                //         subtitle: Text("Vehicule"),
                //       ),
                //       ListTile(
                //         title: Icon(Icons.cast_for_education_outlined),
                //         subtitle: Text("Vehicule"),
                //       ),
                //     ],
                //   ),

                // ),
                // Row(
                //   children: [Icon(Icons.cast_for_education), Text("Vehicule")],
                // ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
