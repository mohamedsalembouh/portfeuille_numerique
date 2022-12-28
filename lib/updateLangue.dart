import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'locale/locale_controller.dart';

class updateLangue extends StatefulWidget {
  updateLangue({Key? key}) : super(key: key);

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
        title: Text("116".tr),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 40, bottom: 10),
            child: Center(
              child: Text(
                "113".tr,
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
              title: Text("114".tr),
              onTap: () {
                controllerLang.changeLang("fr");
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
              title: Text("115".tr),
              onTap: () {
                controllerLang.changeLang("ar");
              },
            ),
          ),
        ],
      ),
    );
  }
}
