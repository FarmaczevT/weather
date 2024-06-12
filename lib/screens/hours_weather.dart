import 'package:flutter/material.dart';
import '../models/weather_data.dart';
import '../api/weather_api.dart';

class WeatherForecastPage extends StatefulWidget {
  final String city;

  WeatherForecastPage({required this.city});

  @override
  _WeatherForecastPageState createState() => _WeatherForecastPageState();
}

class _WeatherForecastPageState extends State<WeatherForecastPage> {
  List<WeatherForecast>? _forecasts;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _getWeatherForecast();
  }

  void _getWeatherForecast() async {

  setState(() {
    _forecasts = [];
    _isLoading = true;
  });

  try {
    // Создаем экземпляр класса WeatherApiForecast
    WeatherApiForecast weatherApiForecast = WeatherApiForecast();

    final forecasts = await weatherApiForecast.getWeatherForecast(widget.city); // Вызываем метод на экземпляре
    setState(() {
      _forecasts = forecasts;
      _isLoading = false;
    });

    // Выводим в консоль данные прогноза
    for (var forecast in _forecasts!) {
      print('${forecast.dateTime}: ${forecast.temperature}°C, ${forecast.description}');
    }
  } catch (e) {
    setState(() {
      _isLoading = false;
    });
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Ошибка'),
          content: Text('Не удалось загрузить прогноз погоды'),
          actions: <Widget>[
            TextButton(
              child: Text('ОК'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: Text('Погода на сегодня'),
      // ),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : _forecasts == null || _forecasts!.isEmpty
              ? Center(
                  child: Text('Нет данных о прогнозе погоды'),
                )
              : Column(
                  children: [
                    if (_forecasts!.any((forecast) => forecast.dateTime.hour >= 6 && forecast.dateTime.hour < 12))
                      _buildForecastCard(_forecasts!.firstWhere((forecast) =>
                          forecast.dateTime.hour >= 6 && forecast.dateTime.hour < 12), 'Утро'),
                    if (_forecasts!.any((forecast) => forecast.dateTime.hour >= 12 && forecast.dateTime.hour < 18))
                      _buildForecastCard(_forecasts!.firstWhere((forecast) =>
                          forecast.dateTime.hour >= 12 && forecast.dateTime.hour < 18), 'День'),
                    if (_forecasts!.any((forecast) => forecast.dateTime.hour >= 18 && forecast.dateTime.hour < 22))
                      _buildForecastCard(_forecasts!.firstWhere((forecast) =>
                          forecast.dateTime.hour >= 18 && forecast.dateTime.hour < 22), 'Вечер'),
                    if (_forecasts!.any((forecast) => forecast.dateTime.hour >= 22 || forecast.dateTime.hour < 6))
                      _buildForecastCard(_forecasts!.firstWhere((forecast) =>
                          forecast.dateTime.hour >= 22 || forecast.dateTime.hour < 6), 'Ночь'),
                  ],
                ),
    );
  }

  Widget _buildForecastCard(WeatherForecast forecast, String timePeriod) {
    return Card(
      child: ListTile(
        title: Text('$timePeriod: ${forecast.temperature.toStringAsFixed(1)}°C'),
        subtitle: Text(forecast.description),
        leading: Image.network(
          'http://openweathermap.org/img/wn/${forecast.icon}@2x.png',
        ),
      ),
    );
  }
}