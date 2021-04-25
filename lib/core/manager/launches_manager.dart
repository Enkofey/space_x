import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'dart:math';
import 'package:spacex_project/core/model/launches.dart';

class LaunchesManager{
  List<Launches> launches;

  List<Launches> filteredLaunches = [];

  String URL_SERVER = "https://api.spacexdata.com/v4/launches";

  static final LaunchesManager _instance = LaunchesManager._internal();

  factory LaunchesManager() => _instance;

  LaunchesManager._internal();

  Future<List<Launches>> loadLaunches(BuildContext context) async {
    List list = await getData();
    sortLaunches();
    return list;
  }

  Future<List<Launches>> getFutureLaunches(BuildContext context) async{
    if(filteredLaunches.isEmpty){
      List<Launches> futureList = await loadLaunches(context);
      if (futureList != null && futureList.isNotEmpty) {
        for (var launche in futureList){
          if(launche.date_local != null){
            DateTime date = DateTime.parse(launche.date_local);
            if(date.isBefore(DateTime.now())){
            }else{
              filteredLaunches.add(launche);
            }
          }
        }
        return filteredLaunches;
      }
      return null;
    }
    return filteredLaunches;
  }

  Future<List<Launches>> getData() async{
    var dio = Dio();
    try{
      var response = await dio.get<List<dynamic>>(URL_SERVER);
      var json = response.data;
      //var json = jsonDecode(jsonString);
      // Mapping data
      launches = List<dynamic>.from(json)
          .map((json) => Launches.fromJson(json))
          .toList();
      return launches;
    }catch(e){
      print("Erreur : $e");
    }
  }

  sortLaunches(){
    bool didChange = true;
    while(didChange == true){
      didChange = false;
      for (var ii = 0;ii < launches.length-1; ii++){
        if(launches[ii].flight_number > launches[ii+1].flight_number){
          didChange = true;
          var tempLaunches = launches[ii];
          launches[ii] = launches[ii+1];
          launches[ii+1] = tempLaunches;
        }
      }
    }
  }

}