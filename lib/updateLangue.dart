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
            padding: const EdgeInsets.only(top: 20),
            child: Center(
              child: Text("Choisissez une Langue : "),
            ),
          ),
          Card(
            child: ListTile(
              title: Text("Francais"),
              onTap: () {
                // widget.setLocale(Locale.fromSubtags(languageCode: 'fr'));
                controllerLang.changeLang("fr");
              },
            ),
          ),
          Card(
            child: ListTile(
              title: Text("Arabe"),
              onTap: () {
                // widget.setLocale(Locale.fromSubtags(languageCode: 'ar'));
                controllerLang.changeLang("ar");
              },
            ),
          ),
        ],
      ),
    );
  }
}
