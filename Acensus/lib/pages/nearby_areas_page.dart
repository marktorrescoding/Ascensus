import 'package:flutter/material.dart';

class NearbyAreasPage extends StatefulWidget {
  final List<String> areas;

  NearbyAreasPage({required this.areas});

  @override
  _NearbyAreasPageState createState() => _NearbyAreasPageState();
}

class _NearbyAreasPageState extends State<NearbyAreasPage> {
  @override
  void initState() {
    super.initState();
    _printAreas();
  }

  void _printAreas() {
    for (final area in widget.areas) {
      print(area);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Nearby Areas'),
      ),
      body: ListView.builder(
        itemCount: widget.areas.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(widget.areas[index]),
          );
        },
      ),
    );
  }
}
