import 'package:flutter/material.dart';
import 'package:openbeta/pages/home_page.dart';
import 'package:openbeta/services/api_service.dart';

void main() {
  runApp(MyApp());
  ApiService().testConnection(); // call the testConnection method
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Climbing App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomePage(),
    );
  }
}
