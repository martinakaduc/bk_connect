import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:bkconnect/welcome_screen.dart';
import 'package:bkconnect/main_screen.dart';
import 'package:bkconnect/signup_screen.dart';
import 'package:bkconnect/forgot_password_screen.dart';

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
    // TODO: implement build
    return Scaffold(
        body: Center(
            child: Column(
      children: <Widget>[
        SizedBox(height: 30),
        Container(
          width: 128,
          height: 128,
          child: Image(
            image: AssetImage('assets/images/BK image.png'),
          ),
        ),
        SizedBox(height: 80),
        Expanded(
          child: ListView(
            scrollDirection: Axis.vertical,
            children: <Widget>[
              Container(
                width: 335,
                height: 75,
                child: Column(
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Container(
                          width: 335,
                          height: 25,
                          child: Text(
                            "Username",
                            style: const TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.w700,
                                fontFamily: "Roboto",
                                fontStyle: FontStyle.normal,
                                fontSize: 20.0),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        // Username icon
                        Container(
                          width: 50,
                          height: 50,
                          child: Image(
                              image: AssetImage(
                                  'assets/images/Username icon.png')),
                        ),
                        // Rectangle 3
                        Container(
                          width: 285,
                          height: 50,
                          child: TextField(
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(60)),
                                borderSide: BorderSide(
                                    color: Colors.blueAccent, width: 1),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(60)),
                                borderSide:
                                    BorderSide(color: Colors.black, width: 1),
                              ),
                              hintStyle: TextStyle(
                                  color: const Color(0xffbdbdbd),
                                  fontWeight: FontWeight.w600,
                                  fontFamily: "Roboto",
                                  fontStyle: FontStyle.normal,
                                  fontSize: 20.0),
                              hintText: 'Enter username',
                              contentPadding: const EdgeInsets.only(left: 20.0),
                            ),
                            keyboardType: TextInputType.text,
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.w600,
                                fontFamily: "Roboto",
                                fontStyle: FontStyle.normal,
                                fontSize: 20.0),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
              SizedBox(height: 15),
              Container(
                width: 335,
                height: 75,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Container(
                          width: 335,
                          height: 25,
                          child: Text(
                            "Password",
                            style: const TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.w700,
                                fontFamily: "Roboto",
                                fontStyle: FontStyle.normal,
                                fontSize: 20.0),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        // Username icon
                        Container(
                          width: 50,
                          height: 50,
                          child: Image(
                              image: AssetImage(
                                  'assets/images/Username icon.png')),
                        ),
                        // Rectangle 3
                        Container(
                          width: 285,
                          height: 50,
                          child: TextField(
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(60)),
                                borderSide: BorderSide(
                                    color: Colors.blueAccent, width: 1),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(60)),
                                borderSide:
                                    BorderSide(color: Colors.black, width: 1),
                              ),
                              hintStyle: TextStyle(
                                  color: const Color(0xffbdbdbd),
                                  fontWeight: FontWeight.w600,
                                  fontFamily: "Roboto",
                                  fontStyle: FontStyle.normal,
                                  fontSize: 20.0),
                              hintText: 'Enter password',
                              contentPadding: const EdgeInsets.only(left: 20.0),
                            ),
                            keyboardType: TextInputType.text,
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.w600,
                                fontFamily: "Roboto",
                                fontStyle: FontStyle.normal,
                                fontSize: 20.0),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
              SizedBox(height: 45),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => WelcomeScreen()),
                      );
                    },
                    child: Container(
                      width: 124,
                      height: 48,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(36)),
                          color: const Color(0xff1588db)),
                      child: Text(
                        "Cancel",
                        style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                            fontFamily: "Roboto",
                            fontStyle: FontStyle.normal,
                            fontSize: 20.0),
                      ),
                    ),
                  ),
                  SizedBox(width: 50),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => MainScreen()),
                      );
                    },
                    child: Container(
                      width: 124,
                      height: 48,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(36)),
                          color: const Color(0xff1588db)),
                      child: Text(
                        "Login",
                        style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                            fontFamily: "Roboto",
                            fontStyle: FontStyle.normal,
                            fontSize: 20.0),
                      ),
                    ),
                  ),
                ],
              ),
              // Forgot password ?
              SizedBox(height: 64),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => ForgotPasswordScreen()),
                      );
                    },
                    child: Text(
                      "Forgot password?",
                      style: const TextStyle(
                          color: Colors.blue,
                          fontWeight: FontWeight.w400,
                          fontFamily: "Roboto",
                          fontStyle: FontStyle.normal,
                          fontSize: 18.0),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10),
              // Do not have an account ? Sign up
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    "Do not have an account? ",
                    style: const TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w400,
                        fontFamily: "Roboto",
                        fontStyle: FontStyle.normal,
                        fontSize: 18.0),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => SignupScreen()),
                      );
                    },
                    child: Text(
                      "Sign up",
                      style: const TextStyle(
                          color: Colors.blue,
                          fontWeight: FontWeight.w400,
                          fontFamily: "Roboto",
                          fontStyle: FontStyle.normal,
                          fontSize: 18.0),
                    ),
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
