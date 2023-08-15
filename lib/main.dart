import 'package:app_final/config/routes.dart';
import 'package:app_final/pages/gelocation.dart';
import 'package:app_final/pages/location_search_screen.dart';
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
      routes: {
        AppRoutes.searchLocation: (context) => const SearchLocationScreen(),
        AppRoutes.home: (context) => const MapScreen(),
      },
    );
  }
}
