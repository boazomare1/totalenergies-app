import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:google_fonts/google_fonts.dart';
import 'screens/splash_screen.dart';
import 'screens/main_screen.dart';
import 'screens/auth_screen.dart';
import 'screens/login_screen.dart';
import 'screens/register_screen.dart';
import 'services/language_service.dart';
import 'services/language_notifier.dart';
import 'services/location_service.dart';
import 'services/notification_service.dart';
import 'services/hive_database_service.dart';
import 'services/cloud_storage_service.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize services
  await _initializeServices();

  runApp(const TotalEnergiesApp());
}

Future<void> _initializeServices() async {
  try {
    // Initialize cloud storage
    await CloudStorageService.initialize();

    // Initialize Hive database
    await HiveDatabaseService.initialize();

    // Initialize location service
    await LocationService.initialize();

    // Initialize notification service
    await NotificationService.initialize();

    print('All services initialized successfully');
  } catch (e) {
    print('Error initializing services: $e');
  }
}

class TotalEnergiesApp extends StatelessWidget {
  const TotalEnergiesApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => LanguageNotifier()..loadCurrentLocale(),
      child: Consumer<LanguageNotifier>(
        builder: (context, languageNotifier, child) {
          return MaterialApp(
            title: 'TotalEnergies',
            debugShowCheckedModeBanner: false,

            // Localization Configuration
            localizationsDelegates: const [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: LanguageService.supportedLocales,
            locale: languageNotifier.currentLocale,
            localeResolutionCallback:
                LanguageService.getLocaleResolutionCallback(),

            theme: ThemeData(
              primarySwatch: Colors.red,
              primaryColor: const Color(0xFFE60012), // TotalEnergies Red
              colorScheme: const ColorScheme.light(
                primary: Color(0xFFE60012),
                secondary: Color(0xFF06D6A0), // Green
                surface: Colors.white,
              ),
              appBarTheme: const AppBarTheme(
                backgroundColor: Color(0xFFE60012),
                foregroundColor: Colors.white,
                elevation: 0,
              ),
              textTheme: GoogleFonts.poppinsTextTheme(),
              useMaterial3: true,
            ),

            initialRoute: '/',
            routes: {
              '/': (context) => const SplashScreen(),
              '/auth': (context) => const AuthScreen(),
              '/login': (context) => const LoginScreen(),
              '/register': (context) => const RegisterScreen(),
              '/main': (context) => const MainScreen(),
            },
          );
        },
      ),
    );
  }
}
