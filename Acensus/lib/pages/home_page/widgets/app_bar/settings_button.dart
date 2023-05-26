import 'package:flutter/material.dart';
import 'package:openbeta/pages/settings_page.dart'; // Import the SettingsPage

class SettingsButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Image.asset('assets/icons/gear.png'), // Use the custom icon
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => SettingsPage(), // Navigate to the SettingsPage
          ),
        );
      },
    );
  }
}
