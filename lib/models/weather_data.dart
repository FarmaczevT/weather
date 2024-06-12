Map<String, String> descriptionTranslations = {
  "thunderstorm with light rain": "гроза с легким дождем",
  "thunderstorm with rain": "гроза с дождем",
  "thunderstorm with heavy rain": "гроза с сильным дождем",
  "light thunderstorm": "легкая гроза",
  "thunderstorm": "гроза",
  "heavy thunderstorm": "сильная гроза",
  "ragged thunderstorm": "разорванная гроза",
  "thunderstorm with light drizzle": "гроза с легким моросящим дождем",
  "thunderstorm with drizzle": "гроза с моросящим дождем",
  "thunderstorm with heavy drizzle": "гроза с сильным моросящим дождем",
  "light intensity drizzle": "легкий моросящий дождь",
  "drizzle": "моросящий дождь",
  "heavy intensity drizzle": "сильный моросящий дождь",
  "light intensity drizzle rain": "легкий моросящий дождь",
  "drizzle rain": "моросящий дождь",
  "heavy intensity drizzle rain": "сильный моросящий дождь",
  "shower rain and drizzle": "ливневый дождь и морось",
  "heavy shower rain and drizzle": "сильный ливневый дождь и морось",
  "shower drizzle": "ливневый моросящий дождь",
  "light rain": "легкий дождь",
  "moderate rain": "умеренный дождь",
  "heavy intensity rain": "сильный дождь",
  "very heavy rain": "очень сильный дождь",
  "extreme rain": "экстремальный дождь",
  "freezing rain": "дождь со снегом",
  "light freezing rain": "легкий дождь со снегом",
  "heavy freezing rain": "сильный дождь со снегом",
  "light intensity shower rain": "легкий ливневый дождь",
  "shower rain": "ливневый дождь",
  "heavy intensity shower rain": "сильный ливневый дождь",
  "ragged shower rain": "разорванный ливневый дождь",
  "light snow": "легкий снег",
  "snow": "снег",
  "heavy snow": "сильный снег",
  "sleet": "снег с дождем",
  "light shower sleet": "легкий ливневый снег с дождем",
  "shower sleet": "ливневый снег с дождем",
  "light rain and snow": "легкий дождь и снег",
  "rain and snow": "дождь и снег",
  "light shower snow": "легкий ливневый снег",
  "shower snow": "ливневый снег",
  "heavy shower snow": "сильный ливневый снег",
  "mist": "туман",
  "smoke": "дым",
  "haze": "легкий туман",
  "sand/ dust whirls": "песок/пыльные вихри",
  "fog": "туман",
  "sand": "песок",
  "dust": "пыль",
  "volcanic ash": "вулканический пепел",
  "squalls": "шквалистый ветер",
  "tornado": "торнадо",
  "clear sky": "ясно",
  "few clouds": "малооблачно",
  "scattered clouds": "облачно",
  "broken clouds": "пасмурно",
  "overcast clouds": "пасмурно",
};

class WeatherData {
  final String city;
  final double temperature;
  final int condition;
  final String icon;
  final String description;
  final int humidity; // Влажность
  final double windSpeed; // Скорость ветра
  final int windDirection; // Направление ветра
  final int clouds; // Облачность
  final int pressure; // Давление
  // final int sunrise; // Время рассвета
  // final int sunset; // Время заката
  final double feelsLike;
  final double tempMin;
  final double tempMax;

  WeatherData({
    required this.city,
    required this.temperature,
    required this.condition,
    required this.icon,
    required this.description,
    required this.humidity,
    required this.windSpeed,
    required this.windDirection,
    required this.clouds,
    required this.pressure,
    // required this.sunrise,
    // required this.sunset,
    required this.feelsLike,
    required this.tempMin,
    required this.tempMax,
  });

  factory WeatherData.fromJson(Map<String, dynamic> json) {
    String description = json['weather'][0]['description'];
    // Переводим значение description, если перевод доступен
    String translatedDescription = descriptionTranslations[description] ?? description;

    return WeatherData(
      city: json['name'],
      temperature: json['main']['temp'].toDouble(),
      condition: json['weather'][0]['id'],
      icon: 'http://openweathermap.org/img/wn/${json['weather'][0]['icon']}@2x.png',
      description: translatedDescription,
      humidity: json['main']['humidity'],
      windSpeed: json['wind']['speed'].toDouble(),
      windDirection: json['wind']['deg'],
      clouds: json['clouds']['all'],
      pressure: json['main']['pressure'],
      // sunrise: json['sys']['sunrise'],
      // sunset: json['sys']['sunset'],
      feelsLike: json['main']['feels_like'].toDouble(),
      tempMin: json['main']['temp_min'].toDouble(),
      tempMax: json['main']['temp_max'].toDouble(),
    );
  }
}

class WeatherForecast {
  final DateTime dateTime;
  final double temperature;
  final String icon;
  final String description;

  WeatherForecast({
    required this.dateTime,
    required this.temperature,
    required this.icon,
    required this.description,
  });

  factory WeatherForecast.fromJson(Map<String, dynamic> json) {
    final dateTime = DateTime.fromMillisecondsSinceEpoch(json['dt'] * 1000);
    final temperature = json['main']['temp'].toDouble();
    final icon = json['weather'][0]['icon'];
    final description = json['weather'][0]['description'];

    return WeatherForecast(
      dateTime: dateTime,
      temperature: temperature,
      icon: icon,
      description: description,
    );
  }
}