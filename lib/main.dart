import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'screens/splash_screen.dart';
import 'screens/main_screen.dart';
import 'screens/auth_screen.dart';
import 'screens/login_screen.dart';
import 'screens/register_screen.dart';
import 'screens/analytics_screen.dart';
import 'services/language_service.dart';
import 'services/language_notifier.dart';
import 'services/location_service.dart';
import 'services/notification_service.dart';
import 'services/hive_database_service.dart';
import 'services/secure_storage_service.dart';
import 'services/theme_service.dart';
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
    // Initialize secure storage
    await SecureStorageService.initialize();

    // Initialize Hive database
    await HiveDatabaseService.initialize();

    // Request location permission
    await LocationService.requestLocationPermission();

    // Initialize location service
    await LocationService.initialize();

    // Initialize notification service
    await NotificationService.initialize();

    // Initialize theme service
    await ThemeService.initialize();

    print('All services initialized successfully');
  } catch (e) {
    print('Error initializing services: $e');
  }
}

class TotalEnergiesApp extends StatefulWidget {
  const TotalEnergiesApp({super.key});

  @override
  State<TotalEnergiesApp> createState() => _TotalEnergiesAppState();
}

class _TotalEnergiesAppState extends State<TotalEnergiesApp> {
  @override
  void initState() {
    super.initState();
    // Listen to theme changes
    ThemeService.addThemeListener(_onThemeChanged);
  }

  @override
  void dispose() {
    ThemeService.removeThemeListener(_onThemeChanged);
    super.dispose();
  }

  void _onThemeChanged() {
    setState(() {});
  }

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

            theme: ThemeService.lightTheme,
            darkTheme: ThemeService.darkTheme,
            themeMode: ThemeService.themeMode,

            initialRoute: '/',
            routes: {
              '/': (context) => const SplashScreen(),
              '/auth': (context) => const AuthScreen(),
              '/login': (context) => const LoginScreen(),
              '/register': (context) => const RegisterScreen(),
              '/main': (context) => const MainScreen(),
              '/analytics': (context) => const AnalyticsScreen(),
            },
          );
        },
      ),
    );
  }
}
