import 'package:bkconnect/view/components/image.dart';
import 'package:flutter/material.dart';

class NewsPage extends StatefulWidget {
  NewsPage();

  @override
  _NewsPageState createState() => _NewsPageState();
}

class _NewsPageState extends State<NewsPage> {

  
  final List<News> news = <News>[];

  // This function is only used for test purpose
  @override
  void initState() {
    for(var i=0; i<8; i++) {
      News notification;
      if(i%4 == 0) {
        notification = News(
          title: "Nearby: Tìm thấy nhiều người",
          text: "Có nhiều sinh viên Bách Khoa xung quanh bạn. Hãy mở Nearby và khám phá nhé!"
        );
      }
      else if(i%4 == 1) {
        notification = News(
          title: "Nearby: Có người quen",
          text: "Một người trong số những liên hệ bạn đã lưu đang ở gần bạn. Hãy mở Nearby và tìm họ nhé!"
        );        
      }
      else if(i%4 == 2) {
        notification = News(
          title: "Liên hệ có thay đổi",
          text: "Có người trong số những liên hệ của bạn vừa thay đổi số điện thoại. Hãy mở profile của họ và lưu lại nhé!"
        );        
      }
      else if(i%4 == 3) {
        notification = News(
          title: "Liên hệ chưa được lưu",
          text: "Có vài liên hệ bạn đã gặp nhưng chưa lưu vào danh bạ. Hãy lưu thông tin ngay để liên hệ họ nhé!"
        );          
      }
      news.add(notification);
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
                itemCount: news.length,
                itemBuilder: (BuildContext context, int index) {
                  // these if-else statement is only used for test purpose
                  //***************************************************************
                  String image;
                  if(index%4==0) {
                    image = "assets/images/nearby1.png";
                  }
                  else if(index%4==1) {
                    image = "assets/images/nearby2.png";
                  }
                  else if(index%4==2) {
                    image = "assets/images/contact1.png";
                  }
                  else if(index%4==3) {
                    image = "assets/images/contact2.png";
                  }
                  //***************************************************************
                  return NewsCard(image: image, title: news[index].title, text: news[index].text,);
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
              Expanded(
                child: Container(
                  height: 104,
                  decoration: BoxDecoration(
                    boxShadow: [BoxShadow(
                      color: const Color(0x40000000),
                      offset: Offset(0,4),
                      blurRadius: 4,
                      spreadRadius: 0
                    )] ,
                    color: Colors.white
                  ),
                  child: FlatButton(
                    onPressed: null,
                    child: Text(
                      "News",
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color:  Colors.black,
                        fontWeight: FontWeight.w400,
                        fontFamily: "Roboto",
                        fontStyle:  FontStyle.normal,
                        fontSize: 24.0
                      ),                
                    ), 
                  ),
                ),
              ),
              Expanded(
                child: Container(
                  height: 104,
                  decoration: BoxDecoration(
                    boxShadow: [BoxShadow(
                      color: const Color(0x40000000),
                      offset: Offset(0,4),
                      blurRadius: 4,
                      spreadRadius: 0
                    )] ,
                    color: Colors.white
                  ),
                  child: FlatButton(
                    onPressed: null,
                    child: Text(
                      "Update",
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: const Color(0xff828282),
                        fontWeight: FontWeight.w400,
                        fontFamily: "Roboto",
                        fontStyle:  FontStyle.normal,
                        fontSize: 24.0
                      ),                
                    ), 
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}


class NewsCard extends StatelessWidget {
  NewsCard({Key key, this.image, this.title, this.text}) : super(key: key);
  final String title;
  final String text;
  final String image;

  @override
  Widget build(BuildContext context) {
    return Container(
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
                          this.title, 
                          style: TextStyle(
                            color:  Colors.black,
                            fontWeight: FontWeight.w700,
                            fontFamily: "Roboto",
                            fontStyle:  FontStyle.normal,
                            fontSize: 20.0
                          ),
                        ),
                        Text(
                          this.text, 
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
        );

  }
}

class News {
  News({this.title, this.text});
  String title;
  String text;
}