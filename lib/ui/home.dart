import 'dart:async';
import 'dart:developer';
import 'dart:math';

import 'package:audioplayers/audio_cache.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:spacex_project/core/manager/company_manager.dart';
import 'package:spacex_project/core/manager/favorite_launch.dart';
import 'package:spacex_project/core/manager/launchpads_manager.dart';
import 'package:spacex_project/core/model/launches.dart';
import 'package:spacex_project/core/model/map_sample.dart';
import 'package:spacex_project/core/model/notification.dart';
import 'package:spacex_project/core/widget/local_notification.dart';
import 'package:workmanager/workmanager.dart';

import '../core/manager/launches_manager.dart';

class HomePage extends StatefulWidget {

  HomePage({Key key, this.title}) : super(key: key);


  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  int _currentIndex = 0;
  BuildContext context;
  FutureBuilder pageHistorique;
  FutureBuilder pageHome;
  FutureBuilder pageCompany;
  Scaffold pageFavorite;
  Scaffold pageParameter;
  Scaffold pageSecret;

  bool dataLoad = false;
  bool alreadyLoad = false;
  bool prefNotification = false;
  bool soundPlaying = false;

  final tabs = [
  ];

  Timer _timer;
  int _counter = 10;

  // Time formatting, converted to the corresponding hh:mm:ss format according to the total number of seconds
  String constructTime(int seconds) {
    int day = seconds ~/ 86400;
    int hour = seconds % 86400 ~/ 3600;
    int minute = seconds % 3600 ~/ 60;
    int second = seconds % 60;
    return formatTime(day) + "d " + formatTime(hour) + "h " + formatTime(minute) + "m " + formatTime(second) + "s";
  }

  // Digital formatting, converting 0-9 time to 00-09
  String formatTime(int timeNum) {
    return timeNum < 10 ? "0" + timeNum.toString() : timeNum.toString();
  }

  void _startTimer() async {
    Workmanager().cancelAll();
    _counter = DateTime.parse(LaunchesManager().filteredLaunches.first.date_local).difference(DateTime.now()).inSeconds;
    if(prefNotification == true){
      Workmanager().registerOneOffTask('timer', 'timer',initialDelay: Duration(seconds: _counter - 3600));
    }
    if (_timer != null) {
      _timer.cancel();
    }
    _timer = Timer.periodic(Duration(seconds: 1), (timer) =>
      setState(() {
        if (_counter > 0) {
          _counter--;
          if(FavoriteLaunch().tabsModify == true){
            FavoriteLaunch().tabsModify = false;
            tabs[2] = getPageFavorite();
          }
          var newPageHome = getPageHome();
          tabs[0] = newPageHome;
        } else {
          _timer.cancel();
        }
      })
    );
  }

  Future<List<Launches>> timerStartWithData(BuildContext context) async{
    if(alreadyLoad == false){
      alreadyLoad = true;
      await LaunchesManager().getFutureLaunches(context);
      _startTimer();
    }
    return LaunchesManager().filteredLaunches;
  }

  @override
  Widget build(BuildContext context) {

    this.context = context;
    pageHome = getPageHome();

    pageHistorique = getPageHistorique();
    pageCompany = getPageSpaceX();
    pageParameter = getPageParameter();
    pageSecret = getPageSecret();

    tabs.add(Center(child: pageHome));
    tabs.add(Center(child: pageHistorique));
    tabs.add(Center(child: pageFavorite));
    tabs.add(Center(child: pageCompany));
    tabs.add(Center(child: pageParameter));
    tabs.add(Center(child: pageSecret));

    if(dataLoad == false){
      LaunchpadsManager().loadLaunchpads(context);
      FavoriteLaunch().loadFavorite(context, tabs, getPageFavorite());
      loadPreferenceNotification();
      dataLoad = true;
    }
    // This method is rerun every time setState is called.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(

      appBar: AppBar(
        // Here we take the value from the HomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: tabs[_currentIndex], // This trailing comma makes auto-formatting nicer for build methods.
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        items: [
          BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: "Home",
              backgroundColor: Colors.indigo
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.watch),
              label: "Historique",
              backgroundColor: Colors.indigo
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.star),
              label: "Favoris",
              backgroundColor: Colors.indigo
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.cancel),
              label: "Space X",
              backgroundColor: Colors.indigo
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.settings),
              label: "Paramètre",
              backgroundColor: Colors.indigo
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.assistant_photo),
              label: "?",
              backgroundColor: Colors.indigo
          )
        ],
        onTap: (index){
          setState(() {
            _currentIndex = index;
          });
        },
      ),
    );
  }

  FutureBuilder getPageHome(){
    return FutureBuilder(
      future: timerStartWithData(context),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          _startTimer();
          return Stack(
            children: [
              Positioned(
                top: 10,
                  left: 90,
                  right: 10,
                  child: Text(
                      constructTime(_counter),
                      style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                      )
                  )
              ),
              Positioned(
                top: 60,
                  right: 0,
                  left: 0,
                  bottom: 0,
                  child: ListView.builder(itemBuilder: (context, position){
                    return Row(
                      children: [
                        SizedBox(
                          width: 400,
                          height: 125,
                          child: Stack(
                            children: <Widget>[
                              Positioned(
                                  top:5,
                                  bottom: 5,
                                  left: 5,
                                  child: Image.network(getImage(LaunchesManager().filteredLaunches[position]), width: 100)
                              ),
                              Positioned(
                                  top: 10,
                                  left: 125,
                                  right: 50,
                                  child: Text(
                                    getMissionName(LaunchesManager().filteredLaunches[position]),
                                    style: TextStyle(
                                      fontSize: 22,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  )
                              ),
                              Positioned(
                                  top: 90,
                                  left: 125,
                                  right: 50,
                                  child: Text(
                                    "N°"+LaunchesManager().filteredLaunches[position].flight_number.toString()+" - "+ getYear(LaunchesManager().filteredLaunches[position]),
                                    style: TextStyle(
                                      fontSize: 20,
                                    ),
                                  )
                              ),
                              Positioned(
                                top:30,
                                left: 350,
                                right: 0,
                                child: InkWell(
                                  onLongPress: (){
                                    bool findInList = false;
                                    for(var ii = 0; ii < FavoriteLaunch().favoriteLaunch.length;ii++){
                                      if(LaunchesManager().filteredLaunches[position].id == FavoriteLaunch().favoriteLaunch[ii].id){
                                        findInList = true;
                                        Scaffold.of(context).showSnackBar(SnackBar(
                                          content: Text("Retiré des favoris"),
                                        ));
                                        FavoriteLaunch().removeFavorite(ii, tabs, getPageFavorite());
                                      }
                                    }
                                    if(findInList == false){
                                      Scaffold.of(context).showSnackBar(SnackBar(
                                        content: Text("Ajouté aux favoris"),
                                      ));
                                      FavoriteLaunch().setFavorite(LaunchesManager().filteredLaunches[position], tabs, getPageFavorite());
                                    }
                                  },
                                  child: FloatingActionButton( // use Ink
                                    child: Icon(Icons.search),
                                    backgroundColor: Colors.indigo,
                                    heroTag: "pageDetailHome"+position.toString(),
                                    onPressed: (){
                                      Navigator.pushNamed(context, '/pageDetailHome', arguments: position);
                                    },
                                  ),
                                ),
                              )
                            ],
                          ),
                        )
                      ],
                    );
                  },itemCount: LaunchesManager().filteredLaunches.length,)
              )
            ],
          );
        } else {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }

  FutureBuilder getPageHistorique(){
    return FutureBuilder(
      future: LaunchesManager().loadLaunches(context),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return ListView.builder(itemBuilder: (context, position){
            return Row(
              children: [
                SizedBox(
                  width: 400,
                  height: 125,
                  child: Stack(
                    children: <Widget>[
                      Positioned(
                          top:5,
                          bottom: 5,
                          left: 5,
                          child: Image.network(getImage(LaunchesManager().launches[position]), width: 100)
                      ),
                      Positioned(
                          top: 10,
                          left: 125,
                          right: 50,
                          child: Text(
                            getMissionName(LaunchesManager().launches[position]),
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                            ),
                          )
                      ),
                      Positioned(
                          top: 90,
                          left: 125,
                          right: 50,
                          child: Text(
                            "N°"+LaunchesManager().launches[position].flight_number.toString()+" - "+ getYear(LaunchesManager().launches[position]),
                            style: TextStyle(
                              fontSize: 20,
                            ),
                          )
                      ),
                  Positioned(
                    top: 30,
                    left: 350,
                    right: 0,
                    child: InkWell(
                        onLongPress: (){
                          bool findInList = false;
                          for(var ii = 0; ii < FavoriteLaunch().favoriteLaunch.length;ii++){
                            if(LaunchesManager().launches[position].id == FavoriteLaunch().favoriteLaunch[ii].id){
                              findInList = true;
                              Scaffold.of(context).showSnackBar(SnackBar(
                                content: Text("Retiré des favoris"),
                              ));
                              FavoriteLaunch().removeFavorite(ii, tabs, getPageFavorite());
                            }
                          }
                          if(findInList == false){
                            Scaffold.of(context).showSnackBar(SnackBar(
                              content: Text("Ajouté aux favoris"),
                            ));
                            FavoriteLaunch().setFavorite(LaunchesManager().launches[position], tabs, getPageFavorite());
                          }
                        },
                      child: FloatingActionButton( // use Ink
                        child: Icon(Icons.search),
                        backgroundColor: Colors.indigo,
                        heroTag: "pageDetail"+position.toString(),
                        onPressed: (){
                          Navigator.pushNamed(context, '/pageDetail', arguments: position);
                          },
                        ),
                      ),
                    )
                    ],
                  ),
                )
              ],
            );
          },itemCount: LaunchesManager().launches.length,);

        } else {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }

  Scaffold getPageFavorite(){
    print("Length : " + FavoriteLaunch().favoriteLaunch.length.toString());
    if(FavoriteLaunch().favoriteLaunch.length-1 >= 0){
      return Scaffold(
        body: MaterialApp(
          debugShowCheckedModeBanner: false,
          builder: (context, snapshot) {
            return  Material(
              type: MaterialType.transparency,
              child : ListView.builder(itemBuilder: (context, position){
                return Row(
                  children: [
                    SizedBox(
                      width: 400,
                      height: 125,
                      child: Stack(
                        children: <Widget>[
                          Positioned(
                              top:5,
                              bottom: 5,
                              left: 5,
                              child: Image.network(getImage(FavoriteLaunch().favoriteLaunch[position]), width: 100)
                          ),
                          Positioned(
                              top: 10,
                              left: 125,
                              right: 50,
                              child: Text(
                                getMissionName(FavoriteLaunch().favoriteLaunch[position]),
                                style: TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              )
                          ),
                          Positioned(
                              top: 90,
                              left: 125,
                              right: 50,
                              child: Text(
                                "N°"+FavoriteLaunch().favoriteLaunch[position].flight_number.toString()+" - "+ getYear(FavoriteLaunch().favoriteLaunch[position]),
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 20,
                                ),
                              )
                          ),
                          Positioned(
                            top:30,
                            left: 350,
                            right: 0,
                            child: InkWell(
                              onLongPress: (){
                                bool findInList = false;
                                for(var ii = 0; ii < FavoriteLaunch().favoriteLaunch.length;ii++){
                                  if(FavoriteLaunch().favoriteLaunch[position].id == FavoriteLaunch().favoriteLaunch[ii].id){
                                    Scaffold.of(context).showSnackBar(SnackBar(
                                      content: Text("Retiré des favoris"),
                                    ));
                                    findInList = true;
                                    FavoriteLaunch().removeFavorite(ii, tabs, getPageFavorite());
                                    setState(() {});
                                  }
                                }
                                if(findInList == false){
                                  Scaffold.of(context).showSnackBar(SnackBar(
                                    content: Text("Ajouté aux favoris"),
                                  ));
                                  FavoriteLaunch().setFavorite(FavoriteLaunch().favoriteLaunch[position], tabs, getPageFavorite());
                                  setState(() {});
                                }
                              },
                              child: FloatingActionButton( // use Ink
                                child: Icon(Icons.search),
                                backgroundColor: Colors.indigo,
                                heroTag: "pageDetailFavorite"+position.toString(),
                                onPressed: (){Navigator.pushNamed(context, '/pageDetailFavorite', arguments: position);},
                              ),
                            ),
                          )
                        ],
                      ),
                    )
                  ],
                );
              },itemCount: FavoriteLaunch().favoriteLaunch.length,),
            );
          },
        ),
      );
    }else{
      return Scaffold(
          body: MaterialApp(
              debugShowCheckedModeBanner: false,
              builder: (context, snapshot) {
                return Material(
                    type: MaterialType.transparency,
                    child: Stack(
                      children: [
                        Positioned(
                          left: 25,
                          top: 350,
                          right: 25,
                          child: Text(
                            "Maintenez le bouton bleu à droite d'un lancement pour ajouter / supprimer.",
                            textAlign: TextAlign.justify,
                            style: TextStyle(
                                fontSize: 17
                            ),
                          ),
                        ),
                      ],
                    )
                );
              }
              )
      );
    }
  }

  FutureBuilder getPageSpaceX(){
    return FutureBuilder(
      future: CompanyManager().loadCompany(context),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return Stack(
            children: [
              Positioned(
                  top: 25,
                  left: 125,
                  right: 0,
                  child: Text(
                      CompanyManager().company.name,
                    style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 50,
                  ),
                  )
              ),
              Positioned(
                  top: 200,
                  left: 25,
                  right: 25,
                  child: Text("Company founded by "+CompanyManager().company.founder+ " in "+CompanyManager().company.founded.toString(),
                    style: TextStyle(
                      fontSize: 20,
                    ),
                  )
              ),
              Positioned(
                  top: 300,
                  left: 25,
                  right: 25,
                  child: Text("Number of employees : " + CompanyManager().company.employees.toString(),
                    style: TextStyle(
                      fontSize: 20,
                    ),
                  )
              ),
              Positioned(
                  top: 400,
                  left: 50,
                  right: 50,
                  child: Text(CompanyManager().company.summary,
                    textAlign: TextAlign.justify,
                    style: TextStyle(
                      fontSize: 20,
                    ),
                  )
              ),
            ],
          );
        } else {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }

  Scaffold getPageParameter(){
    return Scaffold(
      body: MaterialApp(
        debugShowCheckedModeBanner: false,
        builder: (context, snapshot) {
          return Material(
            type: MaterialType.transparency,
            child : Stack(children: [
            Positioned(
                top: 100,
                left: 15,
                right: 0,
                child:
                Text(
                  "Recevoir une notification 1 heure avant un lancement : ",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                  ),
                )
            ),
            Positioned(
                top: 150,
                left: 175,
                child: Switch(value: prefNotification,
                    onChanged: (bool state){
                      if(prefNotification == false){
                        savePreferenceNotification(true);
                        prefNotification = true;
                        var newPageParameter = getPageParameter();
                        tabs[4] = newPageParameter;
                        return state;
                      }
                      else{
                        savePreferenceNotification(false);
                        prefNotification = false;
                        var newPageParameter = getPageParameter();
                        tabs[4] = newPageParameter;
                        return state;
                      }
                    })
            )
          ],),
          );
        },
      ),
    );
  }

  Scaffold getPageSecret(){
    return Scaffold(
      body: MaterialApp(
        debugShowCheckedModeBanner: false,
        builder: (context, snapshot) {
          return Material(
            type: MaterialType.transparency,
            child : Stack(children: [
              Positioned(
                  top: 350,
                  left: 0,
                  right: 0,
                  child: FloatingActionButton(
                    onPressed: (){
                      playSound();
                    },
                    child: const Icon(Icons.airplanemode_active),
                    backgroundColor: Colors.red,
                  )
              ),
            ],
            ),
          );
        },
      ),
    );
  }


  String getImage(Launches position){
    if(position.links.patch.large != null){
      return position.links.patch.large;
    }
    else{
      return "";
    }
  }

  String getMissionName(Launches position){
    if(position.name != null){
      return position.name;
    }
    else{
      return "";
    }
  }

  String getYear(Launches position){
    DateTime date = DateTime.parse(position.date_local);
    String year = date.year.toString();
    return year;
  }

  Future<bool> loadPreferenceNotification() async {
    final prefs = await SharedPreferences.getInstance();
    prefNotification = prefs.getBool('notification');
    print ("state : " + prefNotification.toString());
    var newPageParameter = getPageParameter();
    tabs[4] = newPageParameter;
    return prefNotification;
  }

  Future<void> savePreferenceNotification(bool state) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool('notification', state);
  }

  Future<void> playSound() async{
    if(soundPlaying == false){
      soundPlaying = true;
      await AudioCache(fixedPlayer: AudioPlayer()).play('secret_sound.mp3');
      soundPlaying = false;
    }
  }

}

