import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:spacex_project/core/model/launchpads.dart';

class LaunchpadsManager {
  List<Launchpads> launchpads;

  String URL_SERVER = "https://api.spacexdata.com/v4/launchpads";

  static final LaunchpadsManager _instance = LaunchpadsManager._internal();

  factory LaunchpadsManager() => _instance;

  LaunchpadsManager._internal();

  Future<List<Launchpads>> loadLaunchpads(BuildContext context) async {
    List list = await getData();
    return list;
  }

  Future<List<Launchpads>> getData() async {
    var dio = Dio();
    try {
      var response = await dio.get<List<dynamic>>(URL_SERVER);
      var json = response.data;
      //var json = jsonDecode(jsonString);
      // Mapping data
      launchpads = List<dynamic>.from(json)
          .map((json) => Launchpads.fromJson(json))
          .toList();
      return launchpads;
    } catch (e) {
      print("Erreur : $e");
    }
  }
}
