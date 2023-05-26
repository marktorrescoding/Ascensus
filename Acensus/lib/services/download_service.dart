import 'package:graphql/client.dart';

class DownloadService {
  final HttpLink _httpLink;

  DownloadService(this._httpLink);

  Future<void> downloadData(String areaName) async {
    final QueryOptions options = QueryOptions(
      document: gql('''
        query MyQuery(\$areaName: String!) {
          areas(filter: {area_name: {match: \$areaName}}) {
            id
            climbs {
              uuid
              name
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

    final GraphQLClient client = GraphQLClient(
      cache: GraphQLCache(),
      link: _httpLink,
    );

    final QueryResult result = await client.query(options);

    if (result.hasException) {
      print('GraphQL Error: ${result.exception.toString()}');
      throw Exception('Failed to download data');
    }

    final List<dynamic>? areas = result.data?['areas'] as List<dynamic>?;
    if (areas != null && areas.isNotEmpty) {
      final List<dynamic> climbs = areas[0]['climbs'] as List<dynamic>;

      for (final climb in climbs) {
        final String uuid = climb['uuid'] as String;
        final String name = climb['name'] as String;
        final Map<String, dynamic> content = climb['content'] as Map<String, dynamic>;

        final String description = content['description'] as String;
        final String location = content['location'] as String;
        final String protection = content['protection'] as String;

        // Add the climb data to the local database
        // TODO: Implement your local database logic here
      }
    } else {
      throw Exception('No areas found for download');
    }
  }
}
