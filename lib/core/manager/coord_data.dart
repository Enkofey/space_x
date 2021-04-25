import 'package:spacex_project/core/model/launches.dart';

class CoordData{

  double x = 0;
  double y = 0;

  static final CoordData _instance = CoordData._internal();

  factory CoordData() => _instance;

  CoordData._internal();

}