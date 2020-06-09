import 'package:bkconnect/view/camera.dart';
import 'package:bkconnect/view/components/button.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  HomePage();

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Stack(
        children: <Widget>[
          Container(
            width: 375,
            height: 74,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(10)),
                color: Colors.white),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Button(
                  "Camera",
                  160,
                  48,
                  onTapFunction: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => CameraView()),
                    );
                  },
                ),
                SizedBox(width: 30),
                Button(
                  "Gallery",
                  160,
                  48,
                  color: Color(0xffe0e0e0),
                  onTapFunction: () {},
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
