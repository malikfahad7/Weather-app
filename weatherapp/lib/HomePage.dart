import 'package:flutter/material.dart';
import 'package:weatherapp/WeatherModel.dart';
import 'package:weatherapp/api.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
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
    },
  );
  }

  //Passing location to this function to get Weather Data....
  _getWeatherData(String location) async {
    try {
      ApiResponse response = await WeatherApi().getCurrentWeather(location);
      print(response.toJson());

    } catch (e) {
      print("Error fetching weather data: $e");
    }
  }
}
