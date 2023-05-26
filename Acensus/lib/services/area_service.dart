import 'package:graphql/client.dart';

class AreaService {
  final HttpLink _httpLink;

  AreaService(this._httpLink);

  GraphQLClient get client {
    return GraphQLClient(
      cache: GraphQLCache(),
      link: _httpLink,
    );
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
              totalClimbs
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
          .map<String>((crag) => '${crag['areaName']} (${crag['totalClimbs']} climbs)')
          .toList();
      return areaNames;
    }

    throw Exception('No nearby areas found');
  }
}
