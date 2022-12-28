import 'package:flutter/material.dart';

class profileuser extends StatefulWidget {
  const profileuser({Key? key}) : super(key: key);

  @override
  State<profileuser> createState() => _profileuserState();
}

class _profileuserState extends State<profileuser> {
  @override
  Widget build(BuildContext context) {
    return Container(
      //color: Colors.blue[700],
      width: double.infinity,
      height: 200,
      padding: EdgeInsets.only(top: 20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            margin: EdgeInsets.only(bottom: 10),
            height: 70,
            decoration: BoxDecoration(
                shape: BoxShape.circle,
                image: DecorationImage(
                    image: AssetImage('assets/images/img_profile.jpg'))),
          ),
          Text(
            "medsalem@gmail.com",
            style: TextStyle(fontSize: 20),
          )
        ],
      ),
    );
  }
}
