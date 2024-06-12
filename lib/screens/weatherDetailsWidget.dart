import 'package:flutter/material.dart';
import 'package:weather/models/weather_data.dart';

class WeatherDetailsWidget extends StatelessWidget {
  final WeatherData weatherData;

  WeatherDetailsWidget({required this.weatherData});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 20),
        Text('Ощущается как: ${weatherData.feelsLike}°C'),
        const SizedBox(height: 8),
        Text('Минимальная температура: ${weatherData.tempMin}°C'),
        const SizedBox(height: 8),
        Text('Максимальная температура: ${weatherData.tempMax}°C'),
        const SizedBox(height: 8),
        Text('Влажность: ${weatherData.humidity}%'),
        const SizedBox(height: 8),
        Text('Скорость ветра: ${weatherData.windSpeed} м/с'),
        const SizedBox(height: 8),
        Text('Направление ветра: ${weatherData.windDirection}°'),
        const SizedBox(height: 8),
        Text('Облачность: ${weatherData.clouds}%'),
        const SizedBox(height: 8),
        Text('Давление: ${weatherData.pressure} гПа'),
        // SizedBox(height: 8),
        // Text('Время рассвета: ${DateTime.fromMillisecondsSinceEpoch(weatherData.sunrise * 1000)}'),
        // SizedBox(height: 8),
        // Text('Время заката: ${DateTime.fromMillisecondsSinceEpoch(weatherData.sunset * 1000)}'),
      ],
    );
  }
}