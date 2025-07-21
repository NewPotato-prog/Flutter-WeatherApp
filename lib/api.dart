import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:weather_app/model.dart';

final baseUrl = 'https://api.weatherapi.com/v1/';
final options = {
  'current': 'current.json?',
  'forecast': 'forecast.json?',
  'search': 'search.json?',
  'ip': 'ip.json?',
};
final key = '6156dc7f3916482a87f95841251407';

typedef RespData = Map<String, dynamic>;

Future<CurrentWeather> getCurrentWeatherFromQuery({
  required String query,
}) async {
  // print('getting $query');
  if (query == '') query = 'auto:ip';

  final uri = '$baseUrl${options['current']}key=$key&q=$query&aqi=no';
  final res = await http.get(Uri.parse(uri));
  final weather = jsonDecode(res.body);
  final curWeather = CurrentWeather(
    location: Location.fromJson(weather['location']),
    current: Current.fromJson(weather['current']),
  );
  return curWeather;
}

Future<List<Location>> getSearchResultsFromQuery(String query) async {
  // print('getting $query');
  if (query == '') return [];
  final uri = '$baseUrl${options['search']}key=$key&q=$query';
  final res = await http.get(Uri.parse(uri));
  final locList = jsonDecode(res.body) as List;

  final loc = locList.map((location) => Location.fromJson(location)).toList();
  return loc;
}

Future<GetForecast> getForecastFromQuery(String query) async {
  if (query == '') query = 'auto:ip';
  final curTime = DateTime.now();
  final hour = curTime.minute <= 30 ? curTime.hour : curTime.hour + 1;
  final uri =
      '$baseUrl${options['forecast']}key=$key&q=${query.replaceAll(RegExp(' '), '%')}&days=7&hour=$hour';
  final res = await http.get(Uri.parse(uri));
  final resForecast = jsonDecode(res.body);
  final forecast = GetForecast.fromJson(resForecast);
  return forecast;
}

// void main() {
//   final res = getCurrentWeatherFromQuery(query: 'delhi');
//   res.then((value) => print(value['location']['name']));
// }
