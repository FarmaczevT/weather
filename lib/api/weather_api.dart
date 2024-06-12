import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:weather/utils/constants.dart';
import '../models/weather_data.dart';

class WeatherApi {
  Future<WeatherData> getWeather(String city) async {
    final response = await http.get(Uri.parse(
        'http://api.openweathermap.org/data/2.5/weather?q=$city&appid=$apiKey&units=metric'));

    if (response.statusCode == 200) {
      return WeatherData.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load weather data');
    }
  }

  Future<WeatherData> getWeatherByLocation(
      double latitude, double longitude) async {
    final response = await http.get(Uri.parse(
        'http://api.openweathermap.org/data/2.5/weather?lat=$latitude&lon=$longitude&appid=$apiKey&units=metric'));

    if (response.statusCode == 200) {
      return WeatherData.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load weather data');
    }
  }
}

class WeatherApiForecast {
  Future<List<WeatherForecast>> getWeatherForecast(String city) async {
    final response = await http.get(Uri.parse(
        'https://api.openweathermap.org/data/2.5/forecast?q=$city&appid=$apiKey&units=metric&lang=ru'));

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      final List<dynamic> list = json['list'];
      final List<WeatherForecast> forecasts =
          list.map((item) => WeatherForecast.fromJson(item)).toList();

      // Фильтруем прогнозы для текущего и следующего дня
      final now = DateTime.now();
      final tomorrow = DateTime(now.year, now.month, now.day + 1);
      final todayAndTomorrowForecasts = forecasts.where((forecast) =>
          (forecast.dateTime.year == now.year &&
              forecast.dateTime.month == now.month &&
              forecast.dateTime.day == now.day) ||
          (forecast.dateTime.year == tomorrow.year &&
              forecast.dateTime.month == tomorrow.month &&
              forecast.dateTime.day == tomorrow.day)).toList();

      // Сортируем прогнозы по времени
      todayAndTomorrowForecasts.sort((a, b) => a.dateTime.compareTo(b.dateTime));

      return todayAndTomorrowForecasts;
    } else {
      throw Exception('Failed to load weather forecast');
    }
  }
}