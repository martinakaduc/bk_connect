import 'package:bkconnect/controller/info.dart';
import 'package:bkconnect/view/components/button.dart';
import 'package:bkconnect/view/components/image.dart';
import 'package:bkconnect/view/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:bkconnect/view/components/text.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class ProfilePage extends StatefulWidget {
  ProfilePage() : super();

  var info = MemberInfo();

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  Widget _infoLabel() {
    return Table(
      columnWidths: {
        0: FlexColumnWidth(2.0),
        1: FlexColumnWidth(3.0),
      },
      children: <TableRow>[
        TableRow(
          children: <Widget>[
            Padding(
                child: Text("Full name:",
                    style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 24,
                        color: Colors.black)),
                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15)),
            Padding(
                child: Text(widget.info.getName(),
                    style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 24,
                        color: Color(0xff828282))),
                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15)),
          ],
        ),
        TableRow(
          children: <Widget>[
            Padding(
                child: Text("Student ID:",
                    style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 24,
                        color: Colors.black)),
                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15)),
            Padding(
                child: Text(widget.info.getID(),
                    style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 24,
                        color: Color(0xff828282))),
                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15)),
          ],
        ),
        TableRow(
          children: <Widget>[
            Padding(
                child: Text("Phone:",
                    style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 24,
                        color: Colors.black)),
                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15)),
            Padding(
                child: Text(widget.info.getPhone(),
                    style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 24,
                        color: Color(0xff828282))),
                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15)),
          ],
        ),
        TableRow(
          children: <Widget>[
            Padding(
                child: Text("Email:",
                    style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 24,
                        color: Colors.black)),
                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15)),
            Padding(
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Text(widget.info.getEmail(),
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 24,
                      color: Color(0xff828282)
                    )
                  ),
                ), 
                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15)),
          ],
        ),
      ],
    );
  }


  Future<dynamic> getProfile() async {
    var storage = FlutterSecureStorage();
    var token = await storage.read(key: "token");
    return await http.get("http://10.0.2.2:5000/profile/", headers: {"Authorization": "Bearer $token"});
  }

  Widget loginNavigation() {
    return Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(30)),
        color: Colors.white
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          NormalText("Token has expired. Please login again"),
          SizedBox(
            height: 30,
          ),
          Button(
            "Login",
            124,
            48,
            fontSize: 20,
            onTapFunction: () {
              Navigator.push(context,MaterialPageRoute(builder: (context) => LoginScreen()));
            },
          ),
        ],
      ),        
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: getProfile(),
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Center(child: NormalText('Oh no! Error! ${snapshot.error}'));
        }
        if (!snapshot.hasData) {
          return Center(child: NormalText('Nothing to show'));
        }
    
        final int statusCode = snapshot.data.statusCode;
        if (statusCode > 299) {
          if(statusCode == 401) {
            return loginNavigation();
          }
          return Center(child: NormalText('Error: $statusCode'));
        }

        var responseBody = json.decode(snapshot.data.body);
        widget.info = MemberInfo(
          id: responseBody["id"],
          name: responseBody["username"],
          phone: responseBody["phone"],
          email: responseBody["email"],
          faculty: "Ky Thuat Hoa Hoc",
        );

        return SingleChildScrollView(
          child: Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(30)),
              color: Colors.white
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                GeneralImage(
                  MediaQuery.of(context).size.width * 0.5,
                  'assets/images/TC_Avatar.png',
                  round: true,
                ),
                _infoLabel(),
                Button(
                  "Sign out",
                  160,
                  48,
                  onTapFunction: () {
                    Navigator.pop(context);
                  },
                ),
                SizedBox(
                  height: 10,
                ),
              ],
            ),
          ),
        ); 
      }
    );

  }
}
