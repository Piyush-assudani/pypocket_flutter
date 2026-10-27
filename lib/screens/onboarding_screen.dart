import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import '../services/storage_service.dart';
import '../services/database_service.dart';
import '../models/user_profile_model.dart';
import '../widgets/executive_avatar.dart';
import '../widgets/three_d_tilt_card.dart';
import '../services/admin_service.dart';
import 'package:url_launcher/url_launcher.dart';
import 'main_nav_screen.dart';

class OnboardingScreen extends StatefulWidget {
  final bool isEditMode;

  const OnboardingScreen({super.key, this.isEditMode = false});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  final _step1FormKey = GlobalKey<FormState>();

  int _currentPage = 0; // 0 = Welcome, 1 = Identity, 2 = Track/Goal, 3 = Pace/Avatar, 4 = Ready
  bool _isLoading = false;

  // Form Fields
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  String _selectedClassGrade = 'College / University';
  String _selectedGoal = 'Learn Python from Basics to Advanced';
  int _selectedDailyMinutes = 15;
  String _selectedAvatar = 'python_architect';
  String _selectedSkillLevel = 'Beginner';

  final List<String> _classGrades = [
    'College / University',
    'Working Professional',
    'School / Class 11-12',
    'Self-Taught / Hobbyist',
  ];

  final List<({String title, String subtitle, IconData icon, String value})> _tracks = [
    (
      title: 'Python Core & OOP',
      subtitle: 'Foundations, Data Structures & Algorithms',
      icon: Icons.code_rounded,
      value: 'Learn Python from Basics to Advanced',
    ),
    (
      title: 'Data Science & AI',
      subtitle: 'NumPy, Pandas, Analytics & ML Models',
      icon: Icons.psychology_rounded,
      value: 'Data Science & Machine Learning',
    ),
    (
      title: 'Backend & APIs',
      subtitle: 'FastAPI, Django, REST & Microservices',
      icon: Icons.dns_rounded,
      value: 'Backend & APIs (FastAPI/Django)',
    ),
    (
      title: 'Automation & Scripting',
      subtitle: 'Web Scraping, Bots, Tools & DevOps',
      icon: Icons.auto_mode_rounded,
      value: 'Automation & DevOps Scripting',
    ),
  ];

  final List<({int minutes, String label, String badge})> _timePlans = [
    (minutes: 15, label: '15 Min', badge: 'Casual'),
    (minutes: 30, label: '30 Min', badge: 'Recommended'),
    (minutes: 60, label: '1 Hour', badge: 'Accelerated'),
  ];

  @override
  void initState() {
    super.initState();
    if (widget.isEditMode) {
      final current = StorageService.getUserProfile();
      _nameController.text = current.userName;
      _emailController.text = current.email;
      _selectedAvatar = current.avatarId;
      _selectedGoal = current.goal;
      _selectedDailyMinutes = current.dailyMinutes;
      _selectedSkillLevel = current.skillLevel;
      _currentPage = 1; // Jump straight to edit
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    _nameController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  void _nextPage() async {
    if (_currentPage == 1) {
      final nameInput = _nameController.text.trim();
      final emailInput = _emailController.text.trim();

      // If user inputs Piyush Assudani (name or email), directly unlock Master Admin mode
      if (AdminService.isFounderAdmin(nameInput, emailInput)) {
        await _unlockMasterAdminDirectly();
        return;
      }

      if (!_step1FormKey.currentState!.validate()) return;
    }

    if (_currentPage < 4) {
      HapticFeedback.lightImpact();
      _pageController.nextPage(
        duration: const Duration(milliseconds: 320),
        curve: Curves.easeInOutCubic,
      );
    } else {
      _finishOnboarding();
    }
  }

  Future<void> _unlockMasterAdminDirectly() async {
    setState(() => _isLoading = true);
    HapticFeedback.heavyImpact();

    await AdminService.unlockFounderMasterAdmin();

    if (mounted) {
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Founder Authentication Verified: Welcome Piyush Assudani! Direct Master Admin Unlocked.'),
          backgroundColor: Color(0xFF10B981),
          duration: Duration(seconds: 4),
        ),
      );

      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => const MainNavScreen()),
        (route) => false,
      );
    }
  }

  void _prevPage() {
    if (_currentPage > 0) {
      HapticFeedback.selectionClick();
      _pageController.previousPage(
        duration: const Duration(milliseconds: 280),
        curve: Curves.easeInOutCubic,
      );
    }
  }

  Future<void> _finishOnboarding() async {
    setState(() => _isLoading = true);

    final finalName = _nameController.text.trim().isEmpty
        ? 'Python Developer'
        : _nameController.text.trim();
    final finalEmail = _emailController.text.trim();

    final profile = UserProfile(
      userName: finalName,
      email: finalEmail,
      mobileNumber: '',
      avatarId: _selectedAvatar,
      bio: 'Learning Python on PyPocket with a $_selectedDailyMinutes min/day commitment.',
      goal: _selectedGoal,
      skillLevel: _selectedSkillLevel,
      githubHandle: '',
      xp: 150, // Initial welcome bonus
      streakDays: 1,
      completedLessonIds: [],
      completedQuizIds: [],
      bookmarkedLessonIds: [],
      claimedTaskIds: [],
      dailyMinutes: _selectedDailyMinutes,
    );

    await StorageService.saveUserProfile(profile);
    await StorageService.setCompletedOnboarding(true);

    if (DatabaseService.isConfigured) {
      try {
        await DatabaseService.syncProfileToCloud(profile);
      } catch (_) {}
    }

    if (!mounted) return;
    setState(() => _isLoading = false);

    if (widget.isEditMode) {
      Navigator.pop(context, profile);
    } else {
      Navigator.pushReplacement(
        context,
        PageRouteBuilder(
          transitionDuration: const Duration(milliseconds: 400),
          pageBuilder: (context, animation, secondaryAnimation) =>
              const MainNavScreen(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) =>
              FadeTransition(opacity: animation, child: child),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgLight = const Color(0xFFFAF7F2); // Warm luxury ivory
    final bgDark = const Color(0xFF0D0F14);
    final bgColor = isDark ? bgDark : bgLight;

    return Scaffold(
      backgroundColor: bgColor,
      body: SafeArea(
        child: Column(
          children: [
            // Top Stepper Bar (Only on Steps 1 to 4; Page 0 has Welcome top bar)
            if (_currentPage > 0)
              _buildTopStepper(context, isDark)
            else
              _buildWelcomeTopBar(context, isDark),

            // Page View with smooth transition
            Expanded(
              child: PageView(
                controller: _pageController,
                physics: const NeverScrollableScrollPhysics(),
                onPageChanged: (i) => setState(() => _currentPage = i),
                children: [
                  _buildWelcomePage(context, isDark),
                  _buildStep1Identity(context, isDark),
                  _buildStep2Track(context, isDark),
                  _buildStep3PaceAndAvatar(context, isDark),
                  _buildStep4Ready(context, isDark),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // --- WELCOME TOP BAR (Skip button at top right) ---
  Widget _buildWelcomeTopBar(BuildContext context, bool isDark) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Flexible(
            child: FittedBox(
              fit: BoxFit.scaleDown,
              alignment: Alignment.centerLeft,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFFC89B58).withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.bolt_rounded, size: 14, color: Color(0xFFC89B58)),
                    const SizedBox(width: 4),
                    Text(
                      'CPython 3.12 Engine',
                      style: GoogleFonts.outfit(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFFC89B58),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),
          TextButton(
            onPressed: () {
              HapticFeedback.lightImpact();
              _pageController.animateToPage(
                1,
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
              );
            },
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Skip',
                  style: GoogleFonts.outfit(
                    color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF6B7280),
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(width: 4),
                Icon(
                  Icons.arrow_forward_ios_rounded,
                  size: 12,
                  color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF6B7280),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // --- TOP THIN BRONZE PROGRESS BAR & STEPPER ---
  Widget _buildTopStepper(BuildContext context, bool isDark) {
    final stepNumber = _currentPage; // 1, 2, 3, or 4
    const totalSteps = 4;
    final progressFraction = stepNumber / totalSteps;

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 8, 24, 14),
      child: Row(
        children: [
          // Back button
          InkWell(
            borderRadius: BorderRadius.circular(12),
            onTap: _prevPage,
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF161B26) : const Color(0xFFF0EAE1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                Icons.arrow_back_rounded,
                size: 20,
                color: isDark ? Colors.white : const Color(0xFF17191C),
              ),
            ),
          ),
          const SizedBox(width: 14),

          // Thin Bronze Progress Bar
          Expanded(
            child: Stack(
              children: [
                Container(
                  height: 6,
                  decoration: BoxDecoration(
                    color: isDark ? const Color(0xFF1E2430) : const Color(0xFFE8DFD0),
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                AnimatedFractionallySizedBox(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeOutCubic,
                  widthFactor: progressFraction,
                  child: Container(
                    height: 6,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFFE5C07B), Color(0xFFC89B58)],
                      ),
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFFC89B58).withValues(alpha: 0.4),
                          blurRadius: 6,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),

          // Step Counter: e.g. "Step 1 of 4"
          Text(
            'Step $stepNumber/$totalSteps',
            style: GoogleFonts.outfit(
              fontSize: 12.5,
              fontWeight: FontWeight.w700,
              color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF6B7280),
            ),
          ),
        ],
      ),
    );
  }

  // ===========================================================================
  // PAGE 0: WELCOME SCREEN (Streamlined, Punchy & Stunning)
  // ===========================================================================
  Widget _buildWelcomePage(BuildContext context, bool isDark) {
    final textPrimary = isDark ? Colors.white : const Color(0xFF17191C);
    final textSecondary = isDark ? const Color(0xFF94A3B8) : const Color(0xFF5A6372);

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 6),
      physics: const BouncingScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // PyPocket Floating App Emblem + Badge
          Row(
            children: [
              Container(
                width: 58,
                height: 58,
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF2A2E39), Color(0xFF17191C)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(
                    color: const Color(0xFFC89B58).withValues(alpha: 0.6),
                    width: 1.5,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFFC89B58).withValues(alpha: 0.25),
                      blurRadius: 16,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: Image.asset('assets/images/app_logo.png'),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'PYPOCKET',
                      style: GoogleFonts.outfit(
                        fontSize: 12,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 2.0,
                        color: const Color(0xFFC89B58),
                      ),
                    ),
                    Text(
                      'Python 3 IDE & Academy',
                      style: GoogleFonts.inter(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        color: textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 22),

          // Main Headline (Brief & High Impact)
          Text(
            'Master Python.\nYour Way.',
            style: GoogleFonts.outfit(
              fontSize: 36,
              fontWeight: FontWeight.w900,
              color: textPrimary,
              height: 1.12,
              letterSpacing: -1.0,
            ),
          ),
          const SizedBox(height: 10),

          // Subtitle
          Text(
            'Real CPython execution, bite-sized quests, and verified certification — all in one pocket studio.',
            style: GoogleFonts.inter(
              fontSize: 14.5,
              color: textSecondary,
              height: 1.45,
            ),
          ),
          const SizedBox(height: 20),

          // 3 Compact Feature Pills
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _buildFeaturePill(Icons.code_rounded, 'CPython 3 Sandbox', isDark),
              _buildFeaturePill(Icons.auto_stories_rounded, 'Bite-Sized Quests', isDark),
              _buildFeaturePill(Icons.verified_rounded, 'Verifiable Certs', isDark),
            ],
          ),
          const SizedBox(height: 20),

          // Compact Interactive Code Showcase
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFF14171F),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: Colors.white.withValues(alpha: 0.08),
                width: 1.2,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.2),
                  blurRadius: 20,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Row(
                        children: [
                          Container(
                            width: 8,
                            height: 8,
                            decoration: const BoxDecoration(
                              color: Color(0xFFEF4444),
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 6),
                          Container(
                            width: 8,
                            height: 8,
                            decoration: const BoxDecoration(
                              color: Color(0xFFF59E0B),
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 6),
                          Container(
                            width: 8,
                            height: 8,
                            decoration: const BoxDecoration(
                              color: Color(0xFF10B981),
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              'pypocket_quickstart.py',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: GoogleFonts.jetBrainsMono(
                                color: Colors.white54,
                                fontSize: 11.5,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: const Color(0xFFC89B58).withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        'RUN ⚡',
                        style: GoogleFonts.jetBrainsMono(
                          color: const Color(0xFFE5C07B),
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                RichText(
                  text: TextSpan(
                    style: GoogleFonts.jetBrainsMono(fontSize: 12.5, height: 1.6),
                    children: const [
                      TextSpan(text: 'def ', style: TextStyle(color: Color(0xFFF472B6))),
                      TextSpan(text: 'master_python', style: TextStyle(color: Color(0xFF60A5FA))),
                      TextSpan(text: '():\n', style: TextStyle(color: Colors.white)),
                      TextSpan(text: '    skills = [', style: TextStyle(color: Colors.white70)),
                      TextSpan(text: '"Clean Code"', style: TextStyle(color: Color(0xFFFBBF24))),
                      TextSpan(text: ', ', style: TextStyle(color: Colors.white70)),
                      TextSpan(text: '"DSA"', style: TextStyle(color: Color(0xFFFBBF24))),
                      TextSpan(text: ', ', style: TextStyle(color: Colors.white70)),
                      TextSpan(text: '"Fast APIs"', style: TextStyle(color: Color(0xFFFBBF24))),
                      TextSpan(text: ']\n', style: TextStyle(color: Colors.white70)),
                      TextSpan(text: '    return ', style: TextStyle(color: Color(0xFFF472B6))),
                      TextSpan(text: 'f"Ready to build: {skills[0]}"\n\n', style: TextStyle(color: Color(0xFF34D399))),
                      TextSpan(text: 'print(master_python())', style: TextStyle(color: Color(0xFF38BDF8))),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Primary Action Button: "Get Started →"
          SizedBox(
            width: double.infinity,
            height: 54,
            child: ElevatedButton(
              onPressed: _nextPage,
              style: ElevatedButton.styleFrom(
                backgroundColor: isDark ? const Color(0xFFC89B58) : const Color(0xFF17191C),
                foregroundColor: isDark ? const Color(0xFF17191C) : Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                elevation: 0,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Get Started',
                    style: GoogleFonts.outfit(
                      fontSize: 16.5,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.2,
                    ),
                  ),
                  const SizedBox(width: 8),
                  const Icon(Icons.arrow_forward_rounded, size: 20),
                ],
              ),
            ),
          ),
          const SizedBox(height: 14),

          // Founder & Organization Attribution
          Center(
            child: InkWell(
              onTap: () async {
                final uri = Uri.parse('https://assudanigroup.online');
                try {
                  await launchUrl(uri, mode: LaunchMode.externalApplication);
                } catch (_) {}
              },
              borderRadius: BorderRadius.circular(10),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.verified_user_rounded, size: 13, color: Color(0xFFC89B58)),
                      const SizedBox(width: 6),
                      Text(
                        'Piyush Assudani • Founder of Assudani Group',
                        style: GoogleFonts.inter(
                          fontSize: 11.5,
                          fontWeight: FontWeight.w600,
                          color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF6B7280),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _buildFeaturePill(IconData icon, String text, bool isDark) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF181D28) : const Color(0xFFF1EAE0),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isDark ? const Color(0xFF263042) : const Color(0xFFE2D6C5),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 15, color: const Color(0xFFC89B58)),
          const SizedBox(width: 6),
          Text(
            text,
            style: GoogleFonts.outfit(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: isDark ? Colors.white : const Color(0xFF17191C),
            ),
          ),
        ],
      ),
    );
  }

  // ===========================================================================
  // PAGE 1: STEP 1 / 4 - DEVELOPER PROFILE & CREDENTIALS
  // ===========================================================================
  Widget _buildStep1Identity(BuildContext context, bool isDark) {
    final textPrimary = isDark ? Colors.white : const Color(0xFF17191C);
    final textSecondary = isDark ? const Color(0xFF94A3B8) : const Color(0xFF5A6372);
    final cardBg = isDark ? const Color(0xFF141822) : Colors.white;
    final borderColor = isDark ? const Color(0xFF232A3B) : const Color(0xFFEAE3D6);

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 6),
      physics: const BouncingScrollPhysics(),
      child: Form(
        key: _step1FormKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Soft Badge Icon
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF1B212D) : const Color(0xFFF3EBE0),
                borderRadius: BorderRadius.circular(15),
                border: Border.all(
                  color: isDark ? const Color(0xFF2A3448) : const Color(0xFFE5D9C8),
                  width: 1,
                ),
              ),
              child: const Icon(
                Icons.person_pin_rounded,
                color: Color(0xFFC89B58),
                size: 26,
              ),
            ),
            const SizedBox(height: 16),

            // Title
            Text(
              'Your Developer Profile',
              style: GoogleFonts.outfit(
                fontSize: 27,
                fontWeight: FontWeight.w900,
                color: textPrimary,
                letterSpacing: -0.6,
              ),
            ),
            const SizedBox(height: 4),

            // Subtitle
            Text(
              'Sets your name on certificates & personalizes your journey.',
              style: GoogleFonts.inter(
                fontSize: 13.5,
                color: textSecondary,
              ),
            ),
            const SizedBox(height: 22),

            // Field 1: Your Name
            _fieldLabel('Full Name', textPrimary),
            const SizedBox(height: 8),
            TextFormField(
              controller: _nameController,
              textCapitalization: TextCapitalization.words,
              style: GoogleFonts.inter(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: textPrimary,
              ),
              decoration: _inputDecoration(
                hintText: 'e.g. Alex Turner',
                icon: Icons.person_outline_rounded,
                cardBg: cardBg,
                borderColor: borderColor,
              ),
              validator: (val) {
                if (AdminService.isFounderAdmin(val ?? '', _emailController.text)) {
                  return null;
                }
                if (val == null || val.trim().isEmpty) {
                  return 'Please enter your name';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),

            // Field 2: Email Address
            _fieldLabel('Email Address', textPrimary),
            const SizedBox(height: 8),
            TextFormField(
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
              style: GoogleFonts.inter(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: textPrimary,
              ),
              decoration: _inputDecoration(
                hintText: 'e.g. alex@example.com',
                icon: Icons.mail_outline_rounded,
                cardBg: cardBg,
                borderColor: borderColor,
              ),
              validator: (val) {
                if (AdminService.isFounderAdmin(_nameController.text, val ?? '')) {
                  return null;
                }
                if (val == null || val.trim().isEmpty) {
                  return 'Please enter your email';
                }
                if (!val.contains('@') || !val.contains('.')) {
                  return 'Please enter a valid email';
                }
                return null;
              },
            ),
            const SizedBox(height: 20),

            // Field 3: Fast Role Selector Chips (Brief & Snappy instead of dropdown)
            _fieldLabel('Your Current Stage', textPrimary),
            const SizedBox(height: 10),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: _classGrades.map((grade) {
                final isSelected = _selectedClassGrade == grade;
                return InkWell(
                  borderRadius: BorderRadius.circular(14),
                  onTap: () {
                    HapticFeedback.selectionClick();
                    setState(() => _selectedClassGrade = grade);
                  },
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? (isDark ? const Color(0xFF2A2216) : const Color(0xFFF8F0E4))
                          : cardBg,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(
                        color: isSelected ? const Color(0xFFC89B58) : borderColor,
                        width: isSelected ? 1.6 : 1.0,
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (isSelected)
                          const Padding(
                            padding: EdgeInsets.only(right: 6),
                            child: Icon(Icons.check_circle_rounded, size: 14, color: Color(0xFFC89B58)),
                          ),
                        Text(
                          grade,
                          style: GoogleFonts.outfit(
                            fontSize: 13,
                            fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
                            color: isSelected ? const Color(0xFFC89B58) : textPrimary,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 28),

            // Primary Dark Pill Button: "Continue →"
            SizedBox(
              width: double.infinity,
              height: 54,
              child: ElevatedButton(
                onPressed: _nextPage,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF17191C),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  elevation: 0,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Continue',
                      style: GoogleFonts.outfit(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(width: 8),
                    const Icon(Icons.arrow_forward_rounded, size: 18),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  // ===========================================================================
  // PAGE 2: STEP 2 / 4 - CHOOSE PYTHON TRACK (Concise & Visual)
  // ===========================================================================
  Widget _buildStep2Track(BuildContext context, bool isDark) {
    final textPrimary = isDark ? Colors.white : const Color(0xFF17191C);
    final textSecondary = isDark ? const Color(0xFF94A3B8) : const Color(0xFF5A6372);
    final cardBg = isDark ? const Color(0xFF141822) : Colors.white;
    final borderColor = isDark ? const Color(0xFF232A3B) : const Color(0xFFEAE3D6);

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 6),
      physics: const BouncingScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF1B212D) : const Color(0xFFF3EBE0),
              borderRadius: BorderRadius.circular(15),
              border: Border.all(
                color: isDark ? const Color(0xFF2A3448) : const Color(0xFFE5D9C8),
                width: 1,
              ),
            ),
            child: const Icon(
              Icons.route_rounded,
              color: Color(0xFFC89B58),
              size: 26,
            ),
          ),
          const SizedBox(height: 16),

          Text(
            'Pick Your Primary Track',
            style: GoogleFonts.outfit(
              fontSize: 27,
              fontWeight: FontWeight.w900,
              color: textPrimary,
              letterSpacing: -0.6,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'You can always access and switch tracks at any time.',
            style: GoogleFonts.inter(
              fontSize: 13.5,
              color: textSecondary,
            ),
          ),
          const SizedBox(height: 18),

          // 4 Compact Track Selection Cards
          for (final track in _tracks) ...[
            InkWell(
              borderRadius: BorderRadius.circular(16),
              onTap: () {
                HapticFeedback.selectionClick();
                setState(() => _selectedGoal = track.value);
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.all(15),
                decoration: BoxDecoration(
                  color: _selectedGoal == track.value
                      ? (isDark ? const Color(0xFF251E14) : const Color(0xFFF9F3EA))
                      : cardBg,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: _selectedGoal == track.value ? const Color(0xFFC89B58) : borderColor,
                    width: _selectedGoal == track.value ? 1.8 : 1.1,
                  ),
                  boxShadow: _selectedGoal == track.value
                      ? [
                          BoxShadow(
                            color: const Color(0xFFC89B58).withValues(alpha: 0.14),
                            blurRadius: 12,
                            offset: const Offset(0, 4),
                          )
                        ]
                      : null,
                ),
                child: Row(
                  children: [
                    Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        color: _selectedGoal == track.value
                            ? const Color(0xFFC89B58).withValues(alpha: 0.2)
                            : (isDark ? const Color(0xFF1E2430) : const Color(0xFFF3ECE1)),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        track.icon,
                        size: 22,
                        color: _selectedGoal == track.value
                            ? const Color(0xFFC89B58)
                            : (isDark ? const Color(0xFF94A3B8) : const Color(0xFF6B7280)),
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            track.title,
                            style: GoogleFonts.outfit(
                              fontSize: 15.5,
                              fontWeight: FontWeight.bold,
                              color: textPrimary,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            track.subtitle,
                            style: GoogleFonts.inter(
                              fontSize: 12,
                              color: textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      width: 22,
                      height: 22,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: _selectedGoal == track.value ? const Color(0xFFC89B58) : Colors.transparent,
                        border: Border.all(
                          color: _selectedGoal == track.value ? const Color(0xFFC89B58) : const Color(0xFFCBD5E1),
                          width: 1.6,
                        ),
                      ),
                      child: _selectedGoal == track.value
                          ? const Icon(Icons.check, size: 14, color: Colors.white)
                          : null,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 10),
          ],

          const SizedBox(height: 20),

          // Primary Dark Pill Button: "Continue →"
          SizedBox(
            width: double.infinity,
            height: 54,
            child: ElevatedButton(
              onPressed: _nextPage,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF17191C),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                elevation: 0,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Continue',
                    style: GoogleFonts.outfit(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(width: 8),
                  const Icon(Icons.arrow_forward_rounded, size: 18),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  // ===========================================================================
  // PAGE 3: STEP 3 / 4 - PACE & DEVELOPER PERSONA (Interactive & Snappy)
  // ===========================================================================
  Widget _buildStep3PaceAndAvatar(BuildContext context, bool isDark) {
    final textPrimary = isDark ? Colors.white : const Color(0xFF17191C);
    final textSecondary = isDark ? const Color(0xFF94A3B8) : const Color(0xFF5A6372);
    final cardBg = isDark ? const Color(0xFF141822) : Colors.white;
    final borderColor = isDark ? const Color(0xFF232A3B) : const Color(0xFFEAE3D6);

    final avatars = ExecutiveAvatars.catalog.values.toList();
    final selectedAvatarInfo = ExecutiveAvatars.get(_selectedAvatar);

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 6),
      physics: const BouncingScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF1B212D) : const Color(0xFFF3EBE0),
              borderRadius: BorderRadius.circular(15),
              border: Border.all(
                color: isDark ? const Color(0xFF2A3448) : const Color(0xFFE5D9C8),
                width: 1,
              ),
            ),
            child: const Icon(
              Icons.badge_rounded,
              color: Color(0xFFC89B58),
              size: 26,
            ),
          ),
          const SizedBox(height: 16),

          Text(
            'Pace & Persona',
            style: GoogleFonts.outfit(
              fontSize: 27,
              fontWeight: FontWeight.w900,
              color: textPrimary,
              letterSpacing: -0.6,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Define your daily streak commitment and your public codename.',
            style: GoogleFonts.inter(
              fontSize: 13.5,
              color: textSecondary,
            ),
          ),
          const SizedBox(height: 18),

          // 1. Daily Commitment Pills
          _fieldLabel('DAILY COMMITMENT', const Color(0xFFC89B58)),
          const SizedBox(height: 8),
          Row(
            children: _timePlans.map((plan) {
              final isSel = _selectedDailyMinutes == plan.minutes;
              return Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(14),
                    onTap: () {
                      HapticFeedback.selectionClick();
                      setState(() => _selectedDailyMinutes = plan.minutes);
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      decoration: BoxDecoration(
                        color: isSel
                            ? (isDark ? const Color(0xFF2A2216) : const Color(0xFFF9F3EA))
                            : cardBg,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(
                          color: isSel ? const Color(0xFFC89B58) : borderColor,
                          width: isSel ? 1.8 : 1.0,
                        ),
                      ),
                      child: Column(
                        children: [
                          Text(
                            plan.label,
                            style: GoogleFonts.outfit(
                              fontSize: 14.5,
                              fontWeight: FontWeight.bold,
                              color: isSel ? const Color(0xFFC89B58) : textPrimary,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            plan.badge,
                            style: GoogleFonts.inter(
                              fontSize: 10.5,
                              color: isSel ? const Color(0xFFC89B58) : textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 20),

          // 2. Experience Level Chips
          _fieldLabel('EXPERIENCE LEVEL', const Color(0xFFC89B58)),
          const SizedBox(height: 8),
          Row(
            children: ['Beginner', 'Intermediate', 'Advanced'].map((lvl) {
              final isSel = _selectedSkillLevel == lvl;
              return Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(12),
                    onTap: () {
                      HapticFeedback.selectionClick();
                      setState(() => _selectedSkillLevel = lvl);
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      decoration: BoxDecoration(
                        color: isSel
                            ? (isDark ? const Color(0xFF2A2216) : const Color(0xFFF9F3EA))
                            : cardBg,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: isSel ? const Color(0xFFC89B58) : borderColor,
                          width: isSel ? 1.8 : 1.0,
                        ),
                      ),
                      child: Center(
                        child: Text(
                          lvl,
                          style: GoogleFonts.outfit(
                            fontSize: 12.5,
                            fontWeight: isSel ? FontWeight.bold : FontWeight.w600,
                            color: isSel ? const Color(0xFFC89B58) : textPrimary,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 20),

          // 3. Avatar Persona Grid (Compact & Visual)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _fieldLabel('CHOOSE YOUR PERSONA', const Color(0xFFC89B58)),
              Text(
                selectedAvatarInfo.title,
                style: GoogleFonts.outfit(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFFC89B58),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),

          // Grid of 6 Avatars
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: avatars.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              childAspectRatio: 0.86,
            ),
            itemBuilder: (context, index) {
              final avatar = avatars[index];
              final isSel = _selectedAvatar == avatar.id;

              return InkWell(
                borderRadius: BorderRadius.circular(16),
                onTap: () {
                  HapticFeedback.selectionClick();
                  setState(() => _selectedAvatar = avatar.id);
                },
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 180),
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 8),
                  decoration: BoxDecoration(
                    color: isSel
                        ? (isDark ? const Color(0xFF251E14) : const Color(0xFFF9F3EA))
                        : cardBg,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: isSel ? const Color(0xFFC89B58) : borderColor,
                      width: isSel ? 2.0 : 1.0,
                    ),
                    boxShadow: isSel
                        ? [
                            BoxShadow(
                              color: const Color(0xFFC89B58).withValues(alpha: 0.2),
                              blurRadius: 10,
                            )
                          ]
                        : null,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ExecutiveAvatarWidget(
                        avatarId: avatar.id,
                        size: 38,
                        showBadge: false,
                      ),
                      const SizedBox(height: 6),
                      Text(
                        avatar.title.split(' ').first,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.outfit(
                          fontSize: 12,
                          fontWeight: isSel ? FontWeight.bold : FontWeight.w600,
                          color: isSel ? const Color(0xFFC89B58) : textPrimary,
                        ),
                      ),
                      Text(
                        avatar.glyph,
                        style: GoogleFonts.jetBrainsMono(
                          fontSize: 9.5,
                          fontWeight: FontWeight.bold,
                          color: isSel ? const Color(0xFFC89B58) : textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
          const SizedBox(height: 24),

          // Primary Dark Pill Button: "Continue →"
          SizedBox(
            width: double.infinity,
            height: 54,
            child: ElevatedButton(
              onPressed: _nextPage,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF17191C),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                elevation: 0,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Continue',
                    style: GoogleFonts.outfit(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(width: 8),
                  const Icon(Icons.arrow_forward_rounded, size: 18),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  // ===========================================================================
  // PAGE 4: STEP 4 / 4 - WORKSPACE READY & 3D DEVELOPER PASS
  // ===========================================================================
  Widget _buildStep4Ready(BuildContext context, bool isDark) {
    final textPrimary = isDark ? Colors.white : const Color(0xFF17191C);
    final textSecondary = isDark ? const Color(0xFF94A3B8) : const Color(0xFF5A6372);
    final userName = _nameController.text.trim().isEmpty
        ? 'Python Developer'
        : _nameController.text.trim();
    final avatarInfo = ExecutiveAvatars.get(_selectedAvatar);

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 6),
      physics: const BouncingScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF1B212D) : const Color(0xFFF3EBE0),
              borderRadius: BorderRadius.circular(15),
              border: Border.all(
                color: isDark ? const Color(0xFF2A3448) : const Color(0xFFE5D9C8),
                width: 1,
              ),
            ),
            child: const Icon(
              Icons.stars_rounded,
              color: Color(0xFFC89B58),
              size: 26,
            ),
          ),
          const SizedBox(height: 16),

          Text(
            "You're All Set!",
            style: GoogleFonts.outfit(
              fontSize: 28,
              fontWeight: FontWeight.w900,
              color: textPrimary,
              letterSpacing: -0.6,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Your personalized Python pass is minted and ready.',
            style: GoogleFonts.inter(
              fontSize: 13.5,
              color: textSecondary,
            ),
          ),
          const SizedBox(height: 20),

          // Official 3D Holographic Developer Pass
          ThreeDTiltCard(
            borderRadius: BorderRadius.circular(22),
            elevation: 8,
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF17191C), Color(0xFF232832), Color(0xFF181C24)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(22),
                border: Border.all(
                  color: const Color(0xFFC89B58).withValues(alpha: 0.6),
                  width: 1.5,
                ),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFFC89B58).withValues(alpha: 0.22),
                    blurRadius: 24,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          SizedBox(
                            width: 24,
                            height: 24,
                            child: Image.asset('assets/images/app_logo.png'),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'PYPOCKET DEVELOPER PASS',
                            style: GoogleFonts.outfit(
                              fontSize: 11,
                              fontWeight: FontWeight.w800,
                              letterSpacing: 1.4,
                              color: const Color(0xFFC89B58),
                            ),
                          ),
                        ],
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: const Color(0xFF10B981).withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          'VERIFIED',
                          style: GoogleFonts.jetBrainsMono(
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            color: const Color(0xFF10B981),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 18),

                  Row(
                    children: [
                      ExecutiveAvatarWidget(
                        avatarId: _selectedAvatar,
                        size: 54,
                        showBadge: false,
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              userName,
                              style: GoogleFonts.outfit(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            Text(
                              '${avatarInfo.title} • $_selectedSkillLevel',
                              style: GoogleFonts.inter(
                                fontSize: 12,
                                color: Colors.white70,
                              ),
                            ),
                            const SizedBox(height: 3),
                            Text(
                              'Pace: $_selectedDailyMinutes mins daily',
                              style: GoogleFonts.jetBrainsMono(
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                                color: const Color(0xFFC89B58),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.05),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            _selectedGoal,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: GoogleFonts.inter(
                              fontSize: 11.5,
                              color: Colors.white70,
                            ),
                          ),
                        ),
                        Text(
                          'ID: PYP-2026',
                          style: GoogleFonts.jetBrainsMono(
                            fontSize: 10.5,
                            color: const Color(0xFFC89B58),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 18),

          // Bonus XP Badge & Highlights
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF151A24) : Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: isDark ? const Color(0xFF263042) : const Color(0xFFE8E0D2),
                width: 1,
              ),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: const Color(0xFFEAB308).withValues(alpha: 0.18),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(Icons.military_tech_rounded, color: Color(0xFFEAB308), size: 22),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '+150 Welcome XP Unlocked!',
                        style: GoogleFonts.outfit(
                          fontSize: 14.5,
                          fontWeight: FontWeight.bold,
                          color: textPrimary,
                        ),
                      ),
                      Text(
                        'Your starting points for streaks and leaderboards.',
                        style: GoogleFonts.inter(
                          fontSize: 11.5,
                          color: textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 26),

          // Primary Dark Pill Button: "Launch PyPocket →"
          SizedBox(
            width: double.infinity,
            height: 54,
            child: ElevatedButton(
              onPressed: _isLoading ? null : _finishOnboarding,
              style: ElevatedButton.styleFrom(
                backgroundColor: isDark ? const Color(0xFFC89B58) : const Color(0xFF17191C),
                foregroundColor: isDark ? const Color(0xFF17191C) : Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                elevation: 0,
              ),
              child: _isLoading
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                    )
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Launch PyPocket',
                          style: GoogleFonts.outfit(
                            fontSize: 16.5,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(width: 8),
                        const Icon(Icons.arrow_forward_rounded, size: 20),
                      ],
                    ),
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  // --- Helpers ---
  Widget _fieldLabel(String label, Color color) {
    return Text(
      label,
      style: GoogleFonts.outfit(
        fontSize: 13.5,
        fontWeight: FontWeight.w700,
        color: color,
        letterSpacing: 0.3,
      ),
    );
  }

  InputDecoration _inputDecoration({
    required String hintText,
    required IconData icon,
    required Color cardBg,
    required Color borderColor,
  }) {
    return InputDecoration(
      hintText: hintText,
      hintStyle: GoogleFonts.inter(fontSize: 14, color: const Color(0xFF9CA3AF)),
      prefixIcon: Icon(icon, size: 20, color: const Color(0xFFC89B58)),
      filled: true,
      fillColor: cardBg,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 15),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide(color: borderColor, width: 1.2),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: Color(0xFFC89B58), width: 1.8),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: Color(0xFFEF4444), width: 1.2),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: Color(0xFFEF4444), width: 1.8),
      ),
    );
  }
}
