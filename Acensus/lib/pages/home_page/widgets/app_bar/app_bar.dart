import 'package:flutter/material.dart';
import 'package:openbeta/pages/home_page/widgets/app_bar/user_profile.dart';
import 'package:openbeta/pages/home_page/widgets/app_bar/settings_button.dart';

class AppBarWidget extends StatelessWidget implements PreferredSizeWidget {
  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      flexibleSpace: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF00BFA5), Color(0xFF00ACC1)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
      ),
      centerTitle: true, // Center the title horizontally
      title: Text(
        'ASCENSUS',
        style: TextStyle(
          fontFamily: 'Roboto',
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: Colors.black, // Set the font color to black
        ),
      ),
      actions: [
        UserProfile(),
        SettingsButton(),
      ],
    );
  }
}
