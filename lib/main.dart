import 'package:flutter/material.dart';
import 'package:portfeuille_numerique/homePage.dart';
import 'package:portfeuille_numerique/signin.dart';
import 'package:portfeuille_numerique/signup.dart';
import 'package:portfeuille_numerique/splash_screen.dart';

void main() {
  runApp(portfeuille());
}

class portfeuille extends StatelessWidget {
  const portfeuille({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // debugShowCheckModeBanner:false,
      home: Scaffold(
        body: splashScreen(),
      ),
    );
  }
}
