import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_theme.dart';
import '../services/storage_service.dart';
import '../models/user_profile_model.dart';
import '../data/python_lessons_data.dart';
import '../data/python_quizzes_data.dart';
import '../widgets/xp_badge.dart';
import '../widgets/three_d_tilt_card.dart';
import 'lesson_detail_screen.dart';
import 'certificates_screen.dart';
import 'cheatsheet_screen.dart';
import 'daily_challenge_screen.dart';
import 'flashcards_screen.dart';
import 'roadmap_screen.dart';
import 'playground_screen.dart';
import 'rewards_screen.dart';
import '../services/notification_service.dart';
import '../widgets/executive_avatar.dart';
import '../widgets/admin_login_modal.dart';
import 'booklet_screen.dart';
import 'qa_handbook_screen.dart';
import 'profile_edit_screen.dart';
import '../data/daily_challenges_data.dart';

class HomeScreen extends StatefulWidget {
  final VoidCallback? onNavigateToPlayground;
  final VoidCallback? onNavigateToLessons;

  const HomeScreen({
    super.key,
    this.onNavigateToPlayground,
    this.onNavigateToLessons,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _pulseController;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final profile = StorageService.getUserProfile();
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final allLessons = PythonLessonsData.lessons;
    final totalQuizQuestions = PythonQuizzesData.certificationExamQuestions.length +
        PythonQuizzesData.beginnerQuestions.length;
    final completedLessons = allLessons
        .where((l) => profile.completedLessonIds.contains(l.id))
        .length;

    // Find next uncompleted lesson
    final nextLesson = allLessons.cast().firstWhere(
          (l) => !profile.completedLessonIds.contains(l.id),
          orElse: () => null,
        );

    // Daily tip with runnable playground code
    final tips = [
      (
        tip: 'Use list comprehensions for concise and fast syntax: [x**2 for x in range(10) if x % 2 == 0]',
        code: '''# Tip: List Comprehensions
squares = [x**2 for x in range(10) if x % 2 == 0]
print("Even squares:", squares)''',
      ),
      (
        tip: 'The `enumerate()` function adds a counter index to iterables.',
        code: '''# Tip: enumerate()
languages = ["Python", "Rust", "TypeScript"]
for i, lang in enumerate(languages, start=1):
    print(f"{i}. {lang}")''',
      ),
      (
        tip: 'Use `zip()` to iterate through multiple lists in parallel.',
        code: '''# Tip: zip()
users = ["Alice", "Bob", "Charlie"]
scores = [95, 88, 92]
for u, s in zip(users, scores):
    print(f"{u}: {s} pts")''',
      ),
      (
        tip: 'F-strings evaluate expressions directly at runtime with custom formatting.',
        code: '''# Tip: F-Strings
pi = 3.14159265
print(f"Pi formatted to 2 decimals: {pi:.2f}")''',
      ),
      (
        tip: 'The walrus operator `:=` assigns inside expressions to prevent duplicate calculations.',
        code: '''# Tip: Walrus Operator :=
nums = [1, 2, 3, 4, 5, 6]
if (n := len(nums)) > 4:
    print(f"Length is {n}")''',
      ),
    ];
    final dailyTip = tips[DateTime.now().day % tips.length];

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // Premium App Bar
          SliverAppBar(
            expandedHeight: 0,
            floating: true,
            backgroundColor: isDark ? const Color(0xFF090D16) : const Color(0xFFF8FAFC),
            elevation: 0,
            title: FittedBox(
              fit: BoxFit.scaleDown,
              alignment: Alignment.centerLeft,
              child: InkWell(
                onLongPress: () {
                  AdminLoginModal.show(context, onStateChanged: () => setState(() {}));
                },
                borderRadius: BorderRadius.circular(10),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 30,
                      height: 30,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(9),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFFC89B58).withValues(alpha: 0.25),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(9),
                        child: Image.asset('assets/images/app_logo.png', fit: BoxFit.contain),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'PyPocket',
                      style: GoogleFonts.outfit(
                        fontWeight: FontWeight.w900,
                        fontSize: 20,
                        letterSpacing: -0.5,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            actions: [
              IconButton(
                visualDensity: VisualDensity.compact,
                padding: const EdgeInsets.all(6),
                constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
                tooltip: 'Quick Starter Guide',
                icon: const Icon(Icons.help_outline_rounded, size: 20),
                onPressed: () => _showStarterGuideSheet(context, isDark),
              ),
              IconButton(
                visualDensity: VisualDensity.compact,
                padding: const EdgeInsets.all(6),
                constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
                tooltip: 'Daily Smart Notifications (100 Bank)',
                icon: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    const Icon(Icons.notifications_active_outlined, size: 20),
                    Positioned(
                      right: -1,
                      top: -1,
                      child: Container(
                        width: 6,
                        height: 6,
                        decoration: const BoxDecoration(
                          color: Color(0xFFC89B58),
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                  ],
                ),
                onPressed: () {
                  PythonNotificationService.showNotificationCenterSheet(context, profile);
                },
              ),
              IconButton(
                visualDensity: VisualDensity.compact,
                padding: const EdgeInsets.all(6),
                constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
                icon: Icon(isDark ? Icons.light_mode_rounded : Icons.dark_mode_rounded, size: 19),
                onPressed: () {
                  final newMode = isDark ? ThemeMode.light : ThemeMode.dark;
                  StorageService.setThemeMode(newMode);
                },
              ),
              Padding(
                padding: const EdgeInsets.only(right: 8),
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: XpBadge(xp: profile.xp, streakDays: profile.streakDays),
                ),
              ),
            ],
          ),

          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 1. Welcome Hero Card (Greeting, Level, XP)
                  _buildHeroCard(context, profile, isDark, completedLessons, allLessons.length),
                  const SizedBox(height: 18),

                  // 2. PRIMARY NEXT STEP ACTION CENTER (Eliminates confusion - 1 tap to start)
                  if (nextLesson != null)
                    _buildNextMission(context, isDark, nextLesson),
                  if (nextLesson != null)
                    const SizedBox(height: 18),

                  // 3. QUICK HUBS BAR (Lessons, Sandbox, Playbook, Q&A)
                  _buildQuickLaunchHubs(context, isDark),
                  const SizedBox(height: 18),

                  // 4. 7-Day Habit Streak Tracker
                  _buildHabitStreakTracker(context, profile, isDark),
                  const SizedBox(height: 18),

                  // 5. Daily Coding Quest Hero Card
                  _buildDailyQuestHeroCard(context, isDark),
                  const SizedBox(height: 18),

                  // 6. Executive 6-Feature Suite Grid
                  _buildExecutiveGrid(context, isDark),
                  const SizedBox(height: 22),

                  // 7. Daily Python Tip
                  _buildDailyTip(context, isDark, dailyTip),
                  const SizedBox(height: 18),

                  // 8. Stats overview
                  _buildStatsRow(context, isDark, profile, completedLessons),
                  const SizedBox(height: 18),

                  // 9. Quiz Challenge
                  _buildQuizChallenge(context, isDark, totalQuizQuestions),
                  const SizedBox(height: 22),

                  // 10. Achievement Badges
                  _buildAchievements(context, isDark, profile),
                  const SizedBox(height: 30),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeroCard(BuildContext context, UserProfile profile, bool isDark, int completed, int total) {
    final greetingHour = DateTime.now().hour;
    String greeting;
    if (greetingHour < 12) {
      greeting = 'Good Morning';
    } else if (greetingHour < 17) {
      greeting = 'Good Afternoon';
    } else {
      greeting = 'Good Evening';
    }

    return ThreeDTiltCard(
      borderRadius: BorderRadius.circular(20),
      elevation: 8,
      child: Container(
        padding: const EdgeInsets.all(22),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: isDark
                ? [const Color(0xFF1E1B4B), const Color(0xFF0C1222), const Color(0xFF0F172A)]
                : [const Color(0xFF3B82F6), const Color(0xFF6366F1), const Color(0xFF8B5CF6)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                ExecutiveAvatarWidget(
                  avatarId: profile.avatarId,
                  size: 42,
                  showBadge: false,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '$greeting, ${profile.userName.split(' ').first}!',
                        style: GoogleFonts.outfit(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        'Target: ${profile.dailyMinutes} mins/day • ${profile.goal.split(' ').take(3).join(' ')}',
                        style: GoogleFonts.inter(
                          fontSize: 11,
                          color: Colors.white.withValues(alpha: 0.75),
                        ),
                      ),
                    ],
                  ),
                ),
                InkWell(
                  onTap: () async {
                    await Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => ProfileEditScreen(currentProfile: profile)),
                    );
                    setState(() {});
                  },
                  borderRadius: BorderRadius.circular(10),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.16),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Colors.white.withValues(alpha: 0.25)),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.tune_rounded, color: Colors.white, size: 14),
                        const SizedBox(width: 4),
                        Text(
                          'Profile',
                          style: GoogleFonts.outfit(
                            color: Colors.white,
                            fontSize: 11.5,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),
            Text(
              'Level ${profile.level} ${profile.rankTitle}',
              style: GoogleFonts.inter(
                color: Colors.white.withValues(alpha: 0.7),
                fontSize: 13,
              ),
            ),
            const SizedBox(height: 18),

          // XP Progress to next level
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'XP to Level ${profile.level + 1}',
                          style: GoogleFonts.inter(color: Colors.white70, fontSize: 11),
                        ),
                        Text(
                          '${(profile.levelProgress * 100).toInt()}%',
                          style: GoogleFonts.jetBrainsMono(
                            color: const Color(0xFFFBBF24),
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: LinearProgressIndicator(
                        value: profile.levelProgress,
                        minHeight: 8,
                        backgroundColor: Colors.white.withValues(alpha: 0.15),
                        valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFFFBBF24)),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              // Animated level badge
              AnimatedBuilder(
                animation: _pulseController,
                builder: (context, _) {
                  final scale = 1.0 + _pulseController.value * 0.05;
                  return Transform.scale(
                    scale: scale,
                    child: Container(
                      width: 52,
                      height: 52,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: const LinearGradient(
                          colors: [Color(0xFFFBBF24), Color(0xFFF59E0B)],
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFFFBBF24).withValues(alpha: 0.4),
                            blurRadius: 12,
                          ),
                        ],
                      ),
                      child: Center(
                        child: Text(
                          '${profile.level}',
                          style: GoogleFonts.outfit(
                            color: Colors.black,
                            fontWeight: FontWeight.w900,
                            fontSize: 22,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
          const SizedBox(height: 14),

          // Curriculum progress
          Row(
            children: [
              const Icon(Icons.school_rounded, color: Colors.white54, size: 16),
              const SizedBox(width: 6),
              Text(
                '$completed / $total lessons mastered',
                style: GoogleFonts.inter(color: Colors.white60, fontSize: 12),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '${profile.streakDays} day streak',
                  style: GoogleFonts.outfit(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    fontSize: 11,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    ),
    );
  }

  Widget _buildHabitStreakTracker(BuildContext context, dynamic profile, bool isDark) {
    final activeWeekdays = StorageService.getWeeklyActiveWeekdays();
    final todayWeekday = DateTime.now().weekday; // 1 = Monday, 7 = Sunday
    final dayNames = ['M', 'T', 'W', 'T', 'F', 'S', 'S'];

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF101726) : Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: isDark ? const Color(0xFF1E293B) : const Color(0xFFE2E8F0),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.3 : 0.04),
            blurRadius: 10,
            offset: const Offset(0, 3),
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
                  Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF59E0B).withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(Icons.local_fire_department_rounded, color: Color(0xFFF59E0B), size: 16),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    '7-DAY CODING STREAK',
                    style: GoogleFonts.outfit(
                      color: AppTheme.textPrimaryOf(context),
                      fontSize: 12.5,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 1.0,
                    ),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFFF59E0B).withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: const Color(0xFFF59E0B).withValues(alpha: 0.3)),
                ),
                child: Text(
                  '${profile.streakDays} Days Active',
                  style: GoogleFonts.jetBrainsMono(
                    color: const Color(0xFFF59E0B),
                    fontWeight: FontWeight.bold,
                    fontSize: 11,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: List.generate(7, (index) {
              final weekday = index + 1;
              final isToday = weekday == todayWeekday;
              final isActive = activeWeekdays.contains(weekday);

              Color bgColor;
              Color borderColor;
              Color textColor;

              if (isActive) {
                bgColor = const Color(0xFF10B981).withValues(alpha: 0.18);
                borderColor = const Color(0xFF10B981);
                textColor = const Color(0xFF10B981);
              } else if (isToday) {
                bgColor = const Color(0xFFF59E0B).withValues(alpha: 0.18);
                borderColor = const Color(0xFFF59E0B);
                textColor = const Color(0xFFF59E0B);
              } else {
                bgColor = isDark ? const Color(0xFF1A2234) : const Color(0xFFF1F5F9);
                borderColor = Colors.transparent;
                textColor = AppTheme.textMutedOf(context);
              }

              return Column(
                children: [
                  Text(
                    dayNames[index],
                    style: GoogleFonts.jetBrainsMono(
                      fontSize: 11,
                      fontWeight: isToday ? FontWeight.w900 : FontWeight.w600,
                      color: isToday ? const Color(0xFFF59E0B) : AppTheme.textMutedOf(context),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Container(
                    width: 38,
                    height: 38,
                    decoration: BoxDecoration(
                      color: bgColor,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: borderColor,
                        width: isToday ? 2 : 1,
                      ),
                      boxShadow: isToday
                          ? [
                              BoxShadow(
                                color: const Color(0xFFF59E0B).withValues(alpha: 0.4),
                                blurRadius: 8,
                                spreadRadius: 1,
                              ),
                            ]
                          : null,
                    ),
                    child: Center(
                      child: isActive
                          ? const Icon(Icons.check_rounded, color: Color(0xFF10B981), size: 18)
                          : (isToday
                              ? const Icon(Icons.local_fire_department_rounded, color: Color(0xFFF59E0B), size: 15)
                              : Text(
                                  dayNames[index],
                                  style: GoogleFonts.inter(
                                    fontSize: 11,
                                    color: textColor,
                                    fontWeight: FontWeight.w600,
                                  ),
                                )),
                    ),
                  ),
                ],
              );
            }),
          ),
          const SizedBox(height: 12),
          Text(
            'Keep your daily habit alive! Target: 1 Lesson + 1 Coding Quest.',
            style: GoogleFonts.inter(
              color: AppTheme.textSecondaryOf(context),
              fontSize: 11.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDailyQuestHeroCard(BuildContext context, bool isDark) {
    final challenges = DailyChallengesData.challenges;
    final todayChallenge = challenges[DateTime.now().day % challenges.length];
    final isSolved = StorageService.isChallengeSolved(todayChallenge.id);

    return InkWell(
      borderRadius: BorderRadius.circular(18),
      onTap: () async {
        await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => DailyChallengeScreen(challenge: todayChallenge),
          ),
        );
        setState(() {});
      },
      child: Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: isDark
                ? [const Color(0xFF1E1B4B), const Color(0xFF0F172A)]
                : [const Color(0xFFEFF6FF), Colors.white],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: isSolved
                ? const Color(0xFF10B981).withValues(alpha: 0.4)
                : (isDark ? const Color(0xFF4338CA).withValues(alpha: 0.4) : const Color(0xFFBFDBFE)),
            width: 1.2,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: isDark ? 0.25 : 0.05),
              blurRadius: 10,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: const Color(0xFFEF4444).withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.stars_rounded, size: 14, color: Color(0xFFEF4444)),
                      const SizedBox(width: 4),
                      Text(
                        'DAILY CODE QUEST',
                        style: GoogleFonts.outfit(
                          color: const Color(0xFFEF4444),
                          fontSize: 10.5,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 0.8,
                        ),
                      ),
                    ],
                  ),
                ),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: (isSolved ? const Color(0xFF10B981) : const Color(0xFFF59E0B)).withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    isSolved ? 'COMPLETED' : todayChallenge.difficulty.toUpperCase(),
                    style: GoogleFonts.jetBrainsMono(
                      color: isSolved ? const Color(0xFF10B981) : const Color(0xFFF59E0B),
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Text(
              todayChallenge.title,
              style: GoogleFonts.outfit(
                color: AppTheme.textPrimaryOf(context),
                fontSize: 17,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              todayChallenge.description,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: GoogleFonts.inter(
                color: AppTheme.textSecondaryOf(context),
                fontSize: 12,
                height: 1.4,
              ),
            ),
            const SizedBox(height: 14),
            Row(
              children: [
                Expanded(
                  child: Text(
                    'Automated Test Suite',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.inter(color: AppTheme.textMutedOf(context), fontSize: 11.5),
                  ),
                ),
                const SizedBox(width: 8),
                FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(
                      color: const Color(0xFF2563EB),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          isSolved ? 'Review Quest' : 'Solve Quest (+${todayChallenge.xpReward} XP)',
                          style: GoogleFonts.outfit(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                        const SizedBox(width: 4),
                        const Icon(Icons.arrow_forward_rounded, size: 14, color: Colors.white),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildExecutiveGrid(BuildContext context, bool isDark) {
    final profile = StorageService.getUserProfile();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Icon(Icons.grid_view_rounded, size: 16, color: Color(0xFF64748B)),
            const SizedBox(width: 8),
            Text(
              'PYTHON LEARNING SUITE',
              style: GoogleFonts.outfit(
                color: AppTheme.textMutedOf(context),
                fontSize: 12,
                fontWeight: FontWeight.w800,
                letterSpacing: 1.5,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _suiteCard(
                context,
                title: 'Code IDE',
                subtitle: 'CPython 3 Sandbox',
                icon: Icons.terminal_rounded,
                color: const Color(0xFF10B981),
                onTap: widget.onNavigateToPlayground,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: _suiteCard(
                context,
                title: 'Syntax Hub',
                subtitle: 'Cheat Sheet & Dunders',
                icon: Icons.menu_book_rounded,
                color: const Color(0xFF38BDF8),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const CheatSheetScreen()),
                  );
                },
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            Expanded(
              child: _suiteCard(
                context,
                title: 'Flashcards',
                subtitle: 'Spaced Repetition',
                icon: Icons.flash_on_rounded,
                color: const Color(0xFFF59E0B),
                onTap: () async {
                  await Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const FlashcardsScreen()),
                  );
                  setState(() {});
                },
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: _suiteCard(
                context,
                title: 'Roadmap',
                subtitle: 'Visual Career Tree',
                icon: Icons.alt_route_rounded,
                color: const Color(0xFF8B5CF6),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const RoadmapScreen()),
                  );
                },
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            Expanded(
              child: _suiteCard(
                context,
                title: 'Daily Quests',
                subtitle: 'Test-Driven Challenges',
                icon: Icons.code_rounded,
                color: const Color(0xFFEF4444),
                onTap: () async {
                  await Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const DailyChallengeScreen()),
                  );
                  setState(() {});
                },
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: _suiteCard(
                context,
                title: 'Certification',
                subtitle: 'Verified Exam',
                icon: Icons.workspace_premium_rounded,
                color: const Color(0xFFEAB308),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const CertificatesScreen()),
                  );
                },
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            Expanded(
              child: _suiteCard(
                context,
                title: 'Bonus Quests',
                subtitle: '10 Tasks & +XP Rewards',
                icon: Icons.card_giftcard_rounded,
                color: const Color(0xFFEC4899),
                onTap: () async {
                  await Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const RewardsScreen()),
                  );
                  setState(() {});
                },
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: _suiteCard(
                context,
                title: 'Smart Alerts',
                subtitle: '${profile.dailyMinutes}m Habit Pings',
                icon: Icons.notifications_active_rounded,
                color: const Color(0xFF06B6D4),
                onTap: () {
                  PythonNotificationService.showNotificationCenterSheet(context, profile);
                },
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            Expanded(
              child: _suiteCard(
                context,
                title: 'Booklets',
                subtitle: 'Handbook & Notes',
                icon: Icons.auto_stories_rounded,
                color: const Color(0xFF6366F1),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const BookletScreen()),
                  );
                },
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: _suiteCard(
                context,
                title: 'QA Reviewer',
                subtitle: 'Admin Unlock Pass',
                icon: Icons.admin_panel_settings_rounded,
                color: const Color(0xFF10B981),
                onTap: () {
                  AdminLoginModal.show(context, onStateChanged: () => setState(() {}));
                },
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            Expanded(
              child: _suiteCard(
                context,
                title: 'Q&A Handbook',
                subtitle: '40+ Deep Architectural Q&A',
                icon: Icons.psychology_rounded,
                color: const Color(0xFFC89B58),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const QAHandbookScreen()),
                  );
                },
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: _suiteCard(
                context,
                title: 'Python Roadmap',
                subtitle: 'Visual Learning Trajectory',
                icon: Icons.alt_route_rounded,
                color: const Color(0xFF06B6D4),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const RoadmapScreen()),
                  );
                },
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _suiteCard(
    BuildContext context, {
    required String title,
    required String subtitle,
    required IconData icon,
    required Color color,
    VoidCallback? onTap,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF111827) : Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isDark ? const Color(0xFF1F2937) : const Color(0xFFE2E8F0),
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.03),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(9),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: color, size: 20),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: GoogleFonts.outfit(
                      fontWeight: FontWeight.bold,
                      fontSize: 13.5,
                      color: AppTheme.textPrimaryOf(context),
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.inter(
                      fontSize: 11,
                      color: AppTheme.textSecondaryOf(context),
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

  Widget _buildNextMission(BuildContext context, bool isDark, dynamic lesson) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: const Color(0xFFC89B58).withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(
                Icons.play_circle_fill_rounded,
                color: Color(0xFFC89B58),
                size: 16,
              ),
            ),
            const SizedBox(width: 8),
            Text(
              'RECOMMENDED NEXT STEP',
              style: GoogleFonts.outfit(
                color: const Color(0xFFC89B58),
                fontSize: 12,
                fontWeight: FontWeight.w800,
                letterSpacing: 1.2,
              ),
            ),
            const Spacer(),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF1E293B) : const Color(0xFFF1F5F9),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                (lesson.track as String).toUpperCase(),
                style: GoogleFonts.jetBrainsMono(
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                  color: AppTheme.textMutedOf(context),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        ThreeDTiltCard(
          borderRadius: BorderRadius.circular(18),
          elevation: 6,
          child: Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF111827) : Colors.white,
              borderRadius: BorderRadius.circular(18),
              border: Border.all(
                color: const Color(0xFFC89B58).withValues(alpha: isDark ? 0.35 : 0.25),
                width: 1.2,
              ),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFFC89B58).withValues(alpha: isDark ? 0.08 : 0.05),
                  blurRadius: 16,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            lesson.title,
                            style: GoogleFonts.outfit(
                              fontWeight: FontWeight.bold,
                              color: AppTheme.textPrimaryOf(context),
                              fontSize: 17,
                            ),
                          ),
                          const SizedBox(height: 5),
                          Text(
                            lesson.description,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: GoogleFonts.inter(
                              color: AppTheme.textSecondaryOf(context),
                              fontSize: 12.5,
                              height: 1.4,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 12),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                      decoration: BoxDecoration(
                        color: const Color(0xFFC89B58).withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: const Color(0xFFC89B58).withValues(alpha: 0.3),
                        ),
                      ),
                      child: Text(
                        '+${lesson.xp} XP',
                        style: GoogleFonts.jetBrainsMono(
                          color: const Color(0xFFC89B58),
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                Row(
                  children: [
                    if (lesson.videoDurationMinutes != null) ...[
                      Icon(Icons.timer_outlined, size: 14, color: AppTheme.textMutedOf(context)),
                      const SizedBox(width: 4),
                      Text(
                        '${lesson.videoDurationMinutes} min',
                        style: GoogleFonts.inter(
                          fontSize: 11.5,
                          color: AppTheme.textMutedOf(context),
                        ),
                      ),
                      const SizedBox(width: 12),
                    ],
                    Icon(
                      lesson.youtubeVideoId != null ? Icons.videocam_rounded : Icons.code_rounded,
                      size: 14,
                      color: AppTheme.textMutedOf(context),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      lesson.youtubeVideoId != null ? 'In-App Video + Code' : 'Interactive Sandbox',
                      style: GoogleFonts.inter(
                        fontSize: 11.5,
                        color: AppTheme.textMutedOf(context),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => LessonDetailScreen(lesson: lesson),
                            ),
                          ).then((_) => setState(() {}));
                        },
                        icon: const Icon(Icons.play_arrow_rounded, size: 18),
                        label: Text(
                          'Start Lesson Now',
                          style: GoogleFonts.outfit(
                            fontWeight: FontWeight.bold,
                            fontSize: 13.5,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFC89B58),
                          foregroundColor: const Color(0xFF17191C),
                          padding: const EdgeInsets.symmetric(vertical: 11),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          elevation: 0,
                        ),
                      ),
                    ),
                    if (widget.onNavigateToLessons != null) ...[
                      const SizedBox(width: 10),
                      OutlinedButton.icon(
                        onPressed: widget.onNavigateToLessons,
                        icon: const Icon(Icons.format_list_bulleted_rounded, size: 16),
                        label: Text(
                          'Curriculum',
                          style: GoogleFonts.inter(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: AppTheme.textSecondaryOf(context),
                          side: BorderSide(
                            color: isDark ? const Color(0xFF374151) : const Color(0xFFE2E8F0),
                          ),
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 11),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildQuickLaunchHubs(BuildContext context, bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: const Color(0xFF3B82F6).withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(
                Icons.hub_rounded,
                color: Color(0xFF3B82F6),
                size: 16,
              ),
            ),
            const SizedBox(width: 8),
            Text(
              'LEARNING STATIONS',
              style: GoogleFonts.outfit(
                color: AppTheme.textMutedOf(context),
                fontSize: 12,
                fontWeight: FontWeight.w800,
                letterSpacing: 1.2,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _hubCard(
                context,
                title: '32 Chapters',
                subtitle: 'Full Python Suite',
                badgeText: 'Active',
                icon: Icons.menu_book_rounded,
                color: const Color(0xFF6366F1),
                onTap: () {
                  if (widget.onNavigateToLessons != null) {
                    widget.onNavigateToLessons!();
                  }
                },
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: _hubCard(
                context,
                title: 'CPython IDE',
                subtitle: 'Live Code Sandbox',
                badgeText: 'Live',
                icon: Icons.terminal_rounded,
                color: const Color(0xFF10B981),
                onTap: () {
                  if (widget.onNavigateToPlayground != null) {
                    widget.onNavigateToPlayground!();
                  } else {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const PlaygroundScreen()),
                    );
                  }
                },
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            Expanded(
              child: _hubCard(
                context,
                title: 'Playbook',
                subtitle: 'Engineering Handbooks',
                badgeText: 'Docs',
                icon: Icons.architecture_rounded,
                color: const Color(0xFF8B5CF6),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const BookletScreen()),
                  );
                },
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: _hubCard(
                context,
                title: 'Q&A Prep',
                subtitle: '40+ Architecture Q&A',
                badgeText: 'Interview',
                icon: Icons.quiz_rounded,
                color: const Color(0xFFF59E0B),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const QAHandbookScreen()),
                  );
                },
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _hubCard(
    BuildContext context, {
    required String title,
    required String subtitle,
    required String badgeText,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF111827) : Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isDark ? const Color(0xFF1F2937) : const Color(0xFFE2E8F0),
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.03),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(icon, color: color, size: 20),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    badgeText,
                    style: GoogleFonts.jetBrainsMono(
                      color: color,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              title,
              style: GoogleFonts.outfit(
                fontWeight: FontWeight.bold,
                fontSize: 14,
                color: AppTheme.textPrimaryOf(context),
              ),
            ),
            const SizedBox(height: 2),
            Text(
              subtitle,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: GoogleFonts.inter(
                fontSize: 11,
                color: AppTheme.textSecondaryOf(context),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDailyTip(BuildContext context, bool isDark, dynamic tipData) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF0D1A0F) : const Color(0xFFF0FDF4),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppTheme.accentGreen.withValues(alpha: 0.3),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppTheme.accentGreen.withValues(alpha: 0.15),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.tips_and_updates_rounded, color: AppTheme.accentGreen, size: 18),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Daily Python Tip',
                      style: GoogleFonts.outfit(
                        color: AppTheme.accentGreen,
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      tipData.tip,
                      style: GoogleFonts.jetBrainsMono(
                        color: AppTheme.textSecondaryOf(context),
                        fontSize: 11.5,
                        height: 1.5,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Align(
            alignment: Alignment.centerRight,
            child: InkWell(
              borderRadius: BorderRadius.circular(8),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => PlaygroundScreen(initialCode: tipData.code),
                  ),
                );
              },
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  color: AppTheme.accentGreen.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: AppTheme.accentGreen.withValues(alpha: 0.3)),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.play_arrow_rounded, size: 14, color: AppTheme.accentGreen),
                    const SizedBox(width: 4),
                    Text(
                      'Run in Playground',
                      style: GoogleFonts.outfit(
                        color: AppTheme.accentGreen,
                        fontSize: 11.5,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatsRow(BuildContext context, bool isDark, dynamic profile, int completed) {
    return Row(
      children: [
        Expanded(child: _miniStat(context, Icons.bolt_rounded, '${profile.xp}', 'Total XP', const Color(0xFF3B82F6))),
        const SizedBox(width: 8),
        Expanded(child: _miniStat(context, Icons.local_fire_department_rounded, '${profile.streakDays}', 'Day Streak', const Color(0xFFF59E0B))),
        const SizedBox(width: 8),
        Expanded(child: _miniStat(context, Icons.menu_book_rounded, '$completed', 'Lessons', const Color(0xFF10B981))),
        const SizedBox(width: 8),
        Expanded(child: _miniStat(context, Icons.verified_rounded, '${StorageService.getCertificates().length}', 'Certs', const Color(0xFF8B5CF6))),
      ],
    );
  }

  Widget _miniStat(BuildContext context, IconData icon, String value, String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 8),
      decoration: BoxDecoration(
        color: AppTheme.cardOf(context),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppTheme.borderOf(context)),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 20),
          const SizedBox(height: 6),
          Text(
            value,
            style: GoogleFonts.jetBrainsMono(
              color: color,
              fontWeight: FontWeight.w900,
              fontSize: 18,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: GoogleFonts.inter(
              color: AppTheme.textMutedOf(context),
              fontSize: 10,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuizChallenge(BuildContext context, bool isDark, int totalQuestions) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Icon(Icons.bolt_rounded, color: Color(0xFFF59E0B), size: 18),
            const SizedBox(width: 8),
            Text(
              'QUIZ CHALLENGE',
              style: GoogleFonts.outfit(
                color: AppTheme.textMutedOf(context),
                fontSize: 12,
                fontWeight: FontWeight.w800,
                letterSpacing: 1.5,
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const CertificatesScreen(),
              ),
            ).then((_) => setState(() {}));
          },
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: isDark
                    ? [const Color(0xFF1A150A), const Color(0xFF131B2A)]
                    : [const Color(0xFFFFFBEB), Colors.white],
              ),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: const Color(0xFFF59E0B).withValues(alpha: 0.3),
              ),
            ),
            child: Row(
              children: [
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFFF59E0B), Color(0xFFD97706)],
                    ),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: const Center(
                    child: Icon(Icons.workspace_premium_rounded, color: Colors.white, size: 26),
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Official Certification Arena',
                        style: GoogleFonts.outfit(
                          fontWeight: FontWeight.bold,
                          color: AppTheme.textPrimaryOf(context),
                          fontSize: 15,
                        ),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        'Complete all 20 modules to qualify for credential',
                        style: GoogleFonts.inter(
                          color: AppTheme.textSecondaryOf(context),
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(Icons.arrow_forward_ios_rounded,
                    size: 16, color: AppTheme.textMutedOf(context)),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildAchievements(BuildContext context, bool isDark, dynamic profile) {
    final achievements = <Map<String, dynamic>>[
      {'icon': Icons.flag_outlined, 'title': 'First Steps', 'desc': 'Complete 1 lesson', 'unlocked': profile.completedLessonIds.length >= 1},
      {'icon': Icons.bolt_rounded, 'title': 'Code Runner', 'desc': 'Earn 50 XP', 'unlocked': profile.xp >= 50},
      {'icon': Icons.local_fire_department_rounded, 'title': 'On Fire', 'desc': '3 day streak', 'unlocked': profile.streakDays >= 3},
      {'icon': Icons.track_changes_rounded, 'title': 'Quiz Ace', 'desc': 'Pass 1 quiz', 'unlocked': profile.completedQuizIds.length >= 1},
      {'icon': Icons.verified_rounded, 'title': 'Certified', 'desc': 'Earn a certificate', 'unlocked': StorageService.getCertificates().isNotEmpty},
      {'icon': Icons.school_rounded, 'title': 'Scholar', 'desc': 'Complete 5 lessons', 'unlocked': profile.completedLessonIds.length >= 5},
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Icon(Icons.emoji_events_rounded, color: Color(0xFFC89B58), size: 18),
            const SizedBox(width: 8),
            Text(
              'ACHIEVEMENTS',
              style: GoogleFonts.outfit(
                color: AppTheme.textMutedOf(context),
                fontSize: 12,
                fontWeight: FontWeight.w800,
                letterSpacing: 1.5,
              ),
            ),
            const Spacer(),
            Text(
              '${achievements.where((a) => a['unlocked'] == true).length} / ${achievements.length}',
              style: GoogleFonts.jetBrainsMono(
                color: const Color(0xFFC89B58),
                fontWeight: FontWeight.bold,
                fontSize: 12,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            childAspectRatio: 0.76,
            crossAxisSpacing: 8,
            mainAxisSpacing: 8,
          ),
          itemCount: achievements.length,
          itemBuilder: (context, index) {
            final ach = achievements[index];
            final unlocked = ach['unlocked'] as bool;
            final icon = ach['icon'] as IconData;

            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 8),
              decoration: BoxDecoration(
                color: unlocked
                    ? (isDark ? const Color(0xFF1C2230) : const Color(0xFFF9F4EB))
                    : AppTheme.cardOf(context),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                  color: unlocked
                      ? const Color(0xFFC89B58).withValues(alpha: 0.4)
                      : AppTheme.borderOf(context),
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: unlocked
                          ? const Color(0xFFC89B58).withValues(alpha: 0.15)
                          : (isDark ? const Color(0xFF1E2430) : const Color(0xFFF1F5F9)),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      unlocked ? icon : Icons.lock_outline_rounded,
                      size: 20,
                      color: unlocked ? const Color(0xFFC89B58) : const Color(0xFF94A3B8),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    ach['title'] as String,
                    textAlign: TextAlign.center,
                    style: GoogleFonts.outfit(
                      color: unlocked
                          ? AppTheme.textPrimaryOf(context)
                          : AppTheme.textMutedOf(context),
                      fontWeight: FontWeight.bold,
                      fontSize: 11,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    ach['desc'] as String,
                    textAlign: TextAlign.center,
                    style: GoogleFonts.inter(
                      color: AppTheme.textMutedOf(context),
                      fontSize: 9.5,
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ],
    );
  }

  // Interactive Starter Guide Modal
  void _showStarterGuideSheet(BuildContext context, bool isDark) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(context).size.height * 0.88,
          ),
          padding: const EdgeInsets.fromLTRB(22, 16, 22, 28),
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF141822) : Colors.white,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
            border: Border.all(
              color: isDark ? const Color(0xFF232A3B) : const Color(0xFFEAE3D6),
              width: 1.2,
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 44,
                  height: 5,
                  decoration: BoxDecoration(
                    color: isDark ? const Color(0xFF334155) : const Color(0xFFD1D5DB),
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              const SizedBox(height: 18),

              Row(
                children: [
                  Container(
                    width: 38,
                    height: 38,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.asset('assets/images/app_logo.png'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'PyPocket Starter Guide',
                          style: GoogleFonts.outfit(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: isDark ? Colors.white : const Color(0xFF17191C),
                          ),
                        ),
                        Text(
                          'Your Step-by-Step Learning Roadmap',
                          style: GoogleFonts.inter(
                            fontSize: 12.5,
                            color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF6B7280),
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close_rounded),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              Expanded(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Column(
                    children: [
                      _guideStep(
                        step: '1',
                        icon: Icons.auto_stories_rounded,
                        title: 'Master Lessons Step-by-Step',
                        desc: 'Start with Chapter 1: Foundations & Python Memory Model. Each lesson has deep theory, video masterclasses, and runnable code exercises.',
                        isDark: isDark,
                      ),
                      const SizedBox(height: 12),
                      _guideStep(
                        step: '2',
                        icon: Icons.terminal_rounded,
                        title: 'Run Real Code in the Sandbox',
                        desc: 'Open the Code tab anytime. Write Python 3 scripts, test algorithms, and execute code in our high-speed CPython sandbox.',
                        isDark: isDark,
                      ),
                      const SizedBox(height: 12),
                      _guideStep(
                        step: '3',
                        icon: Icons.style_outlined,
                        title: 'Lock In Memory with 3D Flashcards',
                        desc: 'Use spaced repetition to memorize interview-grade Python concepts, OOP magic dunders, and Big-O complexities.',
                        isDark: isDark,
                      ),
                      const SizedBox(height: 12),
                      _guideStep(
                        step: '4',
                        icon: Icons.menu_book_rounded,
                        title: 'Read Digital Handbooks',
                        desc: 'Explore comprehensive programming booklets with structured chapters, code execution, and architectural takeaways.',
                        isDark: isDark,
                      ),
                      const SizedBox(height: 12),
                      _guideStep(
                        step: '5',
                        icon: Icons.workspace_premium_rounded,
                        title: 'Earn Verified Certification',
                        desc: 'Complete all 20 lessons and take the final algorithmic assessment to unlock your official verified certificate.',
                        isDark: isDark,
                      ),
                      const SizedBox(height: 12),
                      _guideStep(
                        step: '6',
                        icon: Icons.notifications_active_outlined,
                        title: 'Protect Your Daily Streak',
                        desc: 'Set aside your chosen daily minutes. Our 100 smart system notifications will give you daily prompts to keep your fire lit.',
                        isDark: isDark,
                      ),
                      const SizedBox(height: 24),

                      // CTA Button
                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.pop(context);
                            widget.onNavigateToLessons?.call();
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFC89B58),
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                          ),
                          child: Text(
                            'Go to Lessons & Start Learning →',
                            style: GoogleFonts.outfit(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _guideStep({
    required String step,
    required IconData icon,
    required String title,
    required String desc,
    required bool isDark,
  }) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1A202C) : const Color(0xFFFAF7F2),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark ? const Color(0xFF2D3748) : const Color(0xFFEAE3D6),
          width: 1,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: const Color(0xFFC89B58).withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: const Color(0xFFC89B58), size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.outfit(
                    fontSize: 14.5,
                    fontWeight: FontWeight.bold,
                    color: isDark ? Colors.white : const Color(0xFF17191C),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  desc,
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    height: 1.45,
                    color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF5A6372),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
