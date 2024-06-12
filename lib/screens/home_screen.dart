import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:app_settings/app_settings.dart';
import 'package:weather/screens/WeatherDetailsWidget.dart';
import 'package:weather/screens/loading_screen.dart';
import '../models/weather_data.dart';
import '../api/weather_api.dart';
import '../utils/constants.dart';
import 'package:weather/styles/button_styles.dart';
import 'package:weather/screens/hours_weather.dart';

class HomeScreen extends StatefulWidget {
  final WeatherData? weatherData;

  HomeScreen({required this.weatherData});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _cityController = TextEditingController();
  String _selectedCity = defaultCity;
  WeatherData? _weatherData;
  bool _showSearchField = false;
  int _currentPage = 0;

  List<String> pageTitles = ['Текущая погода', 'Погода по часам'];

  void _searchByLocation() async {
    LocationPermission permission = await Geolocator.checkPermission();

    if (permission != LocationPermission.always &&
        permission != LocationPermission.whileInUse) {
      permission = await Geolocator.requestPermission();
    }

    if (permission == LocationPermission.always ||
        permission == LocationPermission.whileInUse) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => LoadingScreen()),
      );
    } else {
      // ignore: use_build_context_synchronously
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text("Ошибка"),
            content: const Text(
                "Разрешение на геолокацию было запрещено. Пожалуйста, разрешите геолокацию в настройках вашего устройства и попробуйте еще раз."),
            actions: <Widget>[
              TextButton(
                child: const Text("ОК"),
                onPressed: () async {
                  await AppSettings.openAppSettings();
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
  void initState() {
    super.initState();
    _weatherData = widget.weatherData;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Погода'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              setState(() {
                _showSearchField = !_showSearchField;
              });
            },
          ),
        ],
      ),
      body: PageView(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                if (_showSearchField)
                  Column(
                    children: [
                      TextField(
                        controller: _cityController,
                        decoration: const InputDecoration(
                          labelText: 'Город или район',
                        ),
                      ),
                      const SizedBox(height: 16),
                      Column(
                        children: [
                          ElevatedButton(
                            onPressed: () async {
                              setState(() {
                                _selectedCity = _cityController.text.trim();
                                _showSearchField = false;
                                _cityController.clear();
                              });
                              final weatherData =
                                  await WeatherApi().getWeather(_selectedCity);
                              setState(() {
                                _weatherData = weatherData;
                              });
                            },
                            style: ButtonStyles.primaryButtonStyle,
                            child: const Text('Поиск'),
                          ),
                          const SizedBox(height: 10),
                          ElevatedButton(
                            onPressed: _searchByLocation,
                            style: ButtonStyles.secondaryButtonStyle,
                            child: const Text('Поиск по геолокации'),
                          ),
                        ],
                      )
                    ],
                  ),
                SizedBox(height: _showSearchField ? 16 : 0),
                Expanded(
                  child: _weatherData == null
                      ? const Center(child: Text('Выберите местоположение'))
                      : Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              _weatherData!.city,
                              style: TextStyle(fontSize: 24),
                            ),
                            SizedBox(height: 20),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Image.network(
                                  _weatherData?.icon ?? '',
                                  width: 100,
                                  height: 100,
                                ),
                                const SizedBox(width: 10),
                                Text(
                                  '${_weatherData?.temperature ?? 0}°C',
                                  style: TextStyle(fontSize: 48),
                                ),
                              ],
                            ),
                            const SizedBox(height: 2),
                            Text(
                              _weatherData?.description ?? '',
                              style: TextStyle(fontSize: 22),
                            ),
                            WeatherDetailsWidget(weatherData: _weatherData!),
                          ],
                        ),
                ),
              ],
            ),
          ),
          WeatherForecastPage(city: _weatherData?.city ?? ''),
        ],
        onPageChanged: (value) {
          setState(() {
            _currentPage = value;
          });
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentPage,
        onTap: (index) {
          setState(() {
            _currentPage = index;
          });
        },
        items: [
          for (var i = 0; i < pageTitles.length; i++)
            BottomNavigationBarItem(
              icon: const Icon(null),
              label: pageTitles[i],
            ),
        ],
        selectedItemColor: Colors.blue, // Цвет выбранного элемента
        unselectedItemColor: Colors.grey, // Цвет не выбранных элементов
        selectedFontSize: 18, // Размер текста выбранного элемента
        unselectedFontSize: 16, // Размер текста не выбранных элементов
        selectedLabelStyle: const TextStyle(
            fontWeight: FontWeight.bold), // Стиль текста выбранного элемента
        unselectedLabelStyle: const TextStyle(
            fontWeight:
                FontWeight.normal), // Стиль текста не выбранных элементов
      ),
    );
  }

  String get selectedCity => _selectedCity;
}
