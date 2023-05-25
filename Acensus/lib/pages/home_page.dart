import 'package:flutter/material.dart';
import 'package:openbeta/models/climbing_route.dart';
import 'package:openbeta/services/api_service.dart';
import 'package:openbeta/services/local_database_service.dart';
import 'package:openbeta/services/get_user_location_service.dart';
import 'package:openbeta/pages/route_details_page.dart';
import 'package:openbeta/pages/nearby_areas_page.dart';


class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final ApiService apiService = ApiService();
  final LocalDatabase localDatabase = LocalDatabase.instance;
  final LocationService locationService = LocationService();
  final TextEditingController _apiController = TextEditingController();
  final TextEditingController _localController = TextEditingController();
  Future<List<ClimbingRoute>>? _apiSearchResult;
  Future<List<ClimbingRoute>>? _localSearchResult;
  List<String>? _nearbyAreas;

  void _searchApi() {
    setState(() {
      _apiSearchResult = apiService.getClimbsForArea(_apiController.text);
    });
    _apiController.clear();
  }

  void _searchLocal() {
    setState(() {
      _localSearchResult = localDatabase.searchRoutes(_localController.text);
    });
    _localController.clear();
  }

  void _getNearbyAreas() async {
    final location = await locationService.getCurrentLocation();
    if (location != null) {
      print('User Location: Latitude=${location.latitude}, Longitude=${location.longitude}');
      final areas = await apiService.getNearbyAreas(location.latitude, location.longitude);
      if (areas != null && areas.isNotEmpty) {
        print('Nearby Areas: $areas');
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => NearbyAreasPage(areas: areas),
          ),
        );
      } else {
        print('No nearby areas found.');
      }
    }
  }




  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('ASCENSUS'),
      ),
      body: Column(
        children: [
          // API Search Bar
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _apiController,
              onSubmitted: (_) => _searchApi(),
              decoration: InputDecoration(
                labelText: 'Search API',
                suffixIcon: IconButton(
                  icon: Icon(Icons.search),
                  onPressed: _searchApi,
                ),
              ),
            ),
          ),
          // Local Database Search Bar
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _localController,
              onSubmitted: (_) => _searchLocal(),
              decoration: InputDecoration(
                labelText: 'Search Local',
                suffixIcon: IconButton(
                  icon: Icon(Icons.search),
                  onPressed: _searchLocal,
                ),
              ),
            ),
          ),
          // Button for getting nearby areas
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
              onPressed: _getNearbyAreas,
              child: Text('Areas Near Me'),
            ),
          ),
          // Display nearby areas
          if (_nearbyAreas != null) ...[
            for (final area in _nearbyAreas!) Text(area),
          ],
          Expanded(
            child: FutureBuilder<List<ClimbingRoute>>(
              future: _apiSearchResult,
              builder: _buildListView,
            ),
          ),
          Expanded(
            child: FutureBuilder<List<ClimbingRoute>>(
              future: _localSearchResult,
              builder: _buildListView,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildListView(BuildContext context, AsyncSnapshot<List<ClimbingRoute>> snapshot) {
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
                  Text(snapshot.data![index].name),
                  Text('${snapshot.data![index].yds}'),
                ],
              ),
            ),
          );
        },
      );
    }
    return SizedBox.shrink();  // Return an empty widget when there's no data yet
  }
}
