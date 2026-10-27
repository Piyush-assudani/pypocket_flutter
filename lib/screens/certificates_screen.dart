import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/certificate_model.dart';
import '../services/storage_service.dart';
import '../theme/app_theme.dart';
import '../widgets/xp_badge.dart';
import '../widgets/three_d_tilt_card.dart';
import 'package:intl/intl.dart';
import '../data/python_lessons_data.dart';
import 'quiz_screen.dart';
import 'lessons_screen.dart';
import 'fullscreen_certificate_screen.dart';
import '../services/certificate_pdf_service.dart';

class CertificatesScreen extends StatefulWidget {
  const CertificatesScreen({super.key});

  @override
  State<CertificatesScreen> createState() => _CertificatesScreenState();
}

class _CertificatesScreenState extends State<CertificatesScreen> {
  late List<Certificate> _certificates;
  int _secretTapCount = 0;
  DateTime? _lastTapTime;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  void _loadData() {
    setState(() {
      _certificates = StorageService.getCertificates();
    });
  }

  void _handleSecretTap() {
    final now = DateTime.now();
    if (_lastTapTime == null || now.difference(_lastTapTime!) > const Duration(seconds: 2)) {
      _secretTapCount = 1;
    } else {
      _secretTapCount++;
    }
    _lastTapTime = now;

    if (_secretTapCount >= 5) {
      _secretTapCount = 0;
      HapticFeedback.heavyImpact();
      _showBackdoorDialog();
    }
  }

  void _showBackdoorDialog() {
    final profile = StorageService.getUserProfile();
    final allLessonIds = PythonLessonsData.lessons.map((l) => l.id).toList();

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppTheme.surfaceOf(context),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: const BorderSide(color: Color(0xFF3B82F6), width: 1.5),
        ),
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: const Color(0xFF3B82F6).withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(Icons.admin_panel_settings_rounded, color: Color(0xFF3B82F6), size: 22),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Play Store QA Backdoor',
                    style: GoogleFonts.outfit(
                      fontWeight: FontWeight.bold,
                      fontSize: 17,
                      color: AppTheme.textPrimaryOf(context),
                    ),
                  ),
                  Text(
                    'Instant state bypass for testing & review',
                    style: GoogleFonts.inter(fontSize: 11.5, color: AppTheme.textMutedOf(context)),
                  ),
                ],
              ),
            ),
          ],
        ),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Use these controls to verify certification, max levels, or reset progress without completing the entire 20-lesson curriculum manually:',
                style: GoogleFonts.inter(fontSize: 12.5, color: AppTheme.textSecondaryOf(context)),
              ),
              const SizedBox(height: 16),

              // Button 1: Complete All Lessons
              ElevatedButton.icon(
                onPressed: () async {
                  Navigator.pop(ctx);
                  await StorageService.markAllLessonsCompleted(allLessonIds);
                  _loadData();
                  if (mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('QA Bypass: All curriculum lessons marked 100% completed! Exam unlocked.'),
                        backgroundColor: Color(0xFF10B981),
                      ),
                    );
                  }
                },
                icon: const Icon(Icons.fact_check_rounded, size: 18),
                label: const Text('Unlock 100% Curriculum (All Lessons)'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF10B981),
                  foregroundColor: Colors.black,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
              ),
              const SizedBox(height: 10),

              // Button 2: Issue Instant Certificate
              ElevatedButton.icon(
                onPressed: () async {
                  Navigator.pop(ctx);
                  await StorageService.issueTestCertificate(profile.userName, score: 96);
                  _loadData();
                  if (mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('QA Bypass: Verified Certificate generated & saved to wallet!'),
                        backgroundColor: Color(0xFFF59E0B),
                      ),
                    );
                  }
                },
                icon: const Icon(Icons.workspace_premium_rounded, size: 18),
                label: const Text('Issue Verified Certificate (Instant)'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFF59E0B),
                  foregroundColor: Colors.black,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
              ),
              const SizedBox(height: 10),

              // Button 3: Grandmaster Tier
              OutlinedButton.icon(
                onPressed: () async {
                  Navigator.pop(ctx);
                  await StorageService.setTesterStats(xp: 3500, streak: 30);
                  _loadData();
                  if (mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('QA Bypass: Set 3,500 XP & 30-Day Streak (Grandmaster Tier)')),
                    );
                  }
                },
                icon: const Icon(Icons.bolt_rounded, size: 18),
                label: const Text('Set Grandmaster Stats (3,500 XP)'),
                style: OutlinedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 12)),
              ),
              const SizedBox(height: 10),

              // Button 4: Reset All Progress
              OutlinedButton.icon(
                onPressed: () async {
                  Navigator.pop(ctx);
                  await StorageService.resetAllProgress();
                  _loadData();
                  if (mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Reset Complete: All progress cleared to 0% for clean testing.'),
                        backgroundColor: AppTheme.errorRed,
                      ),
                    );
                  }
                },
                icon: const Icon(Icons.restart_alt_rounded, size: 18, color: AppTheme.errorRed),
                label: const Text('Reset All Progress to 0 (Clean Test)', style: TextStyle(color: AppTheme.errorRed)),
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: AppTheme.errorRed),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Close Panel'),
          ),
        ],
      ),
    );
  }

  void _openCertificateModal(Certificate cert) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => FullScreenCertificateScreen(certificate: cert),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final profile = StorageService.getUserProfile();
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final allLessons = PythonLessonsData.lessons;
    final completedCount = allLessons.where((l) => profile.completedLessonIds.contains(l.id)).length;
    final isCurriculumComplete = allLessons.isNotEmpty && completedCount >= allLessons.length;
    final progressPercent = allLessons.isEmpty ? 0 : ((completedCount / allLessons.length) * 100).toInt();

    return Scaffold(
      appBar: AppBar(
        title: GestureDetector(
          onTap: _handleSecretTap,
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: Colors.amber.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(Icons.workspace_premium_rounded, color: AppTheme.pythonYellow, size: 20),
              ),
              const SizedBox(width: 10),
              Text(
                'Certificates',
                style: GoogleFonts.outfit(fontWeight: FontWeight.bold, fontSize: 19),
              ),
            ],
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(isDark ? Icons.light_mode_rounded : Icons.dark_mode_rounded, size: 20),
            onPressed: () {
              final newMode = isDark ? ThemeMode.light : ThemeMode.dark;
              StorageService.setThemeMode(newMode);
            },
          ),
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: XpBadge(xp: profile.xp, streakDays: profile.streakDays),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        physics: const BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Certification Exam Card (Locked vs Unlocked based on 100% Curriculum Completion)
            ThreeDTiltCard(
              borderRadius: BorderRadius.circular(20),
              elevation: 8,
              child: Container(
                padding: const EdgeInsets.all(22),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: isCurriculumComplete
                        ? (isDark
                            ? [const Color(0xFF1E293B), const Color(0xFF0F172A)]
                            : [const Color(0xFFFFFBEB), Colors.white])
                        : (isDark
                            ? [const Color(0xFF131B2A), const Color(0xFF090D16)]
                            : [const Color(0xFFF1F5F9), Colors.white]),
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: isCurriculumComplete
                        ? const Color(0xFFF59E0B).withValues(alpha: isDark ? 0.6 : 0.8)
                        : (isDark ? const Color(0xFF334155) : const Color(0xFFCBD5E1)),
                    width: isCurriculumComplete ? 1.5 : 1,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: isCurriculumComplete
                                ? const Color(0xFFF59E0B).withValues(alpha: 0.18)
                                : Colors.grey.withValues(alpha: 0.15),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            isCurriculumComplete ? Icons.workspace_premium_rounded : Icons.lock_outline_rounded,
                            color: isCurriculumComplete ? const Color(0xFFF59E0B) : Colors.grey,
                            size: 24,
                          ),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                isCurriculumComplete
                                    ? 'Certification Exam Unlocked'
                                    : 'Certification Exam (Locked)',
                                style: GoogleFonts.outfit(
                                  color: AppTheme.textPrimaryOf(context),
                                  fontWeight: FontWeight.bold,
                                  fontSize: 17,
                                ),
                              ),
                              Text(
                                isCurriculumComplete
                                    ? 'Curriculum Mastered · Ready for Official Evaluation'
                                    : 'Prerequisite: 100% Curriculum Completion Required',
                                style: GoogleFonts.inter(
                                  color: isCurriculumComplete ? const Color(0xFF10B981) : AppTheme.textMutedOf(context),
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // Curriculum Progress Bar
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Curriculum Mastery Progress:',
                          style: GoogleFonts.inter(
                            fontSize: 12.5,
                            fontWeight: FontWeight.w500,
                            color: AppTheme.textSecondaryOf(context),
                          ),
                        ),
                        Text(
                          '$completedCount / ${allLessons.length} Modules ($progressPercent%)',
                          style: GoogleFonts.jetBrainsMono(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: isCurriculumComplete ? const Color(0xFF10B981) : AppTheme.pythonYellow,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(6),
                      child: LinearProgressIndicator(
                        value: allLessons.isEmpty ? 0 : completedCount / allLessons.length,
                        minHeight: 8,
                        backgroundColor: isDark ? const Color(0xFF1E293B) : const Color(0xFFE2E8F0),
                        valueColor: AlwaysStoppedAnimation<Color>(
                          isCurriculumComplete ? const Color(0xFF10B981) : const Color(0xFFF59E0B),
                        ),
                      ),
                    ),
                    const SizedBox(height: 14),

                    // Explanation Notice
                    Text(
                      isCurriculumComplete
                          ? 'You have completed all ${allLessons.length} modules! Score 70% or higher on this comprehensive industry assessment to receive your official verified digital credential with cryptographic verification ID.'
                          : 'To protect credential integrity and industry value, you must complete all ${allLessons.length} lessons before taking the exam. You have ${allLessons.length - completedCount} modules left to master.',
                      style: GoogleFonts.inter(
                        color: AppTheme.textSecondaryOf(context),
                        fontSize: 13,
                        height: 1.5,
                      ),
                    ),
                    const SizedBox(height: 18),

                    // Main Action Button
                    if (isCurriculumComplete)
                      ElevatedButton.icon(
                        onPressed: () async {
                          await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const QuizScreen(isCertificationExam: true),
                            ),
                          );
                          _loadData();
                        },
                        icon: const Icon(Icons.play_circle_fill_rounded),
                        label: Text(
                          _certificates.isEmpty
                              ? 'Take Exam & Unlock Certificate'
                              : 'Retake Exam for Higher Distinction',
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFF59E0B),
                          foregroundColor: Colors.black,
                          minimumSize: const Size(double.infinity, 48),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                      )
                    else
                      Row(
                        children: [
                          Expanded(
                            child: ElevatedButton.icon(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (_) => const LessonsScreen()),
                                );
                              },
                              icon: const Icon(Icons.school_rounded, size: 18),
                              label: const Text('Complete Lessons to Unlock'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: isDark ? const Color(0xFF1E293B) : const Color(0xFF0F172A),
                                foregroundColor: Colors.white,
                                minimumSize: const Size(0, 48),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                              ),
                            ),
                          ),
                        ],
                      ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 28),

            // Earned Certificates List
            Row(
              children: [
                Text(
                  'YOUR EARNED CREDENTIALS (${_certificates.length})',
                  style: GoogleFonts.outfit(
                    color: AppTheme.textMutedOf(context),
                    fontSize: 11.5,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 1.2,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            if (_certificates.isEmpty)
              Container(
                padding: const EdgeInsets.symmetric(vertical: 44, horizontal: 20),
                decoration: BoxDecoration(
                  color: AppTheme.cardOf(context),
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(color: AppTheme.borderOf(context)),
                ),
                child: Center(
                  child: Column(
                    children: [
                      Icon(Icons.workspace_premium_outlined, size: 48, color: AppTheme.borderOf(context)),
                      const SizedBox(height: 14),
                      Text(
                        'No Credentials Earned Yet',
                        style: GoogleFonts.outfit(
                          color: AppTheme.textPrimaryOf(context),
                          fontSize: 16.5,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        'Master all 32 curriculum chapters and pass the final evaluation to generate your verified certificate.',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.inter(color: AppTheme.textMutedOf(context), fontSize: 13),
                      ),
                    ],
                  ),
                ),
              )
            else
              ...List.generate(_certificates.length, (index) {
                final cert = _certificates[index];
                return Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: _buildEarnedCertificateCard(context, cert, isDark),
                );
              }),

            const SizedBox(height: 30),

            // Play Store Reviewer & QA Backdoor Mode Access Point
            Center(
              child: InkWell(
                onTap: _showBackdoorDialog,
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
                        'Play Store Reviewer & QA Bypass Mode',
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
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildEarnedCertificateCard(BuildContext context, Certificate cert, bool isDark) {
    const bronzeGold = Color(0xFFC89B58);
    final cardBg = isDark ? const Color(0xFF141923) : Colors.white;
    final borderColor = isDark ? const Color(0xFF2B3245) : const Color(0xFFE8E0D5);

    return ThreeDTiltCard(
      borderRadius: BorderRadius.circular(20),
      elevation: 6,
      child: Container(
        decoration: BoxDecoration(
          color: cardBg,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: borderColor, width: 1.2),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: isDark ? 0.25 : 0.05),
              blurRadius: 16,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: () => _openCertificateModal(cert),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Tag: AAPKO MILTA HAI
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 8,
                          height: 8,
                          decoration: const BoxDecoration(
                            color: bronzeGold,
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'AAPKO MILTA HAI • OFFICIAL VERIFIED',
                          style: GoogleFonts.outfit(
                            fontSize: 11,
                            fontWeight: FontWeight.w800,
                            letterSpacing: 1.5,
                            color: bronzeGold,
                          ),
                        ),
                      ],
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: const Color(0xFF10B981).withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(color: const Color(0xFF10B981).withValues(alpha: 0.3)),
                      ),
                      child: Text(
                        'UNLOCKED',
                        style: GoogleFonts.jetBrainsMono(
                          color: const Color(0xFF10B981),
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),

                // Icon and Title Header
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFF9E7238), Color(0xFFC89B58)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: bronzeGold.withValues(alpha: 0.35),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.workspace_premium_rounded,
                        color: Colors.white,
                        size: 28,
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            cert.title,
                            style: GoogleFonts.outfit(
                              fontSize: 17,
                              fontWeight: FontWeight.bold,
                              color: AppTheme.textPrimaryOf(context),
                              height: 1.25,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Awarded to ${cert.userName}',
                            style: GoogleFonts.inter(
                              fontSize: 13,
                              color: AppTheme.textSecondaryOf(context),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // Badges Row
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    _buildMetaPill(
                      icon: Icons.star_rounded,
                      label: cert.grade,
                      color: bronzeGold,
                      isDark: isDark,
                    ),
                    _buildMetaPill(
                      icon: Icons.check_circle_rounded,
                      label: '${cert.score.toInt()}% Score',
                      color: const Color(0xFF38BDF8),
                      isDark: isDark,
                    ),
                    _buildMetaPill(
                      icon: Icons.calendar_today_rounded,
                      label: DateFormat('MMM dd, yyyy').format(cert.issueDate),
                      color: const Color(0xFF94A3B8),
                      isDark: isDark,
                    ),
                  ],
                ),
                const SizedBox(height: 18),

                // Action Buttons: Download PDF and Open Full Screen
                Row(
                  children: [
                    Expanded(
                      flex: 6,
                      child: ElevatedButton.icon(
                        onPressed: () => _openCertificateModal(cert),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: isDark ? const Color(0xFF1B2230) : const Color(0xFF0F1E36),
                          foregroundColor: Colors.white,
                          elevation: 0,
                          padding: const EdgeInsets.symmetric(vertical: 13),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                            side: BorderSide(
                              color: bronzeGold.withValues(alpha: isDark ? 0.3 : 0.1),
                            ),
                          ),
                        ),
                        icon: const Icon(Icons.fullscreen_rounded, size: 20, color: bronzeGold),
                        label: Text(
                          'View Certificate',
                          style: GoogleFonts.outfit(
                            fontSize: 13.5,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 0.2,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      flex: 5,
                      child: ElevatedButton.icon(
                        onPressed: () => CertificatePdfService.downloadCertificatePdf(context, cert),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: isDark ? const Color(0xFF242F42) : const Color(0xFFF1F5F9),
                          foregroundColor: isDark ? Colors.white : const Color(0xFF0F1E36),
                          elevation: 0,
                          padding: const EdgeInsets.symmetric(vertical: 13),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                            side: BorderSide(
                              color: bronzeGold.withValues(alpha: 0.4),
                            ),
                          ),
                        ),
                        icon: const Icon(Icons.download_rounded, size: 18, color: bronzeGold),
                        label: Text(
                          'Download PDF',
                          style: GoogleFonts.outfit(
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMetaPill({
    required IconData icon,
    required String label,
    required Color color,
    required bool isDark,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withValues(alpha: 0.25)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 13, color: color),
          const SizedBox(width: 5),
          Text(
            label,
            style: GoogleFonts.jetBrainsMono(
              color: color,
              fontSize: 11,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
