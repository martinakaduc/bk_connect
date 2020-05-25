import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:bkconnect/login_screen.dart';

class ForgotPasswordScreen extends StatefulWidget {
  ForgotPasswordScreen() : super();

  @override
  State<StatefulWidget> createState() {
    return _ForgotPasswordScreenState();
  }
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
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
                                    "Email",
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
                                      hintText: 'Enter email',
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
                                MaterialPageRoute(builder: (context) => LoginScreen()),
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
                                MaterialPageRoute(
                                    builder: (context) => LoginScreen()),
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
                                "Send",
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
                    ],
                  ),
                ),
              ],
            )));
  }
}
