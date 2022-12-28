import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:portfeuille_numerique/locale/locale.dart';
import 'package:portfeuille_numerique/signin.dart';
import 'package:shared_preferences/shared_preferences.dart';
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
  @override
  Widget build(BuildContext context) {
    MyLocaleController controller = Get.put(MyLocaleController());
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      locale: controller.initiallang,
      translations: MyLocale(),
      home: Scaffold(
        body: signinPage(),
      ),
      routes: {
        '/logout': (context) => signinPage(),
      },
    );
  }
}
