import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vexis_browser/core/theme.dart';
import 'package:vexis_browser/ui/splash_screen.dart';
import 'package:vexis_browser/browser/tab_manager.dart';
import 'package:vexis_browser/browser/turbo_mode.dart';
import 'package:vexis_browser/browser/super_turbo_mode.dart';
import 'package:vexis_browser/services/connectivity_service.dart';

class VexisBrowserApp extends StatelessWidget {
  const VexisBrowserApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => TabManager()),
        ChangeNotifierProvider(create: (_) => TurboModeProvider()),
        ChangeNotifierProvider(create: (_) => SuperTurboModeProvider()),
        Provider(create: (_) => ConnectivityService()),
      ],
      child: MaterialApp(
        title: 'VEXIS Browser',
        debugShowCheckedModeBanner: false,
        theme: VexisTheme.lightTheme,
        darkTheme: VexisTheme.darkTheme,
        themeMode: ThemeMode.dark, // Default to dark mode
        home: const SplashScreen(),
      ),
    );
  }
}
