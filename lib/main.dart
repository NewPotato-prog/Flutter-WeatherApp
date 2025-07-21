import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:scaffold_gradient_background/scaffold_gradient_background.dart';
import 'package:weather_app/weather.dart';

void main() {
  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      home: ScaffoldGradientBackground(
        gradient: LinearGradient(
          colors: [Color(0xffD6EADF), Color(0xffB8E0D2), Color(0xff95B8D1)],
          begin: AlignmentDirectional.topStart,
          end: AlignmentDirectional.bottomEnd,
        ),
        body: SafeArea(
          child: ChangeNotifierProvider<CurrentLocation>(
            create: (context) => CurrentLocation(),
            builder: (context, child) => WeatherApp(),
          ),
        ),
      ),
    ),
  );
}
