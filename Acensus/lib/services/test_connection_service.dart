import 'package:graphql/client.dart';

class TestConnectionService {
  final HttpLink _httpLink;

  TestConnectionService(this._httpLink);

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
}
