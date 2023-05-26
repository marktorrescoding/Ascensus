import 'package:flutter/material.dart';

class NearbyAreasPage extends StatefulWidget {
  final List<String> areas;

  NearbyAreasPage({required this.areas});

  @override
  _NearbyAreasPageState createState() => _NearbyAreasPageState();
}

class _NearbyAreasPageState extends State<NearbyAreasPage> {
  bool includeBouldering = false;
  bool includeTrad = false;
  bool includeSport = true;
  late List<String> filteredAreas;

  @override
  void initState() {
    super.initState();
    filterAreas();
  }

  void filterAreas() {
    List<String> filtered = widget.areas.where((area) {
      if (!includeBouldering && (area.contains('boulder') || area.contains('bouldering'))) {
        return false;
      }
      if (!includeTrad && (area.contains('tr') || area.contains('trad'))) {
        return false;
      }

      final regex = RegExp(r"\((\d+) climbs\)$");
      final match = regex.firstMatch(area);
      if (match != null) {
        final totalClimbs = int.parse(match.group(1)!);
        if (totalClimbs == 0 && (!area.contains('sport') || !area.contains('tr'))) {
          return false;
        }
      }

      if (!includeSport && area.contains('sport') && !area.contains('tr')) {
        return false;
      }

      return true;
    }).toList();

    setState(() {
      filteredAreas = filtered;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Nearby Areas'),
      ),
      body: ListView.builder(
        itemCount: filteredAreas.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(filteredAreas[index]),
          );
        },
      ),
    );
  }
}
