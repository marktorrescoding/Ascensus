import 'package:flutter/material.dart';

class UserProfile extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.topRight,
      padding: EdgeInsets.all(8.0),
      child: IconButton(
        icon: Image.asset('assets/icons/climbing_helmet.png'), // Use the custom icon image
        onPressed: () {
          // Handle user profile button press
        },
      ),
    );
  }
}
