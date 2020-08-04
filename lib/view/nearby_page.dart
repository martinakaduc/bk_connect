import 'dart:async';
import 'dart:convert';

import 'package:bkconnect/controller/config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;

const double CAMERA_ZOOM = 20.0;
const int POSITON_UPDATE_TIME_INTERVAL = 100;

class NearbyPage extends StatefulWidget {
  NearbyPage();

  @override
  _NearbyPageState createState() => _NearbyPageState();
}

class _NearbyPageState extends State<NearbyPage> {
  Completer<GoogleMapController> _controller = Completer();
  Position currentPosition;

  static const LatLng _bk1 = const LatLng(10.772614, 106.657698);
  static const LatLng _bk2 = const LatLng(10.880527, 106.805483);

  final Set<Marker> _markers = Set<Marker>();

  void _onMapCreated(GoogleMapController controller) {
    _controller.complete(controller);
  }

  @override
  void initState() {
    Geolocator()
        .getPositionStream(LocationOptions(
            accuracy: LocationAccuracy.best,
            timeInterval: POSITON_UPDATE_TIME_INTERVAL))
        .listen((position) async {
      currentPosition = position;
      updateCurrentPosition();
      seekNearby().then((friends) {
        updatePins(friends);
      });
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
//    controller.animateCamera(CameraUpdate.newCameraPosition(cameraPosition));
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

  Future<List<Friend>> seekNearby() async {
    var storage = FlutterSecureStorage();
    var token = await storage.read(key: "token");
    try {
      var body = {
        "latitude": currentPosition.latitude,
        "longitude": currentPosition.longitude
      };
      var response = await http.post(base_url + "/update_position/",
          headers: {
            "Authorization": "Bearer $token",
            "Content-Type": "application/json"
          },
          body: json.encode(body));

      var lst = json.decode(response.body)["friends_position"] as List;
      List<Friend> friends = lst.map((i) => Friend.fromJson(i)).toList();
      return friends;
    } catch (e) {
      print("Seek Error");
      print(e.toString());
    }
  }

  void updatePins(List<Friend> friends) {
    setState(() {
      _markers.removeWhere((marker) =>
      marker.markerId.value != "current pin" &&
          marker.markerId.value != _bk1.toString() &&
          marker.markerId.value !=
              _bk2.toString()); // remove all old friends' position
      for (var friend in friends) {
        Geolocator()
            .distanceBetween(currentPosition.latitude,
            currentPosition.longitude, friend.latitude, friend.longitude)
            .then((distance) {
          if (distance <= 200) {
            _markers.add(Marker(
              // update current pin
              // This marker id can be anything that uniquely identifies each marker.
              markerId: MarkerId(friend.username),
              position: LatLng(friend.latitude, friend.longitude),
              infoWindow: InfoWindow(
                title: friend.username,
              ),
              icon: BitmapDescriptor.defaultMarkerWithHue(
                  BitmapDescriptor.hueGreen),
            ));
          }
        });
      }
    });
  }

  void setInitialPosition() async {
    currentPosition = await Geolocator().getCurrentPosition();
  }

  void setInitialPins() {
    setState(() {
      _markers.add(Marker(
        // This marker id can be anything that uniquely identifies each marker.
        markerId: MarkerId(_bk1.toString()),
        position: _bk1,
        infoWindow: InfoWindow(
          title: 'Trường Đại học Bách khoa - Đại học Quốc gia TP.HCM',
          snippet: '268 Lý Thường Kiệt, Phường 14, Quận 10, Hồ Chí Minh',
        ),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
      ));
      _markers.add(Marker(
        // This marker id can be anything that uniquely identifies each marker.
        markerId: MarkerId(_bk2.toString()),
        position: _bk2,
        infoWindow: InfoWindow(
          title: 'Trường Đại học Bách khoa - Đại học Quốc gia TP.HCM',
          snippet: 'Đông Hoà, Tx. Dĩ An, Bình Dương, Việt Nam',
        ),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
      ));
    });
  }

  @override
  Widget build(BuildContext context) {
    CameraPosition initialCameraPosition =
    CameraPosition(target: _bk1, zoom: CAMERA_ZOOM);
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

class Friend {
  String username;
  double latitude;
  double longitude;

  Friend({this.username, this.latitude, this.longitude});

  factory Friend.fromJson(Map<String, dynamic> json) {
    return Friend(
        username: json["username"],
        latitude: json["latitude"],
        longitude: json["longitude"]);
  }
}