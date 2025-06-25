import 'package:flutter/material.dart';
import 'package:golpo/utils/background_audio.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'user/age_input_page.dart';
import 'home/story_page.dart';
import 'user/settings_page.dart';
//import 'package:flutter_localizations/flutter_localizations.dart';
//import 'generated/l10n.dart'; // After running flutter gen-l10n


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();
  final isDark = prefs.getBool('dark_mode') ?? false;

  runApp(MyApp(isDarkMode: isDark));
}

class MyApp extends StatefulWidget {
  final bool isDarkMode;

  const MyApp({super.key, required this.isDarkMode});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late bool isDarkMode;

  @override
  void initState() {
    super.initState();
    isDarkMode = widget.isDarkMode;
  }

  void _updateTheme(bool isDark) {
    setState(() {
      isDarkMode = isDark;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Interactive Story App',
      theme: ThemeData(
        fontFamily: 'asap',
        brightness: Brightness.light,
        scaffoldBackgroundColor: Colors.grey,
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.pinkAccent,
          foregroundColor: Colors.white,
        ),
      ),
      darkTheme: ThemeData(
        fontFamily: 'asap',
        brightness: Brightness.dark,
        scaffoldBackgroundColor: Colors.black,
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.deepPurpleAccent,
          foregroundColor: Colors.black,
        ),
      ),
      themeMode: isDarkMode ? ThemeMode.dark : ThemeMode.light,
      home: InitialLoaderPage(onThemeChange: _updateTheme),
      routes: {
        '/age': (context) => AgeInputPage(),
        '/story': (context) => StoryPage(onThemeChange: _updateTheme),
        '/settings': (context) => SettingsPage(onThemeChange: _updateTheme),
      },
    );
  }
}

class InitialLoaderPage extends StatefulWidget {
  final Function(bool) onThemeChange;

  const InitialLoaderPage({super.key, required this.onThemeChange});

  @override
  _InitialLoaderPageState createState() => _InitialLoaderPageState();
}

class _InitialLoaderPageState extends State<InitialLoaderPage> {
  Future<void> _startApp() async {
    print('Tap to continue');

    try {
      await BackgroundAudio.initAndPlayIfEnabled();
    } catch (e) {
      print('Audio error: $e');
    }

    final prefs = await SharedPreferences.getInstance();
    final hasAgeGroup = prefs.containsKey('age_group');

    if (hasAgeGroup) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => StoryPage(onThemeChange: widget.onThemeChange),
        ),
      );
    } else {
      Navigator.pushReplacementNamed(context, '/age');
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _startApp,
      behavior: HitTestBehavior.opaque, // makes full area tappable
      child: Scaffold(
        body: Container(
          width: double.infinity,
          height: double.infinity,
          alignment: Alignment.center,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.touch_app, size: 80, color: Colors.pinkAccent),
              const SizedBox(height: 20),
              Text(
                "Tap anywhere to continue",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w600,
                  color: Theme.of(context).textTheme.bodyLarge?.color,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
