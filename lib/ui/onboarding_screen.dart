import 'package:flutter/material.dart';
import 'package:vexis_browser/core/constants.dart';
import 'package:vexis_browser/ui/components/shield_v_logo.dart';
import 'package:vexis_browser/auth/login_screen.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({Key? key}) : super(key: key);

  @override
  _OnboardingScreenState createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  
  final List<OnboardingPage> _pages = [
    OnboardingPage(
      title: 'Welcome to VEXIS Browser',
      description: 'Your Ultimate Browser Experience',
      icon: FeatherIcons.globe,
      illustration: (context) => const ShieldVLogo(
        size: 160,
        glowColor: VexisColors.primaryBlue,
        animate: true,
      ),
    ),
    OnboardingPage(
      title: 'Blazing Fast with Turbo Mode',
      description: 'Experience lightning-fast browsing even on slow networks with our advanced compression technology.',
      icon: FeatherIcons.rocket,
      illustration: (context) => Image.asset(
        'assets/animations/rocket.gif',
        height: 180,
        errorBuilder: (context, error, stackTrace) => const Icon(
          FeatherIcons.rocket,
          size: 80,
          color: VexisColors.primaryBlue,
        ),
      ),
    ),
    OnboardingPage(
      title: 'Enhanced Privacy & Security',
      description: 'Your data is protected with our advanced privacy features. Block trackers, ads, and unwanted scripts.',
      icon: FeatherIcons.shield,
      illustration: (context) => const Icon(
        FeatherIcons.shield,
        size: 120,
        color: VexisColors.primaryBlue,
      ),
    ),
    OnboardingPage(
      title: 'Smart Extensions & News',
      description: 'Power your browser with extensions and stay updated with the latest news.',
      icon: FeatherIcons.layers,
      illustration: (context) => const Icon(
        FeatherIcons.layers,
        size: 120,
        color: VexisColors.primaryBlue,
      ),
    ),
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _nextPage() {
    if (_currentPage < _pages.length - 1) {
      _pageController.nextPage(
        duration: VexisConstants.mediumAnimationDuration,
        curve: Curves.easeInOut,
      );
    } else {
      _navigateToLogin();
    }
  }

  void _navigateToLogin() {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) => const LoginScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: VexisColors.backgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            // Skip button
            Align(
              alignment: Alignment.topRight,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: TextButton(
                  onPressed: _navigateToLogin,
                  child: const Text(
                    'Skip',
                    style: TextStyle(
                      color: VexisColors.textColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
            
            // Page content
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                onPageChanged: (index) {
                  setState(() {
                    _currentPage = index;
                  });
                },
                itemCount: _pages.length,
                itemBuilder: (context, index) {
                  return _buildPage(_pages[index]);
                },
              ),
            ),
            
            // Bottom navigation
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Page indicator
                  Row(
                    children: List.generate(
                      _pages.length,
                      (index) => _buildPageIndicator(index),
                    ),
                  ),
                  
                  // Next button
                  ElevatedButton(
                    onPressed: _nextPage,
                    style: ElevatedButton.styleFrom(
                      shape: const CircleBorder(),
                      padding: const EdgeInsets.all(16),
                      backgroundColor: VexisColors.primaryBlue,
                    ),
                    child: Icon(
                      _currentPage < _pages.length - 1
                          ? FeatherIcons.arrowRight
                          : FeatherIcons.check,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPage(OnboardingPage page) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Illustration
          page.illustration(context),
          const SizedBox(height: 48),
          
          // Title
          Text(
            page.title,
            style: const TextStyle(
              color: VexisColors.textColor,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          
          // Description
          Text(
            page.description,
            style: TextStyle(
              color: VexisColors.textColor.withOpacity(0.7),
              fontSize: 16,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildPageIndicator(int index) {
    bool isCurrentPage = index == _currentPage;
    
    return AnimatedContainer(
      duration: VexisConstants.shortAnimationDuration,
      margin: const EdgeInsets.symmetric(horizontal: 4),
      height: 8,
      width: isCurrentPage ? 24 : 8,
      decoration: BoxDecoration(
        color: isCurrentPage ? VexisColors.primaryBlue : VexisColors.textColor.withOpacity(0.3),
        borderRadius: BorderRadius.circular(4),
      ),
    );
  }
}

class OnboardingPage {
  final String title;
  final String description;
  final IconData icon;
  final Widget Function(BuildContext) illustration;

  OnboardingPage({
    required this.title,
    required this.description,
    required this.icon,
    required this.illustration,
  });
}
