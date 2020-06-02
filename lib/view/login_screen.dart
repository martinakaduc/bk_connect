import 'package:bkconnect/view/components/button.dart';
import 'package:bkconnect/view/components/image.dart';
import 'package:bkconnect/view/components/input.dart';
import 'package:bkconnect/view/components/text.dart';
import 'package:bkconnect/view/forgot_password_screen.dart';
import 'package:bkconnect/view/main_screen.dart';
import 'package:bkconnect/view/signup_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  LoginScreen() : super();

  @override
  State<StatefulWidget> createState() {
    return _LoginScreenState();
  }
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
            child: Column(
              children: <Widget>[
                SizedBox(height: 30),
        GeneralImage(
          128,
          'assets/images/BK image.png',
        ),
                SizedBox(height: 80),
                Expanded(
                  child: ListView(
                    scrollDirection: Axis.vertical,
                    children: <Widget>[
                      InputField(
                        "Username",
                        "Enter username",
                        'assets/images/Username icon.png',
                      ),
                      SizedBox(height: 15),
                      InputField(
                        "Password",
                        "Enter password",
                        'assets/images/Username icon.png',
                      ),
                      SizedBox(height: 45),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Button(
                            "Cancel",
                            124,
                            48,
                            fontSize: 20,
                            onTapFunction: () {
                              Navigator.pop(context);
                            },
                          ),
                          SizedBox(width: 50),
                          Button(
                            "Login",
                            124,
                            48,
                            fontSize: 20,
                            onTapFunction: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => MainScreen()),
                              );
                            },
                          ),
                        ],
                      ),
                      // Forgot password ?
                      SizedBox(height: 64),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          TextButton(
                            "Forgot password?",
                            onTapFunction: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) =>
                                    ForgotPasswordScreen()),
                              );
                            },
                          ),
                        ],
                      ),
                      SizedBox(height: 10),
                      // Do not have an account ? Sign up
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          NormalText(
                            "Do not have an account? ",
                          ),
                          TextButton(
                            "Sign up",
                            onTapFunction: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => SignupScreen()),
                              );
                            },
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ],
            )));
  }
}
