import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:spacex_project/core/model/company.dart';

class CompanyManager{
  Company company;

  String URL_SERVER = "https://api.spacexdata.com/v4/company";

  static final CompanyManager _instance = CompanyManager._internal();

  factory CompanyManager() => _instance;

  CompanyManager._internal();

  Future<Company> loadCompany(BuildContext context) async {
    return getData();
  }

  Future<Company> getData() async{
    var dio = Dio();
    try{
      var response = await dio.get<dynamic>(URL_SERVER);
      var json = response.data;
      //var json = jsonDecode(jsonString);
      // Mapping data
      company = Company.fromJson(json);
      return company;
    }catch(e){
      print("Erreur : $e");
    }
  }
}