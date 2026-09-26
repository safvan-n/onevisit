import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../core/theme.dart';
import '../core/constants.dart';
import '../services/app_state.dart';
import 'auth/login_screen.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<Map<String, dynamic>> _pages = [
    {
      'title': 'Government Services\nMade Simple',
      'subtitle': 'Fill forms seamlessly with step-by-step guidance, auto-save drafts, and instant OCR document verification from the comfort of your home.',
      'icon': Icons.assignment_turned_in_rounded,
      'gradient': const [AppColors.royalBlue, AppColors.teal],
      'highlight': 'Guided Form Assistance & OCR',
    },
    {
      'title': 'Skip the Long Queue\nForever',
      'subtitle': 'Book your digital appointment token in advance, monitor live counter movement in real time, and see exactly how many people are ahead.',
      'icon': Icons.confirmation_number_rounded,
      'gradient': const [AppColors.teal, AppColors.emeraldGreen],
      'highlight': 'Smart Token Booking & Tracking',
    },
    {
      'title': 'Visit Only When\nNeeded',
      'subtitle': 'Receive automated notifications when your token is approaching. Walk into the government office just in time for your turn without waiting hours.',
      'icon': Icons.notifications_active_rounded,
      'gradient': const [AppColors.deepNavy, AppColors.royalBlue],
      'highlight': 'Turn Alerts & QR Verification',
    },
  ];

  void _finishOnboarding() {
    final appState = Provider.of<AppState>(context, listen: false);
    appState.completeOnboarding();
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => const LoginScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: Padding(
          padding: const EdgeInsets.only(left: 16.0),
          child: Image.asset(AppConstants.logoAsset, height: 32),
        ),
        leadingWidth: 48,
        title: Row(
          children: [
            Text('One', style: TextStyle(fontWeight: FontWeight.w800, color: AppColors.deepNavy, fontSize: 18)),
            Text('Visit', style: TextStyle(fontWeight: FontWeight.w800, color: AppColors.teal, fontSize: 18)),
          ],
        ),
        actions: [
          if (_currentPage < _pages.length - 1)
            TextButton(
              onPressed: _finishOnboarding,
              child: const Text(
                'Skip',
                style: TextStyle(
                  color: AppColors.textSecondary,
                  fontWeight: FontWeight.w600,
                  fontSize: 15,
                ),
              ),
            ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                itemCount: _pages.length,
                onPageChanged: (idx) {
                  setState(() => _currentPage = idx);
                },
                itemBuilder: (context, index) {
                  final page = _pages[index];
                  final List<Color> colors = page['gradient'];
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 28.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Decorative Hero Graphic
                        Stack(
                          alignment: Alignment.center,
                          children: [
                            Container(
                              width: 220,
                              height: 220,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                gradient: RadialGradient(
                                  colors: [
                                    colors.first.withOpacity(0.18),
                                    colors.last.withOpacity(0.04),
                                    Colors.transparent,
                                  ],
                                  stops: const [0.3, 0.7, 1.0],
                                ),
                              ),
                            ),
                            Container(
                              width: 130,
                              height: 130,
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: colors,
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color: colors.first.withOpacity(0.35),
                                    blurRadius: 25,
                                    offset: const Offset(0, 10),
                                  ),
                                ],
                              ),
                              child: Icon(
                                page['icon'],
                                size: 64,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 36),

                        // Highlight Badge
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                          decoration: BoxDecoration(
                            color: colors.first.withOpacity(0.08),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(color: colors.first.withOpacity(0.25)),
                          ),
                          child: Text(
                            page['highlight'],
                            style: TextStyle(
                              color: colors.first,
                              fontSize: 12.5,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),

                        // Title
                        Text(
                          page['title'],
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 26,
                            fontWeight: FontWeight.w800,
                            color: AppColors.deepNavy,
                            height: 1.25,
                            letterSpacing: -0.5,
                          ),
                        ),
                        const SizedBox(height: 16),

                        // Subtitle
                        Text(
                          page['subtitle'],
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 14.5,
                            color: AppColors.textSecondary,
                            height: 1.5,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),

            // Indicator Dots & Controls
            Padding(
              padding: const EdgeInsets.all(28.0),
              child: Column(
                children: [
                  // Smooth Dots
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(_pages.length, (index) {
                      final isActive = index == _currentPage;
                      return AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        height: 8,
                        width: isActive ? 28 : 8,
                        decoration: BoxDecoration(
                          color: isActive ? AppColors.royalBlue : AppColors.border,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      );
                    }),
                  ),
                  const SizedBox(height: 30),

                  // Button Actions
                  SizedBox(
                    width: double.infinity,
                    height: 54,
                    child: ElevatedButton(
                      onPressed: () {
                        if (_currentPage < _pages.length - 1) {
                          _pageController.nextPage(
                            duration: const Duration(milliseconds: 350),
                            curve: Curves.easeInOut,
                          );
                        } else {
                          _finishOnboarding();
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.royalBlue,
                        elevation: 3,
                        shadowColor: AppColors.royalBlue.withOpacity(0.4),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      child: Text(
                        _currentPage == _pages.length - 1 ? 'Get Started' : 'Next',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.3,
                        ),
                      ),
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
}
