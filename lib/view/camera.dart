import 'dart:convert';
import 'package:bkconnect/view/components/image.dart';
import 'package:bkconnect/controller/config.dart';
import 'package:bkconnect/view/utils.dart';
import 'package:camera/camera.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_ml_vision/firebase_ml_vision.dart';
import 'detector_painters.dart';
import 'utils.dart';
import 'package:image/image.dart' as imglib;
import 'dart:math';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class CameraView extends StatefulWidget {
  CameraView() : super();

  @override
  _CameraViewState createState() => _CameraViewState();
}

class _CameraViewState extends State<CameraView> {
  CameraController _controller;
  // Future<void> _initializeControllerFuture;
  bool isCameraReady = false;
  bool _isDetecting = false;
  dynamic _scanResults;
  CameraLensDirection _direction = CameraLensDirection.back;
  dynamic _image;
  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }

  void _initializeCamera() async {
    // final cameras = await availableCameras();
    // final firstCamera = cameras.first;
    // await PermissionHandler().requestPermissions(<PermissionGroup>[
    //   PermissionGroup.camera,
    //   PermissionGroup.storage,
    // ]);
    CameraDescription description = await getCamera(_direction);
    ImageRotation rotation = rotationIntToImageRotation(
      description.sensorOrientation,
    );

    _controller = CameraController(description, ResolutionPreset.high);
    await _controller.initialize();
    if (!mounted) {
      return;
    }
    setState(() {
      isCameraReady = true;
    });

    _controller.startImageStream((CameraImage image) {
      if (_isDetecting) return;
      _isDetecting = true;

      detect(image, FirebaseVision.instance.faceDetector().processImage,
              rotation)
          .then(
        (dynamic result) {
          setState(() {
            _scanResults = result;
          });
          _isDetecting = false;
        },
      ).catchError((_) {
        _isDetecting = false;
      }).then((_) {
        setState(() {
          _image = image;
        });
      });
    });
  }

  Widget _buildResults() {
    const Text noResultsText = const Text('No results!');

    if (_scanResults == null ||
        _controller == null ||
        !_controller.value.isInitialized) {
      return noResultsText;
    }

    CustomPainter painter;

    final Size imageSize = Size(
      _controller.value.previewSize.height,
      _controller.value.previewSize.width,
    );
    if (_scanResults is! List<Face>) return noResultsText;
    painter = FaceDetectorPainter(imageSize, _scanResults);

    return CustomPaint(
      painter: painter,
    );
  }

  void cropFaceFromImage(CameraImage image) async {
    int index = 0;
    int maxSize = 0;
    int i = 0;
    for (Face face in _scanResults) {
      int size =
          (face.boundingBox.right.toInt() - face.boundingBox.left.toInt()) *
              (face.boundingBox.bottom.toInt() - face.boundingBox.top.toInt());
      if (maxSize < size) {
        maxSize = size;
        index = i;
      }
      i++;
    }
    Face face = _scanResults[index];
    // print(face.boundingBox);
    const shift = (0xFF << 24);
    final int width = image.width;
    final int height = image.height;
    final int uvRowStride = image.planes[1].bytesPerRow;
    final int uvPixelStride = image.planes[1].bytesPerPixel;

    // print("uvRowStride: " + uvRowStride.toString());
    // print("uvPixelStride: " + uvPixelStride.toString());

    // imgLib -> Image package from https://pub.dartlang.org/packages/image
    var img = imglib.Image(width, height); // Create Image buffer

    // Fill image buffer with plane[0] from YUV420_888
    for (int x = 0; x < width; x++) {
      for (int y = 0; y < height; y++) {
        final int uvIndex =
            uvPixelStride * (x / 2).floor() + uvRowStride * (y / 2).floor();
        final int index = y * width + x;

        final yp = image.planes[0].bytes[index];
        final up = image.planes[1].bytes[uvIndex];
        final vp = image.planes[2].bytes[uvIndex];
        // Calculate pixel color
        int r = (yp + vp * 1436 / 1024 - 179).round().clamp(0, 255);
        int g = (yp - up * 46549 / 131072 + 44 - vp * 93604 / 131072 + 91)
            .round()
            .clamp(0, 255);
        int b = (yp + up * 1814 / 1024 - 227).round().clamp(0, 255);
        // color: 0x FF  FF  FF  FF
        //           A   B   G   R
        img.data[index] = shift | (b << 16) | (g << 8) | r;
      }
    }

    imglib.PngEncoder pngEncoder = new imglib.PngEncoder(level: 0, filter: 0);
    img = imglib.copyRotate(img, 90);
    List<int> png = pngEncoder.encodeImage(img);

    imglib.Image src = imglib.decodeImage(png);

    var cropSize = max(
        face.boundingBox.right.toInt() - face.boundingBox.left.toInt(),
        face.boundingBox.bottom.toInt() - face.boundingBox.top.toInt());
    // int offsetX = (src.width - min(src.width, src.height)) ~/ 2;
    // int offsetY = (src.height - min(src.width, src.height)) ~/ 2;

    imglib.Image destImage = imglib.copyCrop(
      src,
      face.boundingBox.left.toInt(),
      face.boundingBox.top.toInt(),
      cropSize,
      cropSize,
    );

    // var jpg = imglib.encodeJpg(destImage);

    String base64Image = base64Encode(imglib.encodeJpg(destImage));
    // var header = {"Content-Type": "application/json"};

    // var storage = FlutterSecureStorage();
    // var token = await storage.read(key: "token");
    // var profile = await http.get(base_url + "/profile/",
    //     headers: {"Authorization": "Bearer $token"});
    // var info = await jsonDecode(profile.body);
    // var body = {"image": base64Image, "id": info["id"]};
    // var response = await http.post(base_url + '/recognize/',
    //     headers: header, body: jsonEncode(body));
    // var responseJson = jsonDecode(response.body);
    // showPopUp(responseJson);
    var storage = FlutterSecureStorage();
    var token = await storage.read(key: "token");
    var body = {"image": base64Image};
    var response = await http.post(base_url + '/recognize/',
        headers: {
          "Authorization": "Bearer $token",
          "Content-Type": "application/json"
        },
        body: jsonEncode(body));
    var responseJson = jsonDecode(response.body);
    showPopUp(responseJson);
    // await getExternalStorageDirectories().then((List<Directory> directory) {
    //   print(directory[0].path);
    //   File(directory[0].path + '/image.jpg').writeAsBytes(jpg);
    // });
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

  // void showPopUp(responseJson) {
  //   showCupertinoDialog(
  //       context: context,
  //       builder: (context) {
  //         return CupertinoAlertDialog(
  //           title: Text("Success!",
  //               style: const TextStyle(
  //                   color: const Color(0xff1588db),
  //                   fontWeight: FontWeight.w700,
  //                   fontFamily: "Roboto",
  //                   fontStyle: FontStyle.normal,
  //                   fontSize: 24.0)),
  //           content: Container(
  //               width: 350,
  //               height: 500,
  //               decoration: BoxDecoration(
  //                   borderRadius: BorderRadius.all(Radius.circular(30)),
  //                   color: const Color(0xf2f6f7f5)),

  //                 child: Table(
  //                   columnWidths: {
  //                     0: FlexColumnWidth(2.0),
  //                     1: FlexColumnWidth(3.0),
  //                   },

  //                 children: <TableRow>[
  //                   TableRow(
  //                     children: <Widget>[
  //                       Padding(
  //                           child: Text("Full name:",
  //                               style: TextStyle(
  //                                   fontWeight: FontWeight.w700,
  //                                   fontSize: 20,
  //                                   color: Colors.black)),
  //                           padding: EdgeInsets.symmetric(
  //                               vertical: 8, horizontal: 12)),
  //                       Padding(
  //                           child: Text(responseJson["username"],
  //                               style: TextStyle(
  //                                   fontWeight: FontWeight.w700,
  //                                   fontSize: 20,
  //                                   color: Color(0xff828282))),
  //                           padding: EdgeInsets.symmetric(
  //                               vertical: 8, horizontal: 12)),
  //                     ],
  //                   ),
  //                   TableRow(
  //                     children: <Widget>[
  //                       Padding(
  //                           child: Text("Student ID",
  //                               style: TextStyle(
  //                                   fontWeight: FontWeight.w700,
  //                                   fontSize: 20,
  //                                   color: Colors.black)),
  //                           padding: EdgeInsets.symmetric(
  //                               vertical: 8, horizontal: 12)),
  //                       Padding(
  //                           child: Text(responseJson["id"],
  //                               style: TextStyle(
  //                                   fontWeight: FontWeight.w700,
  //                                   fontSize: 20,
  //                                   color: Color(0xff828282))),
  //                           padding: EdgeInsets.symmetric(
  //                               vertical: 8, horizontal: 12)),
  //                     ],
  //                   ),
  //                   TableRow(
  //                     children: <Widget>[
  //                       Padding(
  //                           child: Text("Phone: ",
  //                               style: TextStyle(
  //                                   fontWeight: FontWeight.w700,
  //                                   fontSize: 20,
  //                                   color: Colors.black)),
  //                           padding: EdgeInsets.symmetric(
  //                               vertical: 8, horizontal: 12)),
  //                       Padding(
  //                           child: Text(responseJson["phone"],
  //                               style: TextStyle(
  //                                   fontWeight: FontWeight.w700,
  //                                   fontSize: 20,
  //                                   color: Color(0xff828282))),
  //                           padding: EdgeInsets.symmetric(
  //                               vertical: 8, horizontal: 12)),
  //                     ],
  //                   ),
  //                   TableRow(
  //                     children: <Widget>[
  //                       Padding(
  //                           child: Text("Email: ",
  //                               style: TextStyle(
  //                                   fontWeight: FontWeight.w700,
  //                                   fontSize: 20,
  //                                   color: Colors.black)),
  //                           padding: EdgeInsets.symmetric(
  //                               vertical: 8, horizontal: 12)),
  //                       Padding(
  //                           child: Text(responseJson["email"],
  //                               style: TextStyle(
  //                                   fontWeight: FontWeight.w700,
  //                                   fontSize: 20,
  //                                   color: Color(0xff828282))),
  //                           padding: EdgeInsets.symmetric(
  //                               vertical: 8, horizontal: 12)),
  //                     ],
  //                   ),
  //                 ],
  //               )),
  //           actions: [
  //             new FlatButton(
  //               child: const Text("OK"),
  //               onPressed: () {
  //                 Navigator.pop(context);
  //               },
  //             ),
  //           ],
  //         );
  //       });
  // }

  Future<dynamic> getProfile() async {
    var storage = FlutterSecureStorage();
    var token = await storage.read(key: "token");
    return await http.get(base_url + "/profile/",
        headers: {"Authorization": "Bearer $token"});
  }

  // Widget loginNavigation() {
  //   return Container(
  //     height: MediaQuery.of(context).size.height,
  //     width: MediaQuery.of(context).size.width,
  //     decoration: BoxDecoration(
  //         borderRadius: BorderRadius.all(Radius.circular(30)),
  //         color: Colors.white),
  //     child: Column(
  //       mainAxisAlignment: MainAxisAlignment.center,
  //       children: <Widget>[
  //         NormalText("Token has expired. Please login again"),
  //         SizedBox(
  //           height: 30,
  //         ),
  //         Button(
  //           "Login",
  //           124,
  //           48,
  //           fontSize: 20,
  //           onTapFunction: () {
  //             Navigator.push(context,
  //                 MaterialPageRoute(builder: (context) => LoginScreen()));
  //           },
  //         ),
  //       ],
  //     ),
  //   );
  // }
  // dynamic getProfile() async {
  //   var storage = FlutterSecureStorage();
  //   var token = await storage.read(key: "token");
  //   return await http.get(base_url + "/profile/",
  //       headers: {"Authorization": "Bearer $token"});
  // }
  // @override
  // void didChangeAppLifecycleState(AppLifecycleState state) {
  //   if (state == AppLifecycleState.resumed) {
  //     _controller != null
  //         ? _initializeControllerFuture = _controller.initialize()
  //         : null; //on pause camera is disposed, so we need to call again "issue is only for android"
  //   }
  // }

  Widget _buildImage() {
    return Container(
      constraints: const BoxConstraints.expand(),
      child: _controller == null
          ? const Center(
              child: Text(
                'Initializing Camera...',
                style: TextStyle(
                  color: Colors.green,
                  fontSize: 30.0,
                ),
              ),
            )
          : Stack(
              fit: StackFit.expand,
              children: <Widget>[
                CameraPreview(_controller),
                _buildResults(),
              ],
            ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // final size = MediaQuery.of(context).size;
    // final deviceRatio = size.width / size.height;

    // return FutureBuilder<void>(
    // future: _initializeControllerFuture,
    // builder: (context, snapshot) {
    // if (snapshot.connectionState == ConnectionState.done) {
    // If the Future is complete, display the preview.
    return Scaffold(
      body: InkWell(
        onTap: () {
          // _isDetecting = true;
          cropFaceFromImage(_image);
          // print("Hello");
          //TODO: Do something to crop face from image
        },
        child: _buildImage(),
      ),
      // body: Transform.scale(
      //   scale: _controller.value.aspectRatio / deviceRatio,
      //   child: Center(
      //     child: AspectRatio(
      //       aspectRatio: _controller.value.aspectRatio,
      //       child: CameraPreview(_controller), //cameraPreview
      //     ),
      //   ),
      // ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
      floatingActionButton: Column(
        children: <Widget>[
          SizedBox(
            height: 30,
          ),
          Opacity(
            child: FloatingActionButton(
              onPressed: () async {
                await _controller?.stopImageStream();
                await _controller?.dispose();
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
            opacity: 0.5,
          ),
        ],
      ),
    );
    // } else {
    // return Center(
    // child: CircularProgressIndicator(
    // backgroundColor: const Color(0xff1588db),
    // ),
    // ); // Otherwise, display a loading indicator.
  }
  // },
  // );
}
// }
