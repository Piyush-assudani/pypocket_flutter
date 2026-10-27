import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../services/storage_service.dart';
import '../services/database_service.dart';
import '../models/user_profile_model.dart';
import '../theme/app_theme.dart';
import 'db_setup_screen.dart';
import 'certificates_screen.dart';
import 'profile_edit_screen.dart';
import 'roadmap_screen.dart';
import 'flashcards_screen.dart';
import 'cheatsheet_screen.dart';
import 'rewards_screen.dart';
import '../services/notification_service.dart';
import '../widgets/executive_avatar.dart';
import '../widgets/admin_login_modal.dart';
import '../widgets/three_d_tilt_card.dart';
import 'booklet_screen.dart';
import 'qa_handbook_screen.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/services.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late UserProfile _profile;

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  void _loadProfile() {
    setState(() {
      _profile = StorageService.getUserProfile();
    });
  }

  void _openEditProfile() async {
    final updated = await Navigator.push<UserProfile>(
      context,
      MaterialPageRoute(
        builder: (context) => ProfileEditScreen(currentProfile: _profile),
      ),
    );
    if (updated != null) {
      setState(() => _profile = updated);
    }
  }

  @override
  Widget build(BuildContext context) {
    final certCount = StorageService.getCertificates().length;
    final snippetCount = StorageService.getSnippets().length;
    final isCloudSynced = DatabaseService.isConfigured;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'PyPocket Profile',
          style: GoogleFonts.outfit(fontWeight: FontWeight.bold, fontSize: 19),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit_note_rounded),
            tooltip: 'Edit Profile',
            onPressed: _openEditProfile,
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Theme Mode Toggle Segment Bar
            Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF131B2A) : const Color(0xFFE2E8F0),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: AppTheme.borderOf(context)),
              ),
              child: ValueListenableBuilder<ThemeMode>(
                valueListenable: AppTheme.themeModeNotifier,
                builder: (context, currentMode, _) {
                  return Row(
                    children: [
                      _themeButton(ThemeMode.light, Icons.light_mode_rounded, 'Light', currentMode),
                      _themeButton(ThemeMode.dark, Icons.dark_mode_rounded, 'Dark', currentMode),
                      _themeButton(ThemeMode.system, Icons.brightness_auto_rounded, 'System', currentMode),
                    ],
                  );
                },
              ),
            ),
            const SizedBox(height: 16),

            // 3D Profile Holographic Passport Card
            ThreeDTiltCard(
              borderRadius: BorderRadius.circular(20),
              elevation: 6,
              child: Container(
                padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: isDark
                      ? [const Color(0xFF1E293B), const Color(0xFF0F172A)]
                      : [Colors.white, const Color(0xFFF1F5F9)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: AppTheme.borderOf(context)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: isDark ? 0.3 : 0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Center(
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        ExecutiveAvatarWidget(
                          avatarId: _profile.avatarId,
                          size: 78,
                          showBadge: true,
                        ),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: InkWell(
                            onTap: _openEditProfile,
                            child: Container(
                              padding: const EdgeInsets.all(5),
                              decoration: const BoxDecoration(
                                color: Color(0xFF2563EB),
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(Icons.edit, size: 13, color: Colors.white),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),

                  Text(
                    _profile.userName,
                    style: GoogleFonts.outfit(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.textPrimaryOf(context),
                    ),
                  ),
                  const SizedBox(height: 4),

                  if (_profile.bio.isNotEmpty) ...[
                    Text(
                      _profile.bio,
                      textAlign: TextAlign.center,
                      style: GoogleFonts.inter(
                        color: AppTheme.textSecondaryOf(context),
                        fontSize: 13,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                    const SizedBox(height: 8),
                  ],

                  // Badges Row
                  Wrap(
                    spacing: 8,
                    runSpacing: 6,
                    alignment: WrapAlignment.center,
                    children: [
                      _badgeChip('Level ${_profile.level}', const Color(0xFFF59E0B)),
                      _badgeChip(_profile.rankTitle, const Color(0xFF10B981)),
                      _badgeChip(_profile.skillLevel, const Color(0xFF2563EB)),
                      _badgeChip('${_profile.dailyMinutes}m Target', const Color(0xFF8B5CF6)),
                    ],
                  ),

                  // Contact Details (Email & Phone)
                  if (_profile.email.isNotEmpty || _profile.mobileNumber.isNotEmpty) ...[
                    const SizedBox(height: 10),
                    Wrap(
                      spacing: 12,
                      runSpacing: 4,
                      alignment: WrapAlignment.center,
                      children: [
                        if (_profile.email.isNotEmpty)
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(Icons.email_outlined, size: 13, color: Color(0xFF64748B)),
                              const SizedBox(width: 4),
                              Text(
                                _profile.email,
                                style: GoogleFonts.inter(fontSize: 11.5, color: const Color(0xFF64748B)),
                              ),
                            ],
                          ),
                        if (_profile.mobileNumber.isNotEmpty)
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(Icons.phone_iphone_rounded, size: 13, color: Color(0xFF64748B)),
                              const SizedBox(width: 4),
                              Text(
                                _profile.mobileNumber,
                                style: GoogleFonts.inter(fontSize: 11.5, color: const Color(0xFF64748B)),
                              ),
                            ],
                          ),
                      ],
                    ),
                  ],

                  if (_profile.githubHandle.isNotEmpty) ...[
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.code_rounded, size: 14, color: AppTheme.pythonBlue),
                        const SizedBox(width: 4),
                        Text(
                          'github.com/${_profile.githubHandle}',
                          style: GoogleFonts.jetBrainsMono(
                            fontSize: 11.5,
                            color: AppTheme.pythonBlue,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ],

                  const SizedBox(height: 16),

                  // Level Progress Bar
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Level ${_profile.level} XP Progress',
                            style: GoogleFonts.inter(color: AppTheme.textSecondaryOf(context), fontSize: 12),
                          ),
                          Text(
                            '${(_profile.levelProgress * 100).toInt()}%',
                            style: GoogleFonts.jetBrainsMono(
                              color: AppTheme.textPrimaryOf(context),
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(6),
                        child: LinearProgressIndicator(
                          value: _profile.levelProgress,
                          minHeight: 6,
                          backgroundColor: isDark ? const Color(0xFF1E293B) : const Color(0xFFE2E8F0),
                          valueColor: const AlwaysStoppedAnimation<Color>(AppTheme.pythonBlue),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            ),
            const SizedBox(height: 16),

            // Executive Stats Grid (Clean 3D Vector Cards, Zero Cartoon Emojis)
            Row(
              children: [
                Expanded(child: _statCard(Icons.local_fire_department_rounded, 'STREAK', '${_profile.streakDays} Days', const Color(0xFFF59E0B))),
                const SizedBox(width: 10),
                Expanded(child: _statCard(Icons.bolt_rounded, 'TOTAL XP', '${_profile.xp} XP', const Color(0xFF2563EB))),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(child: _statCard(Icons.terminal_rounded, 'LESSONS', '${_profile.completedLessonIds.length} / 20', const Color(0xFF10B981))),
                const SizedBox(width: 10),
                Expanded(child: _statCard(Icons.verified_rounded, 'CREDENTIALS', '$certCount Earned', const Color(0xFF8B5CF6))),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(child: _statCard(Icons.code_rounded, 'SAVED SCRIPTS', '$snippetCount Scripts', const Color(0xFF06B6D4))),
                const SizedBox(width: 10),
                Expanded(child: _statCard(Icons.track_changes_rounded, 'CURRENT GOAL', _profile.skillLevel, const Color(0xFFEAB308))),
              ],
            ),
            const SizedBox(height: 20),

            // Bonus Rewards Hub Card
            InkWell(
              borderRadius: BorderRadius.circular(16),
              onTap: () async {
                await Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const RewardsScreen()),
                );
                _loadProfile();
              },
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: isDark
                        ? [const Color(0xFF3B0764).withValues(alpha: 0.5), const Color(0xFF1E1B4B).withValues(alpha: 0.5)]
                        : [const Color(0xFFFDF2F8), const Color(0xFFF5F3FF)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: isDark ? const Color(0xFF701A75) : const Color(0xFFF472B6).withValues(alpha: 0.4),
                  ),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: const Color(0xFFEC4899).withValues(alpha: 0.15),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.card_giftcard_rounded,
                        color: Color(0xFFEC4899),
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                'Bonus Reward Quests',
                                style: GoogleFonts.outfit(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15,
                                  color: AppTheme.textPrimaryOf(context),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFEC4899).withValues(alpha: 0.15),
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Text(
                                  '+820 XP',
                                  style: GoogleFonts.outfit(
                                    fontSize: 10,
                                    fontWeight: FontWeight.w800,
                                    color: const Color(0xFFEC4899),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 2),
                          Text(
                            '${_profile.claimedTaskIds.length} of 10 completed • Follow, Review & Star',
                            style: GoogleFonts.inter(
                              color: AppTheme.textSecondaryOf(context),
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Icon(Icons.chevron_right_rounded, color: Color(0xFFEC4899)),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12),

            // Daily Notifications Hub Card
            InkWell(
              borderRadius: BorderRadius.circular(16),
              onTap: () {
                PythonNotificationService.showNotificationCenterSheet(context, _profile);
              },
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppTheme.cardOf(context),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppTheme.borderOf(context)),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: const Color(0xFF06B6D4).withValues(alpha: 0.15),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.notifications_active_rounded,
                        color: Color(0xFF06B6D4),
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Smart Developer Notifications',
                            style: GoogleFonts.outfit(
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                              color: AppTheme.textPrimaryOf(context),
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            '5 daily witty habit reminders • ${_profile.dailyMinutes} mins target',
                            style: GoogleFonts.inter(
                              color: AppTheme.textSecondaryOf(context),
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Icon(Icons.chevron_right_rounded, color: AppTheme.textMutedOf(context)),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12),

            // Cloud Database Settings Link Card
            InkWell(
              borderRadius: BorderRadius.circular(16),
              onTap: () async {
                await Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const DbSetupScreen()),
                );
                _loadProfile();
              },
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppTheme.cardOf(context),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: isCloudSynced ? AppTheme.accentGreen.withValues(alpha: 0.5) : AppTheme.borderOf(context),
                  ),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: (isCloudSynced ? AppTheme.accentGreen : AppTheme.pythonBlue).withValues(alpha: 0.15),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        isCloudSynced ? Icons.cloud_done_rounded : Icons.cloud_queue_rounded,
                        color: isCloudSynced ? AppTheme.accentGreen : AppTheme.pythonBlue,
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Supabase Cloud Database',
                            style: GoogleFonts.outfit(
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                              color: AppTheme.textPrimaryOf(context),
                            ),
                          ),
                          Text(
                            isCloudSynced ? 'Connected & Live Sync Active' : 'Setup Free Cloud Database Sync',
                            style: GoogleFonts.inter(
                              color: isCloudSynced ? AppTheme.accentGreen : AppTheme.textSecondaryOf(context),
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Icon(Icons.chevron_right_rounded, color: AppTheme.textMutedOf(context)),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12),

            // Certificates link
            InkWell(
              borderRadius: BorderRadius.circular(16),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const CertificatesScreen()),
                );
              },
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppTheme.cardOf(context),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppTheme.borderOf(context)),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.amber.withValues(alpha: 0.15),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.workspace_premium_rounded, color: AppTheme.pythonYellow, size: 24),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'My Certifications',
                            style: GoogleFonts.outfit(
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                              color: AppTheme.textPrimaryOf(context),
                            ),
                          ),
                          Text(
                            'View and share verified credentials ($certCount)',
                            style: GoogleFonts.inter(color: AppTheme.textSecondaryOf(context), fontSize: 12),
                          ),
                        ],
                      ),
                    ),
                    Icon(Icons.chevron_right_rounded, color: AppTheme.textMutedOf(context)),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12),

            // Roadmap link
            InkWell(
              borderRadius: BorderRadius.circular(16),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const RoadmapScreen()),
                );
              },
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppTheme.cardOf(context),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppTheme.borderOf(context)),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: const Color(0xFF8B5CF6).withValues(alpha: 0.15),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.alt_route_rounded, color: Color(0xFF8B5CF6), size: 24),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Python Career Roadmap',
                            style: GoogleFonts.outfit(
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                              color: AppTheme.textPrimaryOf(context),
                            ),
                          ),
                          Text(
                            'Track milestone stages & learning progression',
                            style: GoogleFonts.inter(color: AppTheme.textSecondaryOf(context), fontSize: 12),
                          ),
                        ],
                      ),
                    ),
                    Icon(Icons.chevron_right_rounded, color: AppTheme.textMutedOf(context)),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12),

            // Flashcards link
            InkWell(
              borderRadius: BorderRadius.circular(16),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const FlashcardsScreen()),
                );
              },
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppTheme.cardOf(context),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppTheme.borderOf(context)),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF59E0B).withValues(alpha: 0.15),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.flash_on_rounded, color: Color(0xFFF59E0B), size: 24),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Python Flashcards',
                            style: GoogleFonts.outfit(
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                              color: AppTheme.textPrimaryOf(context),
                            ),
                          ),
                          Text(
                            'Spaced repetition concept mastery & Big-O trainer',
                            style: GoogleFonts.inter(color: AppTheme.textSecondaryOf(context), fontSize: 12),
                          ),
                        ],
                      ),
                    ),
                    Icon(Icons.chevron_right_rounded, color: AppTheme.textMutedOf(context)),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12),

            // Syntax Hub Cheat Sheet Link
            InkWell(
              borderRadius: BorderRadius.circular(16),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const CheatSheetScreen()),
                );
              },
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppTheme.cardOf(context),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppTheme.borderOf(context)),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: const Color(0xFF38BDF8).withValues(alpha: 0.15),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.menu_book_rounded, color: Color(0xFF38BDF8), size: 24),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Python Syntax Hub & Cheat Sheet',
                            style: GoogleFonts.outfit(
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                              color: AppTheme.textPrimaryOf(context),
                            ),
                          ),
                          Text(
                            'Searchable quick reference, dunder methods & Big-O guide',
                            style: GoogleFonts.inter(color: AppTheme.textSecondaryOf(context), fontSize: 12),
                          ),
                        ],
                      ),
                    ),
                    Icon(Icons.chevron_right_rounded, color: AppTheme.textMutedOf(context)),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12),

            // Python Digital Booklets & Handbooks Link
            InkWell(
              borderRadius: BorderRadius.circular(16),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const BookletScreen()),
                );
              },
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppTheme.cardOf(context),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppTheme.borderOf(context)),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: const Color(0xFF6366F1).withValues(alpha: 0.15),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.auto_stories_rounded, color: Color(0xFF6366F1), size: 24),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Python Booklets & Notes Handbook',
                            style: GoogleFonts.outfit(
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                              color: AppTheme.textPrimaryOf(context),
                            ),
                          ),
                          Text(
                            'Structured digital chapters, memory rules & runnable snippets',
                            style: GoogleFonts.inter(color: AppTheme.textSecondaryOf(context), fontSize: 12),
                          ),
                        ],
                      ),
                    ),
                    Icon(Icons.chevron_right_rounded, color: AppTheme.textMutedOf(context)),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12),

            // Python Q&A & Interview Playbook Link
            InkWell(
              borderRadius: BorderRadius.circular(16),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const QAHandbookScreen()),
                );
              },
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppTheme.cardOf(context),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppTheme.borderOf(context)),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: const Color(0xFF10B981).withValues(alpha: 0.15),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.psychology_rounded, color: Color(0xFF10B981), size: 24),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Engineering Q&A Playbook',
                            style: GoogleFonts.outfit(
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                              color: AppTheme.textPrimaryOf(context),
                            ),
                          ),
                          Text(
                            'Staff-level architectural trade-offs, GIL & internals',
                            style: GoogleFonts.inter(color: AppTheme.textSecondaryOf(context), fontSize: 12),
                          ),
                        ],
                      ),
                    ),
                    Icon(Icons.chevron_right_rounded, color: AppTheme.textMutedOf(context)),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12),

            // Edit Profile Button
            OutlinedButton.icon(
              onPressed: _openEditProfile,
              icon: const Icon(Icons.tune_rounded),
              label: const Text('Customize Full Profile & Goal'),
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 14),
              ),
            ),
            const SizedBox(height: 18),

            // Founder & Engineering Credits Section
            _buildFounderCreditsCard(context, isDark),
            const SizedBox(height: 20),

            // Play Store Reviewer & QA Backdoor Mode Access Point
            Center(
              child: InkWell(
                onTap: () {
                  AdminLoginModal.show(
                    context,
                    onStateChanged: _loadProfile,
                  );
                },
                borderRadius: BorderRadius.circular(8),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.bug_report_outlined,
                        size: 14,
                        color: Color(0xFF64748B),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        'Play Store Reviewer & QA Bypass (Tap to Open)',
                        style: GoogleFonts.jetBrainsMono(
                          fontSize: 11,
                          color: const Color(0xFF64748B),
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget _themeButton(ThemeMode mode, IconData icon, String label, ThemeMode current) {
    final isSelected = current == mode;
    return Expanded(
      child: InkWell(
        borderRadius: BorderRadius.circular(10),
        onTap: () => StorageService.setThemeMode(mode),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 9),
          decoration: BoxDecoration(
            color: isSelected ? AppTheme.pythonBlue : Colors.transparent,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 15, color: isSelected ? Colors.white : AppTheme.textSecondaryOf(context)),
              const SizedBox(width: 6),
              Text(
                label,
                style: GoogleFonts.outfit(
                  color: isSelected ? Colors.white : AppTheme.textSecondaryOf(context),
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                  fontSize: 12.5,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _badgeChip(String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withValues(alpha: 0.4)),
      ),
      child: Text(
        text,
        style: GoogleFonts.outfit(
          color: color,
          fontWeight: FontWeight.bold,
          fontSize: 11.5,
        ),
      ),
    );
  }

  Widget _statCard(IconData icon, String label, String value, Color color) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppTheme.cardOf(context),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppTheme.borderOf(context), width: 1.1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.25 : 0.03),
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
              Container(
                padding: const EdgeInsets.all(7),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: color.withValues(alpha: 0.25), width: 0.8),
                ),
                child: Icon(icon, size: 16, color: color),
              ),
              Text(
                label,
                style: GoogleFonts.outfit(
                  color: AppTheme.textMutedOf(context),
                  fontSize: 10,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 0.8,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: GoogleFonts.jetBrainsMono(
              color: AppTheme.textPrimaryOf(context),
              fontSize: 16,
              fontWeight: FontWeight.bold,
              letterSpacing: -0.4,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFounderCreditsCard(BuildContext context, bool isDark) {
    final cardBg = isDark ? const Color(0xFF141923) : Colors.white;
    final borderColor = isDark ? const Color(0xFF2B3245) : const Color(0xFFE8E0D5);
    final textPrimary = isDark ? Colors.white : const Color(0xFF17191C);
    final textSecondary = isDark ? const Color(0xFF94A3B8) : const Color(0xFF5A6372);
    final bronzeColor = const Color(0xFFC89B58);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: borderColor, width: 1.2),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.25 : 0.04),
            blurRadius: 18,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Bronze Category Tag
          Row(
            children: [
              Container(
                width: 6,
                height: 6,
                decoration: const BoxDecoration(
                  color: Color(0xFFC89B58),
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                'FOUNDER & ARCHITECT ATTRIBUTION',
                style: GoogleFonts.outfit(
                  fontSize: 10.5,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 1.8,
                  color: bronzeColor,
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),

          // Founder Header Row
          Row(
            children: [
              Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFFC89B58), Color(0xFF9E7238)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: bronzeColor.withValues(alpha: 0.35),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: const Center(
                  child: Text(
                    'PA',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 1,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Flexible(
                          child: Text(
                            'Piyush Assudani',
                            style: GoogleFonts.outfit(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: textPrimary,
                              letterSpacing: -0.3,
                            ),
                          ),
                        ),
                        const SizedBox(width: 6),
                        const Icon(
                          Icons.verified_rounded,
                          size: 16,
                          color: Color(0xFF38BDF8),
                        ),
                      ],
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Founder of Assudani Group',
                      style: GoogleFonts.inter(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: bronzeColor,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),

          // Description
          Text(
            'PyPocket was conceptualized and engineered by Piyush Assudani to deliver elite, high-performance Python instruction with native interactive sandboxes, verified engineering certs, and real-world system architecture.',
            style: GoogleFonts.inter(
              fontSize: 12.5,
              height: 1.5,
              color: textSecondary,
            ),
          ),
          const SizedBox(height: 18),

          // 4 Redirection Links
          _buildFounderLinkTile(
            icon: Icons.language_rounded,
            title: 'piyushassudani.in',
            subtitle: 'Personal Portfolio & Engineering Hub',
            url: 'https://piyushassudani.in',
            isDark: isDark,
          ),
          const SizedBox(height: 8),
          _buildFounderLinkTile(
            icon: Icons.apartment_rounded,
            title: 'assudanigroup.online',
            subtitle: 'Assudani Group Official Enterprise',
            url: 'https://assudanigroup.online',
            isDark: isDark,
          ),
          const SizedBox(height: 8),
          _buildFounderLinkTile(
            icon: Icons.work_outline_rounded,
            title: 'LinkedIn',
            subtitle: 'in/piyush-assudani96',
            url: 'https://www.linkedin.com/in/piyush-assudani96/',
            isDark: isDark,
          ),
          const SizedBox(height: 8),
          _buildFounderLinkTile(
            icon: Icons.camera_alt_outlined,
            title: 'Instagram',
            subtitle: '@assudani_group',
            url: 'https://www.instagram.com/assudani_group/',
            isDark: isDark,
          ),
        ],
      ),
    );
  }

  Widget _buildFounderLinkTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required String url,
    required bool isDark,
  }) {
    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: () => _openExternalUrl(url),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF1B2230) : const Color(0xFFF9F6F0),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isDark ? const Color(0xFF283245) : const Color(0xFFE8DFD3),
          ),
        ),
        child: Row(
          children: [
            Icon(icon, size: 18, color: const Color(0xFFC89B58)),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: GoogleFonts.outfit(
                      fontSize: 13.5,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.textPrimaryOf(context),
                    ),
                  ),
                  Text(
                    subtitle,
                    style: GoogleFonts.inter(
                      fontSize: 11,
                      color: AppTheme.textSecondaryOf(context),
                    ),
                  ),
                ],
              ),
            ),
            const Icon(
              Icons.open_in_new_rounded,
              size: 15,
              color: Color(0xFFC89B58),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _openExternalUrl(String urlString) async {
    final uri = Uri.parse(urlString);
    try {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } catch (_) {
      await Clipboard.setData(ClipboardData(text: urlString));
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Link copied to clipboard: $urlString')),
        );
      }
    }
  }
}
