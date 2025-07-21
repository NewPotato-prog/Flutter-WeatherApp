import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:weather_app/api.dart';
import 'package:weather_app/components.dart';
import 'package:weather_app/dropdown_list.dart';
import 'package:weather_app/model.dart';

class WeatherApp extends StatefulWidget {
  const WeatherApp({super.key});

  @override
  State<WeatherApp> createState() => _WeatherAppState();
}

class CurrentLocation extends ChangeNotifier {
  String _location = '';

  String get location => _location;

  void changeLocation(String location) {
    _location = location;
    notifyListeners();
  }
}

class _WeatherAppState extends State<WeatherApp> {
  late final Future<Map<String, dynamic>> weatherData;
  final TextEditingController inputController = TextEditingController();
  late CurrentWeather initData;

  @override
  void initState() {
    getCurrentWeatherFromQuery(query: '').then((value) {
      setState(() {
        initData = value;
      });
      inputController.text =
          '${value.location.name}, ${value.location.country}';
      if (context.mounted) {
        Provider.of<CurrentLocation>(
          context,
          listen: false,
        ).changeLocation(inputController.text);
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Consumer<CurrentLocation>(
        builder: (context, value, child) => SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            spacing: 10,
            // mainAxisAlignment: MainAxisAlignment.center,
            children: [
              MyDropDown(
                initialValue: inputController.text,
                inputController: inputController,
              ),
              FutureBuilder(
                future: getCurrentWeatherFromQuery(query: value.location),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    return WeatherReport(weatherData: snapshot.data);
                  } else if (snapshot.hasError) {
                    print(snapshot.error);
                    return Text('Failed to load data..');
                  }
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: LinearProgressIndicator(),
                  );
                },
              ),
              WeatherForecastCard(),
            ],
          ),
        ),
      ),
    );
  }
}
