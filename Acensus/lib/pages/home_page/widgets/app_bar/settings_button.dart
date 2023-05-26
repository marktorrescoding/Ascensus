import 'package:flutter/material.dart';

class SettingsButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Image.asset('assets/icons/gear.png'), // Use the custom icon
      onPressed: () {
        // Handle settings button press
      },
    );
  }
}
