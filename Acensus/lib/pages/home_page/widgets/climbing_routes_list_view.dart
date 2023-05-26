import 'package:flutter/material.dart';
import 'package:openbeta/models/climbing_route.dart';
import 'package:openbeta/pages/route_details_page.dart';

class ClimbingRoutesListView extends StatelessWidget {
  final AsyncSnapshot<List<ClimbingRoute>> snapshot;

  const ClimbingRoutesListView({required this.snapshot});

  @override
  Widget build(BuildContext context) {
    if (snapshot.connectionState == ConnectionState.waiting) {
      return Center(child: CircularProgressIndicator());
    } else if (snapshot.hasError) {
      return Center(child: Text('Failed to load climbs'));
    } else if (snapshot.hasData) {
      return ListView.builder(
        itemCount: snapshot.data!.length,
        itemBuilder: (context, index) {
          return InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => RouteDetailsPage(route: snapshot.data![index]),
                ),
              );
            },
            child: ListTile(
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    snapshot.data![index].name,
                    style: TextStyle(color: Colors.black),
                  ),
                  Text(
                    '${snapshot.data![index].yds}',
                    style: TextStyle(color: Colors.black),
                  ),
                ],
              ),
            ),
          );
        },
      );
    }
    return SizedBox.shrink();
  }
}
