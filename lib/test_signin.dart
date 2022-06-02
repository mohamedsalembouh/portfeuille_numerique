import 'package:flutter/material.dart';
import 'package:portfeuille_numerique/test_signup.dart';

class testSignin extends StatefulWidget {
  const testSignin({Key? key}) : super(key: key);

  @override
  State<testSignin> createState() => _testSigninState();
}

class _testSigninState extends State<testSignin> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Sign in"),
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Container(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  height: 20,
                ),
                Text(
                  "Login",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                      fontSize: 30),
                ),
                SizedBox(
                  height: 20,
                ),
                Image.asset(
                  "assets/images/image_portfeuille.jpg",
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
                      hintText: 'Email adresse',
                      fillColor: Colors.grey[200],
                      filled: true,
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  margin: EdgeInsets.only(top: 10),
                  child: TextFormField(
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
                      hintText: 'Mot de passe',
                      fillColor: Colors.grey[200],
                      filled: true,
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.all(30),
                  width: double.infinity,
                  child: FlatButton(
                    onPressed: () {},
                    child: Text(
                      "Login",
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
                        "Vous n'avez pas de compte  ?",
                        style: TextStyle(fontSize: 16),
                      ),
                      FlatButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => testSignup()));
                        },
                        child: Text("Signup"),
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
    );
  }
}
// return SafeArea(
    //     child: Scaffold(
    //         resizeToAvoidBottomInset: false,
    //         backgroundColor: Colors.white,
    //         body: Padding(
    //           padding: const EdgeInsets.symmetric(horizontal: 30),
    //           child: Column(
    //             children: [
    //               SizedBox(
    //                 height: 40,
    //               ),
    //               // Image.asset('images/'),
    //               SizedBox(
    //                 height: 40,
    //               ),
    //               TextField(
    //                 controller: f_email,
    //                 decoration: InputDecoration(
    //                   labelText: 'Email',
    //                   labelStyle: TextStyle(
    //                     fontWeight: FontWeight.bold,
    //                     color: Colors.grey,
    //                   ),
    //                   focusedBorder: UnderlineInputBorder(
    //                     borderSide: BorderSide(
    //                       color: Colors.green,
    //                     ),
    //                   ),
    //                 ),
    //               ),
    //               SizedBox(
    //                 height: 10,
    //               ),
    //               TextField(
    //                 controller: f_pass,
    //                 decoration: InputDecoration(
    //                   labelText: 'Password',
    //                   labelStyle: TextStyle(
    //                     fontWeight: FontWeight.bold,
    //                     color: Colors.grey,
    //                   ),
    //                   focusedBorder: UnderlineInputBorder(
    //                     borderSide: BorderSide(
    //                       color: Colors.green,
    //                     ),
    //                   ),
    //                 ),
    //                 obscureText: true,
    //               ),
    //               SizedBox(
    //                 height: 5.0,
    //               ),
    //               Container(
    //                 alignment: Alignment(1.0, 0.0),
    //                 child: Text(
    //                   'Forgot Password ?',
    //                   style: TextStyle(
    //                       fontWeight: FontWeight.bold,
    //                       color: Colors.green,
    //                       decoration: TextDecoration.underline),
    //                 ),
    //               ),
    //               SizedBox(
    //                 height: 40,
    //               ),
    //               Container(
    //                 height: 40,
    //                 child: Material(
    //                   borderRadius: BorderRadius.circular(20.0),
    //                   shadowColor: Colors.greenAccent,
    //                   color: Colors.green,
    //                   elevation: 7.0,
    //                   child: GestureDetector(
    //                     onTap: () {
    //                       signin(f_email.text, f_pass.text);
    //                     },
    //                     child: Center(
    //                       child: Text(
    //                         'Login',
    //                         style: TextStyle(
    //                             fontWeight: FontWeight.bold,
    //                             color: Colors.white),
    //                       ),
    //                     ),
    //                   ),
    //                 ),
    //               ),
    //               SizedBox(
    //                 height: 20.0,
    //               ),
    //               // Container(
    //               //   height: 40,
    //               //   color: Colors.transparent,
    //               //   child: Container(
    //               //     decoration: BoxDecoration(
    //               //       border: Border.all(
    //               //           color: Colors.black,
    //               //           style: BorderStyle.solid,
    //               //           width: 1.0),
    //               //       color: Colors.transparent,
    //               //       borderRadius: BorderRadius.circular(20.0),
    //               //     ),
    //               //     child: Row(
    //               //       mainAxisAlignment: MainAxisAlignment.center,
    //               //       children: [
    //               //         Center(
    //               //             // child: ImageIcon(
    //               //             //   AssetImage('images/facebook.png'),
    //               //             // ),
    //               //             ),
    //               //         SizedBox(
    //               //           width: 10.0,
    //               //         ),
    //               //         Center(
    //               //           child: Text(
    //               //             'Login with Facebook',
    //               //             style: TextStyle(fontWeight: FontWeight.bold),
    //               //           ),
    //               //         ),
    //               //       ],
    //               //     ),
    //               //   ),
    //               // ),
    //               SizedBox(
    //                 height: 15,
    //               ),
    //               Row(
    //                 mainAxisAlignment: MainAxisAlignment.center,
    //                 children: [
    //                   Text(
    //                     "Vous n'avez pas de compte  ?",
    //                     style: TextStyle(fontWeight: FontWeight.bold),
    //                   ),
    //                   SizedBox(
    //                     width: 5.0,
    //                   ),
    //                   InkWell(
    //                     onTap: () {
    //                       Navigator.push(
    //                           context,
    //                           MaterialPageRoute(
    //                               builder: (context) => SignUpPage()));
    //                     },
    //                     child: Text(
    //                       'Register',
    //                       style: TextStyle(
    //                           fontWeight: FontWeight.bold, color: Colors.green),
    //                     ),
    //                   )
    //                 ],
    //               )
    //             ],
    //           ),
    //         )));