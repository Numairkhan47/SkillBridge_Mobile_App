import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'providers/auth_provider.dart';
import 'providers/chat_provider.dart';
import 'providers/skill_provider.dart';
import 'providers/theme_provider.dart';
import 'services/skill_repository.dart';
import 'services/storage_service.dart';
import 'screens/splash_screen.dart';
import 'utils/app_theme.dart';
import 'utils/constants.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await StorageService.init();
  runApp(const SkillBridgeApp());
}

/// Root widget. Wires up dependency injection (via `provider`) for the
/// repository/service layer and exposes the four app-wide
/// [ChangeNotifier]s (auth, skills, chat, theme) to the entire widget
/// tree using [MultiProvider].
class SkillBridgeApp extends StatelessWidget {
  const SkillBridgeApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Swap LocalSkillRepository() for
    // ApiSkillRepository(baseUrl: 'https://your-api.com/api') to point
    // the whole app at a live backend with no other code changes.
    final SkillRepository skillRepository = LocalSkillRepository();

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => SkillProvider(skillRepository)),
        ChangeNotifierProvider(create: (_) => ChatProvider()),
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
      ],
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, _) {
          return MaterialApp(
            title: AppConstants.appName,
            debugShowCheckedModeBanner: false,
            theme: AppTheme.light,
            darkTheme: AppTheme.dark,
            themeMode: themeProvider.themeMode,
            home: const SplashScreen(),
          );
        },
      ),
    );
  }
}
