// To parse this JSON data, do
//
//     final cityListModel = cityListModelFromJson(jsonString);

import 'dart:convert';

List<CityModel> cityListModelFromJson(String str) =>
    List<CityModel>.from(json.decode(str).map((x) => CityModel.fromJson(x)));

String cityListModelToJson(List<CityModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class CityModel {
  String city;
  String lat;
  String lng;

  CityModel({
    required this.city,
    required this.lat,
    required this.lng,
  });

  factory CityModel.fromJson(Map<String, dynamic> json) => CityModel(
        city: json["city"],
        lat: json["lat"],
        lng: json["lng"],
      );

  Map<String, dynamic> toJson() => {
        "city": city,
        "lat": lat,
        "lng": lng,
      };
  @override
  bool operator ==(covariant CityModel other) => city == other.city;

  @override
  int get hashCode => city.hashCode;
}
