import 'package:app_final/config/routes.dart';
import 'package:app_final/pages/gelocation.dart';
import 'package:app_final/pages/location_search_screen.dart';
import 'package:flutter/material.dart';
import 'package:app_final/theme.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_provider/flutter_provider.dart';
import 'package:rx_shared_preferences/rx_shared_preferences.dart';

import 'pages/my_places.dart';

void main() async {
    WidgetsFlutterBinding.ensureInitialized();

  /// Singleton instance for app
  final rxPrefs = RxSharedPreferences(
    SharedPreferences.getInstance(),
    kReleaseMode ? null : const RxSharedPreferencesDefaultLogger(),
  );

  runApp(
    Provider.value(
      rxPrefs,
      child: const MyApp(),
    ),
  );
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
        AppRoutes.myPlaces: (context) => const MyPlacesScreen(),
        AppRoutes.home: (context) => const MapScreen(),
      },
    );
  }
}
