import 'package:flutter/material.dart';
import 'package:openbeta/services/download_service.dart';

class NearbyAreasPage extends StatelessWidget {
  final List<String> areas;
  final DownloadService downloadService;

  NearbyAreasPage({required this.areas, required this.downloadService});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Nearby Areas'),
      ),
      body: ListView.builder(
        itemCount: areas.length,
        itemBuilder: (context, index) {
          final areaName = areas[index].split(' (')[0]; // Extract area name
          return ListTile(
            title: Row(
              children: [
                Expanded(
                  child: Text(areaName),
                ),
                DownloadButton(
                  areaName: areaName,
                  downloadService: downloadService,
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class DownloadButton extends StatefulWidget {
  final String areaName;
  final DownloadService downloadService;

  DownloadButton({required this.areaName, required this.downloadService});

  @override
  _DownloadButtonState createState() => _DownloadButtonState();
}

class _DownloadButtonState extends State<DownloadButton> {
  bool downloading = false;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.download),
      onPressed: () async {
        setState(() {
          downloading = true;
        });

        final success = await widget.downloadService.downloadData(widget.areaName);

        setState(() {
          downloading = false;
        });

        if (success) {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text('Download Complete'),
                content: Text('The data for ${widget.areaName} has been downloaded.'),
                actions: <Widget>[
                  TextButton(
                    child: Text('OK'),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              );
            },
          );
        } else {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text('Download Error'),
                content: Text('Failed to download data for ${widget.areaName}.'),
                actions: <Widget>[
                  TextButton(
                    child: Text('OK'),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              );
            },
          );
        }
      },
    );
  }
}
