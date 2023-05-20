import 'package:flutter/material.dart';
import 'package:openbeta/models/climbing_route.dart';

class RouteDetailsPage extends StatelessWidget {
  final ClimbingRoute route;

  RouteDetailsPage({required this.route});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${route.name} (${route.yds})'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Description:', style: Theme.of(context).textTheme.headline5),
            SizedBox(height: 10),
            Text(route.content.description),
            SizedBox(height: 20),
            Text('Location:', style: Theme.of(context).textTheme.headline5),
            SizedBox(height: 10),
            Text(route.content.location),
            SizedBox(height: 20),
            Text('Protection:', style: Theme.of(context).textTheme.headline5),
            SizedBox(height: 10),
            Text(route.content.protection),
          ],
        ),
      ),
    );
  }
}
