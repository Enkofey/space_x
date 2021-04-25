import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:spacex_project/core/manager/coord_data.dart';
import 'package:spacex_project/core/manager/launches_manager.dart';
import 'package:spacex_project/core/manager/launchpads_manager.dart';
import 'package:spacex_project/core/model/launches.dart';

String getDate(Launches launche){
  DateTime date = DateTime.parse(launche.date_local);
  String dayMonthYear = date.day.toString()+"/"+date.month.toString()+"/"+ date.year.toString();
  return dayMonthYear;
}

String getHour(Launches launche){
  DateTime date = DateTime.parse(launche.date_local);
  String hourMinuteSecond = date.hour.toString()+"h"+date.minute.toString()+"m"+ date.second.toString()+"s";
  return hourMinuteSecond;
}

String getDetails(Launches launche){
  if(launche.details != null){
    return launche.details;
  }else{
    return "(NO DATA)";
  }
}

class pageDetail extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final int position = ModalRoute.of(context).settings.arguments;
    return Scaffold(
      appBar: AppBar(
        title: Text("PageDetail"),
      ),
    body: FutureBuilder(
      future: getData(LaunchesManager().launches[position].id),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            Launches launche = snapshot.data;
            return SizedBox(
                width: 400,
                height: 900,
              child: Stack(
                children: [
                  Positioned(
                    top: 25,
                      left: 125,
                      child: Image.network(getImage(launche), width: 150)
                  ),
                  Positioned(
                    top: 200,
                    left: 160,
                    child: Text(
                        "N°" + launche.flight_number.toString(),
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 35,
                      ),
                    ),
                  ),
                  Positioned(
                    top: 240,
                    left: 25,
                    right: 25,
                    child: Text(launche.name,
                      textAlign: TextAlign.justify,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 30,
                      ),
                    ),
                  ),
              Positioned(
                top: 340,
                left: 25,
                child: Text("Date : " + getDate(launche),
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 30,
                  ),
                ),
              ),
                  Positioned(
                    top: 390,
                    left: 25,
                    child: Text("Hour : " + getHour(launche),
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 30,
                      ),
                    ),
                  ),
                  Positioned(
                    top: 440,
                    left: 25,
                    child: Text("Success : " + launche.success.toString(),
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 30,
                      ),
                    ),
                  ),
                  Positioned(
                    top: 490,
                    left: 25,
                    child: Text("Reason : ",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 30,
                      ),
                    ),
                  ),
                  Positioned(
                    top: 540,
                    left: 25,
                    right: 25,
                    bottom: 100,
                    child: Text(getDetails(launche),
                      textAlign: TextAlign.justify,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                  ),
                  Positioned(
                    top: 800,
                    left: 175,
                    child: FloatingActionButton(

                      onPressed: (){
                        for(var ii = 0; ii< LaunchpadsManager().launchpads.length;ii++){
                          var currentlaunchpad = LaunchpadsManager().launchpads[ii];
                          if(launche.launchpad == currentlaunchpad.id){
                            CoordData().y = currentlaunchpad.latitude;
                            CoordData().x = currentlaunchpad.longitude;
                          }
                        }
                        Navigator.pushNamed(context, '/pageMap', arguments: position);
                      },
                      child: const Icon(Icons.navigation),
                      backgroundColor: Colors.indigo,
                    ),
                    ),
                ],
              ),
            );
          }else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        }
    ),
    );
  }

  Future<Launches> getData(String id) async{
    var dio = Dio();
    try{
      var response = await dio.get<dynamic>("https://api.spacexdata.com/v4/launches/"+id.toString());
      var json = response.data;
      var launches;
      launches = Launches.fromJson(json);
      return launches;
    }catch(e){
      print("Erreur : $e");
    }
  }

  String getImage(Launches launche){
    if(launche.links.patch.large != null){
      return launche.links.patch.large;
    }
    else{
      return "";
    }
  }

}