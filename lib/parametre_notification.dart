import 'package:flutter/material.dart';
import 'package:lite_rolling_switch/lite_rolling_switch.dart';
import 'package:portfeuille_numerique/db/sql_helper.dart';
import 'package:portfeuille_numerique/models/budgete.dart';
import 'package:portfeuille_numerique/models/catBudget.dart';
import 'package:portfeuille_numerique/models/emprunte_dette.dart';
import 'package:portfeuille_numerique/models/objective.dart';
import 'package:portfeuille_numerique/models/prette_dette.dart';
import 'package:portfeuille_numerique/models/utilisateur.dart';

class parametre_notification extends StatefulWidget {
  //const parametre_notification({Key? key}) : super(key: key);
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
    // helper.updateStatusNotificationBudget(y, this.widget.usr!.id!);
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

  // bool? stst;
  // bool stst = false;
  static var status_dette;
  static var status_budget;
  static var status_objectif;

  @override
  Widget build(BuildContext context) {
    if (status_dette == null) {
      status_dette = true;
    }
    if (status_budget == null) {
      status_budget = true;
    }
    if (status_objectif == null) {
      status_objectif = true;
    }
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 15),
            child: Card(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Container(
                      width: MediaQuery.of(context).size.width / 2,
                      child: Text(
                          "Activer ou desactiver les notifications des dettes")),
                  LiteRollingSwitch(
                    value: status_dette,
                    textOn: "Active",
                    textOff: "Desactive",
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
                      status_dette = position;
                    },
                  )
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 15),
            child: Card(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Container(
                      width: MediaQuery.of(context).size.width / 2,
                      child: Text(
                          "Activer ou desactiver les notifications des Budgets")),
                  LiteRollingSwitch(
                    value: status_budget,
                    textOn: "Active",
                    textOff: "Desactive",
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
                      status_budget = position;
                    },
                  )
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 15),
            child: Card(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Container(
                      width: MediaQuery.of(context).size.width / 2,
                      child: Text(
                          "Activer ou desactiver les notifications des Objectifs")),
                  LiteRollingSwitch(
                    value: status_objectif,
                    textOn: "Active",
                    textOff: "Desactive",
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
                      status_objectif = position;
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
