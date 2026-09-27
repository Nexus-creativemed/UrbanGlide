import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'providers/driver_auth_provider.dart';
import 'providers/driver_location_provider.dart';
import 'providers/driver_ride_provider.dart';
import 'screens/splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const UrbanGlideDriverApp());
}

class UrbanGlideDriverApp extends StatelessWidget {
  const UrbanGlideDriverApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => DriverAuthProvider()),
        ChangeNotifierProvider(create: (_) => DriverRideProvider()),
        ChangeNotifierProvider(create: (_) => DriverLocationProvider()),
      ],
      child: MaterialApp(
        title: 'Urban Glide Driver',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          useMaterial3: true,
          brightness: Brightness.dark,
          colorScheme: ColorScheme.dark(
            primary: const Color(0xFF00D9FF), // Neon cyan
            secondary: const Color(0xFF0080FF), // Blue
            surface: const Color(0xFF1A2742), // Dark navy background
            onPrimary: Colors.black,
            onSecondary: Colors.white,
            onSurface: Colors.white,
          ),
          scaffoldBackgroundColor: const Color(0xFF0A1628),
          appBarTheme: const AppBarTheme(
            backgroundColor: Color(0xFF0A1628),
            elevation: 0,
            centerTitle: true,
            titleTextStyle: TextStyle(
              color: Color(0xFF00D9FF),
              fontSize: 24,
              fontWeight: FontWeight.bold,
              letterSpacing: 2,
            ),
          ),
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF00D9FF),
              foregroundColor: Colors.black,
              elevation: 8,
              shadowColor: const Color(0xFF00D9FF).withOpacity(0.5),
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              textStyle: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.2,
              ),
            ),
          ),
          cardTheme: CardThemeData(
            color: const Color(0xFF1A2742),
            elevation: 8,
            shadowColor: const Color(0xFF00D9FF).withOpacity(0.3),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
          ),
          inputDecorationTheme: InputDecorationTheme(
            filled: true,
            fillColor: const Color(0xFF1A2742),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFF00D9FF)),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: const Color(0xFF00D9FF).withOpacity(0.5)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFF00D9FF), width: 2),
            ),
            labelStyle: const TextStyle(color: Color(0xFF00D9FF)),
            hintStyle: TextStyle(color: Colors.white.withOpacity(0.5)),
          ),
        ),
        home: const DriverSplashScreen(),
      ),
    );
  }
}
