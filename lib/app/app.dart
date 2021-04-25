import 'package:flutter/material.dart';
import 'package:spacex_project/ui/home.dart';
import 'package:spacex_project/ui/pageDetail.dart';
import 'package:spacex_project/ui/pageDetailFavorite.dart';
import 'package:spacex_project/ui/pageDetailHome.dart';
import 'package:spacex_project/ui/pageMap.dart';

class App extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Launches',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.indigo,
        // This makes the visual density adapt to the platform that you run
        // the app on. For desktop platforms, the controls will be smaller and
        // closer together (more dense) than on mobile platforms.
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => HomePage(title: 'Launches'),
        '/pageDetail': (context) => pageDetail(),
        '/pageDetailHome': (context) => pageDetailHome(),
        '/pageDetailFavorite': (context) => pageDetailFavorite(),
        '/pageMap': (context) => pageMap(),
      },
    );
  }
}