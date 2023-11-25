import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class WeatherPage extends StatefulWidget {
  @override
  _WeatherPageState createState() => _WeatherPageState();
}

class _WeatherPageState extends State<WeatherPage> {
  String apiKey = 'e34a5eb0b4c5ff748fdf9219a63d224e';
  String city = '';
  Map<String, dynamic> weatherData = {};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xff0bd9b3),
        title: Text(
          'Weather',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.green,
          ),
        ),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/images.jpeg'),
              fit: BoxFit.cover,
            ),
          ),
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Current Weather in $city:',
              style: TextStyle(fontSize: 20),
            ),
            SizedBox(height: 20),
            if (weatherData.isNotEmpty)
              Column(
                children: <Widget>[
                  Text(
                    '${convertKelvinToCelsius(weatherData['main']['temp']).toInt()}°C',
                    style: TextStyle(fontSize: 40),
                  ),
                  Text(
                    '${weatherData['weather'][0]['description']}',
                    style: TextStyle(fontSize: 20),
                  ),
                ],
              ),
            SizedBox(height: 20),
            TextField(
              onChanged: (value) {
                setState(() {
                  city = value;
                });
              },
              decoration: InputDecoration(
                hintText: 'Enter a city',
                suffixIcon: IconButton(
                  icon: Icon(Icons.search),
                  onPressed: () {
                    fetchWeatherData(city);
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> fetchWeatherData(String city) async {
    final response = await http.get(
      Uri.parse('https://api.openweathermap.org/data/2.5/weather?q=$city&appid=$apiKey'),
    );

    if (response.statusCode == 200) {
      setState(() {
        weatherData = jsonDecode(response.body);
      });
    } else {
      // Handle error, e.g., show a snackbar or dialog.
    }
  }

  double convertKelvinToCelsius(double kelvin) {
    return kelvin - 273.15;
  }
}
