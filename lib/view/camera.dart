import 'package:bkconnect/view/utils.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:firebase_ml_vision/firebase_ml_vision.dart';

import 'detector_painters.dart';
import 'utils.dart';

class CameraView extends StatefulWidget {
  CameraView() : super();

  @override
  _CameraViewState createState() => _CameraViewState();
}

class _CameraViewState extends State<CameraView> {
  CameraController _controller;
  Future<void> _initializeControllerFuture;
  bool isCameraReady = false;
  bool _isDetecting = false;
  dynamic _scanResults;

  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }

  Future<void> _initializeCamera() async {
    final cameras = await availableCameras();
    final firstCamera = cameras.first;
    CameraLensDirection _direction = CameraLensDirection.back;
    _controller = CameraController(firstCamera, ResolutionPreset.high);
    _initializeControllerFuture = _controller.initialize();
    if (!mounted) {
      return;
    }
    setState(() {
      isCameraReady = true;
    });

    CameraDescription description = await getCamera(_direction);
    ImageRotation rotation = rotationIntToImageRotation(
      description.sensorOrientation,
    );
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

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _controller != null
          ? _initializeControllerFuture = _controller.initialize()
          : null; //on pause camera is disposed, so we need to call again "issue is only for android"
    }
  }

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
    final size = MediaQuery.of(context).size;
    final deviceRatio = size.width / size.height;

    return FutureBuilder<void>(
      future: _initializeControllerFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          // If the Future is complete, display the preview.
          return Scaffold(
            body: _buildImage(),
            // body: Transform.scale(
            //   scale: _controller.value.aspectRatio / deviceRatio,
            //   child: Center(
            //     child: AspectRatio(
            //       aspectRatio: _controller.value.aspectRatio,
            //       child: CameraPreview(_controller), //cameraPreview
            //     ),
            //   ),
            // ),
            floatingActionButtonLocation:
                FloatingActionButtonLocation.endDocked,
            floatingActionButton: Column(
              children: <Widget>[
                SizedBox(
                  height: 30,
                ),
                Opacity(
                  child: FloatingActionButton(
                    onPressed: () {
                      _controller.stopImageStream();
                      _controller.dispose();
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
        } else {
          return Center(
            child: CircularProgressIndicator(
              backgroundColor: const Color(0xff1588db),
            ),
          ); // Otherwise, display a loading indicator.
        }
      },
    );
  }
}
