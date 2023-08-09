import 'package:app_final/session_managment/session.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Guía de Turismo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: SessionManagementScreen(),
    );
  }
}
