import 'dart:async';
import 'dart:convert';

import 'package:assessmentfc/repo/permission.dart';
import 'package:assessmentfc/views/my_homepage.dart';
import 'package:flutter/material.dart';

import 'package:assessmentfc/models/city_list_model.dart';

import 'package:geolocator/geolocator.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:assessmentfc/utilities/city.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

const String apiKey = '08a99d02b785c3ad65d2fbdb34f6e015';

class GeoLocating {
  static const _currentPosition = Position(
      longitude: 0,
      latitude: 0,
      timestamp: null,
      accuracy: 0,
      altitude: 0,
      altitudeAccuracy: 0,
      heading: 0,
      headingAccuracy: 0,
      speed: 0,
      speedAccuracy: 0);
  Weather _weather = Weather(main: '', description: '', icon: '');
  Weather get weather => _weather;

  get currentPosition => _currentPosition;
  Future<Position?> getCurrentPosition({required BuildContext context}) async {
    Position position;
    final hasPermission =
        await Permission(context: context).handleLocationPermission();
    if (!hasPermission) return null;
    position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);

    return position;
  }

  Future getUserWeather({required BuildContext context}) async {
    final position = await getCurrentPosition(context: context);
    if (position == null) return;
    final UserWeatherServices uservices = UserWeatherServices();
    await uservices.getWeather(position);
    _weather = uservices.weather;

    return _weather;
  }
}

class CityServices extends ChangeNotifier {
  List<CityModel> get _cities => Jsoncity().cityList().sublist(0, 3);

  List<CityModel> get cities => cachecity ?? _cities;
  void addCity(CityModel city) {
    if (cities.any((element) => element == city)) {
      return;
    } else if (cities.length < 3) {
      cities.add(city);
      storeCityLocally();
      notifyListeners();
    }
  }

  void removeCity(CityModel city) {
    cities.remove(city);
    storeCityLocally();
    notifyListeners();
  }
}

final carouselListProvider = ChangeNotifierProvider((ref) => CityServices());

class WeatherServices {
  Weather weatherNow = Weather(main: '', description: '', icon: '');
  get weather => weatherNow;
  Future getWeather(
    CityModel city,
  ) async {
    String latitude;
    String longitude;
    latitude = city.lat;
    longitude = city.lng;

    try {
      http.Response response = await http.get(Uri.parse(
          'https://api.openweathermap.org/data/2.5/weather?lat=$latitude&lon=$longitude&appid=$apiKey'));
      if (response.statusCode == 200) {
        String data = response.body;
        var decodedData = jsonDecode(data);
        final main = decodedData['weather'][0]['id'].toString();
        final description = decodedData['weather'][0]['description'].toString();
        final icon = decodedData['weather'][0]['icon'].toString();
        weatherNow = Weather(main: main, description: description, icon: icon);

        return weatherNow;
      }
    } catch (e) {
      return;
    }
  }
}

class Weather {
  final String main;
  final String description;
  final String icon;

  Weather({required this.main, required this.description, required this.icon});
}

class UserWeatherServices {
  Weather weatherNow = Weather(main: '', description: '', icon: '');
  get weather => weatherNow;
  Future getWeather(Position position) async {
    String latitude;
    String longitude;
    latitude = position.latitude.toString();
    longitude = position.longitude.toString();

    try {
      http.Response response = await http.get(Uri.parse(
          'https://api.openweathermap.org/data/2.5/weather?lat=$latitude&lon=$longitude&appid=$apiKey'));

      if (response.statusCode == 200) {
        String data = response.body;
        var decodedData = jsonDecode(data);
        final main = decodedData['weather'][0]['id'].toString();
        final description = decodedData['weather'][0]['description'].toString();
        final icon = decodedData['weather'][0]['icon'].toString();
        weatherNow = Weather(main: main, description: description, icon: icon);

        return weatherNow;
      }
    } catch (e) {
      return;
    }
  }
}

class Show extends StateNotifier<bool> {
  Show() : super(false);
  changeShow() {
    state = !state;
  }
}

final showProvider = StateNotifierProvider<Show, bool>((ref) => Show());
storeCityLocally() async {
  final pref = await SharedPreferences.getInstance();
  List<String> cityListString =
      CityServices().cities.map((city) => jsonEncode(city.toJson())).toList();
  pref.setStringList('cityString', cityListString);
}
