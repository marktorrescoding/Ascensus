import 'package:flutter/material.dart';

class NearbyAreas extends StatelessWidget {
  final List<String> areas;

  const NearbyAreas({required this.areas});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        for (final area in areas) Text(area),
      ],
    );
  }
}
