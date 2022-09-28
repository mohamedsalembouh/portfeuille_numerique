import 'package:flutter/material.dart';
import 'package:portfeuille_numerique/db/sql_helper.dart';
import 'package:portfeuille_numerique/homePage.dart';
import 'package:portfeuille_numerique/methodes.dart';
import 'package:portfeuille_numerique/models/utilisateur.dart';
import 'package:portfeuille_numerique/signup.dart';
import 'package:toast/toast.dart';
import 'package:get/get.dart';

class signinPage extends StatefulWidget {
  const signinPage({Key? key}) : super(key: key);

  @override
  State<signinPage> createState() => _signinPageState();
}

class _signinPageState extends State<signinPage> {
  final f_email = TextEditingController();
  final f_pass = TextEditingController();
  final _formKey = new GlobalKey<FormState>();
  final toast = ToastContext();
  // List<diagrameSolde> allUpdateSolde = [];

  void initState() {
    // TODO: implement initState
    super.initState();
    toast.init(context);
  }

  signin(String email, String pass) async {
    final form = _formKey.currentState;
    if (form!.validate()) {
      SQL_Helper helper = new SQL_Helper();
      utilisateur? user = await helper.getUser(email, pass);
      if (user == null) {
        Toast.show("utilisateur n'existe pas ",
            duration: Toast.lengthShort, gravity: Toast.center);
        print("user not existe");
      } else {
        Navigator.push(
            context,
            // MaterialPageRoute(builder: (context) => homepage(email, pass))
            MaterialPageRoute(builder: (context) => homepage(user)));
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
                      controller: f_email,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Entrer votre email';
                        }
                        if (!validateEmail(value)) {
                          return 'SVP entrer valide email';
                        }
                        return null;
                      },
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
                          return 'Entrer votre mot de passe';
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
                    margin: EdgeInsets.all(30),
                    width: double.infinity,
                    child: FlatButton(
                      onPressed: () {
                        signin(f_email.text, f_pass.text);
                      },
                      child: Text(
                        "4".tr,
                        style: TextStyle(color: Colors.white),
                      ),
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
                          "5".tr,
                          style: TextStyle(fontSize: 16),
                        ),
                        FlatButton(
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => SignUpPage()));
                          },
                          child: Text("6".tr),
                          textColor: Colors.blue,
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
