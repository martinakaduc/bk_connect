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
                "Student ",
                "Enter ID number ",
                'assets/images/Username icon.png',
              ),
              SizedBox(height: 15),
              InputField(
                "Email",
                "Enter email",
                'assets/images/Username icon.png',
              ),
              SizedBox(height: 15),
              InputField(
                "Phone number",
                "Enter phone number",
                'assets/images/Username icon.png',
              ),
              SizedBox(height: 15),
              InputField(
                "Password",
                "Enter password",
                'assets/images/Username icon.png',
              ),
              SizedBox(height: 15),
              InputField(
                "Confirm password",
                "Confirm your password",
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
                    "Sign up",
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
              SizedBox(height: 10),
            ],
          ),
        ),
      ],
    )));
  }
}
