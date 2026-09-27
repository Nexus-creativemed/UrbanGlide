import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/driver_auth_provider.dart';
import 'home_screen.dart';
import 'login_screen.dart';

class DriverSplashScreen extends StatefulWidget {
  const DriverSplashScreen({super.key});

  @override
  State<DriverSplashScreen> createState() => _DriverSplashScreenState();
}

class _DriverSplashScreenState extends State<DriverSplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigateToNextScreen();
  }

  Future<void> _navigateToNextScreen() async {
    await Future.delayed(const Duration(seconds: 2));

    if (!mounted) return;

    final authProvider = Provider.of<DriverAuthProvider>(context, listen: false);

    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) => authProvider.isAuthenticated ? const DriverHomeScreen() : const DriverLoginScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              const Color(0xFF0A1628),
              const Color(0xFF1A2742),
            ],
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Logo placeholder - you can add your actual logo here
              Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  color: const Color(0xFF00D9FF).withOpacity(0.2),
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF00D9FF).withOpacity(0.5),
                      blurRadius: 30,
                      spreadRadius: 10,
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.local_taxi,
                  size: 60,
                  color: Color(0xFF00D9FF),
                ),
              ),
              const SizedBox(height: 30),
              const Text(
                'URBAN GLIDE',
                style: TextStyle(
                  fontSize: 36,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF00D9FF),
                  letterSpacing: 4,
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                'DRIVER',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w300,
                  color: Colors.white70,
                  letterSpacing: 3,
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                'DRIVEN BY THE NEW GENERATION',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.white54,
                  letterSpacing: 2,
                ),
              ),
              const SizedBox(height: 50),
              const CircularProgressIndicator(
                color: Color(0xFF00D9FF),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
