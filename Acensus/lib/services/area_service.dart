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
            maxDistance: 10000
          ) {
            crags {
              id
              uuid
              areaName
              totalClimbs
              aggregate {
                byDiscipline {
                  sport {
                    total
                  }
                  tr {
                    total
                  }
                  trad {
                    total
                  }
                  boulder {
                    total
                  }
                  bouldering {
                    total
                  }
                  mixed {
                    total
                  }
                }
              }
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
      print('GraphQL Error: ${result.exception.toString()}');
      throw Exception('Failed to load nearby areas');
    }

    final List<dynamic>? cragsNear = result.data?['cragsNear'] as List<dynamic>?;
    if (cragsNear != null && cragsNear.isNotEmpty) {
      final List<dynamic> crags = cragsNear[0]['crags'] as List<dynamic>;
      List<String> areaNames = crags.map<String>((crag) {
        final String areaName = crag['areaName'] as String;
        final int totalClimbs = crag['totalClimbs'] as int;
        final String id = crag['id'] as String;
        final String uuid = crag['uuid'] as String;
        return '$areaName ($totalClimbs climbs) - ID: $id, UUID: $uuid';
      }).toList();
      return areaNames;
    }

    throw Exception('No nearby areas found');
  }
}
