import 'package:flutter/material.dart';
import 'package:openbeta/pages/home_page/home_page.dart';
import 'package:openbeta/effects/splash_screen.dart';
import 'package:openbeta/services/test_connection_service.dart';
import 'package:graphql/client.dart';
import 'package:openbeta/services/download_service.dart'; // Add this import

void main() {
  runApp(MyApp());

  // Initialize HttpLink with your GraphQL endpoint.
  final HttpLink httpLink = HttpLink('https://api.openbeta.io/graphql');
  TestConnectionService(httpLink).testConnection(); // call the testConnection method
}

class MyApp extends StatelessWidget {
  final DownloadService downloadService = DownloadService(); // Add this line

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Climbing App',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: SplashScreen(), // Set the SplashScreen as the initial screen
      routes: {
        '/home': (context) => HomePage(downloadService: downloadService), // Pass the DownloadService instance
      },
    );
  }
}
