import 'package:assessmentfc/models/city_list_model.dart';
import 'package:assessmentfc/repo/services.dart';

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class CityItem extends ConsumerWidget {
  const CityItem({super.key, required this.cityname, required this.city});

  final String cityname;
  final CityModel city;

  @override
  Widget build(BuildContext context, ref) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          IconButton(
              onPressed: () {
                ref.read(carouselListProvider).addCity(city);
              },
              icon: const Icon(Icons.add_circle_rounded)),
          Container(
              decoration: const BoxDecoration(
                  color: Colors.redAccent,
                  borderRadius: BorderRadius.all(Radius.circular(10))),
              height: 50,
              width: 90,
              child: Center(
                child: Text(
                  cityname,
                  style: const TextStyle(
                      color: Colors.white, fontWeight: FontWeight.w500),
                ),
              )),
        ],
      ),
    );
  }
}
