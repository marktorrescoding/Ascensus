import 'package:graphql/client.dart';
import 'package:openbeta/models/climbing_route.dart';

class ApiService {
  final HttpLink _httpLink = HttpLink(
    'https://api.openbeta.io/graphql',
  );

  GraphQLClient get client {
    return GraphQLClient(
      cache: GraphQLCache(),
      link: _httpLink,
    );
  }

  Future<void> testConnection() async {
    final QueryOptions options = QueryOptions(
      document: gql('''
        query TestQuery {
          areas {
            area_name
          }
        }
      '''),
    );

    final QueryResult result = await client.query(options);

    if (result.hasException) {
      print(result.exception.toString());
      throw Exception('Failed to connect to API');
    }

    print('Connected to API successfully');
  }

  Future<List<ClimbingRoute>> getClimbsForArea(String areaName) async {
    final QueryOptions options = QueryOptions(
      document: gql('''
        query GetClimbsForArea(\$areaName: String!) {
          areas(filter: {area_name: {match: \$areaName, exactMatch: false}}) {
            area_name
            climbs {
              name
              yds
              content {
                description
                location
                protection
              }
            }
          }
        }
      '''),
      variables: <String, dynamic>{
        'areaName': areaName,
      },
    );

    final QueryResult result = await client.query(options);

    if (result.hasException) {
      print(result.exception.toString());
      throw Exception('Failed to load climbs');
    }

    List<ClimbingRoute> climbs = (result.data?['areas'] as List<dynamic>)
        .expand((area) =>
        (area['climbs'] as List<dynamic>)
            .map((climb) => ClimbingRoute.fromJson(climb)))
        .toList();

    return climbs;
  }

  Future<ClimbingRoute> getClimbingRouteDetails(String climbName) async {
    final QueryOptions options = QueryOptions(
      document: gql('''
        query GetClimbDetails(\$climbName: String!) {
          climb(filter: {name: {match: \$climbName, exactMatch: true}}) {
            name
            yds
            content {
              description
              location
              protection
            }
          }
        }
      '''),
      variables: <String, dynamic>{
        'climbName': climbName,
      },
    );

    final QueryResult result = await client.query(options);

    if (result.hasException) {
      print(result.exception.toString());
      throw Exception('Failed to load climb details');
    }

    final Map<String, dynamic> json =
    result.data?['climb'][0] as Map<String, dynamic>;
    return ClimbingRoute.fromJson(json);
  }

  Future<List<String>> getNearbyAreas(double lat, double lng) async {
    final QueryOptions options = QueryOptions(
      document: gql('''
      query GetNearbyAreas(\$lat: Float!, \$lng: Float!) {
        cragsNear(
          lnglat: { lat: \$lat, lng: \$lng }
          includeCrags: true
          maxDistance: 15000
        ) {
          crags {
            areaName
          }
        }
      }
    '''),
      variables: <String, dynamic>{
        'lat': lat,
        'lng': lng,
      },
    );

    final QueryResult result = await client.query(options);

    if (result.hasException) {
      print(result.exception.toString());
      throw Exception('Failed to load nearby areas');
    }

    final List<dynamic> cragsNear = result.data?['cragsNear'] as List<dynamic>;
    if (cragsNear.isNotEmpty) {
      final List<dynamic> crags = cragsNear[0]['crags'] as List<dynamic>;
      List<String> areaNames = crags
          .map<String>((crag) => crag['areaName'] as String)
          .toList();
      return areaNames;
    }

    throw Exception('No nearby areas found');
  }








}
