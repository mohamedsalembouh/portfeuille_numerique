import 'package:flutter/material.dart';

class operdatte extends StatefulWidget {
  const operdatte({Key? key}) : super(key: key);

  @override
  State<operdatte> createState() => _operdatteState();
}

class _operdatteState extends State<operdatte> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(50),
            child: Row(
              children: [
                Text(
                  "Choisir une operation : ",
                  style: TextStyle(fontSize: 25),
                )
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.only(),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                RaisedButton(
                  onPressed: () {},
                  child: Text(
                    "Prette dettes",
                    style: TextStyle(),
                  ),
                  color: Colors.red,
                ),
                RaisedButton(
                  onPressed: () {},
                  child: Text(
                    "Emprunte dettes",
                    style: TextStyle(),
                  ),
                  color: Colors.green,
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
