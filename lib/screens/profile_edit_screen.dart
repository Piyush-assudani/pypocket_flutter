import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/user_profile_model.dart';
import '../services/storage_service.dart';
import '../services/database_service.dart';
import '../theme/app_theme.dart';
import '../widgets/executive_avatar.dart';
import '../widgets/three_d_tilt_card.dart';
import '../services/admin_service.dart';

class ProfileEditScreen extends StatefulWidget {
  final UserProfile currentProfile;

  const ProfileEditScreen({super.key, required this.currentProfile});

  @override
  State<ProfileEditScreen> createState() => _ProfileEditScreenState();
}

class _ProfileEditScreenState extends State<ProfileEditScreen> {
  late TextEditingController _nameController;
  late TextEditingController _bioController;
  late TextEditingController _emailController;
  late TextEditingController _mobileController;
  late TextEditingController _githubController;
  late String _selectedAvatar;
  late String _selectedGoal;
  late String _selectedLevel;
  late int _selectedMinutes;

  final List<String> _goalOptions = [
    'Full-Stack Python & AI',
    'Data Science & Machine Learning',
    'Backend & APIs (FastAPI/Django)',
    'Data Structures & Algorithms',
    'Automation & DevOps',
  ];

  final List<String> _levelOptions = [
    'Beginner',
    'Intermediate',
    'Advanced',
  ];

  final List<int> _minutesOptions = [10, 20, 45];

  @override
  void initState() {
    super.initState();
    final p = widget.currentProfile;
    _nameController = TextEditingController(text: p.userName);
    _bioController = TextEditingController(text: p.bio);
    _emailController = TextEditingController(text: p.email);
    _mobileController = TextEditingController(text: p.mobileNumber);
    _githubController = TextEditingController(text: p.githubHandle);
    _selectedAvatar = p.avatarId;
    _selectedGoal = _goalOptions.contains(p.goal) ? p.goal : _goalOptions.first;
    _selectedLevel = _levelOptions.contains(p.skillLevel) ? p.skillLevel : _levelOptions.first;
    _selectedMinutes = p.dailyMinutes > 0 ? p.dailyMinutes : 20;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _bioController.dispose();
    _emailController.dispose();
    _mobileController.dispose();
    _githubController.dispose();
    super.dispose();
  }

  Future<void> _saveProfile() async {
    final name = _nameController.text.trim();
    if (name.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter your full name')),
      );
      return;
    }

    if (AdminService.isFounderAdmin(name, _emailController.text)) {
      await AdminService.unlockFounderMasterAdmin();
      final founderProfile = StorageService.getUserProfile();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Founder Authentication Active: Welcome Piyush Assudani! Master Admin Mode Enabled.'),
            backgroundColor: Color(0xFF10B981),
          ),
        );
        Navigator.pop(context, founderProfile);
      }
      return;
    }

    final updated = widget.currentProfile.copyWith(
      userName: name,
      bio: _bioController.text.trim(),
      email: _emailController.text.trim(),
      mobileNumber: _mobileController.text.trim(),
      githubHandle: _githubController.text.trim(),
      avatarId: _selectedAvatar,
      goal: _selectedGoal,
      skillLevel: _selectedLevel,
      dailyMinutes: _selectedMinutes,
    );

    await StorageService.saveUserProfile(updated);
    await DatabaseService.syncProfileToCloud(updated);

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Executive Developer Profile Saved successfully.'),
          backgroundColor: AppTheme.accentGreen,
        ),
      );
      Navigator.pop(context, updated);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final currentAvatar = ExecutiveAvatars.get(_selectedAvatar);

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF0D1117) : const Color(0xFFF9F7F4),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: isDark ? const Color(0xFF0D1117) : const Color(0xFFF9F7F4),
        surfaceTintColor: Colors.transparent,
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: InkWell(
            borderRadius: BorderRadius.circular(12),
            onTap: () => Navigator.pop(context),
            child: Container(
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF161B22) : Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: isDark ? const Color(0xFF21262D) : const Color(0xFFE5E7EB),
                ),
              ),
              child: Icon(
                Icons.arrow_back_ios_new_rounded,
                size: 16,
                color: AppTheme.textPrimaryOf(context),
              ),
            ),
          ),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Executive Profile',
              style: GoogleFonts.outfit(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppTheme.textPrimaryOf(context),
              ),
            ),
            Text(
              'Professional Credentials & Study Plan',
              style: GoogleFonts.inter(
                fontSize: 11,
                color: AppTheme.textSecondaryOf(context),
              ),
            ),
          ],
        ),
        actions: [
          Container(
            margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
            child: ElevatedButton(
              onPressed: _saveProfile,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFC89B58),
                foregroundColor: const Color(0xFF17191C),
                padding: const EdgeInsets.symmetric(horizontal: 18),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 0,
              ),
              child: Text(
                'Save',
                style: GoogleFonts.outfit(
                  fontWeight: FontWeight.bold,
                  fontSize: 13.5,
                ),
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ================= 1. HERO SPOTLIGHT CARD =================
            _buildHeroSpotlight(context, isDark, currentAvatar),
            const SizedBox(height: 22),

            // ================= 2. PROFESSIONAL CREDENTIALS =================
            _buildSectionCard(
              context,
              isDark: isDark,
              title: 'Professional Credentials',
              icon: Icons.badge_outlined,
              iconColor: const Color(0xFFC89B58),
              subtitle: 'Verified on Certificates',
              child: Column(
                children: [
                  _buildModernField(
                    context,
                    isDark: isDark,
                    label: 'Full Legal Name',
                    controller: _nameController,
                    icon: Icons.person_outline_rounded,
                    hint: 'e.g. Piyush Sharma',
                    helperText: 'Displayed on official Python certificates',
                    isRequired: true,
                  ),
                  const SizedBox(height: 14),
                  _buildModernField(
                    context,
                    isDark: isDark,
                    label: 'Official Email Address',
                    controller: _emailController,
                    icon: Icons.mail_outline_rounded,
                    hint: 'developer@example.com',
                    keyboardType: TextInputType.emailAddress,
                  ),
                  const SizedBox(height: 14),
                  _buildModernField(
                    context,
                    isDark: isDark,
                    label: 'Mobile Phone Number',
                    controller: _mobileController,
                    icon: Icons.phone_iphone_rounded,
                    hint: '+91 98765 43210',
                    keyboardType: TextInputType.phone,
                  ),
                  const SizedBox(height: 14),
                  _buildModernField(
                    context,
                    isDark: isDark,
                    label: 'Developer Bio & Ambition',
                    controller: _bioController,
                    icon: Icons.format_quote_rounded,
                    hint: 'Building scalable async microservices and AI pipelines...',
                    maxLines: 2,
                  ),
                  const SizedBox(height: 14),
                  _buildModernField(
                    context,
                    isDark: isDark,
                    label: 'GitHub Profile Handle',
                    controller: _githubController,
                    icon: Icons.code_rounded,
                    hint: 'username',
                    prefixText: 'github.com/',
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // ================= 3. DAILY STUDY COMMITMENT =================
            _buildSectionCard(
              context,
              isDark: isDark,
              title: 'Daily Study Commitment',
              icon: Icons.schedule_rounded,
              iconColor: const Color(0xFF3B82F6),
              subtitle: 'Active Habit',
              child: Row(
                children: _minutesOptions.map((mins) {
                  final isSelected = mins == _selectedMinutes;
                  return Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      child: _buildTimeOption(
                        context,
                        isDark: isDark,
                        minutes: mins,
                        isSelected: isSelected,
                        onTap: () => setState(() => _selectedMinutes = mins),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
            const SizedBox(height: 20),

            // ================= 4. CAREER TRACK SELECTION =================
            _buildSectionCard(
              context,
              isDark: isDark,
              title: 'Target Specialization Track',
              icon: Icons.alt_route_rounded,
              iconColor: const Color(0xFF10B981),
              subtitle: 'Curriculum Focus',
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
                decoration: BoxDecoration(
                  color: isDark ? const Color(0xFF161B22) : const Color(0xFFF8FAFC),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                    color: isDark ? const Color(0xFF28303E) : const Color(0xFFE2E8F0),
                  ),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: _selectedGoal,
                    isExpanded: true,
                    icon: const Icon(Icons.unfold_more_rounded, size: 20, color: Color(0xFFC89B58)),
                    dropdownColor: isDark ? const Color(0xFF161B22) : Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    items: _goalOptions.map((g) {
                      return DropdownMenuItem(
                        value: g,
                        child: Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(6),
                              decoration: BoxDecoration(
                                color: const Color(0xFFC89B58).withValues(alpha: 0.15),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: const Icon(
                                Icons.school_rounded,
                                size: 16,
                                color: Color(0xFFC89B58),
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                g,
                                style: GoogleFonts.outfit(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: AppTheme.textPrimaryOf(context),
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                    onChanged: (val) {
                      if (val != null) setState(() => _selectedGoal = val);
                    },
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),

            // ================= 5. EXPERIENCE LEVEL =================
            _buildSectionCard(
              context,
              isDark: isDark,
              title: 'Current Experience Level',
              icon: Icons.trending_up_rounded,
              iconColor: const Color(0xFF8B5CF6),
              subtitle: 'Adaptive Difficulty',
              child: Row(
                children: _levelOptions.map((lvl) {
                  final isSelected = lvl == _selectedLevel;
                  return Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      child: _buildLevelOption(
                        context,
                        isDark: isDark,
                        level: lvl,
                        isSelected: isSelected,
                        onTap: () => setState(() => _selectedLevel = lvl),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
            const SizedBox(height: 28),

            // ================= 6. LARGE EXECUTIVE SAVE BUTTON =================
            Container(
              width: double.infinity,
              height: 54,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFFC89B58).withValues(alpha: 0.28),
                    blurRadius: 18,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: ElevatedButton.icon(
                onPressed: _saveProfile,
                icon: const Icon(Icons.verified_rounded, size: 20),
                label: Text(
                  'Save Executive Profile',
                  style: GoogleFonts.outfit(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.5,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFC89B58),
                  foregroundColor: const Color(0xFF17191C),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  elevation: 0,
                ),
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildHeroSpotlight(BuildContext context, bool isDark, ExecutiveAvatarInfo currentAvatar) {
    return ThreeDTiltCard(
      borderRadius: BorderRadius.circular(22),
      elevation: 6,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF111827) : Colors.white,
          borderRadius: BorderRadius.circular(22),
          border: Border.all(
            color: const Color(0xFFC89B58).withValues(alpha: isDark ? 0.35 : 0.25),
            width: 1.2,
          ),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFFC89B58).withValues(alpha: isDark ? 0.08 : 0.04),
              blurRadius: 20,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          children: [
            Center(
              child: Stack(
                alignment: Alignment.bottomRight,
                children: [
                  Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: currentAvatar.accentColor.withValues(alpha: 0.5),
                        width: 2.5,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: currentAvatar.accentColor.withValues(alpha: 0.25),
                          blurRadius: 18,
                          spreadRadius: 2,
                        ),
                      ],
                    ),
                    child: ExecutiveAvatarWidget(
                      avatarId: _selectedAvatar,
                      size: 80,
                      showBadge: false,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: const Color(0xFFC89B58),
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: isDark ? const Color(0xFF111827) : Colors.white,
                        width: 2,
                      ),
                    ),
                    child: const Icon(
                      Icons.check_rounded,
                      size: 14,
                      color: Color(0xFF17191C),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            Text(
              currentAvatar.title,
              style: GoogleFonts.outfit(
                fontWeight: FontWeight.bold,
                fontSize: 18,
                color: AppTheme.textPrimaryOf(context),
              ),
            ),
            const SizedBox(height: 3),
            Text(
              currentAvatar.subtitle,
              textAlign: TextAlign.center,
              style: GoogleFonts.inter(
                fontSize: 12.5,
                color: AppTheme.textSecondaryOf(context),
              ),
            ),
            const SizedBox(height: 16),

            Row(
              children: [
                Text(
                  'SELECT PERSONA',
                  style: GoogleFonts.outfit(
                    fontSize: 10.5,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 1.0,
                    color: AppTheme.textMutedOf(context),
                  ),
                ),
                const Spacer(),
                Text(
                  '6 Roles Available',
                  style: GoogleFonts.inter(
                    fontSize: 10.5,
                    color: AppTheme.textMutedOf(context),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            SizedBox(
              height: 76,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                physics: const BouncingScrollPhysics(),
                itemCount: ExecutiveAvatars.catalog.length,
                separatorBuilder: (context, index) => const SizedBox(width: 8),
                itemBuilder: (context, index) {
                  final item = ExecutiveAvatars.catalog.values.elementAt(index);
                  final isSelected = item.id == _selectedAvatar;
                  return InkWell(
                    borderRadius: BorderRadius.circular(14),
                    onTap: () => setState(() => _selectedAvatar = item.id),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      width: 68,
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? item.accentColor.withValues(alpha: 0.15)
                            : (isDark ? const Color(0xFF161B22) : const Color(0xFFF8FAFC)),
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(
                          color: isSelected ? item.accentColor : (isDark ? const Color(0xFF28303E) : const Color(0xFFE2E8F0)),
                          width: isSelected ? 2 : 1,
                        ),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ExecutiveAvatarWidget(
                            avatarId: item.id,
                            size: 36,
                            showBadge: false,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            item.glyph,
                            style: GoogleFonts.outfit(
                              fontSize: 10.5,
                              fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
                              color: isSelected ? item.accentColor : AppTheme.textSecondaryOf(context),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionCard(
    BuildContext context, {
    required bool isDark,
    required String title,
    required IconData icon,
    required Color iconColor,
    required Widget child,
    String? subtitle,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: iconColor.withValues(alpha: 0.14),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, color: iconColor, size: 15),
            ),
            const SizedBox(width: 8),
            Text(
              title.toUpperCase(),
              style: GoogleFonts.outfit(
                fontSize: 11.5,
                fontWeight: FontWeight.w800,
                letterSpacing: 1.1,
                color: AppTheme.textMutedOf(context),
              ),
            ),
            if (subtitle != null) ...[
              const Spacer(),
              Text(
                subtitle,
                style: GoogleFonts.inter(
                  fontSize: 11,
                  color: AppTheme.textMutedOf(context),
                ),
              ),
            ],
          ],
        ),
        const SizedBox(height: 10),
        Container(
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF111827) : Colors.white,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: isDark ? const Color(0xFF1F2937) : const Color(0xFFE5E7EB),
              width: 1.2,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: isDark ? 0.25 : 0.03),
                blurRadius: 14,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: child,
        ),
      ],
    );
  }

  Widget _buildModernField(
    BuildContext context, {
    required bool isDark,
    required String label,
    required TextEditingController controller,
    required IconData icon,
    required String hint,
    String? helperText,
    String? prefixText,
    TextInputType keyboardType = TextInputType.text,
    int maxLines = 1,
    bool isRequired = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              label,
              style: GoogleFonts.outfit(
                fontSize: 12.5,
                fontWeight: FontWeight.w600,
                color: AppTheme.textPrimaryOf(context),
              ),
            ),
            if (isRequired) ...[
              const SizedBox(width: 4),
              const Text('*', style: TextStyle(color: Color(0xFFEF4444), fontSize: 13, fontWeight: FontWeight.bold)),
            ],
          ],
        ),
        const SizedBox(height: 6),
        Container(
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF161B22) : const Color(0xFFF8FAFC),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: isDark ? const Color(0xFF28303E) : const Color(0xFFE2E8F0),
            ),
          ),
          child: TextField(
            controller: controller,
            keyboardType: keyboardType,
            maxLines: maxLines,
            style: GoogleFonts.inter(
              fontSize: 14,
              color: AppTheme.textPrimaryOf(context),
            ),
            decoration: InputDecoration(
              isDense: true,
              border: InputBorder.none,
              enabledBorder: InputBorder.none,
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: const BorderSide(color: Color(0xFFC89B58), width: 1.5),
              ),
              contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              prefixIcon: Icon(icon, size: 18, color: const Color(0xFFC89B58)),
              prefixText: prefixText,
              prefixStyle: GoogleFonts.jetBrainsMono(
                color: AppTheme.textMutedOf(context),
                fontSize: 13,
              ),
              hintText: hint,
              hintStyle: GoogleFonts.inter(
                color: AppTheme.textMutedOf(context),
                fontSize: 13,
              ),
            ),
          ),
        ),
        if (helperText != null) ...[
          const SizedBox(height: 4),
          Text(
            helperText,
            style: GoogleFonts.inter(
              fontSize: 11,
              color: AppTheme.textMutedOf(context),
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildTimeOption(
    BuildContext context, {
    required bool isDark,
    required int minutes,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    String subLabel;
    IconData subIcon;
    Color toneColor;
    if (minutes == 10) {
      subLabel = 'Sprint';
      subIcon = Icons.bolt_rounded;
      toneColor = const Color(0xFFF59E0B);
    } else if (minutes == 20) {
      subLabel = 'Standard';
      subIcon = Icons.timer_outlined;
      toneColor = const Color(0xFF3B82F6);
    } else {
      subLabel = 'Intense';
      subIcon = Icons.local_fire_department_rounded;
      toneColor = const Color(0xFFEF4444);
    }

    return InkWell(
      borderRadius: BorderRadius.circular(14),
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 8),
        decoration: BoxDecoration(
          color: isSelected
              ? const Color(0xFFC89B58)
              : (isDark ? const Color(0xFF161B22) : const Color(0xFFF8FAFC)),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: isSelected
                ? const Color(0xFFC89B58)
                : (isDark ? const Color(0xFF28303E) : const Color(0xFFE2E8F0)),
            width: isSelected ? 1.5 : 1,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: const Color(0xFFC89B58).withValues(alpha: 0.3),
                    blurRadius: 10,
                    offset: const Offset(0, 3),
                  ),
                ]
              : null,
        ),
        child: Column(
          children: [
            Icon(
              subIcon,
              size: 20,
              color: isSelected ? const Color(0xFF17191C) : toneColor,
            ),
            const SizedBox(height: 6),
            Text(
              '$minutes Min',
              style: GoogleFonts.outfit(
                color: isSelected ? const Color(0xFF17191C) : AppTheme.textPrimaryOf(context),
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
            Text(
              subLabel,
              style: GoogleFonts.inter(
                color: isSelected
                    ? const Color(0xFF17191C).withValues(alpha: 0.8)
                    : AppTheme.textMutedOf(context),
                fontSize: 10.5,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLevelOption(
    BuildContext context, {
    required bool isDark,
    required String level,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    int dots = 1;
    if (level == 'Intermediate') dots = 2;
    if (level == 'Advanced') dots = 3;

    return InkWell(
      borderRadius: BorderRadius.circular(14),
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(vertical: 13, horizontal: 6),
        decoration: BoxDecoration(
          color: isSelected
              ? const Color(0xFFC89B58)
              : (isDark ? const Color(0xFF161B22) : const Color(0xFFF8FAFC)),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: isSelected
                ? const Color(0xFFC89B58)
                : (isDark ? const Color(0xFF28303E) : const Color(0xFFE2E8F0)),
            width: isSelected ? 1.5 : 1,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: const Color(0xFFC89B58).withValues(alpha: 0.3),
                    blurRadius: 10,
                    offset: const Offset(0, 3),
                  ),
                ]
              : null,
        ),
        alignment: Alignment.center,
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                dots,
                (i) => Container(
                  width: 5,
                  height: 5,
                  margin: const EdgeInsets.symmetric(horizontal: 1.5),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? const Color(0xFF17191C)
                        : const Color(0xFF8B5CF6),
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 4),
            Text(
              level,
              style: GoogleFonts.outfit(
                color: isSelected ? const Color(0xFF17191C) : AppTheme.textPrimaryOf(context),
                fontWeight: FontWeight.bold,
                fontSize: 13,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
