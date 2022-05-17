import 'package:flutter/material.dart';
import 'package:portfeuille_numerique/homePage.dart';

void main() {
  runApp(portfeuille());
}

class portfeuille extends StatelessWidget {
  const portfeuille({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      //debugShowCheckModeBanner:false
      home: Scaffold(
        body: homepage(),
      ),
    );
  }
}
