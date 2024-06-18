import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:weatherapp/WeatherModel.dart';
import 'package:weatherapp/api.dart';
import 'dart:ui';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  ApiResponse? response;
  bool isFill = false;
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Container(
          padding: EdgeInsets.all(20),
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          color: Colors.white,
          child: Column(
            children: [
              _SearchWidget(),
              isFill?_WeatherWidget():Padding(
                padding: const EdgeInsets.only(top: 20.0),
                child: Text('Search for any location'),
              )
            ],
          ),
        ),
      ),
    );
  }

  //Search widget to search location..
  Widget _SearchWidget() {
  return SearchBar(

    hintText: "Search any location",
    onSubmitted: (value){
      _getWeatherData(value);
      isFill = true;
    },
  );
  }
  Widget _WeatherWidget() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(response?.location?.name??""),
      ],
    );
  }

  //Passing location to this function to get Weather Data....
  _getWeatherData(String location) async {
    try {
      response = await WeatherApi().getCurrentWeather(location);
      _WeatherWidget();

    } catch (e) {
      print("Error fetching weather data: $e");
    }
  }
}
