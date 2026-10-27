import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import '../data/daily_challenges_data.dart';
import '../models/code_execution_model.dart';
import '../services/python_runner_service.dart';
import '../services/storage_service.dart';
import '../theme/app_theme.dart';
import '../widgets/three_d_tilt_card.dart';

class DailyChallengeScreen extends StatefulWidget {
  final DailyChallenge? challenge;

  const DailyChallengeScreen({super.key, this.challenge});

  @override
  State<DailyChallengeScreen> createState() => _DailyChallengeScreenState();
}

class _DailyChallengeScreenState extends State<DailyChallengeScreen> {
  late DailyChallenge _challenge;
  late TextEditingController _codeController;
  final PythonRunnerService _runner = PythonRunnerService();

  bool _isRunning = false;
  CodeExecutionResult? _lastResult;
  bool _allPassed = false;
  String? _errorHint;

  final List<String> _quickSymbols = [
    '    ', ':', '(', ')', '[', ']', '{', '}', '=', '==', '!=', '->', '#', ',', 'for', 'in', 'if', 'return',
  ];

  @override
  void initState() {
    super.initState();
    _challenge = widget.challenge ?? DailyChallengesData.getTodayChallenge();
    _codeController = TextEditingController(text: _challenge.starterCode);
  }

  @override
  void dispose() {
    _codeController.dispose();
    super.dispose();
  }

  void _insertSymbol(String sym) {
    final text = _codeController.text;
    final selection = _codeController.selection;
    final start = selection.start >= 0 ? selection.start : text.length;
    final end = selection.end >= 0 ? selection.end : text.length;
    final newText = text.replaceRange(start, end, sym);
    _codeController.value = TextEditingValue(
      text: newText,
      selection: TextSelection.collapsed(offset: start + sym.length),
    );
  }

  Future<void> _runTests() async {
    setState(() {
      _isRunning = true;
      _lastResult = null;
      _allPassed = false;
      _errorHint = null;
    });
    HapticFeedback.mediumImpact();

    // Combine user's code with automated test runner assertions
    final completeExecutable = '${_codeController.text}\n\n${_challenge.testRunnerCode}';

    try {
      final res = await _runner.executePython(sourceCode: completeExecutable);

      if (!mounted) return;

      final isSuccess = res.isSuccess && res.stdout.contains('SUCCESS: ALL_TESTS_PASSED');

      setState(() {
        _lastResult = res;
        _isRunning = false;
        _allPassed = isSuccess;
      });

      if (isSuccess) {
        HapticFeedback.heavyImpact();
        await StorageService.addXp(_challenge.xpReward);
        _showSuccessModal();
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isRunning = false;
          _errorHint = 'Execution encountered a network or execution issue: $e';
        });
      }
    }
  }

  void _showSuccessModal() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppTheme.surfaceOf(context),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(22),
          side: const BorderSide(color: Color(0xFF10B981), width: 1.5),
        ),
        title: Row(
          children: [
            const Icon(Icons.military_tech_rounded, color: Color(0xFFC89B58), size: 26),
            const SizedBox(width: 10),
            Text(
              'Quest Conquered!',
              style: GoogleFonts.outfit(
                fontWeight: FontWeight.bold,
                fontSize: 19,
                color: AppTheme.textPrimaryOf(context),
              ),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'All test assertions passed successfully! You demonstrated proper algorithmic mastery.',
              style: GoogleFonts.inter(fontSize: 13.5, color: AppTheme.textSecondaryOf(context)),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFF10B981).withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFF10B981).withValues(alpha: 0.3)),
              ),
              child: Row(
                children: [
                  const Icon(Icons.bolt_rounded, color: AppTheme.pythonYellow, size: 24),
                  const SizedBox(width: 10),
                  Text(
                    '+${_challenge.xpReward} XP Awarded',
                    style: GoogleFonts.jetBrainsMono(
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                      color: AppTheme.textPrimaryOf(context),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          ElevatedButton(
            onPressed: () {
              Navigator.pop(ctx);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF10B981),
              foregroundColor: Colors.black,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            child: const Text('Claim Reward & Continue'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final borderColor = AppTheme.borderOf(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Daily Code Quest',
          style: GoogleFonts.outfit(fontWeight: FontWeight.bold, fontSize: 18),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        physics: const BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Top Problem Card
            ThreeDTiltCard(
              borderRadius: BorderRadius.circular(20),
              elevation: 8,
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: isDark
                        ? [const Color(0xFF1E1B4B), const Color(0xFF0F172A)]
                        : [const Color(0xFFEFF6FF), Colors.white],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: isDark ? const Color(0xFF4338CA).withValues(alpha: 0.5) : borderColor,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 3),
                          decoration: BoxDecoration(
                            color: _challenge.difficulty == "Easy"
                                ? const Color(0xFF10B981).withValues(alpha: 0.2)
                                : const Color(0xFFF59E0B).withValues(alpha: 0.2),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            _challenge.difficulty.toUpperCase(),
                            style: GoogleFonts.jetBrainsMono(
                              fontSize: 10.5,
                              fontWeight: FontWeight.bold,
                              color: _challenge.difficulty == "Easy"
                                  ? const Color(0xFF10B981)
                                  : const Color(0xFFF59E0B),
                            ),
                          ),
                        ),
                        const Spacer(),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.amber.withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(color: Colors.amber.withValues(alpha: 0.3)),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(Icons.bolt, color: AppTheme.pythonYellow, size: 14),
                              const SizedBox(width: 4),
                              Text(
                                '+${_challenge.xpReward} XP',
                                style: GoogleFonts.outfit(
                                  color: AppTheme.pythonYellow,
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),

                    Text(
                      _challenge.title,
                      style: GoogleFonts.outfit(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.textPrimaryOf(context),
                      ),
                    ),
                    const SizedBox(height: 8),

                    Text(
                      _challenge.description,
                      style: GoogleFonts.inter(
                        fontSize: 13.5,
                        height: 1.5,
                        color: AppTheme.textSecondaryOf(context),
                      ),
                    ),
                    const SizedBox(height: 14),

                    // Example I/O Block
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: isDark ? const Color(0xFF070B12) : const Color(0xFFF1F5F9),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: borderColor),
                      ),
                      child: SelectableText(
                        _challenge.examples,
                        style: GoogleFonts.jetBrainsMono(
                          fontSize: 12,
                          height: 1.45,
                          color: isDark ? const Color(0xFFE2E8F0) : const Color(0xFF334155),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Code Editor Area
            Row(
              children: [
                const Icon(Icons.terminal_rounded, size: 18, color: AppTheme.pythonYellow),
                const SizedBox(width: 8),
                Text(
                  'Your Python Solution',
                  style: GoogleFonts.outfit(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.textPrimaryOf(context),
                  ),
                ),
                const Spacer(),
                TextButton.icon(
                  onPressed: () {
                    setState(() => _codeController.text = _challenge.starterCode);
                  },
                  icon: const Icon(Icons.refresh_rounded, size: 14),
                  label: const Text('Reset Starter'),
                  style: TextButton.styleFrom(
                    textStyle: GoogleFonts.outfit(fontSize: 12, fontWeight: FontWeight.w600),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),

            // Code Editor Container with Quick Symbols
            Container(
              decoration: BoxDecoration(
                color: const Color(0xFF0D1424),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: borderColor),
              ),
              child: Column(
                children: [
                  TextField(
                    controller: _codeController,
                    maxLines: 9,
                    style: GoogleFonts.jetBrainsMono(
                      fontSize: 13.5,
                      height: 1.45,
                      color: const Color(0xFFE2E8F0),
                    ),
                    cursorColor: AppTheme.pythonYellow,
                    decoration: const InputDecoration(
                      contentPadding: EdgeInsets.all(14),
                      border: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      fillColor: Colors.transparent,
                    ),
                  ),

                  // Quick Insert Symbol Bar
                  Container(
                    height: 38,
                    decoration: BoxDecoration(
                      color: const Color(0xFF131D30),
                      borderRadius: const BorderRadius.only(
                        bottomLeft: Radius.circular(13),
                        bottomRight: Radius.circular(13),
                      ),
                      border: Border(top: BorderSide(color: borderColor, width: 0.8)),
                    ),
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.symmetric(horizontal: 6),
                      itemCount: _quickSymbols.length,
                      itemBuilder: (context, idx) {
                        final sym = _quickSymbols[idx];
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 3, vertical: 4),
                          child: InkWell(
                            borderRadius: BorderRadius.circular(6),
                            onTap: () => _insertSymbol(sym),
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                color: const Color(0xFF1C2842),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text(
                                sym == '    ' ? 'Tab' : sym,
                                style: GoogleFonts.jetBrainsMono(
                                  color: AppTheme.pythonYellow,
                                  fontSize: 11.5,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Run Tests Action Button
            ElevatedButton.icon(
              onPressed: _isRunning ? null : _runTests,
              icon: _isRunning
                  ? const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                    )
                  : const Icon(Icons.play_circle_fill_rounded, size: 20),
              label: Text(_isRunning ? 'Verifying Test Suite...' : 'Run Automated Test Suite'),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF2563EB),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                textStyle: GoogleFonts.outfit(fontSize: 15, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 16),

            // Test Output Console
            if (_lastResult != null) ...[
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFF0C1420),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                    color: _allPassed ? const Color(0xFF10B981) : AppTheme.errorRed,
                    width: 1.2,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          _allPassed ? Icons.check_circle_rounded : Icons.cancel_rounded,
                          color: _allPassed ? const Color(0xFF10B981) : AppTheme.errorRed,
                          size: 18,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          _allPassed ? 'ALL TEST ASSERTIONS PASSED' : 'TEST VERIFICATION FAILED',
                          style: GoogleFonts.jetBrainsMono(
                            color: _allPassed ? const Color(0xFF10B981) : AppTheme.errorRed,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    SelectableText(
                      _lastResult!.stdout.isNotEmpty
                          ? _lastResult!.stdout
                          : (_lastResult!.stderr ?? 'No output returned.'),
                      style: GoogleFonts.jetBrainsMono(
                        fontSize: 12.5,
                        height: 1.45,
                        color: const Color(0xFFE2E8F0),
                      ),
                    ),
                  ],
                ),
              ),
            ],

            if (_errorHint != null) ...[
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppTheme.errorRed.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: AppTheme.errorRed),
                ),
                child: Text(
                  _errorHint!,
                  style: GoogleFonts.inter(color: AppTheme.errorRed, fontSize: 13),
                ),
              ),
            ],
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}
