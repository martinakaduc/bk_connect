import 'package:bkconnect/controller/info.dart';
import 'package:bkconnect/view/components/button.dart';
import 'package:bkconnect/view/components/image.dart';
import 'package:bkconnect/view/components/input.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ForgotPasswordScreen extends StatefulWidget {
  ForgotPasswordScreen() : super();

  @override
  State<StatefulWidget> createState() {
    return _ForgotPasswordScreenState();
  }
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  GlobalKey<FormState> _key = GlobalKey<FormState>();
  UserInfo _info = UserInfo();

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
              'assets/images/BK image.png',
            ),
            SizedBox(height: 80),
            Form(
              key: _key,
              child: Expanded(
                child: ListView(
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  children: <Widget>[
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
                              "Send",
                              124,
                              48,
                              fontSize: 20,
                              onTapFunction: () {
                                if (_key.currentState.validate()) {
                                  _key.currentState.save();
                                  print("Email: ${_info.getEmail()}");
                                }
                                Navigator.pop(context);
                              },
                            ),
                          ],
                        );
                      },
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
