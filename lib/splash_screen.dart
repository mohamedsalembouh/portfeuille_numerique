import 'dart:async';

import 'package:flutter/material.dart';
import 'package:portfeuille_numerique/signin.dart';
import 'package:get/get.dart';

class splashScreen extends StatefulWidget {
  splashScreen({Key? key}) : super(key: key);
  //final void Function(Locale locale) setLocale;

  @override
  State<splashScreen> createState() => _splashScreenState();
}

class _splashScreenState extends State<splashScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Timer(
        Duration(seconds: 5),
        () => Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => signinPage())));
  }

  @override
  Widget build(BuildContext context) {
    // return Scaffold(
    //   body: Column(
    //     children: [
    //       Padding(
    //         padding: const EdgeInsets.all(90),
    //         child: Container(
    //             child: Text(AppLocalizations.of(context)!.helloWorld)),
    //       ),
    //       ListTile(
    //         title: Text("Anglais"),
    //         onTap: () {
    //           widget.setLocale(Locale.fromSubtags(languageCode: 'en'));
    //         },
    //       ),
    //       ListTile(
    //         title: Text("Espanish"),
    //         onTap: () {
    //           widget.setLocale(Locale.fromSubtags(languageCode: 'es'));
    //         },
    //       ),
    //       ListTile(
    //         title: Text("frensh"),
    //         onTap: () {
    //           widget.setLocale(Locale.fromSubtags(languageCode: 'fr'));
    //         },
    //       ),
    //       ListTile(
    //         title: Text("arabe"),
    //         onTap: () {
    //           widget.setLocale(Locale.fromSubtags(languageCode: 'ar'));
    //         },
    //       ),
    //     ],
    //   ),
    // );
    return Scaffold(
      //backgroundColor: Colors.green[600],
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Stack(
              children: [
                CircleAvatar(
                  backgroundColor: Colors.white,
                  radius: 100,
                  child: Padding(
                    padding: EdgeInsets.all(8),
                    child: Image(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height,
                      // image: AssetImage("assets/images/img_tesyir.jpg"),
                      image: AssetImage("assets/images/imageApp.jpg"),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 5,
            ),
            Text(
              "1".tr,
              style: TextStyle(
                  color: Colors.green,
                  fontWeight: FontWeight.bold,
                  fontSize: 50),
            ),
            Padding(
              padding: EdgeInsets.only(top: 40),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
