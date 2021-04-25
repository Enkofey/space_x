import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:spacex_project/core/manager/coord_data.dart';

class MapSample extends StatefulWidget {

  MapSampleState state;

  @override
  State<MapSample> createState() => state = MapSampleState();
}

class MapSampleState extends State<MapSample> {
  Completer<GoogleMapController> _controller = Completer();

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: GoogleMap(
        mapType: MapType.hybrid,
        initialCameraPosition: _goToCoord(CoordData().y, CoordData().x),
        onMapCreated: (GoogleMapController controller) {
          _controller.complete(controller);
        },
      ),
    );
  }

  CameraPosition _goToCoord(double lat, double lng) {

    CameraPosition newCam = CameraPosition(
        bearing: 192.8334901395799,
        target: LatLng(lat, lng),
        tilt: 59.440717697143555,
        zoom: 19.151926040649414);

    return newCam;

  }

}