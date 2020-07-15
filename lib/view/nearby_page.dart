import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:async';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

const double CAMERA_ZOOM = 25.0;
const int POSITON_UPDATE_TIME_INTERVAL = 1000;

class NearbyPage extends StatefulWidget {
  NearbyPage();

  @override
  _NearbyPageState createState() => _NearbyPageState();
}

class _NearbyPageState extends State<NearbyPage> {
  Completer<GoogleMapController> _controller = Completer();
  Position currentPosition;

  static const LatLng _center = const LatLng(10.772614, 106.657698);

  final Set<Marker> _markers = Set<Marker>();

  void _onMapCreated(GoogleMapController controller) {
    _controller.complete(controller);
  }

  @override
  void initState() {
    // _markers.add(Marker(
    //   // This marker id can be anything that uniquely identifies each marker.
    //   markerId: MarkerId(_center.toString()),
    //   position: _center,
    //   infoWindow: InfoWindow(
    //     title: 'Trường Đại học Bách khoa - Đại học Quốc gia TP.HCM',
    //     snippet: '268 Lý Thường Kiệt, Phường 14, Quận 10, Hồ Chí Minh',
    //   ),
    //   icon: BitmapDescriptor.defaultMarker,
    // ));

    Geolocator()
        .getPositionStream(LocationOptions(
            accuracy: LocationAccuracy.best,
            timeInterval: POSITON_UPDATE_TIME_INTERVAL))
        .listen((position) {
      currentPosition = position;
      updateCurrentPosition();
    });

    setInitialPins();
    setInitialPosition();

    super.initState();
  }

  void updateCurrentPosition() async {
    final GoogleMapController controller = await _controller.future;
    var cameraPosition = CameraPosition(
      target: LatLng(currentPosition.latitude, currentPosition.longitude),
      zoom: CAMERA_ZOOM,
    );
    controller.animateCamera(CameraUpdate.newCameraPosition(cameraPosition));
    setState(() {
      _markers.removeWhere((marker) =>
          marker.markerId.value == "current pin"); // remove previous pin
      _markers.add(Marker(
        // update current pin
        // This marker id can be anything that uniquely identifies each marker.
        markerId: MarkerId("current pin"),
        position: LatLng(currentPosition.latitude, currentPosition.longitude),
        infoWindow: InfoWindow(
          title: 'You are here',
        ),
        icon: BitmapDescriptor.defaultMarker,
      ));
    });
  }

  void setInitialPosition() async {
    currentPosition = await Geolocator().getCurrentPosition();
  }

  void setInitialPins() {
    setState(() {
      _markers.add(Marker(
        // This marker id can be anything that uniquely identifies each marker.
        markerId: MarkerId(_center.toString()),
        position: _center,
        infoWindow: InfoWindow(
          title: 'Trường Đại học Bách khoa - Đại học Quốc gia TP.HCM',
          snippet: '268 Lý Thường Kiệt, Phường 14, Quận 10, Hồ Chí Minh',
        ),
        icon: BitmapDescriptor.defaultMarker,
      ));
    });
  }

  @override
  Widget build(BuildContext context) {
    CameraPosition initialCameraPosition =
        CameraPosition(target: _center, zoom: CAMERA_ZOOM);
    if (currentPosition != null) {
      initialCameraPosition = CameraPosition(
        target: LatLng(currentPosition.latitude, currentPosition.longitude),
        zoom: CAMERA_ZOOM,
      );
    }

    return GoogleMap(
      onMapCreated: _onMapCreated,
      initialCameraPosition: initialCameraPosition,
      mapType: MapType.normal,
      zoomGesturesEnabled: true,
      myLocationButtonEnabled: true,
      myLocationEnabled: true,
      mapToolbarEnabled: true,
      compassEnabled: true,
      markers: _markers,
    );
  }
}
