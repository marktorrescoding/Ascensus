import 'package:flutter/material.dart';
import 'package:openbeta/models/climbing_route.dart';
import 'package:openbeta/services/climb_service.dart';
import 'package:openbeta/services/area_service.dart';
import 'package:openbeta/services/test_connection_service.dart';
import 'package:openbeta/services/local_database_service.dart';
import 'package:openbeta/services/get_user_location_service.dart';
import 'package:openbeta/pages/nearby_areas_page/nearby_areas_page.dart';
import 'package:graphql/client.dart';

import 'widgets/search_bar.dart';
import 'widgets/nearby_areas_button.dart';
import 'widgets/nearby_areas.dart';
import 'widgets/app_bar/app_bar.dart';
import 'widgets/climbing_routes_list_view.dart';

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
  late TextEditingController _apiController;
  late TextEditingController _localController;
  Future<List<ClimbingRoute>>? _apiSearchResult;
  Future<List<ClimbingRoute>>? _localSearchResult;
  List<String>? _nearbyAreas;

  @override
  void initState() {
    super.initState();
    // Initialize HTTP link and services
    httpLink = HttpLink('https://api.openbeta.io/graphql');
    climbService = ClimbService(httpLink);
    areaService = AreaService(httpLink);
    testConnectionService = TestConnectionService(httpLink);
    _initializeControllers();
  }

  void _initializeControllers() {
    // Initialize text controllers for search input
    _apiController = TextEditingController();
    _localController = TextEditingController();
  }

  void _searchApi() {
    setState(() {
      // Perform API search and update the search result
      _apiSearchResult = climbService.getClimbsForArea(_apiController.text);
    });
    _apiController.clear();
  }

  void _searchLocal() {
    setState(() {
      // Perform local database search and update the search result
      _localSearchResult = localDatabase.searchRoutes(_localController.text);
    });
    _localController.clear();
  }

  void _getNearbyAreas() async {
    final location = await locationService.getCurrentLocation();
    if (location != null) {
      // Get user location and retrieve nearby areas
      print('User Location: Latitude=${location.latitude}, Longitude=${location.longitude}');
      final areas = await areaService.getNearbyAreas(location.latitude, location.longitude);
      if (areas != null && areas.isNotEmpty) {
        // If nearby areas are found, navigate to the NearbyAreasPage
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
      appBar: AppBarWidget(), // Custom AppBar
      body: Column(
        children: [
          CustomSearchBar(
            labelText: 'Search API', // Custom search bar for API search
            controller: _apiController,
            onPressed: _searchApi,
          ),
          CustomSearchBar(
            labelText: 'Search Local', // Custom search bar for local search
            controller: _localController,
            onPressed: _searchLocal,
          ),
          Button(
            text: 'Areas Near Me', // Button to retrieve and display nearby areas
            onPressed: _getNearbyAreas,
          ),
          if (_nearbyAreas != null) NearbyAreas(areas: _nearbyAreas!), // Display nearby areas if available
          Expanded(
            child: FutureBuilder<List<ClimbingRoute>>(
              future: _apiSearchResult,
              builder: (context, snapshot) {
                return ClimbingRoutesListView(snapshot: snapshot); // Custom ListView for climbing routes
              },
            ),
          ),
          Expanded(
            child: FutureBuilder<List<ClimbingRoute>>(
              future: _localSearchResult,
              builder: (context, snapshot) {
                return ClimbingRoutesListView(snapshot: snapshot); // Custom ListView for climbing routes
              },
            ),
          ),
        ],
      ),
    );
  }
}
