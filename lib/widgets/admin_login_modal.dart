import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../services/admin_service.dart';
import '../theme/app_theme.dart';

class AdminLoginModal extends StatefulWidget {
  final VoidCallback? onStateChanged;

  const AdminLoginModal({super.key, this.onStateChanged});

  static Future<void> show(BuildContext context, {VoidCallback? onStateChanged}) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => AdminLoginModal(onStateChanged: onStateChanged),
    );
  }

  @override
  State<AdminLoginModal> createState() => _AdminLoginModalState();
}

class _AdminLoginModalState extends State<AdminLoginModal> {
  final _userController = TextEditingController();
  final _passController = TextEditingController();
  bool _obscurePassword = true;
  bool _isLoading = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _userController.dispose();
    _passController.dispose();
    super.dispose();
  }

  void _fillQaCredentials() {
    setState(() {
      _userController.text = 'tester@google.com';
      _passController.text = 'PyPocket2026!';
      _errorMessage = null;
    });
  }

  void _fillFounderCredentials() {
    setState(() {
      _userController.text = 'piyushassudani96@gmail.com';
      _passController.text = 'piyushassudani';
      _errorMessage = null;
    });
  }

  Future<void> _handleUnlock() async {
    final username = _userController.text.trim();
    final password = _passController.text.trim();

    // Check founder credentials
    if (AdminService.isFounderAdmin(username, username)) {
      setState(() {
        _isLoading = true;
        _errorMessage = null;
      });

      await AdminService.unlockFounderMasterAdmin();

      if (mounted) {
        setState(() => _isLoading = false);
        widget.onStateChanged?.call();
        Navigator.pop(context);

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Founder Authentication Active: Welcome Piyush Assudani! Master Admin Unlocked.'),
            backgroundColor: Color(0xFF10B981),
            duration: Duration(seconds: 4),
          ),
        );
      }
      return;
    }

    if (!AdminService.verifyCredentials(username, password)) {
      setState(() {
        _errorMessage = 'Invalid Reviewer ID or Password. Tap "Fill QA Credentials" below.';
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    await AdminService.unlockAllForTesting(
      testerName: username.contains('google') ? 'Google Play QA Lead' : 'PyPocket Executive Reviewer',
    );

    if (mounted) {
      setState(() => _isLoading = false);
      widget.onStateChanged?.call();
      Navigator.pop(context);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Admin Mode Active: All 32 Lessons, Quizzes & Verified Certificate Unlocked!'),
          backgroundColor: Color(0xFF10B981),
          duration: Duration(seconds: 4),
        ),
      );
    }
  }

  Future<void> _handleReset() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Reset to Clean Slate?', style: GoogleFonts.outfit(fontWeight: FontWeight.bold)),
        content: const Text('This will reset progress back to 0 XP and locked lessons for testing onboarding from scratch.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Cancel')),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFEF4444)),
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Reset Everything', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );

    if (confirm == true) {
      await AdminService.resetTestData();
      if (mounted) {
        widget.onStateChanged?.call();
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Test progress reset to clean beginner state.')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isUnlocked = AdminService.isAdminModeActive();
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;

    return Container(
      padding: EdgeInsets.only(
        left: 20,
        right: 20,
        top: 20,
        bottom: bottomInset + 24,
      ),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF101726) : Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
        border: Border.all(
          color: isDark ? const Color(0xFF1E293B) : const Color(0xFFE2E8F0),
        ),
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Drag handle
            Center(
              child: Container(
                width: 44,
                height: 4,
                decoration: BoxDecoration(
                  color: isDark ? Colors.white24 : Colors.black12,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 18),

            // Header Row
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: const Color(0xFF2563EB).withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.admin_panel_settings_rounded,
                    color: Color(0xFF2563EB),
                    size: 24,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Play Store Reviewer & Admin QA',
                        style: GoogleFonts.outfit(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.textPrimaryOf(context),
                        ),
                      ),
                      Text(
                        'Instant full curriculum and certificate unlock',
                        style: GoogleFonts.inter(
                          fontSize: 12,
                          color: AppTheme.textSecondaryOf(context),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Mode Badge
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: (isUnlocked ? const Color(0xFF10B981) : const Color(0xFFF59E0B)).withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: (isUnlocked ? const Color(0xFF10B981) : const Color(0xFFF59E0B)).withValues(alpha: 0.3),
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    isUnlocked ? Icons.check_circle_rounded : Icons.lock_outline_rounded,
                    size: 16,
                    color: isUnlocked ? const Color(0xFF10B981) : const Color(0xFFF59E0B),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      isUnlocked
                          ? 'STATUS: Full Curriculum & Verified Certificate UNLOCKED'
                          : 'STATUS: Standard User Mode (Lessons Locked by Progression)',
                      style: GoogleFonts.jetBrainsMono(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: isUnlocked ? const Color(0xFF10B981) : const Color(0xFFF59E0B),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // 1-Tap Fill Founder Credentials button
            InkWell(
              onTap: _fillFounderCredentials,
              borderRadius: BorderRadius.circular(10),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: isDark ? const Color(0xFF231E17) : const Color(0xFFFBF6EE),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: const Color(0xFFC89B58).withValues(alpha: 0.4)),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.verified_user_rounded, size: 16, color: Color(0xFFC89B58)),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Fill Founder Credentials (Piyush Assudani)',
                        style: GoogleFonts.inter(
                          fontSize: 11.5,
                          fontWeight: FontWeight.w700,
                          color: const Color(0xFFC89B58),
                        ),
                      ),
                    ),
                    const Icon(Icons.arrow_downward_rounded, size: 14, color: Color(0xFFC89B58)),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 8),

            // 1-Tap Fill Credentials button
            InkWell(
              onTap: _fillQaCredentials,
              borderRadius: BorderRadius.circular(10),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: isDark ? const Color(0xFF1E293B) : const Color(0xFFF1F5F9),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: AppTheme.borderOf(context)),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.flash_on_rounded, size: 16, color: Color(0xFFF59E0B)),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Fill Official Reviewer Credentials (tester@google.com)',
                        style: GoogleFonts.inter(
                          fontSize: 11.5,
                          fontWeight: FontWeight.w600,
                          color: AppTheme.textPrimaryOf(context),
                        ),
                      ),
                    ),
                    const Icon(Icons.arrow_downward_rounded, size: 14),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 14),

            // Form Fields
            TextField(
              controller: _userController,
              decoration: InputDecoration(
                labelText: 'Reviewer / Admin ID',
                hintText: 'tester@google.com or admin',
                prefixIcon: const Icon(Icons.person_outline_rounded),
                contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
            const SizedBox(height: 12),

            TextField(
              controller: _passController,
              obscureText: _obscurePassword,
              decoration: InputDecoration(
                labelText: 'Reviewer Passkey',
                hintText: 'PyPocket2026!',
                prefixIcon: const Icon(Icons.key_rounded),
                suffixIcon: IconButton(
                  icon: Icon(_obscurePassword ? Icons.visibility_outlined : Icons.visibility_off_outlined),
                  onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),

            if (_errorMessage != null) ...[
              const SizedBox(height: 10),
              Text(
                _errorMessage!,
                style: GoogleFonts.inter(
                  color: const Color(0xFFEF4444),
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
            const SizedBox(height: 20),

            // Primary Unlock Button
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton.icon(
                onPressed: _isLoading ? null : _handleUnlock,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF2563EB),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                icon: _isLoading
                    ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                    : const Icon(Icons.lock_open_rounded, size: 18),
                label: Text(
                  'Unlock All Lessons, Quizzes & Certificate',
                  style: GoogleFonts.outfit(fontWeight: FontWeight.bold, fontSize: 13.5),
                ),
              ),
            ),
            const SizedBox(height: 10),

            // Reset Button
            SizedBox(
              width: double.infinity,
              height: 44,
              child: OutlinedButton.icon(
                onPressed: _handleReset,
                style: OutlinedButton.styleFrom(
                  foregroundColor: const Color(0xFFEF4444),
                  side: const BorderSide(color: Color(0xFFEF4444)),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                icon: const Icon(Icons.refresh_rounded, size: 16),
                label: Text(
                  'Reset Progress to Clean Slate',
                  style: GoogleFonts.outfit(fontWeight: FontWeight.w600, fontSize: 13),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
