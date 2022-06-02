import 'package:flutter/material.dart';
import 'package:portfeuille_numerique/methodes.dart';

class partage extends StatefulWidget {
  const partage({Key? key}) : super(key: key);

  @override
  State<partage> createState() => _partageState();
}

class _partageState extends State<partage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Partage en groupe"),
      ),
      drawer: drowerfunction(context),
      body: Column(
        children: [
          Expanded(
            child: Column(
              children: [
                Expanded(
                  child: ListView(
                    children: [
                      ListTile(
                        title: Text("GROUPE que je cree"),
                      ),
                      ListTile(
                        leading: Icon(Icons.home),
                        title: Text("Nom groupe"),
                        subtitle: Text("Nombre des membres de groupe"),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Column(
              children: [
                Expanded(
                  child: ListView(
                    children: [
                      ListTile(
                        title: Text("Invite dans "),
                      ),
                      ListTile(
                        leading: Icon(Icons.home),
                        title: Text("Nom groupe"),
                        subtitle: Text("Nombre des membres de groupe"),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
