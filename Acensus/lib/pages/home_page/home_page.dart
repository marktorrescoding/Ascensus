import 'package:flutter/material.dart';
import 'package:openbeta/models/climbing_route.dart';
import 'package:openbeta/services/climb_service.dart';
import 'package:openbeta/services/area_service.dart';
import 'package:openbeta/services/test_connection_service.dart';
import 'package:openbeta/services/local_database_service.dart';
import 'package:openbeta/services/get_user_location_service.dart';
import 'package:openbeta/pages/route_details_page.dart';
import 'package:openbeta/pages/nearby_areas_page.dart';
import 'package:graphql/client.dart';
import 'package:openbeta/pages/home_page/search_bar.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late HttpLink httpLink;
  late ClimbService climbService;
  late AreaService areaService;
  late TestConnectionService testConnectionService;
  final LocalDatabase localDatabase = LocalDatabase.instance;
  final LocationService locationService = LocationService();
  final TextEditingController _apiController = TextEditingController();
  final TextEditingController _localController = TextEditingController();
  Future<List<ClimbingRoute>>? _apiSearchResult;
  Future<List<ClimbingRoute>>? _localSearchResult;
  List<String>? _nearbyAreas;

  @override
  void initState() {
    super.initState();
    httpLink = HttpLink('https://api.openbeta.io/graphql');
    climbService = ClimbService(httpLink);
    areaService = AreaService(httpLink);
    testConnectionService = TestConnectionService(httpLink);
  }

  void _searchApi() {
    setState(() {
      _apiSearchResult = climbService.getClimbsForArea(_apiController.text);
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
      final areas = await areaService.getNearbyAreas(location.latitude, location.longitude);
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
    return SizedBox.shrink(); // Return an empty widget when there's no data yet
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('ASCENSUS'),
      ),
      body: Column(
        children: [
          CustomSearchBar(
            labelText: 'Search API',
            controller: _apiController,
            onPressed: _searchApi,
          ),
          CustomSearchBar(
            labelText: 'Search Local',
            controller: _localController,
            onPressed: _searchLocal,
          ),
          Button(
            text: 'Areas Near Me',
            onPressed: _getNearbyAreas,
          ),
          if (_nearbyAreas != null) NearbyAreas(areas: _nearbyAreas!),
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
}

class Button extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;

  const Button({
    required this.text,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ElevatedButton(
        onPressed: onPressed,
        child: Text(text),
      ),
    );
  }
}

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
