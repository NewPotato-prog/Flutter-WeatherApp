import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:weather_app/api.dart';
import 'package:weather_app/model.dart';
import 'package:weather_app/weather.dart';

class WeatherReport extends StatefulWidget {
  final CurrentWeather? weatherData;
  const WeatherReport({super.key, this.weatherData});

  @override
  State<WeatherReport> createState() => _WeatherReportState();
}

class _WeatherReportState extends State<WeatherReport> {
  late final CurrentWeather? weatherData;
  late final Location? location;
  late final Current? current;
  late final Condition? condition;
  late bool isDegC;

  @override
  void initState() {
    weatherData = widget.weatherData;
    location = weatherData?.location;
    current = weatherData?.current;
    condition = current?.condition;
    isDegC = true;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.weatherData == null) {
      return Container();
    }
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        // mainAxisSize: MainAxisSize.min,
        spacing: 5,
        children: [
          Image.network(
            'http:${condition?.icon.toString().replaceAll('64x64', '128x128')}',
            scale: 1,
          ),

          Text(
            condition?.text ?? '',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
          ),
          TapRegion(
            onTapInside: (event) => setState(() {
              isDegC = !isDegC;
            }),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              spacing: 5,
              children: [
                Text(
                  isDegC
                      ? current?.temp_c.toString() ?? ''
                      : current?.temp_f.toString() ?? '',
                  style: TextStyle(fontSize: 38, fontWeight: FontWeight.bold),
                ),
                Text(
                  isDegC ? '\u00B0C' : '\u2109',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.w700),
                ),
              ],
            ),
          ),

          Text(
            'Feels Like : ${isDegC ? '${current?.feelslike_c}\u00B0C' : '${current?.feelslike_f}\u2109'}',
            style: TextStyle(fontWeight: FontWeight.w600, fontSize: 12),
          ),
          // Row(
          //   mainAxisAlignment: MainAxisAlignment.center,
          //   children: [
          //     Icon(Icons.water_drop_outlined, size: 14),
          //     Text(
          //       ' ${current['humidity']}%',
          //       style: TextStyle(fontWeight: FontWeight.w600, fontSize: 12),
          //     ),
          //   ],
          // ),
        ],
      ),
    );
  }
}

class WeatherForecastCard extends StatefulWidget {
  const WeatherForecastCard({super.key});

  @override
  State<WeatherForecastCard> createState() => _WeatherForecastCardState();
}

class _WeatherForecastCardState extends State<WeatherForecastCard> {
  @override
  void initState() {
    getForecastFromQuery('auto:ip').then((data) {
      setState(() {});
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: getForecastFromQuery(
        Provider.of<CurrentLocation>(context).location,
      ),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return LinearProgressIndicator();
        }
        if (snapshot.hasError) return Text('Error Occurred');
        if (snapshot.hasData) {
          final GetForecast snap = snapshot.data!;
          final forecast = snap.forecast.forecastdayList;

          return Container(
            height: 200,
            padding: EdgeInsets.all(2),
            margin: EdgeInsets.symmetric(horizontal: 10),
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: forecast.dayList.length,
              itemBuilder: (context, int index) {
                late final String day;
                var date = DateTime.parse(
                  forecast.dayList[index].hourList.hours[0].time,
                );
                if (index == 0) {
                  day = 'Today';
                } else if (index == 1) {
                  day = 'Tomorrow';
                } else {
                  day = DateFormat('E, dd MMMM').format(date).toString();
                }
                return Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  mainAxisSize: MainAxisSize.min,
                  spacing: 5,
                  children: [
                    Text(day, style: TextStyle(fontWeight: FontWeight.w600)),
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: [
                            Text(DateFormat('h:mm aa').format(date).toString()),
                            Image.network(
                              'http:${forecast.dayList[index].hourList.hours[0].condition.icon}',
                            ),
                            Text(
                              '${forecast.dayList[index].hourList.hours[0].temp_c}\u00B0C',
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          );
        }
        return LinearProgressIndicator();
      },
    );
  }
}
