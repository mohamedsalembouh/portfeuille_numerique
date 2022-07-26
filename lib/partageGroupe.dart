import 'package:flutter/material.dart';
import 'package:portfeuille_numerique/budget.dart';
import 'package:portfeuille_numerique/methodes.dart';
import 'package:portfeuille_numerique/models/utilisateur.dart';
import 'package:portfeuille_numerique/services/local_notification_service.dart';

class partage extends StatefulWidget {
  // const partage({Key? key}) : super(key: key);
  utilisateur? usr;
  partage(this.usr);
  @override
  State<partage> createState() => _partageState(this.usr);
}

class _partageState extends State<partage> {
  utilisateur? usr;
  _partageState(this.usr);
  late final LocalNotificationService service;
  @override
  void initState() {
    // TODO: implement initState
    service = LocalNotificationService();
    service.initialize();
    listenToNotification();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Partage en groupe"),
      ),
      drawer: drowerfunction(context, usr),
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
                RaisedButton(
                  onPressed: () {
                    service.showNotificationWithPayload(
                        id: 0,
                        title: "Hi",
                        body: "helloo",
                        payload: 'payload navigation');
                  },
                  child: Text("click"),
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

  void listenToNotification() =>
      service.onNotificationClick.stream.listen((onNotificationListener));
  void onNotificationListener(String? payload) {
    if (payload != null && payload.isNotEmpty) {
      print("payload $payload");
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => budget(usr, 2)));
    }
  }
}
