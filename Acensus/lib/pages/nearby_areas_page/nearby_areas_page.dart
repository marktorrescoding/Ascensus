import 'package:flutter/material.dart';

class NearbyAreasPage extends StatelessWidget {
  final List<String> areas;

  NearbyAreasPage({required this.areas});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Nearby Areas'),
      ),
      body: ListView.builder(
        itemCount: areas.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(areas[index]),
          );
        },
      ),
    );
  }
}