import 'package:flutter/material.dart';
import 'package:openbeta/models/climbing_route.dart';
import 'package:openbeta/services/climb_service.dart';
import 'package:openbeta/services/area_service.dart';
import 'package:openbeta/services/test_connection_service.dart';
import 'package:openbeta/services/local_database_service.dart';
import 'package:openbeta/services/get_user_location_service.dart';
import 'package:openbeta/pages/route_details_page.dart';
import 'package:openbeta/pages/nearby_areas_page/nearby_areas_page.dart';
import 'package:graphql/client.dart';

import 'widgets/search_bar.dart';
import 'widgets/nearby_areas_button.dart';
import 'widgets/nearby_areas.dart';
import 'widgets/app_bar/app_bar.dart';
import 'package:openbeta/services/download_service.dart';

class HomePage extends StatefulWidget {
  final DownloadService downloadService; // Add this line

  HomePage({required this.downloadService}); // Add this line

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
  late TextEditingController _apiController;
  late TextEditingController _localController;
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
    _initializeControllers();
  }

  void _initializeControllers() {
    _apiController = TextEditingController();
    _localController = TextEditingController();
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
            builder: (context) => NearbyAreasPage(
              areas: areas,
              downloadService: widget.downloadService, // Pass the DownloadService instance
            ),
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
    return SizedBox.shrink(); // Return an empty widget when there's no data yet
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWidget(),
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
            gradient: LinearGradient(
              colors: [Color(0xFF00BFA5), Color(0xFF00ACC1)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            textColor: Colors.white,
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
