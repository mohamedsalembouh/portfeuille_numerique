import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:portfeuille_numerique/homePage.dart';
import 'package:portfeuille_numerique/locale/locale.dart';
import 'package:portfeuille_numerique/signin.dart';
import 'package:portfeuille_numerique/signup.dart';
import 'package:portfeuille_numerique/splash_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timezone/timezone.dart';

import 'locale/locale_controller.dart';

SharedPreferences? sharedpref;
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  sharedpref = await SharedPreferences.getInstance();
  runApp(portfeuille());
}

class portfeuille extends StatefulWidget {
  portfeuille({Key? key}) : super(key: key);

  @override
  _portfeuilleState createState() => _portfeuilleState();
}

class _portfeuilleState extends State<portfeuille> {
  // Locale? _locale;

  // void setLocale(Locale locale) {
  //   setState(() {
  //     _locale = locale;
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    MyLocaleController controller = Get.put(MyLocaleController());
    return GetMaterialApp(
      // locale: _locale,
      // // debugShowCheckModeBanner:false,
      // localizationsDelegates: AppLocalizations.localizationsDelegates,
      // supportedLocales: AppLocalizations.supportedLocales,
      // localizationsDelegates: [
      //    AppLocalizations.delegate,
      //   GlobalMaterialLocalizations.delegate,
      //   GlobalWidgetsLocalizations.delegate,
      //   GlobalCupertinoLocalizations.delegate
      // ],
      // supportedLocales: [Locale('en', ''), Locale('es', '')],
      locale: controller.initiallang,
      translations: MyLocale(),
      home: Scaffold(
        body: splashScreen(),
      ),
    );
  }
}
