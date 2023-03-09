import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:weathercal/models/current_weather_response.dart';
import 'package:weathercal/models/forcast_weather_response.dart';
import 'package:weathercal/utils/constants.dart';
import 'package:http/http.dart' as Http;


class WeatherProvider extends ChangeNotifier{
  CurrentWeatherResponse? currentWeatherResponse;
  ForcastWeatherResponse? forcastWeatherResponse;
  double latitude=0.0;
  double longitude=0.0;
  String tempUnit= metric;
  String tempUnitSymbol= celsius;
  String timePattern= timePattern12;

  void setNewLocation(double lat, double lng){
    latitude=lat;
    longitude=lng;
  }
  void setTimePattern(bool status){
    timePattern= status? timePattern24: timePattern12;
    notifyListeners();
  }
  void setTemuUnit(bool status){
    tempUnit= status? imperial: metric;
    tempUnitSymbol= status? fahrenheit: celsius;
    getData();
  }



  bool get hasDataLoades=> currentWeatherResponse!=null &&
      forcastWeatherResponse!=null;
  void getData(){
    _getCurrentWeatherData();
    _getForecastWeatherData();
  }

  Future<void> _getCurrentWeatherData() async{
    final urlString='https://api.openweathermap.org/data/2.5/weather?lat=$latitude&lon=$longitude&units=$tempUnit&appid=$weatherApikey';
    final response= await Http.get(Uri.parse(urlString));
    final map= json.decode(response.body);
    if(response.statusCode==200){
      currentWeatherResponse=CurrentWeatherResponse.fromJson(map);
      notifyListeners();
    }else{
      print(map['message']);

    }
  }

  Future<void> _getForecastWeatherData() async{
    final urlString='https://api.openweathermap.org/data/2.5/forecast?lat=$latitude&lon=$longitude&units=$tempUnit&appid=$weatherApikey';
    final response= await Http.get(Uri.parse(urlString));
    final map= json.decode(response.body);
    if(response.statusCode==200){
      forcastWeatherResponse=ForcastWeatherResponse.fromJson(map);
      notifyListeners();
    }else{
      print(map['message']);

    }
  }

  Future <void> convertAddressToLatLng(String city) async{
    try{
      final locationList= await locationFromAddress(city);
      if(locationList.isNotEmpty){
        final location= locationList.first;
        latitude= location.latitude;
        longitude= location.longitude;
        getData();
      }else{
        print('No location found from provided address');
      }
    }catch(error){
      print(error.toString());
    }
  }

}