import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../services/storage_service.dart';
import '../utils/app_colors.dart';
import '../utils/constants.dart';
import 'onboarding_screen.dart';
import 'auth/login_screen.dart';
import 'main/main_navigation.dart';

/// First screen shown when the app launches. Demonstrates an
/// `initState` + `Future.delayed` pattern combined with provider state
/// to decide where to route the user next (onboarding vs. login vs.
/// straight into the app for returning, logged-in users).
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  static const _onboardingSeenKey = 'skillbridge_onboarding_seen';

  @override
  void initState() {
    super.initState();
    _bootstrap();
  }

  Future<void> _bootstrap() async {
    final authProvider = context.read<AuthProvider>();
    await Future.wait([
      authProvider.restoreSession(),
      Future.delayed(const Duration(milliseconds: 1100)),
    ]);

    if (!mounted) return;

    final seenOnboarding = StorageService.readBool(_onboardingSeenKey);

    Widget next;
    if (!seenOnboarding) {
      next = const OnboardingScreen();
    } else if (authProvider.isAuthenticated) {
      next = const MainNavigation();
    } else {
      next = const LoginScreen();
    }

    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => next),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primary,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 96,
              height: 96,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(26),
              ),
              child: const Icon(Icons.handshake_rounded, size: 50, color: AppColors.primary),
            ),
            const SizedBox(height: 22),
            const Text(
              AppConstants.appName,
              style: TextStyle(
                color: Colors.white,
                fontSize: 28,
                fontWeight: FontWeight.w800,
                letterSpacing: 0.4,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              AppConstants.tagline,
              style: TextStyle(color: Colors.white.withOpacity(0.85), fontSize: 13.5),
            ),
            const SizedBox(height: 40),
            const SizedBox(
              width: 26,
              height: 26,
              child: CircularProgressIndicator(strokeWidth: 2.6, color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}
