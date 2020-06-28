import 'package:bkconnect/controller/info.dart';
import 'package:bkconnect/view/camera.dart';
import 'package:bkconnect/view/components/button.dart';
import 'package:bkconnect/view/components/image.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  HomePage();

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  
  final List<MemberInfo> infos = <MemberInfo>[];

  // This function is only used for test purpose
  @override
  void initState() {
    for(var i=0; i<8; i++) {
      MemberInfo info;
      if(i%4 == 0) {
        info = MemberInfo(
          name: "Trần Thùy Chi",
          id: "181011x",
          email: "daylaemail@hcmut.edu.vn",
          phone: "0898 xxx yyy",
          faculty: "Kỹ thuật Hóa học"
        );
      }
      else if(i%4 == 1) {
        info = MemberInfo(
          name: "Nguyễn Thùy Chi",
          id: "181111x",
          email: "daylaemail@hcmut.edu.vn",
          phone: "0898 xxx yyy",
          faculty: "Cơ khí",
        );        
      }
      else if(i%4 == 2) {
        info = MemberInfo(
          name: "Nguyễn Hoàng Yến",
          id: "181211x",
          email: "daylaemail@hcmut.edu.vn",
          phone: "0898 xxx yyy",
          faculty: "Khoa học ứng dụng",
        );        
      }
      else if(i%4 == 3) {
        info = MemberInfo(
          name: "Dương Hoàng Yến",
          id: "181311x",
          email: "daylaemail@hcmut.edu.vn",
          phone: "0898 xxx yyy",
          faculty: "Quản lý công nghiệp",
        );        
      }
      infos.add(info);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            SizedBox(
              height: 74
            ),
            Expanded(
              child: ListView.separated(
                shrinkWrap: true,
                padding: const EdgeInsets.all(1),
                itemCount: infos.length,
                itemBuilder: (BuildContext context, int index) {
                  // these if-else statement is only used for test purpose
                  //***************************************************************
                  String image;
                  if(index%4==0) {
                    image = "assets/images/image1.png";
                  }
                  else if(index%4==1) {
                    image = "assets/images/image2.png";
                  }
                  else if(index%4==2) {
                    image = "assets/images/image3.png";
                  }
                  else if(index%4==3) {
                    image = "assets/images/image4.png";
                  }
                  //***************************************************************
                  return InformationCard(image: image, info: infos[index]);
                },
                separatorBuilder: (BuildContext context, int index) => const SizedBox(height: 10.0),
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
                onTapFunction: () {},
              ),
            ],
          ),
        ),
      ],
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
                  child: GeneralImage(100, this.image, round: true,),
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
                        Text(
                          info.getName(), 
                          style: TextStyle(
                            color:  Colors.black,
                            fontWeight: FontWeight.w700,
                            fontFamily: "Roboto",
                            fontStyle:  FontStyle.normal,
                            fontSize: 20.0
                          ),
                        ),
                        Text(
                          info.getID(), 
                          style: const TextStyle(
                            color:  Colors.black,
                            fontWeight: FontWeight.w400,
                            fontFamily: "Roboto",
                            fontStyle:  FontStyle.normal,
                            fontSize: 14.0
                          ),     
                        ),
                        Text(
                          info.getPhone(), 
                          style: const TextStyle(
                            color:  Colors.black,
                            fontWeight: FontWeight.w400,
                            fontFamily: "Roboto",
                            fontStyle:  FontStyle.normal,
                            fontSize: 14.0
                          ),     
                        ),
                        Text(
                          info.getEmail(), 
                          style: const TextStyle(
                            color:  Colors.black,
                            fontWeight: FontWeight.w400,
                            fontFamily: "Roboto",
                            fontStyle:  FontStyle.normal,
                            fontSize: 14.0
                          ),     
                        ),
                        Text(
                          "Khoa " + info.getFaculty(), 
                          style: const TextStyle(
                            color:  Colors.black,
                            fontWeight: FontWeight.w400,
                            fontFamily: "Roboto",
                            fontStyle:  FontStyle.normal,
                            fontSize: 14.0
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
        Positioned(top: 5, right: 20, child: Icon(Icons.more_horiz),),
      ],
    ); 

  }
}