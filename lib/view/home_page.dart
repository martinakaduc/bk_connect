import 'dart:convert';
import 'dart:ui';

import 'package:bkconnect/controller/info.dart';
import 'package:bkconnect/view/camera.dart';
import 'package:bkconnect/view/components/button.dart';
import 'package:bkconnect/view/components/image.dart';
import 'package:bkconnect/view/gallery.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:bkconnect/controller/config.dart';
import 'package:bkconnect/view/components/text.dart';
import 'package:url_launcher/url_launcher.dart';

class HomePage extends StatefulWidget {
  HomePage() : super();
  List<MemberInfo> infos = <MemberInfo>[];
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final List<MemberInfo> infos = <MemberInfo>[];
  // This function is only used for test purpose
  bool isLoading = false;
  @override
  void initState() {
    super.initState();
    // _getFriendList();
  }

  Future<dynamic> _getFriendList() async {
    var storage = FlutterSecureStorage();
    var token = await storage.read(key: "token");
    return await http.get(base_url + "/getFriendList/",
        headers: {"Authorization": "Bearer $token"});

    // print(infos[0].getEmail());
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _getFriendList(),
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
        var responseBody = json.decode(snapshot.data.body);
        var friendList = responseBody["infoFriends"];
        // print(friendList["infoFriends"]);

        for (var friend in friendList) {
          MemberInfo info;
          info = MemberInfo(
            email: friend["email"],
            id: friend["id"],
            name: friend["username"],
            phone: friend["phone"],
            faculty: "Khoa học và kỹ thuật máy tính",
          );
          infos.add(info);
        }
        widget.infos = infos;
        // print(infos[0].getEmail());
        // print(widget.infos[0].getName());
        // if (widget.infos.length == 0)
        //   return CircularProgressIndicator();
        // else
        return Stack(
          children: <Widget>[
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                SizedBox(height: 74),
                Expanded(
                  child: ListView.separated(
                    shrinkWrap: true,
                    padding: const EdgeInsets.all(1),
                    itemCount: widget.infos.length,
                    itemBuilder: (BuildContext context, int index) {
                      // these if-else statement is only used for test purpose
                      //***************************************************************
                      String image = "assets/images/image1.png";

                      //***************************************************************
                      return InformationCard(
                          image: image, info: widget.infos[index]);
                      // var info = infos[index].getEmail();
                      // return Text('$info');
                    },
                    separatorBuilder: (BuildContext context, int index) =>
                        const SizedBox(height: 10.0),
                  ),
                ),
                SizedBox(
                  height: 30,
                ),
              ],
            ),
            Container(
              width: MediaQuery.of(context).size.width,
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
                    onTapFunction: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => GalleryView()));
                    },
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}

class InformationCard extends StatelessWidget {
  InformationCard({Key key, this.image, this.info}) : super(key: key);
  final MemberInfo info;
  final String image;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Container(
          height: 120,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(10)),
          ),
          child: Card(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Container(
                  margin: EdgeInsets.all(5),
                  child: GeneralImage(
                    100,
                    this.image,
                    round: true,
                  ),
                ),
                SizedBox(
                  width: 20,
                ),
                Expanded(
                  child: Container(
                    padding: EdgeInsets.all(5),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Text(
                            info.getName().toString(),
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.w700,
                                fontFamily: "Roboto",
                                fontStyle: FontStyle.normal,
                                fontSize: 20.0),
                          ),
                        ),
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Text(
                            info.getID(),
                            style: const TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.w400,
                                fontFamily: "Roboto",
                                fontStyle: FontStyle.normal,
                                fontSize: 14.0),
                          ),
                        ),
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Text(
                            info.getPhone().toString(),
                            style: const TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.w400,
                                fontFamily: "Roboto",
                                fontStyle: FontStyle.normal,
                                fontSize: 14.0),
                          ),
                        ),
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Text(
                            info.getEmail().toString(),
                            style: const TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.w400,
                                fontFamily: "Roboto",
                                fontStyle: FontStyle.normal,
                                fontSize: 14.0),
                          ),
                        ),
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Text(
                            "Khoa " + info.getFaculty().toString(),
                            style: const TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.w400,
                                fontFamily: "Roboto",
                                fontStyle: FontStyle.normal,
                                fontSize: 14.0),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        Positioned(
          top: 5,
          right: 20,
          child: IconButton(
            icon: Icon(Icons.more_horiz),
            onPressed: () => _settingModalBottomSheet(context, info),
          ),
        ),
      ],
    );
  }

  void _settingModalBottomSheet(context, MemberInfo info) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return Container(
            height: 330,
            child: Column(
              children: <Widget>[
                InfoMenuCard(
                  image: 'assets/images/save_icon.png',
                  title: 'Save to contact',
                  text: 'Save this people to phone contact',
                ),
                InfoMenuCard(
                  image: 'assets/images/share_icon.png',
                  title: 'Share contact',
                  text: 'Share this contact to your friend',
                ),
                InfoMenuCard(
                  image: 'assets/images/call_icon.png',
                  title: 'Call',
                  text: 'Try to make connection by calling',
                  onTap: () {
                    launch("tel://" + info.getPhone());
                  },
                ),
                InfoMenuCard(
                  image: 'assets/images/delete_icon.png',
                  title: 'Delete',
                  text: 'Remove this contact in recognized',
                )
              ],
            ),
          );
          // return Container(
          //   child: new Wrap(
          //     children: <Widget>[
          //       new ListTile(
          //           leading: new Icon(Icons.music_note),
          //           title: new Text('Music'),
          //           onTap: () => {}),
          //       new ListTile(
          //         leading: new Icon(Icons.videocam),
          //         title: new Text('Video'),
          //         onTap: () => {},
          //       ),
          //     ],
          //   ),
          // );
        });
  }
}

class InfoMenuCard extends StatelessWidget {
  InfoMenuCard({Key key, this.image, this.title, this.text, this.onTap})
      : super(key: key);
  final String title;
  final String text;
  final String image;
  final GestureTapCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        height: 80,
        decoration: BoxDecoration(
          border: Border.all(color: const Color(0xffe0e0e0), width: 1),
        ),
        child: Card(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Container(
                margin: EdgeInsets.all(5),
                child: GeneralImage(
                  50,
                  this.image,
                  round: true,
                ),
              ),
              SizedBox(
                width: 20,
              ),
              Expanded(
                child: Container(
                  padding: EdgeInsets.all(5),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Text(
                          this.title,
                          style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.w500,
                              fontFamily: "Roboto",
                              fontStyle: FontStyle.normal,
                              fontSize: 24.0),
                        ),
                      ),
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Text(
                          this.text,
                          style: const TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.w400,
                              fontFamily: "Roboto",
                              fontStyle: FontStyle.normal,
                              fontSize: 18.0),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
