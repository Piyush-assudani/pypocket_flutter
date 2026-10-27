import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:uuid/uuid.dart';
import '../models/quiz_model.dart';
import '../models/certificate_model.dart';
import '../data/python_quizzes_data.dart';
import '../services/storage_service.dart';
import '../services/database_service.dart';
import '../theme/app_theme.dart';
import 'certificates_screen.dart';

class QuizScreen extends StatefulWidget {
  final bool isCertificationExam;

  const QuizScreen({super.key, this.isCertificationExam = true});

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  late List<QuizQuestion> _questions;
  int _currentIndex = 0;
  int? _selectedOption;
  bool _isAnswerSubmitted = false;
  int _correctAnswers = 0;
  int _totalXpEarned = 0;
  bool _quizFinished = false;

  @override
  void initState() {
    super.initState();
    _questions = widget.isCertificationExam
        ? PythonQuizzesData.certificationExamQuestions
        : PythonQuizzesData.beginnerQuestions;
  }

  void _submitAnswer() {
    if (_selectedOption == null) return;

    final q = _questions[_currentIndex];
    final isCorrect = _selectedOption == q.correctIndex;

    setState(() {
      _isAnswerSubmitted = true;
      if (isCorrect) {
        _correctAnswers++;
        _totalXpEarned += q.xp;
      }
    });
  }

  Future<void> _nextQuestion() async {
    if (_currentIndex < _questions.length - 1) {
      setState(() {
        _currentIndex++;
        _selectedOption = null;
        _isAnswerSubmitted = false;
      });
    } else {
      // Quiz Finished!
      await _finalizeQuiz();
    }
  }

  Future<void> _finalizeQuiz() async {
    final scorePercentage = (_correctAnswers / _questions.length) * 100;
    final isPassed = scorePercentage >= 70.0;

    // Award XP
    await StorageService.addXp(_totalXpEarned);

    // If passed Certification Exam, issue certificate
    Certificate? newCert;
    if (widget.isCertificationExam && isPassed) {
      final profile = StorageService.getUserProfile();
      final certId = 'PYPKT-2026-${const Uuid().v4().substring(0, 8).toUpperCase()}';
      final grade = scorePercentage >= 90
          ? 'High Distinction'
          : scorePercentage >= 80
              ? 'Distinction'
              : 'Pass with Merit';

      newCert = Certificate(
        id: certId,
        userName: profile.userName.isNotEmpty ? profile.userName : 'PyPocket Developer',
        title: 'Certified Python Specialist',
        track: 'Python Engineering & Algorithms',
        score: scorePercentage,
        grade: grade,
        issueDate: DateTime.now(),
        verificationHash: const Uuid().v4(),
      );

      await StorageService.saveCertificate(newCert);
      await DatabaseService.syncCertificateToCloud(newCert);
    }

    final updatedProfile = StorageService.getUserProfile();
    await DatabaseService.syncProfileToCloud(updatedProfile);

    if (mounted) {
      setState(() {
        _quizFinished = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_quizFinished) {
      return _buildResultsView();
    }

    final q = _questions[_currentIndex];
    final progress = (_currentIndex + 1) / _questions.length;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.isCertificationExam ? 'Certification Assessment' : 'Practice Quiz'),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: Center(
              child: Text(
                '${_currentIndex + 1}/${_questions.length}',
                style: GoogleFonts.jetBrainsMono(
                  color: AppTheme.pythonYellow,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Progress Bar
            ClipRRect(
              borderRadius: BorderRadius.circular(6),
              child: LinearProgressIndicator(
                value: progress,
                minHeight: 6,
                backgroundColor: isDark ? const Color(0xFF1E293B) : const Color(0xFFE2E8F0),
                valueColor: const AlwaysStoppedAnimation<Color>(AppTheme.pythonBlue),
              ),
            ),
            const SizedBox(height: 18),

            // Question Header
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppTheme.pythonBlue.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    q.category,
                    style: GoogleFonts.outfit(
                      color: AppTheme.pythonBlue,
                      fontSize: 11.5,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const Spacer(),
                Text(
                  '+${q.xp} XP',
                  style: GoogleFonts.outfit(
                    color: AppTheme.pythonYellow,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Question Text
            Text(
              q.question,
              style: GoogleFonts.outfit(
                color: AppTheme.textPrimaryOf(context),
                fontSize: 17,
                fontWeight: FontWeight.bold,
                height: 1.4,
              ),
            ),
            const SizedBox(height: 14),

            // Code Snippet if present
            if (q.codeSnippet != null) ...[
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: AppTheme.darkTerminalBg,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppTheme.darkBorder),
                ),
                child: SelectableText(q.codeSnippet!, style: AppTheme.codeStyle),
              ),
              const SizedBox(height: 16),
            ],

            // Options List
            ...List.generate(q.options.length, (idx) {
              final isSelected = _selectedOption == idx;
              final isCorrect = idx == q.correctIndex;

              Color borderColor = AppTheme.borderOf(context);
              Color bgColor = AppTheme.cardOf(context);

              if (_isAnswerSubmitted) {
                if (isCorrect) {
                  borderColor = AppTheme.accentGreen;
                  bgColor = AppTheme.accentGreen.withValues(alpha: 0.15);
                } else if (isSelected && !isCorrect) {
                  borderColor = AppTheme.errorRed;
                  bgColor = AppTheme.errorRed.withValues(alpha: 0.15);
                }
              } else if (isSelected) {
                borderColor = AppTheme.pythonBlue;
                bgColor = AppTheme.pythonBlue.withValues(alpha: 0.15);
              }

              return Container(
                margin: const EdgeInsets.only(bottom: 10),
                decoration: BoxDecoration(
                  color: bgColor,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: borderColor, width: 1.5),
                ),
                child: ListTile(
                  onTap: _isAnswerSubmitted ? null : () => setState(() => _selectedOption = idx),
                  leading: Container(
                    width: 28,
                    height: 28,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: isSelected
                          ? AppTheme.pythonBlue
                          : (isDark ? const Color(0xFF1E293B) : const Color(0xFFEFF6FF)),
                    ),
                    child: Text(
                      String.fromCharCode(65 + idx), // A, B, C, D
                      style: GoogleFonts.outfit(
                        color: isSelected || isDark ? Colors.white : AppTheme.pythonBlue,
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                      ),
                    ),
                  ),
                  title: Text(
                    q.options[idx],
                    style: GoogleFonts.inter(
                      color: AppTheme.textPrimaryOf(context),
                      fontSize: 13.5,
                      height: 1.35,
                    ),
                  ),
                  trailing: _isAnswerSubmitted
                      ? (isCorrect
                          ? const Icon(Icons.check_circle_rounded, color: AppTheme.accentGreen)
                          : isSelected
                              ? const Icon(Icons.cancel_rounded, color: AppTheme.errorRed)
                              : null)
                      : null,
                ),
              );
            }),

            // Explanation Box after submission
            if (_isAnswerSubmitted) ...[
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: AppTheme.cardOf(context),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppTheme.pythonYellow.withValues(alpha: 0.4)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.lightbulb_rounded, color: AppTheme.pythonYellow, size: 18),
                        const SizedBox(width: 6),
                        Text(
                          'Explanation:',
                          style: GoogleFonts.outfit(
                            color: AppTheme.pythonYellow,
                            fontWeight: FontWeight.bold,
                            fontSize: 13.5,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Text(
                      q.explanation,
                      style: GoogleFonts.inter(
                        color: AppTheme.textSecondaryOf(context),
                        fontSize: 13,
                        height: 1.45,
                      ),
                    ),
                  ],
                ),
              ),
            ],

            const SizedBox(height: 24),

            // Submit / Next Action Button
            ElevatedButton(
              onPressed: _selectedOption == null
                  ? null
                  : _isAnswerSubmitted
                      ? _nextQuestion
                      : _submitAnswer,
              style: ElevatedButton.styleFrom(
                backgroundColor: _isAnswerSubmitted ? const Color(0xFF10B981) : AppTheme.pythonBlue,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              child: Text(
                !_isAnswerSubmitted
                    ? 'Submit Answer'
                    : (_currentIndex < _questions.length - 1 ? 'Next Question →' : 'Complete Exam'),
                style: GoogleFonts.outfit(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildResultsView() {
    final scorePercentage = (_correctAnswers / _questions.length) * 100;
    final isPassed = scorePercentage >= 70.0;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Exam Results'),
        automaticallyImplyLeading: false,
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Result Trophy / Badge
              Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: (isPassed ? const Color(0xFF10B981) : AppTheme.errorRed).withValues(alpha: 0.15),
                  border: Border.all(
                    color: isPassed ? const Color(0xFF10B981) : AppTheme.errorRed,
                    width: 2,
                  ),
                ),
                child: Icon(
                  isPassed ? Icons.workspace_premium_rounded : Icons.replay_rounded,
                  size: 52,
                  color: isPassed ? AppTheme.pythonYellow : AppTheme.errorRed,
                ),
              ),
              const SizedBox(height: 20),

              Text(
                isPassed ? 'Congratulations!' : 'Keep Practicing!',
                style: GoogleFonts.outfit(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.textPrimaryOf(context),
                ),
              ),
              const SizedBox(height: 8),

              Text(
                isPassed
                    ? 'You passed the PyPocket Certified Python Specialist Assessment!'
                    : 'Passing score is 70%. Review the lessons and try again.',
                textAlign: TextAlign.center,
                style: GoogleFonts.inter(color: AppTheme.textSecondaryOf(context), fontSize: 14),
              ),
              const SizedBox(height: 24),

              // Stats Row
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: AppTheme.cardOf(context),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppTheme.borderOf(context)),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _statColumn('Score', '${scorePercentage.toInt()}%', AppTheme.pythonYellow),
                    _statColumn('Correct', '$_correctAnswers/${_questions.length}', AppTheme.accentGreen),
                    _statColumn('XP Earned', '+$_totalXpEarned', AppTheme.pythonBlue),
                  ],
                ),
              ),
              const SizedBox(height: 28),

              // Action Buttons
              if (isPassed && widget.isCertificationExam) ...[
                ElevatedButton.icon(
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => const CertificatesScreen()),
                    );
                  },
                  icon: const Icon(Icons.card_membership_rounded),
                  label: const Text('View Official Certificate'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFF59E0B),
                    foregroundColor: Colors.black,
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                    minimumSize: const Size(double.infinity, 50),
                  ),
                ),
                const SizedBox(height: 12),
              ],

              OutlinedButton(
                onPressed: () => Navigator.pop(context),
                style: OutlinedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 50),
                ),
                child: const Text('Return to Home'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _statColumn(String label, String value, Color color) {
    return Column(
      children: [
        Text(
          value,
          style: GoogleFonts.jetBrainsMono(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: GoogleFonts.outfit(color: AppTheme.textMutedOf(context), fontSize: 12),
        ),
      ],
    );
  }
}
