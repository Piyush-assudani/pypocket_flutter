import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import '../services/storage_service.dart';
import '../services/database_service.dart';
import '../theme/app_theme.dart';

class DbSetupScreen extends StatefulWidget {
  const DbSetupScreen({super.key});

  @override
  State<DbSetupScreen> createState() => _DbSetupScreenState();
}

class _DbSetupScreenState extends State<DbSetupScreen> {
  final TextEditingController _urlController = TextEditingController();
  final TextEditingController _keyController = TextEditingController();

  bool _isTesting = false;
  String? _statusMessage;
  bool? _isSuccess;

  @override
  void initState() {
    super.initState();
    _urlController.text = StorageService.getSupabaseUrl() ?? '';
    _keyController.text = StorageService.getSupabaseAnonKey() ?? '';
  }

  @override
  void dispose() {
    _urlController.dispose();
    _keyController.dispose();
    super.dispose();
  }

  Future<void> _testAndSave() async {
    final url = _urlController.text.trim();
    final key = _keyController.text.trim();

    if (url.isEmpty || key.isEmpty) {
      setState(() {
        _statusMessage = 'Please enter both Supabase Project URL and anon public Key.';
        _isSuccess = false;
      });
      return;
    }

    setState(() {
      _isTesting = true;
      _statusMessage = null;
    });

    final testRes = await DatabaseService.testConnection(url, key);

    if (testRes['success'] == true) {
      await StorageService.saveSupabaseCredentials(url, key);
      await DatabaseService.init();

      // Trigger sync of current profile
      final profile = StorageService.getUserProfile();
      await DatabaseService.syncProfileToCloud(profile);

      setState(() {
        _isTesting = false;
        _isSuccess = true;
        _statusMessage = testRes['message'] as String;
      });
    } else {
      setState(() {
        _isTesting = false;
        _isSuccess = false;
        _statusMessage = testRes['message'] as String;
      });
    }
  }

  void _copySqlSchema() {
    Clipboard.setData(ClipboardData(text: DatabaseService.setupSqlScript));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('SQL Schema copied to clipboard! Paste it into Supabase SQL Editor.'),
        backgroundColor: AppTheme.accentGreen,
      ),
    );
  }

  Future<void> _disconnect() async {
    await StorageService.clearSupabaseCredentials();
    setState(() {
      _urlController.clear();
      _keyController.clear();
      _isSuccess = null;
      _statusMessage = 'Disconnected. App will continue to use local offline storage.';
    });
  }

  @override
  Widget build(BuildContext context) {
    final isConfigured = DatabaseService.isConfigured;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Cloud Database Sync'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Status Card
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: (isConfigured ? AppTheme.accentGreen : AppTheme.pythonYellow).withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                  color: isConfigured ? AppTheme.accentGreen : AppTheme.pythonYellow,
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    isConfigured ? Icons.cloud_done_rounded : Icons.cloud_queue_rounded,
                    color: isConfigured ? AppTheme.accentGreen : AppTheme.pythonYellow,
                    size: 28,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          isConfigured ? 'Supabase Connected & Synced' : 'Offline Mode (Local Storage)',
                          style: GoogleFonts.outfit(
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                            color: AppTheme.textPrimaryOf(context),
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          isConfigured
                              ? 'Your XP, lessons, and certificates are synced in the cloud.'
                              : 'Connect Supabase (100% Free) for multi-device sync & cloud backup.',
                          style: GoogleFonts.inter(
                            color: AppTheme.textSecondaryOf(context),
                            fontSize: 12.5,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // How to get free API keys in 2 minutes
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppTheme.cardOf(context),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: AppTheme.borderOf(context)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.info_outline_rounded, color: AppTheme.accentCyan, size: 20),
                      const SizedBox(width: 8),
                      Text(
                        'How to get your Free Supabase Keys:',
                        style: GoogleFonts.outfit(
                          color: AppTheme.textPrimaryOf(context),
                          fontWeight: FontWeight.bold,
                          fontSize: 14.5,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  _stepItem('1', 'Go to https://supabase.com and create a free project.'),
                  _stepItem('2', 'In your project, go to Project Settings -> API.'),
                  _stepItem('3', 'Copy Project URL and anon public Key, and paste them below.'),
                  _stepItem('4', 'Click "Copy SQL Schema" and paste it in Supabase SQL Editor.'),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // SQL Schema Copy Button
            OutlinedButton.icon(
              onPressed: _copySqlSchema,
              icon: const Icon(Icons.copy_rounded, size: 16, color: AppTheme.pythonYellow),
              label: Text(
                'Copy Database Tables SQL Script',
                style: GoogleFonts.outfit(color: AppTheme.pythonYellow, fontWeight: FontWeight.bold),
              ),
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: AppTheme.pythonYellow),
                padding: const EdgeInsets.symmetric(vertical: 14),
              ),
            ),
            const SizedBox(height: 20),

            // Input Fields
            Text(
              'SUPABASE CREDENTIALS',
              style: GoogleFonts.outfit(
                color: AppTheme.textMutedOf(context),
                fontSize: 12,
                fontWeight: FontWeight.w700,
                letterSpacing: 1.2,
              ),
            ),
            const SizedBox(height: 10),

            TextField(
              controller: _urlController,
              style: GoogleFonts.jetBrainsMono(
                fontSize: 13,
                color: AppTheme.textPrimaryOf(context),
              ),
              decoration: const InputDecoration(
                labelText: 'Project URL',
                hintText: 'https://xxxxxxxxxxxx.supabase.co',
                prefixIcon: Icon(Icons.link_rounded),
              ),
            ),
            const SizedBox(height: 12),

            TextField(
              controller: _keyController,
              obscureText: true,
              style: GoogleFonts.jetBrainsMono(
                fontSize: 13,
                color: AppTheme.textPrimaryOf(context),
              ),
              decoration: const InputDecoration(
                labelText: 'Anon Public API Key',
                hintText: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...',
                prefixIcon: Icon(Icons.key_rounded),
              ),
            ),
            const SizedBox(height: 16),

            if (_statusMessage != null) ...[
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: (_isSuccess == true ? AppTheme.accentGreen : AppTheme.errorRed).withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: _isSuccess == true ? AppTheme.accentGreen : AppTheme.errorRed,
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      _isSuccess == true ? Icons.check_circle_rounded : Icons.error_outline_rounded,
                      color: _isSuccess == true ? AppTheme.accentGreen : AppTheme.errorRed,
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        _statusMessage!,
                        style: GoogleFonts.inter(
                          color: AppTheme.textPrimaryOf(context),
                          fontSize: 13,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
            ],

            ElevatedButton.icon(
              onPressed: _isTesting ? null : _testAndSave,
              icon: _isTesting
                  ? const SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                    )
                  : const Icon(Icons.cloud_upload_rounded),
              label: Text(_isTesting ? 'Testing Connection...' : 'Connect & Sync Supabase'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.pythonBlue,
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
            ),

            if (isConfigured) ...[
              const SizedBox(height: 12),
              TextButton.icon(
                onPressed: _disconnect,
                icon: const Icon(Icons.link_off_rounded, color: AppTheme.errorRed),
                label: Text(
                  'Disconnect Supabase',
                  style: GoogleFonts.outfit(color: AppTheme.errorRed),
                ),
              ),
            ],
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _stepItem(String number, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 20,
            height: 20,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: AppTheme.borderOf(context),
              shape: BoxShape.circle,
            ),
            child: Text(
              number,
              style: GoogleFonts.jetBrainsMono(
                color: AppTheme.textPrimaryOf(context),
                fontSize: 11,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              text,
              style: GoogleFonts.inter(color: AppTheme.textSecondaryOf(context), fontSize: 13),
            ),
          ),
        ],
      ),
    );
  }
}
