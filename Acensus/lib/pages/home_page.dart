import 'package:flutter/material.dart';
import 'package:openbeta/models/climbing_route.dart';
import 'package:openbeta/services/api_service.dart';
import 'package:openbeta/pages/route_details_page.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final ApiService apiService = ApiService();
  final TextEditingController _controller = TextEditingController();
  Future<List<ClimbingRoute>>? _searchResult;

  void _search() {
    setState(() {
      _searchResult = apiService.getClimbsForArea(_controller.text);
    });
    _controller.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('ASCENSUS'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _controller,
              onSubmitted: (_) => _search(),
              decoration: InputDecoration(
                labelText: 'Search area',
                suffixIcon: IconButton(
                  icon: Icon(Icons.search),
                  onPressed: _search,
                ),
              ),
            ),
          ),
          Expanded(
            child: FutureBuilder<List<ClimbingRoute>>(
              future: _searchResult,
              builder: (context, snapshot) {
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
              },
            ),
          ),
        ],
      ),
    );
  }
}
