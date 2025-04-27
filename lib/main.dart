import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:vexis_browser/core/constants.dart';
import 'package:vexis_browser/browser/tab_manager.dart';
import 'package:vexis_browser/browser/turbo_mode.dart';
import 'package:vexis_browser/browser/super_turbo_mode.dart';
import 'package:vexis_browser/ui/splash_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  
  runApp(const VexisBrowserApp());
}

class VexisBrowserApp extends StatelessWidget {
  const VexisBrowserApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => TabManager()),
        ChangeNotifierProvider(create: (_) => TurboModeProvider()),
        ChangeNotifierProvider(create: (_) => SuperTurboModeProvider()),
      ],
      child: MaterialApp(
        title: 'VEXIS Browser',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primaryColor: VexisColors.primaryBlue,
          scaffoldBackgroundColor: VexisColors.backgroundColor,
          colorScheme: ColorScheme.dark(
            primary: VexisColors.primaryBlue,
            secondary: VexisColors.secondaryPurple,
          ),
        ),
        home: const SplashScreen(),
      ),
    );
  }
}
