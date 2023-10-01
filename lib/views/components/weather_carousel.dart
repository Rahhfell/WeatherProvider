import 'package:assessmentfc/models/city_list_model.dart';
import 'package:assessmentfc/repo/services.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class WeatherCarouselCard extends ConsumerWidget {
  const WeatherCarouselCard({super.key, required this.city});
  final CityModel city;

  @override
  Widget build(BuildContext context, ref) {
    WeatherServices weatherServices;

    weatherServices = WeatherServices();

    return FutureBuilder(
      future: weatherServices.getWeather(city),
      builder: (context, snapshot) {
        final text = weatherServices.weatherNow;
        switch (snapshot.connectionState) {
          case ConnectionState.done:
            return Row(children: [
              IconButton(
                  onPressed: () {
                    ref.read(carouselListProvider).removeCity(city);
                  },
                  icon: const Icon(Icons.remove_circle)),
              const SizedBox(
                width: 10,
              ),
              Container(
                  decoration: const BoxDecoration(
                    color: Colors.redAccent,
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                  ),
                  height: 250,
                  width: 200,
                  child: Center(
                      child: Column(
                    children: [
                      const SizedBox(
                        height: 20,
                      ),
                      Text(
                        city.city,
                        style:
                            const TextStyle(color: Colors.white, fontSize: 25),
                      ),
                      const SizedBox(
                        height: 60,
                      ),
                      Text(
                        text.main,
                        style: const TextStyle(
                            color: Colors.white,
                            fontSize: 25,
                            fontWeight: FontWeight.w500),
                      ),
                      Text(
                        text.description,
                        style:
                            const TextStyle(color: Colors.white, fontSize: 25),
                      ),
                    ],
                  )))
            ]);

          default:
            return const LinearProgressIndicator(
              semanticsLabel: 'getting weather',
            );
        }
      },
    );
  }
}
