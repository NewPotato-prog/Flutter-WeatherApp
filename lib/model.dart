// ignore_for_file: non_constant_identifier_names

import 'dart:convert';

class Condition {
  final String icon;
  final String text;
  final int code;

  const Condition({required this.icon, required this.text, required this.code});

  factory Condition.fromJson(Map<String, dynamic> json) => Condition(
    icon: json['icon'] as String,
    text: json['text'] as String,
    code: json['code'] as int,
  );

  Map<String, dynamic> toJson() => {'icon': icon, 'text': text, 'code': code};
}

class Current {
  final double temp_c;
  final double temp_f;
  final double feelslike_c;
  final double feelslike_f;
  final Condition condition;

  const Current({
    required this.temp_c,
    required this.temp_f,
    required this.feelslike_c,
    required this.feelslike_f,
    required this.condition,
  });

  factory Current.fromJson(Map<String, dynamic> json) => Current(
    temp_c: json['temp_c'],
    temp_f: json['temp_f'],
    feelslike_c: json['feelslike_c'],
    feelslike_f: json['feelslike_f'],
    condition: Condition.fromJson(json['condition']),
  );

  Map<String, dynamic> toJson() => {
    'temp_c': temp_c,
    'temp_f': temp_f,
    'feelslike_c': feelslike_c,
    'feelslike_f': feelslike_f,
    'condition': condition,
  };
}

class Location {
  final String name;
  final String region;
  final String country;
  final String? localtime;

  const Location({
    required this.name,
    required this.region,
    required this.country,
    this.localtime,
  });

  factory Location.fromJson(Map<String, dynamic> json) => Location(
    name: json['name'],
    region: json['region'],
    country: json['country'],
    localtime: json['localtime'],
  );

  Map<String, dynamic> toJson() => {
    'name': name,
    'region': region,
    'country': country,
    'localtime': localtime,
  };
}

class Hour {
  final double temp_c;
  final double temp_f;
  final Condition condition;

  const Hour({
    required this.temp_c,
    required this.temp_f,
    required this.condition,
  });

  factory Hour.fromJson(Map<String, dynamic> json) => Hour(
    temp_c: json['temp_c'],
    temp_f: json['temp_f'],
    condition: Condition.fromJson(json['condition']),
  );

  Map<String, dynamic> toJson() => {
    'avgtemp_c': temp_c,
    'avgtemp_f': temp_f,
    'condition': condition,
  };
}

class HourList {
  final List<Hour> hours;

  const HourList({required this.hours});

  factory HourList.formJsonList(List list) =>
      HourList(hours: list.map((hour) => Hour.fromJson(hour)).toList());

  String toJsonList() => jsonEncode(hours);
}

class Forecastday {
  final String date;
  final HourList hourList;

  const Forecastday({required this.date, required this.hourList});

  factory Forecastday.fromJson(Map<String, dynamic> json) => Forecastday(
    date: json['date'],
    hourList: HourList.formJsonList(json['hour']),
  );

  Map<String, dynamic> toJson() => {'date': date, 'hour': hourList};
}

class ForecastdayList {
  final List<Forecastday> dayList;

  const ForecastdayList({required this.dayList});

  factory ForecastdayList.fromJson(List list) => ForecastdayList(
    dayList: list
        .map((forecastday) => Forecastday.fromJson(forecastday))
        .toList(),
  );

  String toJson() => jsonEncode(dayList);
}

class Forecast {
  final ForecastdayList forecastdayList;

  const Forecast({required this.forecastdayList});

  factory Forecast.fromJson(Map<String, dynamic> json) =>
      Forecast(forecastdayList: ForecastdayList.fromJson(json['forecastday']));
}

class GetForecast {
  final Location location;
  final Current current;
  final Forecast forecast;

  const GetForecast({
    required this.location,
    required this.current,
    required this.forecast,
  });

  factory GetForecast.fromJson(Map<String, dynamic> json) => GetForecast(
    location: Location.fromJson(json['location']),
    current: Current.fromJson(json['current']),
    forecast: Forecast.fromJson(json['forecast']),
  );

  Map<String, dynamic> toJson() => {
    'location': location,
    'current': current,
    'forecast': forecast,
  };
}

class CurrentWeather {
  final Location location;
  final Current current;

  const CurrentWeather({required this.location, required this.current});

  factory CurrentWeather.fromJson(Map<String, dynamic> json) =>
      CurrentWeather(location: json['location'], current: json['current']);

  Map<String, dynamic> toJson() => {'location': location, 'current': current};
}
