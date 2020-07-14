import 'dart:io';
import 'dart:ui' as ui;
import 'dart:convert';
import 'package:bkconnect/view/components/image.dart';
import 'package:bkconnect/controller/config.dart';
import 'package:flutter/material.dart';
import 'package:firebase_ml_vision/firebase_ml_vision.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image/image.dart' as imglib;
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'dart:math';

class GalleryView extends StatefulWidget {
  GalleryView() : super();
  @override
  _GalleryViewState createState() => _GalleryViewState();
}

class _GalleryViewState extends State<GalleryView> {
  @override
  void initState() {
    super.initState();
    _getImageAndDetectFaces();
  }

  File _imageFile;
  List<Face> _faces;
  bool isLoading = false;
  ui.Image _image;
  Size _imageSize;
  void _getImageAndDetectFaces() async {
    final imageFilePicked =
        await ImagePicker().getImage(source: ImageSource.gallery);
    final File imageFile = File(imageFilePicked.path);
    setState(() {
      isLoading = true;
    });
    final image = FirebaseVisionImage.fromFile(imageFile);
    final faceDetector = FirebaseVision.instance.faceDetector();
    List<Face> faces = await faceDetector.processImage(image);
    if (mounted) {
      setState(() {
        _imageFile = imageFile;
        _faces = faces;
        _loadImage(imageFile);
      });
    }
  }

  _loadImage(File file) async {
    final data = await file.readAsBytes();
    await decodeImageFromList(data).then(
      (value) => setState(() {
        _image = value;
        isLoading = false;
        _imageSize = Size(
          _image.width.toDouble(),
          _image.height.toDouble(),
        );
      }),
    );
  }

  void showPopUp(responseJson) {
    // var height = MediaQuery.of(context).size.height;
    // var width = MediaQuery.of(context).size.width;
    showDialog(
        context: context,
        builder: (context) {
          return ConstrainedBox(
              constraints: BoxConstraints(maxHeight: 150.0, minWidth: 180.0),
              child: AlertDialog(
                scrollable: true,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(30))),
                backgroundColor: const Color(0xf2f6f7f5),
                // insetPadding:
                //     EdgeInsets.symmetric(horizontal: 24, vertical: 40),
                title: Text("Success!",
                    style: const TextStyle(
                        color: const Color(0xff1588db),
                        fontWeight: FontWeight.w700,
                        fontFamily: "Roboto",
                        fontStyle: FontStyle.normal,
                        fontSize: 24.0),
                    textAlign: TextAlign.center),
                content: Column(
                  // height: MediaQuery.of(context).size.height,
                  // width: MediaQuery.of(context).size.width,
                  // decoration: BoxDecoration(
                  //     borderRadius: BorderRadius.all(Radius.circular(30)),
                  //     color: const Color(0xf2f6f7f5)),
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    GeneralImage(
                      MediaQuery.of(context).size.width * 0.5,
                      'assets/images/TC_Avatar.png',
                      round: true,
                    ),
                    _infoLabel(responseJson),
                  ],
                ),
                actions: [
                  new FlatButton(
                    child: const Text("OK"),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                ],
              ));
        });
  }

  Widget _infoLabel(responseJson) {
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
                        fontSize: 18,
                        color: Colors.black)),
                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 5)),
            Padding(
                child: Text(responseJson["username"],
                    style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 18,
                        color: Color(0xff828282))),
                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 5)),
          ],
        ),
        TableRow(
          children: <Widget>[
            Padding(
                child: Text("Student ID:",
                    style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 18,
                        color: Colors.black)),
                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 5)),
            Padding(
                child: Text(responseJson["id"],
                    style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 18,
                        color: Color(0xff828282))),
                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 5)),
          ],
        ),
        TableRow(
          children: <Widget>[
            Padding(
                child: Text("Phone:",
                    style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 18,
                        color: Colors.black)),
                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 5)),
            Padding(
                child: Text(responseJson["phone"],
                    style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 18,
                        color: Color(0xff828282))),
                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 5)),
          ],
        ),
        TableRow(
          children: <Widget>[
            Padding(
                child: Text("Email:",
                    style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 18,
                        color: Colors.black)),
                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 5)),
            Padding(
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Text(responseJson["email"],
                      style: TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 18,
                          color: Color(0xff828282))),
                ),
                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 5)),
          ],
        ),
      ],
    );
  }

  void cropFaceFromImage(File _imageFile) async {
    int index = 0;
    int maxSize = 0;
    int i = 0;
    for (Face face in _faces) {
      int size =
          (face.boundingBox.right.toInt() - face.boundingBox.left.toInt()) *
              (face.boundingBox.bottom.toInt() - face.boundingBox.top.toInt());
      if (maxSize < size) {
        maxSize = size;
        index = i;
      }
      i++;
    }
    Face face = _faces[index];
    imglib.Image image = imglib.decodeImage(_imageFile.readAsBytesSync());
    // image = imglib.copyRotate(image, 90);

    var cropSize = max(
        face.boundingBox.right.toInt() - face.boundingBox.left.toInt(),
        face.boundingBox.bottom.toInt() - face.boundingBox.top.toInt());

    imglib.Image destImage = imglib.copyCrop(
      image,
      face.boundingBox.left.toInt(),
      face.boundingBox.top.toInt(),
      cropSize,
      cropSize,
    );

    String base64Image = base64Encode(imglib.encodeJpg(destImage));
    var header = {"Content-Type": "application/json"};

    var storage = FlutterSecureStorage();
    var token = await storage.read(key: "token");
    var profile = await http.get(base_url + "/profile/",
        headers: {"Authorization": "Bearer $token"});
    var info = await jsonDecode(profile.body);
    var body = {"image": base64Image, "id": info["id"]};
    var response = await http.post(base_url + '/recognize/',
        headers: header, body: jsonEncode(body));
    var responseJson = jsonDecode(response.body);
    showPopUp(responseJson);
    // await getExternalStorageDirectories().then((List<Directory> directory) {
    //   print(directory[0].path);
    //   File(directory[0].path + '/image.jpg').writeAsBytes(jpg);
    // });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: InkWell(
        onTap: () {
          cropFaceFromImage(_imageFile);
        },
        child: isLoading
            ? Center(child: CircularProgressIndicator())
            : (_imageFile == null)
                ? Center(child: Text('No image selected'))
                : Center(
                    child: FittedBox(
                      child: SizedBox(
                        width: _image.width.toDouble(),
                        height: _image.height.toDouble(),
                        child: CustomPaint(
                          painter: FacePainter(_image, _faces, _imageSize),
                        ),
                      ),
                    ),
                  ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
      floatingActionButton: Column(
        children: <Widget>[
          SizedBox(
            height: 30,
          ),
          Opacity(
            child: FloatingActionButton(
              onPressed: () async {
                Navigator.pop(context);
              },
              tooltip: 'Exit',
              child: Icon(
                Icons.cancel,
                size: 40,
              ),
              elevation: 0,
              backgroundColor: Colors.transparent,
            ),
            opacity: 1,
          ),
        ],
      ),
    );
  }
}

class FacePainter extends CustomPainter {
  final ui.Image image;
  final List<Face> faces;
  final List<Rect> rects = [];
  final Size imageSize;
  FacePainter(this.image, this.faces, this.imageSize) {
    for (var i = 0; i < faces.length; i++) {
      rects.add(faces[i].boundingBox);
    }
  }

  @override
  void paint(ui.Canvas canvas, ui.Size size) {
    final Paint paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0
      ..color = Color.fromRGBO(242, 201, 76, 1);

    canvas.drawImage(image, Offset.zero, Paint());
    for (var i = 0; i < faces.length; i++) {
      canvas.drawRect(
        _scaleRect(
            rect: faces[i].boundingBox, imageSize: imageSize, widgetSize: size),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(FacePainter oldDelegate) {
    return image != oldDelegate.image || faces != oldDelegate.faces;
  }
}

Rect _scaleRect({
  @required Rect rect,
  @required Size imageSize,
  @required Size widgetSize,
}) {
  final double scaleX = widgetSize.width / imageSize.width;
  final double scaleY = widgetSize.height / imageSize.height;

  return Rect.fromLTRB(
    rect.left.toDouble() * scaleX,
    rect.top.toDouble() * scaleY,
    rect.right.toDouble() * scaleX,
    rect.bottom.toDouble() * scaleY,
  );
}
