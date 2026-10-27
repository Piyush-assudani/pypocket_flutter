import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../services/storage_service.dart';
import 'onboarding_screen.dart';
import 'main_nav_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;
  late Animation<double> _progressAnimation;

  bool _hasNavigated = false;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    );

    _fadeAnimation = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.0, 0.4, curve: Curves.easeOut),
    );

    _scaleAnimation = Tween<double>(begin: 0.92, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.5, curve: Curves.easeOutCubic),
      ),
    );

    _progressAnimation = Tween<double>(begin: 0.05, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.1, 0.95, curve: Curves.easeInOutCubic),
      ),
    );

    _controller.forward().then((_) {
      _proceed();
    });
  }

  void _proceed() {
    if (_hasNavigated || !mounted) return;
    _hasNavigated = true;

    final hasOnboarded = StorageService.hasCompletedOnboarding();
    final targetScreen = hasOnboarded ? const MainNavScreen() : const OnboardingScreen();

    Navigator.of(context).pushReplacement(
      PageRouteBuilder(
        transitionDuration: const Duration(milliseconds: 600),
        pageBuilder: (context, animation, secondaryAnimation) => targetScreen,
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(opacity: animation, child: child);
        },
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgLight = const Color(0xFFFAF7F2); // Warm luxury ivory from SS1
    final bgDark = const Color(0xFF0D0F14);
    final bgColor = isDark ? bgDark : bgLight;

    return Scaffold(
      backgroundColor: bgColor,
      body: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: _proceed, // Tap to launch instantly
        child: Stack(
          children: [
            // Champagne wavy ambient curve background (SS1 style)
            Positioned(
              top: -60,
              right: -80,
              child: Container(
                width: 380,
                height: 380,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      const Color(0xFFC89B58).withValues(alpha: isDark ? 0.12 : 0.09),
                      Colors.transparent,
                    ],
                  ),
                ),
              ),
            ),
            Positioned(
              bottom: -100,
              left: -80,
              child: Container(
                width: 420,
                height: 420,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      const Color(0xFFE2C499).withValues(alpha: isDark ? 0.08 : 0.14),
                      Colors.transparent,
                    ],
                  ),
                ),
              ),
            ),

            // Center Content matching Phone 1 in Screenshot
            Center(
              child: FadeTransition(
                opacity: _fadeAnimation,
                child: ScaleTransition(
                  scale: _scaleAnimation,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Spacer(flex: 3),

                      // 3D Official App Logo
                      Container(
                        width: 140,
                        height: 140,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(32),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFFC89B58).withValues(alpha: 0.18),
                              blurRadius: 36,
                              offset: const Offset(0, 16),
                            ),
                          ],
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(32),
                          child: Image.asset(
                            'assets/images/app_logo.png',
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                      const SizedBox(height: 28),

                      // PyPocket Brand Typography
                      Text(
                        'PyPocket',
                        style: GoogleFonts.outfit(
                          fontSize: 36,
                          fontWeight: FontWeight.w900,
                          letterSpacing: -1.0,
                          color: isDark ? Colors.white : const Color(0xFF17191C),
                        ),
                      ),
                      const SizedBox(height: 8),

                      // Subtitle: LEARN • CODE • GROW
                      Text(
                        'L E A R N   •   C O D E   •   G R O W',
                        style: GoogleFonts.outfit(
                          fontSize: 11,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 2.4,
                          color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF7A8290),
                        ),
                      ),

                      const Spacer(flex: 3),

                      // Thin Bronze/Gold Progress Bar & Status (SS1 Match)
                      AnimatedBuilder(
                        animation: _progressAnimation,
                        builder: (context, _) {
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 48),
                            child: Column(
                              children: [
                                Container(
                                  width: 160,
                                  height: 4,
                                  decoration: BoxDecoration(
                                    color: isDark
                                        ? const Color(0xFF1E2430)
                                        : const Color(0xFFE8DFD0),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  alignment: Alignment.centerLeft,
                                  child: FractionallySizedBox(
                                    widthFactor: _progressAnimation.value,
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: const Color(0xFFC89B58),
                                        borderRadius: BorderRadius.circular(10),
                                        boxShadow: [
                                          BoxShadow(
                                            color: const Color(0xFFC89B58).withValues(alpha: 0.5),
                                            blurRadius: 6,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 14),
                                Text(
                                  'Setting up your workspace...',
                                  style: GoogleFonts.inter(
                                    fontSize: 12.5,
                                    color: isDark
                                        ? const Color(0xFF94A3B8)
                                        : const Color(0xFF7A8290),
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
