import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lite_rolling_switch/lite_rolling_switch.dart';
import 'package:portfeuille_numerique/db/sql_helper.dart';
import 'package:portfeuille_numerique/main.dart';
import 'package:portfeuille_numerique/models/catBudget.dart';
import 'package:portfeuille_numerique/models/emprunte_dette.dart';
import 'package:portfeuille_numerique/models/objective.dart';
import 'package:portfeuille_numerique/models/prette_dette.dart';
import 'package:portfeuille_numerique/models/utilisateur.dart';

class parametre_notification extends StatefulWidget {
  utilisateur? usr;
  parametre_notification(this.usr);

  @override
  _parametre_notificationState createState() =>
      _parametre_notificationState(this.usr);
}

class _parametre_notificationState extends State<parametre_notification> {
  utilisateur? usr;
  _parametre_notificationState(this.usr);
  SQL_Helper helper = SQL_Helper();

  updateStatusDettes(int y) async {
    List<prette_dette> pretes =
        await helper.getAllPrettesDettes(this.widget.usr!.id!);
    pretes.forEach((element) {
      helper.updateStatusNotificationPretteDette(y, element.id!);
    });
    List<emprunte_dette> empruntes =
        await helper.getAllEmprunteDettes(this.widget.usr!.id!);
    empruntes.forEach((element) {
      helper.updateStatusNotificationEmprunteDette(y, element.id!);
    });
  }

  updateStatusBudget(int y) async {
    List<catBudget> budgetes = await helper.getAllBudgets(this.usr!.id!);
    budgetes.forEach((element) {
      helper.updateStatusNotificationBudget(y, element.id!);
    });
  }

  updateStatusObjectif(int y) async {
    List<objective> objectifes = await helper.getAllObjectivfs(this.usr!.id!);
    objectifes.forEach((element) {
      helper.updateStatusNotificationObjectif(y, element.id!);
    });
  }

  bool? status_dette = sharedpref!.getBool("statusDette") == null
      ? true
      : sharedpref!.getBool("statusDette");
  bool? status_budget = sharedpref!.getBool("statusBudget") == null
      ? true
      : sharedpref!.getBool("statusBudget");
  bool? status_objectif = sharedpref!.getBool("statusObjectif") == null
      ? true
      : sharedpref!.getBool("statusObjectif");
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: [
          SizedBox(
            height: 30,
          ),
          Padding(
            padding: const EdgeInsets.only(top: 15),
            child: Card(
              elevation: 5,
              shape: RoundedRectangleBorder(
                side: BorderSide(
                  color: Colors.white.withOpacity(1),
                ),
                borderRadius: BorderRadius.circular(20.0),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Container(
                      width: MediaQuery.of(context).size.width / 2,
                      child: Text("103".tr)),
                  LiteRollingSwitch(
                    value: status_dette,
                    textOn: "104".tr,
                    textOff: "105".tr,
                    colorOn: Colors.greenAccent,
                    colorOff: Colors.redAccent,
                    iconOn: Icons.done,
                    iconOff: Icons.alarm_off,
                    textSize: 12,
                    onChanged: (bool position) {
                      print("the button is $position");
                      if (position == true) {
                        updateStatusDettes(0);
                      } else {
                        updateStatusDettes(1);
                      }
                      //status_dette = position;
                      sharedpref!.setBool("statusDette", position);
                    },
                  )
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 15),
            child: Card(
              elevation: 5,
              shape: RoundedRectangleBorder(
                side: BorderSide(
                  color: Colors.white.withOpacity(1),
                ),
                borderRadius: BorderRadius.circular(20.0),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Container(
                      width: MediaQuery.of(context).size.width / 2,
                      child: Text("106".tr)),
                  LiteRollingSwitch(
                    value: status_budget,
                    textOn: "104".tr,
                    textOff: "105".tr,
                    colorOn: Colors.greenAccent,
                    colorOff: Colors.redAccent,
                    iconOn: Icons.done,
                    iconOff: Icons.alarm_off,
                    textSize: 12,
                    onChanged: (bool position) {
                      // print("the button is $position");
                      if (position == true) {
                        updateStatusBudget(0);
                      } else {
                        updateStatusBudget(1);
                      }
                      sharedpref!.setBool("statusBudget", position);
                    },
                  )
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 15),
            child: Card(
              elevation: 5,
              shape: RoundedRectangleBorder(
                side: BorderSide(
                  color: Colors.white.withOpacity(1),
                ),
                borderRadius: BorderRadius.circular(20.0),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Container(
                      width: MediaQuery.of(context).size.width / 2,
                      child: Text("107".tr)),
                  LiteRollingSwitch(
                    value: status_objectif,
                    textOn: "104".tr,
                    textOff: "105".tr,
                    colorOn: Colors.greenAccent,
                    colorOff: Colors.redAccent,
                    iconOn: Icons.done,
                    iconOff: Icons.alarm_off,
                    textSize: 12,
                    onChanged: (bool position) {
                      print("the button is $position");
                      if (position == true) {
                        updateStatusObjectif(0);
                      } else {
                        updateStatusObjectif(1);
                      }
                      sharedpref!.setBool("statusObjectif", position);
                    },
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
