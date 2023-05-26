import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;
import 'dart:io';

class DownloadService {
  Future<bool> downloadData(String areaName) async {
    final url = 'https://example.com/api/download?area=$areaName'; // Replace with your download URL

    // Create a directory to save the downloaded data
    final directory = await getApplicationDocumentsDirectory();
    final filePath = '${directory.path}/$areaName.json';

    try {
      // Download the data file
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        // Save the downloaded file to the local storage
        final file = File(filePath);
        await file.writeAsBytes(response.bodyBytes);

        return true; // Download successful
      } else {
        throw Exception('Failed to download data: ${response.statusCode}');
      }
    } catch (e) {
      return false; // Download failed
    }
  }
}
