import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:spacex_project/core/manager/launches_manager.dart';
import 'package:spacex_project/core/model/launches.dart';
import 'package:spacex_project/ui/home.dart';

class FavoriteLaunch{

  List<Launches> favoriteLaunch = [];
  List<String> dataString = [];

  bool tabsModify = false;

  static const String KEY = 'favoriteId';

  Future<void> loadFavorite(BuildContext context, List<dynamic> tabs, Scaffold newPageFavorite) async {
    final prefs = await SharedPreferences.getInstance();
    await LaunchesManager().loadLaunches(context);
    var listString = prefs.getStringList(KEY);
    print(listString);
    bool find = false;
    if(listString != null) {
      for (var ii = 0; ii < listString.length; ii++) {
        find = false;
        for (var jj = 0; jj < LaunchesManager().launches.length; jj++) {
          var id = listString[ii];
          var launche = LaunchesManager().launches[jj];
          if (id == launche.id) {
            favoriteLaunch.add(launche);
            dataString.add(id);
            find = true;
          }
          if (find == true) {
            jj = LaunchesManager().launches.length;
          }
        }
      }
    }
    tabsModify = true;
  }

  Future<void> setFavorite(Launches launche, List<dynamic> tabs, Scaffold newPage) async {
    print("element add from the data");
    final prefs = await SharedPreferences.getInstance();
    favoriteLaunch.add(launche);
    dataString.add(launche.id);
    print(dataString);
    prefs.setStringList(KEY, dataString);
    tabsModify = true;
  }

  Future<void> removeFavorite(int position, List<dynamic> tabs, Scaffold newPage) async {
    print("element remove from the data");
    final prefs = await SharedPreferences.getInstance();
    Launches tempLaunche = favoriteLaunch[position];
    for(int ii = 0; ii < dataString.length; ii++){
      if(dataString[ii] == tempLaunche.id){
        dataString.removeAt(ii);
      }
    }
    favoriteLaunch.removeAt(position);
    print(dataString);
    prefs.setStringList(KEY, dataString);
    tabsModify = true;
  }

  static final FavoriteLaunch _instance = FavoriteLaunch._internal();

  factory FavoriteLaunch() => _instance;

  FavoriteLaunch._internal();

}