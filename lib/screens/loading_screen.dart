import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import '../api/weather_api.dart';
import '../models/weather_data.dart';
import 'home_screen.dart';

class LoadingScreen extends StatefulWidget {
  const LoadingScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _LoadingScreenState createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> {
  WeatherData? _weatherData;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => getLocationAndWeather());
  }

  Future<void> getLocationAndWeather() async {
    try {
      // Проверяем доступность разрешения на геолокацию
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        // Предлагаем пользователю включить геолокацию в настройках устройства
        // ignore: use_build_context_synchronously
        return showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text("Ошибка"),
              content: const Text("Геолокация отключена. Пожалуйста, включите геолокацию в настройках устройства и попробуйте снова."),
              actions: <Widget>[
                TextButton(
                  child: const Text("OK"),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ],
            );
          },
        );
      }

      // Получаем текущие координаты пользователя
      Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
      // Получаем погоду по координатам
      WeatherData weatherData = await WeatherApi().getWeatherByLocation(position.latitude, position.longitude);

      // Обновляем состояние с полученными данными
      setState(() {
        _weatherData = weatherData;
      });

      // Переходим на HomeScreen с полученными данными
      // ignore: use_build_context_synchronously
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => HomeScreen(weatherData: _weatherData),
        ),
      );
    } catch (e) {
      // print('Error: $e');
      // Обработка ошибок
      // При возникновении исключения переходим на HomeScreen с null-значением данных о погоде
      // ignore: use_build_context_synchronously
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => HomeScreen(weatherData: null),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Загрузка...'),
      ),
      body: const Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}