import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:golpo/widgets/my_app_bar.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../l10n/app_localizations.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String? ageGroup;

  @override
  void initState() {
    super.initState();
    _loadAgeGroup();
  }

  Future<void> _loadAgeGroup() async {
    final prefs = await SharedPreferences.getInstance();
    final group = prefs.getString('age_group');

    setState(() {
      ageGroup = group ?? AppLocalizations.of(context)!.unknown;
    });
  }

  Future<void> signInWithGoogle() async {
    // TODO: Replace with your actual sign-in logic
    print("Signing in with Google...");
  }

  @override
  Widget build(BuildContext context) {
    String getReadableGroup(String? group) {
      switch (group) {
        case 'under_18':
          return AppLocalizations.of(context)!.under18;
        case '18_30':
          return AppLocalizations.of(context)!.ageGroup18to30;
        case 'over_30':
          return AppLocalizations.of(context)!.over30;
        default:
          return AppLocalizations.of(context)!.unknown;
      }
    }

    return Scaffold(
      appBar: MyAppBar(title: AppLocalizations.of(context)!.profile),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Card(
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.person, size: 80, color: Colors.deepPurple),
                  SizedBox(height: 16),
                  Text(
                    'Welcome to your profile!',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  SizedBox(height: 32),
                  Text('Your Age Group:', style: TextStyle(fontSize: 18)),
                  SizedBox(height: 8),
                  Text(
                    getReadableGroup(ageGroup),
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 32),
                  ElevatedButton.icon(
                    icon: FaIcon(FontAwesomeIcons.google, color: Colors.red),
                    label: Text('Sign in with Google'),
                    onPressed: signInWithGoogle,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.black,
                      padding: EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                      textStyle: TextStyle(fontSize: 16),
                      elevation: 3,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
