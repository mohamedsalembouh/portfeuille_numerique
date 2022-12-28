import 'package:flutter/material.dart';
import 'package:portfeuille_numerique/db/sql_helper.dart';
import 'package:portfeuille_numerique/methodes.dart';
import 'package:portfeuille_numerique/models/utilisateur.dart';
import 'package:portfeuille_numerique/signin.dart';
import 'package:get/get.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({Key? key}) : super(key: key);

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  SQL_Helper helper = new SQL_Helper();
  final f_username = TextEditingController();
  final f_email = TextEditingController();
  final f_pass = TextEditingController();
  final f_pass2 = TextEditingController();

  final _formKey = new GlobalKey<FormState>();

  signup() async {
    final form = _formKey.currentState;
    if (form!.validate()) {
      if (f_pass.text == f_pass2.text) {
        utilisateur? existUser = await helper.getUserByEmail(f_email.text);
        if (existUser == null) {
          utilisateur user =
              new utilisateur(f_username.text, f_email.text, f_pass.text);
          int result = await helper.insert_user(user);
          if (result > 0) {
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => signinPage()));
            showText(context, "", "m2".tr);
          }
        } else {
          showText(context, "m12".tr, "m3".tr);
        }
      } else {
        showText(context, "m12".tr, "m4".tr);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "1".tr,
          style: TextStyle(fontSize: 25),
        ),
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Container(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 20,
                  ),
                  Image.asset(
                    "assets/images/imageApp.jpg",
                    height: 100,
                    width: 150,
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    margin: EdgeInsets.only(top: 10),
                    child: TextFormField(
                      controller: f_username,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'va'.tr;
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(30)),
                          borderSide: BorderSide(color: Colors.transparent),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(30)),
                          borderSide: BorderSide(color: Colors.blue),
                        ),
                        prefixIcon: Icon(Icons.person),
                        hintText: '7'.tr,
                        fillColor: Colors.grey[200],
                        filled: true,
                      ),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    margin: EdgeInsets.only(top: 10),
                    child: TextFormField(
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'va'.tr;
                        }
                        if (!validateEmail(value)) {
                          return 'vm'.tr;
                        }
                        return null;
                      },
                      controller: f_email,
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(30)),
                          borderSide: BorderSide(color: Colors.transparent),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(30)),
                          borderSide: BorderSide(color: Colors.blue),
                        ),
                        prefixIcon: Icon(Icons.mail),
                        hintText: '2'.tr,
                        fillColor: Colors.grey[200],
                        filled: true,
                      ),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    margin: EdgeInsets.only(top: 10),
                    child: TextFormField(
                      controller: f_pass,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'va'.tr;
                        }
                        return null;
                      },
                      obscureText: true,
                      decoration: InputDecoration(
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(30)),
                          borderSide: BorderSide(color: Colors.transparent),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(30)),
                          borderSide: BorderSide(color: Colors.blue),
                        ),
                        prefixIcon: Icon(Icons.lock),
                        hintText: '3'.tr,
                        fillColor: Colors.grey[200],
                        filled: true,
                      ),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    margin: EdgeInsets.only(top: 10),
                    child: TextFormField(
                      controller: f_pass2,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'va'.tr;
                        }
                        return null;
                      },
                      obscureText: true,
                      decoration: InputDecoration(
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(30)),
                          borderSide: BorderSide(color: Colors.transparent),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(30)),
                          borderSide: BorderSide(color: Colors.blue),
                        ),
                        prefixIcon: Icon(Icons.lock),
                        hintText: '8'.tr,
                        fillColor: Colors.grey[200],
                        filled: true,
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.all(30),
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: signup,
                      child: Text(
                        "6".tr,
                        style: TextStyle(color: Colors.white),
                      ),
                      style: ElevatedButton.styleFrom(shape: StadiumBorder()),
                    ),
                    decoration: BoxDecoration(
                      color: Colors.blue,
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  Container(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "9".tr,
                          style: TextStyle(fontSize: 16),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 20),
                          child: SizedBox(
                            width: 100,
                            child: ElevatedButton(
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => signinPage()));
                              },
                              child: Text("4".tr),
                              style: ElevatedButton.styleFrom(
                                  shape: StadiumBorder()),
                            ),
                          ),
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
