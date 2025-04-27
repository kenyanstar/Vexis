import 'package:flutter/material.dart';

void main() {
  runApp(const VexisBrowserApp());
}

class VexisBrowserApp extends StatelessWidget {
  const VexisBrowserApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'VEXIS Browser',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: const Color(0xFF005DFF),
        scaffoldBackgroundColor: const Color(0xFF0A0A0A),
        colorScheme: const ColorScheme.dark(
          primary: Color(0xFF005DFF),
          secondary: Color(0xFF7F00FF),
        ),
      ),
      home: const VexisHomePage(),
    );
  }
}

class VexisHomePage extends StatelessWidget {
  const VexisHomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('VEXIS Browser'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.rocket_launch,
              size: 80,
              color: Theme.of(context).primaryColor,
            ),
            const SizedBox(height: 24),
            Text(
              'VEXIS Browser',
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Your Ultimate Browser Experience',
              style: TextStyle(
                color: Colors.white70,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 48),
            _buildFeatureItem(context, 'Turbo Mode for faster browsing'),
            _buildFeatureItem(context, 'Biometric authentication'),
            _buildFeatureItem(context, 'Dark theme interface'),
            _buildFeatureItem(context, 'Super Turbo Mode (hidden feature)'),
            _buildFeatureItem(context, 'Tab management'),
            const SizedBox(height: 48),
            ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
              ),
              child: const Text('Start Browsing'),
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildFeatureItem(BuildContext context, String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0, horizontal: 24.0),
      child: Row(
        children: [
          Icon(
            Icons.check_circle,
            color: Theme.of(context).primaryColor,
            size: 20,
          ),
          const SizedBox(width: 12),
          Text(
            text,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }
}
