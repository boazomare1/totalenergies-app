import 'package:flutter/material.dart';
import 'screens/splash_screen.dart';
import 'screens/home_screen.dart';

void main() {
  print('TotalEnergies App: Starting...');
  runApp(const TotalEnergiesApp());
}

class TotalEnergiesApp extends StatelessWidget {
  const TotalEnergiesApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TotalEnergies',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.red,
        primaryColor: const Color(0xFFE60012), // TotalEnergies Red
        colorScheme: const ColorScheme.light(
          primary: Color(0xFFE60012),
          secondary: Color(0xFF06D6A0), // Green
          surface: Colors.white,
          background: Colors.white,
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFFE60012),
          foregroundColor: Colors.white,
          elevation: 0,
        ),
        useMaterial3: true,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const SplashScreen(),
        '/home': (context) => const HomeScreen(),
      },
    );
  }
}
