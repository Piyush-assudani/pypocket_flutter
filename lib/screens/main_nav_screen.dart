import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'home_screen.dart';
import 'playground_screen.dart';
import 'lessons_screen.dart';
import 'certificates_screen.dart';
import 'profile_screen.dart';

class MainNavScreen extends StatefulWidget {
  const MainNavScreen({super.key});

  @override
  State<MainNavScreen> createState() => _MainNavScreenState();
}

class _MainNavScreenState extends State<MainNavScreen>
    with SingleTickerProviderStateMixin {
  int _currentIndex = 0; // Default to Home

  late final List<Widget> _screens;

  @override
  void initState() {
    super.initState();
    _screens = [
      HomeScreen(
        onNavigateToPlayground: () => setState(() => _currentIndex = 2),
        onNavigateToLessons: () => setState(() => _currentIndex = 1),
      ),
      const LessonsScreen(),
      const PlaygroundScreen(),
      const CertificatesScreen(),
      const ProfileScreen(),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: isDark ? Brightness.light : Brightness.dark,
      systemNavigationBarColor: isDark ? const Color(0xFF0D0F14) : const Color(0xFFFAF7F2),
    ));

    return Scaffold(
      extendBody: true, // Crucial for Apple floating capsule overlay!
      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
      ),
      bottomNavigationBar: _buildAppleFloatingCapsuleBar(context, isDark),
    );
  }

  Widget _buildAppleFloatingCapsuleBar(BuildContext context, bool isDark) {
    final activeColor = isDark ? const Color(0xFFEAB308) : const Color(0xFFC89B58);
    final inactiveColor = isDark ? const Color(0xFF64748B) : const Color(0xFF8C95A5);

    final items = [
      _NavItem(Icons.home_rounded, Icons.home_outlined, 'Home'),
      _NavItem(Icons.menu_book_rounded, Icons.menu_book_outlined, 'Learn'),
      _NavItem(Icons.terminal_rounded, Icons.terminal_rounded, 'Code'),
      _NavItem(Icons.workspace_premium_rounded, Icons.workspace_premium_outlined, 'Certs'),
      _NavItem(Icons.person_rounded, Icons.person_outline_rounded, 'Profile'),
    ];

    return SafeArea(
      child: Container(
        margin: const EdgeInsets.fromLTRB(12, 0, 12, 10),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(30),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 6),
              decoration: BoxDecoration(
                color: isDark
                    ? const Color(0xFF141822).withValues(alpha: 0.85)
                    : Colors.white.withValues(alpha: 0.88),
                borderRadius: BorderRadius.circular(30),
                border: Border.all(
                  color: isDark
                      ? const Color(0xFF2A3448).withValues(alpha: 0.8)
                      : const Color(0xFFEAE3D6).withValues(alpha: 0.9),
                  width: 1.2,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: isDark ? 0.35 : 0.08),
                    blurRadius: 24,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Row(
                children: List.generate(items.length, (index) {
                  final isSelected = _currentIndex == index;
                  final item = items[index];

                  // Center Code Tab (Elevated button with play icon)
                  if (index == 2) {
                    return Expanded(
                      child: Center(
                        child: _buildCenterCodeButton(context, isDark, isSelected),
                      ),
                    );
                  }

                  return Expanded(
                    child: InkWell(
                      borderRadius: BorderRadius.circular(16),
                      onTap: () {
                        HapticFeedback.selectionClick();
                        setState(() => _currentIndex = index);
                      },
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 220),
                        padding: EdgeInsets.symmetric(
                          horizontal: isSelected ? 6 : 4,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? activeColor.withValues(alpha: 0.14)
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: FittedBox(
                          fit: BoxFit.scaleDown,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                isSelected ? item.activeIcon : item.inactiveIcon,
                                color: isSelected ? activeColor : inactiveColor,
                                size: 20,
                              ),
                              const SizedBox(height: 2),
                              Text(
                                item.label,
                                style: GoogleFonts.outfit(
                                  color: isSelected ? activeColor : inactiveColor,
                                  fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
                                  fontSize: 10,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                }),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCenterCodeButton(BuildContext context, bool isDark, bool isSelected) {
    return InkWell(
      borderRadius: BorderRadius.circular(22),
      onTap: () {
        HapticFeedback.mediumImpact();
        setState(() => _currentIndex = 2);
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 220),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 7),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFFC89B58), Color(0xFFB48540)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFFC89B58).withValues(alpha: 0.4),
              blurRadius: 10,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.play_arrow_rounded,
              color: Colors.white,
              size: 22,
            ),
            Text(
              'Code',
              style: GoogleFonts.outfit(
                color: Colors.white,
                fontWeight: FontWeight.w800,
                fontSize: 10.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _NavItem {
  final IconData activeIcon;
  final IconData inactiveIcon;
  final String label;

  _NavItem(this.activeIcon, this.inactiveIcon, this.label);
}
