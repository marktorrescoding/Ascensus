import 'package:flutter/material.dart';
import 'package:openbeta/pages/profile_page.dart'; // Import the UserProfilePage

class UserProfile extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.topRight,
      padding: EdgeInsets.all(8.0),
      child: IconButton(
        icon: Image.asset('assets/icons/climbing_helmet.png'), // Use the custom icon image
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => UserProfilePage(), // Navigate to the UserProfilePage
            ),
          );
        },
      ),
    );
  }
}
