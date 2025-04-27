import 'dart:async';
import 'package:flutter/material.dart';
import 'package:vexis_browser/core/constants.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;
  
  @override
  void initState() {
    super.initState();
    
    // Set up animations
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.0, 0.7, curve: Curves.easeInOut),
      ),
    );
    
    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.0, 0.7, curve: Curves.easeOutBack),
      ),
    );
    
    // Start animations
    _animationController.forward();
    
    // Navigate to main screen after delay
    Timer(VexisConstants.splashScreenDuration, () {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => const DemoScreen(),
        ),
      );
    });
  }
  
  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: VexisColors.backgroundColor,
      body: AnimatedBuilder(
        animation: _animationController,
        builder: (context, child) {
          return Center(
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: Transform.scale(
                scale: _scaleAnimation.value,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Logo placeholder
                    Container(
                      width: 120,
                      height: 120,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.transparent,
                        border: Border.all(
                          color: VexisColors.primaryBlue,
                          width: 3,
                        ),
                      ),
                      child: Center(
                        child: Icon(
                          Icons.rocket_launch,
                          size: 60,
                          color: VexisColors.primaryBlue,
                        ),
                      ),
                    ),
                    const SizedBox(height: 40),
                    // App name
                    Text(
                      'VEXIS Browser',
                      style: TextStyle(
                        color: VexisColors.textColor,
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.2,
                      ),
                    ),
                    const SizedBox(height: 10),
                    // Slogan
                    Text(
                      'Experience the web at turbo speed',
                      style: TextStyle(
                        color: VexisColors.textColor.withOpacity(0.7),
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 80),
                    // Loading indicator
                    SizedBox(
                      width: 40,
                      height: 40,
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(
                          VexisColors.primaryBlue,
                        ),
                        strokeWidth: 2,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

// Demo Screen for when the splash screen finishes
class DemoScreen extends StatelessWidget {
  const DemoScreen({Key? key}) : super(key: key);

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
              Icons.rocket,
              size: 80,
              color: VexisColors.primaryBlue,
            ),
            const SizedBox(height: 24),
            Text(
              'VEXIS Browser',
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                color: VexisColors.textColor,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Your Ultimate Browser Experience',
              style: TextStyle(
                color: VexisColors.textColor.withOpacity(0.7),
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 48),
            // Features list
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
            color: VexisColors.primaryBlue,
            size: 20,
          ),
          const SizedBox(width: 12),
          Text(
            text,
            style: const TextStyle(
              color: VexisColors.textColor,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }
}