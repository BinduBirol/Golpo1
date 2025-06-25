import 'package:flutter/material.dart';
import 'package:golpo/utils/background_audio.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'user/age_input_page.dart';
import 'home/story_page.dart';
import 'user/settings_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();
  final isDark = prefs.getBool('dark_mode') ?? false;

  runApp(MyApp(isDarkMode: isDark));
}

class MyApp extends StatefulWidget {
  final bool isDarkMode;

  MyApp({required this.isDarkMode});

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
        fontFamily: 'amita',
        brightness: Brightness.light,
        scaffoldBackgroundColor: Colors.black38,
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.pinkAccent,
          foregroundColor: Colors.white,
        ),
      ),
      darkTheme: ThemeData(
        fontFamily: 'amita',
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

  InitialLoaderPage({required this.onThemeChange});

  @override
  _InitialLoaderPageState createState() => _InitialLoaderPageState();
}

class _InitialLoaderPageState extends State<InitialLoaderPage> {
  Future<void> _startApp() async {
    await BackgroundAudio.initAndPlayIfEnabled();

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
    return Scaffold(
      body: Center(
        child: ElevatedButton.icon(
          icon: const Icon(Icons.play_arrow),
          label: const Text("Enter App"),
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            textStyle: const TextStyle(fontSize: 18),
          ),
          onPressed: _startApp,
        ),
      ),
    );
  }
}
