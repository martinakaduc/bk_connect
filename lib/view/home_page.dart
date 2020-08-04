import 'dart:convert';
import 'dart:ui';
import 'dart:io';

import 'package:bkconnect/controller/info.dart';
import 'package:bkconnect/view/camera.dart';
import 'package:bkconnect/view/components/button.dart';
import 'package:bkconnect/view/components/image.dart';
import 'package:bkconnect/view/gallery.dart';
import 'package:contacts_service/contacts_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:bkconnect/controller/config.dart';
import 'package:bkconnect/view/components/text.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:bkconnect/view/login_screen.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:contacts_service/contacts_service.dart';
import 'package:flutter_appavailability/flutter_appavailability.dart';

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

  Widget loginNavigation() {
    return Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(30)),
          color: Colors.white),
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
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => LoginScreen()));
            },
          ),
        ],
      ),
    );
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

        final int statusCode = snapshot.data.statusCode;
        if (statusCode > 299) {
          if (statusCode == 401) {
            return loginNavigation();
          }
          return Center(child: NormalText('Error: $statusCode'));
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
                  onTap: () async {
                    final PermissionStatus permissionStatus =
                        await _getPermission();
                    if (permissionStatus == PermissionStatus.granted) {
                      //We can now access our contacts here
                      saveContact(info).then((value) {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              shape: RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(30.0))),
                              content: Builder(builder: (BuildContext context) {
                                var height =
                                    MediaQuery.of(context).size.height * 0.25;
                                var width =
                                    MediaQuery.of(context).size.width * 0.9;
                                return Container(
                                  height: height,
                                  width: width,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.stretch,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      Container(
                                        height: height * 0.15,
                                        child: Text(
                                          "Success!",
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            color: Colors.blue,
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
                                          "Đã lưu thành công vào danh bạ",
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
                                              color: Colors.blue,
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
                      });
                    } else {
                      //If permissions have been denied show standard cupertino alert dialog
                      print("permission error");
                    }
                  },
                ),
                InfoMenuCard(
                  image: 'assets/images/share_icon.png',
                  title: 'Share contact',
                  text: 'Share this contact to your friend',
                  onTap: () {
                    openEmailApp(context);
                  },
                ),
                InfoMenuCard(
                  image: 'assets/images/call_icon.png',
                  title: 'Call',
                  text: 'Try to make connection by calling',
                  onTap: () {
                    makePhoneCall(info.getPhone());
                  },
                ),
                InfoMenuCard(
                  image: 'assets/images/delete_icon.png',
                  title: 'Delete',
                  text: 'Remove this contact in recognized',
                  onTap: () async {
                    var success = await removeFriend(info.getID());
                    if (success) {
                      final PermissionStatus permissionStatus =
                          await _getPermission();
                      if (permissionStatus == PermissionStatus.granted) {
                        await deleteContact(info);
                      } else {
                        //If permissions have been denied show standard cupertino alert dialog
                        print("permission error");
                      }
                    }
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(30.0))),
                          content: Builder(builder: (BuildContext context) {
                            var height =
                                MediaQuery.of(context).size.height * 0.25;
                            var width = MediaQuery.of(context).size.width * 0.9;
                            return Container(
                              height: height,
                              width: width,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Container(
                                    height: height * 0.15,
                                    child: Text(
                                      success ? "Success!" : "Failure!",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        color:
                                            success ? Colors.blue : Colors.red,
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
                                      success
                                          ? "Đã xóa thành công"
                                          : "Chưa xóa được",
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
                                          color: success
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
                  },
                )
              ],
            ),
          );
        });
  }

  void makePhoneCall(String phoneNumber) {
    launch("tel://" + phoneNumber);
  }

  void openEmailApp(BuildContext context) {
    try {
      AppAvailability.launchApp(
              Platform.isIOS ? "message://" : "com.google.android.gm")
          .then((_) {
        print("App Email launched!");
      }).catchError((err) {
        Scaffold.of(context)
            .showSnackBar(SnackBar(content: Text("App Email not found!")));
        print(err);
      });
    } catch (e) {
      Scaffold.of(context)
          .showSnackBar(SnackBar(content: Text("Email App not found!")));
    }
  }

  Future<PermissionStatus> _getPermission() async {
    final PermissionStatus permission = await Permission.contacts.status;
    if (permission != PermissionStatus.granted &&
        permission != PermissionStatus.denied) {
      final Map<Permission, PermissionStatus> permissionStatus =
          await [Permission.contacts].request();
      return permissionStatus[Permission.contacts] ??
          PermissionStatus.undetermined;
    } else {
      return permission;
    }
  }

  Future saveContact(MemberInfo info) async {
    Contact newContact = new Contact();
    newContact.givenName = info.getName();
    newContact.emails = [Item(label: "email", value: info.getEmail())];
    newContact.company = info.getFaculty() + " Bách Khoa";
    newContact.phones = [Item(label: "mobile", value: info.getPhone())];
    return await ContactsService.addContact(newContact);
  }

  Future deleteContact(MemberInfo info) async {
    Iterable<Contact> contacts =
        await ContactsService.getContacts(query: info.getName());
    var contactList = contacts.toList();
    for (var contact in contactList) {
      if (contact.emails.length == 0 || contact.phones.length == 0) {
        continue;
      }
      if (contact.emails.elementAt(0).value == info.getEmail() &&
          contact.phones.elementAt(0).value == info.getPhone()) {
        return await ContactsService.deleteContact(contact);
      }
    }
    return Future;
  }

  Future<bool> removeFriend(String id) async {
    var storage = FlutterSecureStorage();
    var token = await storage.read(key: "token");
    try {
      var body = {"id": id};
      var response = await http.post(base_url + "/delete_friend/",
          headers: {
            "Authorization": "Bearer $token",
            "Content-Type": "application/json"
          },
          body: json.encode(body));
      print(response.body);
      return json.decode(response.body)["status"] == "success" ? true : false;
    } catch (e) {
      print("Delete Error");
    }
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
