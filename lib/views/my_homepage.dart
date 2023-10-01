import 'package:assessmentfc/utilities/city.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:assessmentfc/repo/services.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'components/city_item.dart';
import 'components/weather_carousel.dart';

class MyHomePage extends ConsumerStatefulWidget {
  const MyHomePage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _MyHomePageState();
}

class _MyHomePageState extends ConsumerState<MyHomePage> {
  @override
  initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    GeoLocating geoloc = GeoLocating();
    Weather uWeather = Weather(main: '', description: '', icon: '');
    final cityServices = ref.watch(carouselListProvider);
    final carouselcities = cityServices.cities;
    Jsoncity jsonService;

    jsonService = Jsoncity();
    jsonService.cityList();
    final listOfCities = jsonService.listOfCities;

    Future showUserLocation() async {
      await geoloc.getUserWeather(context: context);
      uWeather = geoloc.weather;
    }

    return Scaffold(
        backgroundColor: Colors.grey,
        appBar: AppBar(
            backgroundColor: Colors.amber,
            title: Center(
              child: Title(
                  color: Colors.redAccent,
                  child: const Text(
                    'Assessment',
                    style: TextStyle(color: Colors.white),
                  )),
            )),
        body: Column(children: [
          const SizedBox(height: 1),
          SizedBox(
            height: 100,
            child: ListView.builder(
                padding: const EdgeInsets.all(20),
                scrollDirection: Axis.horizontal,
                itemCount: listOfCities.length,
                itemBuilder: (context, index) {
                  final city = listOfCities[index];
                  return CityItem(
                      city: city,
                      onpressed: () {
                        cityServices.addCity(city);
                      },
                      cityname: city.city);
                }),
          ),
          Center(
            child: CarouselSlider(
              items: carouselcities
                  .map((city) => WeatherCarouselCard(city: city))
                  .toList(),
              options: CarouselOptions(
                  aspectRatio: 1.0,
                  enlargeCenterPage: true,
                  viewportFraction: 0.8),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          FutureBuilder(
              future: showUserLocation(),
              builder: (context, snapshot) {
                switch (snapshot.connectionState) {
                  case ConnectionState.done:
                    return Column(children: [
                      Container(
                          decoration: BoxDecoration(
                              color: Colors.amber,
                              borderRadius: BorderRadius.circular(20)),
                          child: TextButton(
                              onPressed: () {
                                ref.read(showProvider.notifier).changeShow();
                              },
                              child: const Text(
                                'Current Location',
                                style: TextStyle(color: Colors.black),
                              ))),
                      Consumer(builder: (context, ref, child) {
                        final showProviders = ref.watch(showProvider);
                        return !showProviders
                            ? Container()
                            : Column(
                                children: [
                                  Text(
                                    uWeather.description,
                                    style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 20,
                                        fontWeight: FontWeight.w500),
                                  ),
                                ],
                              );
                      })
                    ]);
                  default:
                    return const CircularProgressIndicator.adaptive();
                }
              }),
        ]));
  }
}
