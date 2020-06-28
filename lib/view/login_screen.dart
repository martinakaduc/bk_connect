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
import 'package:bkconnect/controller/authencation.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';


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

  Authentication _auth = Authentication();

  void submitCallback(http.Response response) {
    print(response.body);
    var msg = json.decode(response.body);
    if(msg["status"] == "success") {
      var storage = FlutterSecureStorage();
      storage.write(key: "token", value: msg["access_token"]);      
      Navigator.push(
        context, 
        MaterialPageRoute(builder: (context) => MainScreen())
      );
    }
    else {
      showAlertDialog(msg);
    }
  } 

  void showAlertDialog(Map<String, dynamic> msg) {
    showDialog(
      context: context,
      child: new AlertDialog(
        title: Text(
          msg["status"],
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.red,
            fontSize: 30,
            fontWeight: FontWeight.w600,
          ),
        ),
        content: Text(
          msg["message"],
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.black,
            fontSize: 30,
            fontWeight: FontWeight.w400,
          ),
        ),
        actions: [
          new FlatButton(
            child: const Text("OK"),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );                  
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        alignment: Alignment.center,
        color: Colors.white,
        child: Column(
          children: <Widget>[
            SizedBox(height: 30),
            GeneralImage(
              128,
              'assets/images/BK_image.png',
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
                            onTapFunction: () async {
                              if (_key.currentState.validate()) {
                                _key.currentState.save();
                                try {
                                  var response = await _auth.signIn(_info);
                                  submitCallback(response);
                                } catch(e) {
                                  print(e);
                                  var msg = {"status": "failure", "message": "lost connection"};
                                  showAlertDialog(msg);
                                }
                              }
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
