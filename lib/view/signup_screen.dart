import 'package:bkconnect/controller/info.dart';
import 'package:bkconnect/view/components/button.dart';
import 'package:bkconnect/view/components/image.dart';
import 'package:bkconnect/view/components/input.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:bkconnect/controller/authencation.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class SignupScreen extends StatefulWidget {
  SignupScreen() : super();

  @override
  State<StatefulWidget> createState() {
    return _SignupScreenState();
  }
}

class _SignupScreenState extends State<SignupScreen> {
  GlobalKey<FormState> _key = GlobalKey<FormState>();
  UserInfo _info = UserInfo();

  Authentication _auth = Authentication();

  void submitCallback(http.Response response) {
    print(response.body);
    var msg = json.decode(response.body);
    showAlertDialog(msg);
  }

  void showAlertDialog(Map<String, dynamic> msg) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(30.0))),
          content: Builder(builder: (BuildContext context) {
            var height = MediaQuery.of(context).size.height * 0.25;
            var width = MediaQuery.of(context).size.width * 0.9;
            return Container(
              height: height,
              width: width,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Container(
                    height: height * 0.15,
                    child: Text(
                      msg["status"] == "success" ? "Success!" : "Failure!",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: msg["status"] == "success"
                            ? Colors.blue
                            : Colors.red,
                        fontSize: 24,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  Divider(
                    color: Colors.black,
                  ),
                  Spacer(),
                  Container(
                    child: Text(
                      msg["message"],
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 18,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                  Spacer(),
                  Divider(
                    color: Colors.black,
                  ),
                  Container(
                    height: height * 0.15,
                    child: FlatButton(
                      child: Text(
                        "OK",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: msg["status"] == "success"
                              ? Colors.blue
                              : Colors.red,
                          fontSize: 24,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                  ),
                ],
              ),
            );
          }),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        alignment: Alignment.center,
        color: Colors.white,
        child: Stack(
          children: <Widget>[
            Form(
              key: _key,
              child: SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    SizedBox(
                      height: 178,
                    ),
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
                      "Student ",
                      "Enter ID number ",
                      keyboardType: TextInputType.number,
                      icon: Icon(
                        Icons.format_list_numbered,
                        color: Colors.black,
                        size: 36.0,
                      ),
                      validator: (String val) {
                        return val.isEmpty
                            ? "ID number cannot be empty!"
                            : null;
                      },
                      onSave: (String val) {
                        _info.setID(val);
                      },
                    ),
                    InputField(
                      "Email",
                      "Enter email",
                      keyboardType: TextInputType.emailAddress,
                      icon: Icon(
                        Icons.email,
                        color: Colors.black,
                        size: 36.0,
                      ),
                      validator: (String val) {
                        if (val.isNotEmpty) {
                          bool isValidEmail = RegExp(
                                  r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@hcmut\.edu\.vn")
                              .hasMatch(val);
                          return isValidEmail ? null : "Invalid email address!";
                        }
                        return "Email cannot be empty!";
                      },
                      onSave: (String val) {
                        _info.setEmail(val);
                      },
                    ),
                    InputField(
                      "Phone number",
                      "Enter phone number",
                      keyboardType: TextInputType.number,
                      icon: Icon(
                        Icons.phone_in_talk,
                        color: Colors.black,
                        size: 36.0,
                      ),
                      validator: (String val) {
                        return val.isEmpty
                            ? "Phone number cannot be empty!"
                            : null;
                      },
                      onSave: (String val) {
                        _info.setPhone(val);
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
                    InputField(
                      "Confirm password",
                      "Confirm your password",
                      isPassword: true,
                      icon: Icon(
                        Icons.lock,
                        color: Colors.black,
                        size: 36.0,
                      ),
                      validator: (String val) {
                        if (val.isNotEmpty) {
                          return val == _info.getPassword()
                              ? null
                              : "Password does not match!";
                        } else {
                          return "Please confirm your password in order to register!";
                        }
                      },
                      // onSave: (String val) {
                      //   _info.setPassword(val);
                      // },
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
                              "Sign up",
                              124,
                              48,
                              fontSize: 20,
                              onTapFunction: () async {
                                _key.currentState.save();
                                if (_key.currentState.validate()) {
                                  //_key.currentState.save();
                                  try {
                                    var response = await _auth.signUp(_info);
                                    submitCallback(response);
                                  } catch (e) {
                                    print(e);
                                    var msg = {
                                      "status": "failure",
                                      "message": "lost connection"
                                    };
                                    showAlertDialog(msg);
                                  }
                                }
                              },
                            ),
                          ],
                        );
                      },
                    ),
                    SizedBox(height: 10),
                  ],
                ),
              ),
            ),
            Container(
              color: Colors.white.withOpacity(1.0),
              width: MediaQuery.of(context).size.width,
              height: 178,
              padding: EdgeInsets.only(top: 30, bottom: 20),
              alignment: Alignment.topCenter,
              child: GeneralImage(
                128,
                'assets/images/BK_image.png',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
