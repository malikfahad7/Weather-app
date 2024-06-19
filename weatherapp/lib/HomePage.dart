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
  bool inProgress = false;
  String _getBackgroundImage() {
    if (response == null || response!.current == null) {
      return 'assets/default.jpg'; // Default background when no data
    }
    String condition = response?.current?.condition?.text ?? "";
    print(condition);
    if (condition.toLowerCase().contains("sunny")) {
      return 'assets/sunny_back.jpg';
    } else if (condition.toLowerCase().contains("rain")) {
      return 'assets/rainy_back.jpg';
    } else {
      return 'assets/cloudy_back.jpg';
    }
  }
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      
      child: Scaffold(
        body: SingleChildScrollView(
          child: Container(
            decoration: BoxDecoration(

              image: DecorationImage(
                
                image: AssetImage(_getBackgroundImage()),
                fit: BoxFit.cover,
                scale: double.maxFinite
              ),
            ),
            padding: EdgeInsets.all(20),
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
          
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                _SearchWidget(),
                inProgress?CircularProgressIndicator():_WeatherWidget()
              ],
            ),
          ),
        ),
      ),
    );
  }

  //Search widget to search location..
  Widget _SearchWidget() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      padding: EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.grey[200], // Background color of the search bar
        borderRadius: BorderRadius.circular(30), // Rounded corners
      ),
      child: TextField(

        style: TextStyle(color: Colors.black87), // Text color
        cursorColor: Colors.blue, // Cursor color
        decoration: InputDecoration(
          border: InputBorder.none, // Remove default border
          hintText: 'Search any location', // Placeholder text
          hintStyle: TextStyle(color: Colors.grey), // Placeholder style
          suffixIcon: Icon(Icons.search, color: Colors.blue), // Search icon
        ),
        onSubmitted: (value) {
          _getWeatherData(value); // Handle submission
        },
      ),
    );
  }

  Widget _WeatherWidget() {
    String condition = response?.current?.condition?.text ?? "";
    String? imagePath;

    if (condition.toLowerCase().contains("sunny")) {
      imagePath = 'assets/sunny.png';
    } else if (condition.toLowerCase().contains("rain")) {
      imagePath = 'assets/rainy.png';
    } else {
      imagePath = 'assets/cloudy.png';
    }
    if (response == null) {
      return const Text('Search for any location');
    }

    else {
      return Padding(
        padding: const EdgeInsets.only(
            top: 50, left: 10, right: 10, bottom: 10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.only(right: 18.0),
              child: Text(response!.location!.localtime!.substring(10) ?? "",
                style: TextStyle(fontSize: 100, fontWeight: FontWeight.w800
                    , color: Colors.black87),),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 50.0),
              child: Text(response!.location!.name ?? "", style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87),),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 20.0),
              child: Image.asset(
                imagePath,
                width: 200,
                height: 200,
              ),
            ),
            Text((response?.current?.tempC.toString() ?? "") + "°c",
              style: TextStyle(fontSize: 80,
                  fontWeight: FontWeight.w800,
                  color: Colors.black87),),
            Padding(
              padding: const EdgeInsets.only(top: 20.0),
              child: Text(condition, style: TextStyle(fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87),),
            )
          ],
        ),
      );
    }
  }
  //Passing location to this function to get Weather Data....
  _getWeatherData(String location) async {
    setState(() {
      inProgress=true;
    });
    try {
      response = await WeatherApi().getCurrentWeather(location);
    } catch (e) {
      print("Error fetching weather data: $e");
    }
    finally{
      setState(() {
        inProgress=false;
      });
    }
  }
}
