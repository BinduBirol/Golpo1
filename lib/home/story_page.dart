import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../user/profile_page.dart';
import '../user/settings_page.dart';
import '../widgets/CustomListTile.dart';
import '../widgets/StoryAppBar.dart';
import 'category_page.dart';

class StoryPage extends StatefulWidget {
  final Function(bool) onThemeChange;

  StoryPage({required this.onThemeChange});

  @override
  _StoryPageState createState() => _StoryPageState();
}

class _StoryPageState extends State<StoryPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  Future<void> _resetAge(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('age_group');
    Navigator.pushReplacementNamed(context, '/age');
  }

  void _navigateTo(BuildContext context, Widget page) {
    Navigator.pop(context); // Close drawer
    Navigator.push(context, MaterialPageRoute(builder: (_) => page));
  }

  @override
  Widget build(BuildContext context) {
    final appBarTheme = Theme.of(context).appBarTheme;

    return Scaffold(
      key: _scaffoldKey, // Assign the scaffold key here
      appBar: StoryAppBar(title: 'Golpo', scaffoldKey: _scaffoldKey),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(color: appBarTheme.backgroundColor),
              child: Row(
                children: [
                  // Left: user image or placeholder
                  CircleAvatar(
                    radius: 30,
                    backgroundColor: Colors.white24,
                    child: Icon(Icons.person, color: Colors.white, size: 40),
                    // If you have user image, use:
                    // backgroundImage: NetworkImage(userImageUrl),
                  ),

                  SizedBox(width: 16),

                  // Right: user info (name and id)
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'User Name', // replace with your dynamic username
                          style: TextStyle(color: Colors.white, fontSize: 20),
                        ),
                        SizedBox(height: 4),
                        Text(
                          'User ID: 123456',
                          // replace with your dynamic user id
                          style: TextStyle(color: Colors.white70),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            CustomListTile(
              iconData: FontAwesomeIcons.layerGroup,
              title: 'Library',
              onTap: () => _navigateTo(context, CategoryPage()),
            ),

            CustomListTile(
              iconData: FontAwesomeIcons.user,

              title: 'Profile',
              onTap: () => _navigateTo(context, ProfilePage()),
            ),
            CustomListTile(
              iconData: FontAwesomeIcons.gear,
              title: 'Settings',

              onTap: () => _navigateTo(
                context,
                SettingsPage(onThemeChange: widget.onThemeChange),
              ),
            ),
          ],
        ),
      ),
      body: Center(
        child: Text(
          '✨ This is where your interactive story will begin!',
          style: TextStyle(fontSize: 18),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
