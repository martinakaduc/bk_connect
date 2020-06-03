import 'package:bkconnect/controller/info.dart';
import 'package:bkconnect/view/components/button.dart';
import 'package:bkconnect/view/components/image.dart';
import 'package:bkconnect/view/components/input.dart';
import 'package:bkconnect/view/main_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

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
            SizedBox(height: 20),
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
                        return val.isEmpty ? "Password does not match!" : null;
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
                              "Sign up",
                              124,
                              48,
                              fontSize: 20,
                              onTapFunction: () {
                                if (_key.currentState.validate()) {
                                  _key.currentState.save();
                                  print("Username: ${_info.getName()}");
                                  print("ID: ${_info.getID()}");
                                  print("Email: ${_info.getEmail()}");
                                  print("Phone: ${_info.getPhone()}");
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
                      },
                    ),
                    SizedBox(height: 10),
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
