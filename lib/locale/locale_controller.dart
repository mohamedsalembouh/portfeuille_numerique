import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:portfeuille_numerique/main.dart';

class MyLocaleController extends GetxController {
  Locale initiallang = sharedpref!.getString("lang") == null
      ? Get.deviceLocale!
      : Locale(sharedpref!.getString("lang")!);
  void changeLang(String codeLang) {
    Locale locale = Locale(codeLang);
    sharedpref!.setString("lang", codeLang);
    Get.updateLocale(locale);
  }
}
