import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AgeInputPage extends StatelessWidget {
  Future<void> _setAgeGroup(BuildContext context, String group) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('age_group', group);

    Navigator.pushReplacementNamed(context, '/story');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min, // Center content vertically
            children: [
              Text(
                '📖 Welcome to the Story App',
                style: Theme.of(context).textTheme.headlineSmall,
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 20),
              Text(
                'Please select your age group:',
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 24),

              ElevatedButton(
                onPressed: () => _setAgeGroup(context, 'under_18'),
                child: Text('Under 18'),
              ),
              SizedBox(height: 12),

              ElevatedButton(
                onPressed: () => _setAgeGroup(context, '18_30'),
                child: Text('18 - 30'),
              ),
              SizedBox(height: 12),

              ElevatedButton(
                onPressed: () => _setAgeGroup(context, 'over_30'),
                child: Text('Over 30'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
