import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:spacex_project/core/manager/coord_data.dart';
import 'package:spacex_project/core/manager/launches_manager.dart';
import 'package:spacex_project/core/manager/launchpads_manager.dart';
import 'package:spacex_project/core/model/launches.dart';
import 'package:spacex_project/core/model/map_sample.dart';

class pageMap extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("PageMap"),
      ),
      body: MaterialApp(
        title: 'Map',
        home: MapSample(),
      ),
    );
  }
}