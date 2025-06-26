import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'utils/initial_loader_page.dart';
import 'user/age_input_page.dart';
import 'home/story_page.dart';
import 'user/settings_page.dart';
import 'l10n/app_localizations.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  print('[MAIN] Widgets initialized');

  bool isDark = false;
  String langCode = 'bn';

  if (!kIsWeb) {
    print('[MAIN] Loading SharedPreferences...');
    final prefs = await SharedPreferences.getInstance();
    isDark = prefs.getBool('dark_mode') ?? false;
    langCode = prefs.getString('language') ?? 'bn';
    print('[MAIN] Loaded prefs: dark=$isDark, lang=$langCode');
  }

  print('[MAIN] Initializing Firebase...');
  if (kIsWeb) {
    await Firebase.initializeApp(
      options: FirebaseOptions(
        apiKey: "AIzaSyDhTjTdTHa5xyZPpM_khIHxxTBTbBK6RNQ",
        authDomain: "golpo-4e336.firebaseapp.com",
        projectId: "golpo-4e336",
        storageBucket: "golpo-4e336.appspot.com",
        messagingSenderId: "937469130987",
        appId: "1:937469130987:web:a7a81fb2f6c341951d26ae",
        measurementId: "G-S370BRK2G1",
      ),
    );
  } else {
    await Firebase.initializeApp();
  }
  print('[MAIN] Firebase initialized');

  runApp(MyApp(isDarkMode: isDark, initialLangCode: langCode));
}


class MyApp extends StatefulWidget {
  final bool isDarkMode;
  final String initialLangCode;

  const MyApp({
    super.key,
    required this.isDarkMode,
    required this.initialLangCode,
  });

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late bool isDarkMode;
  late Locale _locale;

  @override
  void initState() {
    super.initState();

    // Handle language code like 'en' or 'en_US'
    final parts = widget.initialLangCode.split('_');
    _locale = parts.length == 1
        ? Locale(parts[0])
        : Locale(parts[0], parts[1]);

    isDarkMode = widget.isDarkMode;
  }

  void _updateTheme(bool isDark) {
    setState(() {
      isDarkMode = isDark;
    });
  }

  void _updateLocale(String langCode) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('language', langCode);

    final parts = langCode.split('_');
    setState(() {
      _locale = parts.length == 1
          ? Locale(parts[0])
          : Locale(parts[0], parts[1]);
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
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
      locale: _locale,
      supportedLocales: const [
        Locale('en'),
        Locale('bn'),
      ],
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      home: InitialLoaderPage(
        onThemeChange: _updateTheme,
        onLocaleChange: _updateLocale,
      ),
      routes: {
        '/age': (context) => AgeInputPage(),
        '/story': (context) => StoryPage(
          onThemeChange: _updateTheme,
          onLocaleChange: _updateLocale,
        ),
        '/settings': (context) => SettingsPage(
          onThemeChange: _updateTheme,
          onLocaleChange: _updateLocale,
        ),
      },
    );
  }
}
