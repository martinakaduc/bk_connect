import 'package:bkconnect/controller/info.dart';
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
  GlobalKey<FormState> _key = GlobalKey<FormState>();
  UserInfo _info = UserInfo();

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
            SizedBox(height: 60),
            Form(
              key: _key,
              child: Expanded(
                child: ListView(
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  children: <Widget>[
                    InputField(
                      "Username",
                      "Enter username",
                      icon: Icon(
                        Icons.person_pin,
                        color: Colors.black,
                        size: 36.0,
                      ),
                      validator: (String val) {
                        return val.isEmpty ? "Username cannot be empty!" : null;
                      },
                      onSave: (String val) {
                        _info.setUsername(val);
                      },
                    ),
                    InputField(
                      "Password",
                      "Enter password",
                      isPassword: true,
                      icon: Icon(
                        Icons.lock,
                        color: Colors.black,
                        size: 36.0,
                      ),
                      validator: (String val) {
                        return val.isEmpty ? "Password cannot be empty!" : null;
                      },
                      onSave: (String val) {
                        _info.setPassword(val);
                      },
                    ),
                    SizedBox(height: 45),
                    FormField(
                      builder: (FormFieldState<String> state) {
                        return Row(
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
                              if (_key.currentState.validate()) {
                                _key.currentState.save();
                                  print("Name: ${_info.getUserName()}");
                                  print("Password: ${_info.getPassword()}");
                              }

                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => MainScreen()),
                              );
                            },
                          ),
                        ],
                      );
                    },),
                    SizedBox(height: 64),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        TextButton(
                          "Forgot password?",
                          onTapFunction: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ForgotPasswordScreen()),
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
                              MaterialPageRoute(
                                  builder: (context) => SignupScreen()),
                            );
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
