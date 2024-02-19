import 'package:flutter/material.dart';
import 'package:flutter_calendar/home_page.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: [
        // Locale('en', 'US'), // English
        // Locale('es'), // Spanish
        Locale('pt', 'BR'),
      ],
      home: HomePage(),
    );
  }
}
