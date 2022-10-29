import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:portfeuille_numerique/main.dart';
import 'package:portfeuille_numerique/models/utilisateur.dart';

import 'locale/locale_controller.dart';
// import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class updateLangue extends StatefulWidget {
  updateLangue({Key? key}) : super(key: key);
  //final void Function(Locale locale) setLocale;

  @override
  _updateLangueState createState() => _updateLangueState();
}

class _updateLangueState extends State<updateLangue> {
  @override
  Widget build(BuildContext context) {
    MyLocaleController controllerLang = Get.find();
    String? choosen;
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: BackButtonIcon(),
        ),
        title: Text("Modifier la langue"),
      ),
      body: Column(
        children: [
          // Padding(
          //   padding: const EdgeInsets.all(90),
          //   child: Container(child: Text("")),
          // ),
          // ListTile(
          //   title: Text("Anglais"),
          //   onTap: () {
          //     // widget.setLocale(Locale.fromSubtags(languageCode: 'en'));
          //     // controllerLang.changeLang("en");
          //   },
          // ),
          Padding(
            padding: const EdgeInsets.only(top: 40, bottom: 10),
            child: Center(
              child: Text(
                "Choisissez une Langue : ",
                style: TextStyle(fontSize: 20),
              ),
            ),
          ),
          Card(
            elevation: 5,
            shape: RoundedRectangleBorder(
              side: BorderSide(
                color: Colors.white.withOpacity(1),
              ),
              borderRadius: BorderRadius.circular(20.0),
            ),
            child: ListTile(
              title: Text("Francais"),
              //trailing: choosen == "fr" ? Icon(Icons.check) : null,
              onTap: () {
                // widget.setLocale(Locale.fromSubtags(languageCode: 'fr'));
                controllerLang.changeLang("fr");
                // setState(() {
                //   choosen = "fr";
                // });
              },
            ),
          ),
          Card(
            elevation: 5,
            shape: RoundedRectangleBorder(
              side: BorderSide(
                color: Colors.white.withOpacity(1),
              ),
              borderRadius: BorderRadius.circular(20.0),
            ),
            child: ListTile(
              title: Text("Arabe"),
              // trailing: choosen == "ar" ? Icon(Icons.check) : null,
              onTap: () {
                // widget.setLocale(Locale.fromSubtags(languageCode: 'ar'));
                controllerLang.changeLang("ar");
                // setState(() {
                //   choosen = "ar";
                // });
              },
            ),
          ),
        ],
      ),
    );
  }
}
