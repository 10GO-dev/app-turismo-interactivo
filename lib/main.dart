import 'package:app_final/geolocation/gelocation.dart';
import 'package:app_final/geolocation/location_search_screen.dart';
import 'package:flutter/material.dart';
import 'package:app_final/theme.dart';

void main() async {

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Guía de Turismo',
      theme: lightTheme(context),
      home: const SearchLocationScreen(),
    );
  }
}
