import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/lesson_model.dart';
import '../models/code_execution_model.dart';
import '../services/python_runner_service.dart';
import '../services/storage_service.dart';
import '../services/database_service.dart';
import '../theme/app_theme.dart';
import '../widgets/embedded_video_player.dart';
import 'playground_screen.dart';

class LessonDetailScreen extends StatefulWidget {
  final Lesson lesson;

  const LessonDetailScreen({super.key, required this.lesson});

  @override
  State<LessonDetailScreen> createState() => _LessonDetailScreenState();
}

class _LessonDetailScreenState extends State<LessonDetailScreen> {
  final PythonRunnerService _runner = PythonRunnerService();
  late TextEditingController _exerciseController;
  CodeExecutionResult? _exampleRunResult;
  CodeExecutionResult? _exerciseRunResult;
  bool _isRunningExample = false;
  bool _isRunningExercise = false;
  bool _showSolution = false;
  bool _isCompleted = false;
  String? _runnerErrorMessage;

  @override
  void initState() {
    super.initState();
    _exerciseController = TextEditingController(text: widget.lesson.starterCode);
    final profile = StorageService.getUserProfile();
    _isCompleted = profile.completedLessonIds.contains(widget.lesson.id);
  }

  @override
  void dispose() {
    _exerciseController.dispose();
    super.dispose();
  }

  Future<void> _runExample() async {
    setState(() {
      _isRunningExample = true;
      _runnerErrorMessage = null;
    });

    try {
      final res = await _runner.executePython(sourceCode: widget.lesson.codeExample);
      if (mounted) {
        setState(() {
          _exampleRunResult = res;
          _isRunningExample = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isRunningExample = false;
          _runnerErrorMessage = 'Execution failed: $e. Check your network connection.';
        });
      }
    }
  }

  Future<void> _runExercise() async {
    setState(() {
      _isRunningExercise = true;
      _runnerErrorMessage = null;
    });

    try {
      final res = await _runner.executePython(sourceCode: _exerciseController.text);
      if (mounted) {
        setState(() {
          _exerciseRunResult = res;
          _isRunningExercise = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isRunningExercise = false;
          _runnerErrorMessage = 'Execution failed: $e. Check your network connection.';
        });
      }
    }
  }

  Future<void> _completeLesson() async {
    await StorageService.markLessonCompleted(widget.lesson.id, widget.lesson.xp);
    final profile = StorageService.getUserProfile();
    await DatabaseService.syncProfileToCloud(profile);

    if (mounted) {
      setState(() {
        _isCompleted = true;
      });

      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          backgroundColor: AppTheme.surfaceOf(context),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
            side: const BorderSide(color: Color(0xFF10B981)),
          ),
          title: Row(
            children: [
              const Icon(Icons.verified_rounded, color: Color(0xFFC89B58), size: 24),
              const SizedBox(width: 8),
              Text(
                'Mastery Achieved!',
                style: GoogleFonts.outfit(
                  color: AppTheme.textPrimaryOf(context),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'You earned +${widget.lesson.xp} XP for completing "${widget.lesson.title}"!',
                style: GoogleFonts.inter(color: AppTheme.textSecondaryOf(context), fontSize: 14),
              ),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppTheme.accentGreen.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.bolt, color: AppTheme.pythonYellow),
                    const SizedBox(width: 8),
                    Text(
                      'Total XP: ${profile.xp} XP',
                      style: GoogleFonts.outfit(
                        color: AppTheme.textPrimaryOf(context),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          actions: [
            ElevatedButton(
              onPressed: () => Navigator.pop(ctx),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.accentGreen,
                foregroundColor: Colors.black,
              ),
              child: const Text('Continue Journey'),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final lesson = widget.lesson;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardColor = AppTheme.cardOf(context);
    final borderColor = AppTheme.borderOf(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          lesson.title,
          style: GoogleFonts.outfit(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.open_in_new_rounded, color: AppTheme.pythonYellow),
            tooltip: 'Open in Full IDE Playground',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => PlaygroundScreen(initialCode: lesson.codeExample),
                ),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
        physics: const BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Track & Difficulty Badges
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppTheme.pythonBlue.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: AppTheme.pythonBlue.withValues(alpha: 0.4)),
                  ),
                  child: Text(
                    lesson.track,
                    style: GoogleFonts.outfit(
                      color: AppTheme.pythonBlue,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.amber.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    '+${lesson.xp} XP',
                    style: GoogleFonts.outfit(
                      color: AppTheme.pythonYellow,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const Spacer(),
                if (_isCompleted)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppTheme.accentGreen.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: AppTheme.accentGreen),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.check_circle_rounded, size: 14, color: AppTheme.accentGreen),
                        const SizedBox(width: 4),
                        Text(
                          'Completed',
                          style: GoogleFonts.outfit(
                            color: AppTheme.accentGreen,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 18),

            // Embedded Video Player (if available)
            if (lesson.youtubeVideoId != null && lesson.youtubeVideoId!.isNotEmpty) ...[
              EmbeddedVideoPlayer(
                videoId: lesson.youtubeVideoId!,
                videoTitle: lesson.videoTitle ?? '${lesson.title} - Video Masterclass',
                durationMinutes: lesson.videoDurationMinutes,
              ),
              const SizedBox(height: 20),
            ],

            // Lesson Overview
            Text(
              lesson.description,
              style: GoogleFonts.outfit(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: AppTheme.textPrimaryOf(context),
              ),
            ),
            const SizedBox(height: 12),

            // Concept Content Box
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: cardColor,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: borderColor),
              ),
              child: Text(
                lesson.content,
                style: GoogleFonts.inter(
                  fontSize: 14.5,
                  height: 1.65,
                  color: AppTheme.textSecondaryOf(context),
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Key Architectural Concepts
            if (lesson.keyConcepts.isNotEmpty) ...[
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFF3B82F6).withValues(alpha: isDark ? 0.08 : 0.05),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: const Color(0xFF3B82F6).withValues(alpha: 0.25)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.psychology_outlined, color: Color(0xFF3B82F6), size: 18),
                        const SizedBox(width: 8),
                        Text(
                          'Key Architectural Concepts',
                          style: GoogleFonts.outfit(
                            fontSize: 14.5,
                            fontWeight: FontWeight.bold,
                            color: AppTheme.textPrimaryOf(context),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    ...lesson.keyConcepts.map(
                      (concept) => Padding(
                        padding: const EdgeInsets.only(bottom: 6),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('• ', style: TextStyle(color: Color(0xFF3B82F6), fontWeight: FontWeight.bold)),
                            Expanded(
                              child: Text(
                                concept,
                                style: GoogleFonts.inter(
                                  fontSize: 13,
                                  color: AppTheme.textSecondaryOf(context),
                                  height: 1.4,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
            ],

            // Common Mistakes & Pitfalls
            if (lesson.commonMistakes.isNotEmpty) ...[
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFFF59E0B).withValues(alpha: isDark ? 0.08 : 0.06),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: const Color(0xFFF59E0B).withValues(alpha: 0.3)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.warning_amber_rounded, color: Color(0xFFF59E0B), size: 18),
                        const SizedBox(width: 8),
                        Text(
                          'Common Gotchas & Pitfalls to Avoid',
                          style: GoogleFonts.outfit(
                            fontSize: 14.5,
                            fontWeight: FontWeight.bold,
                            color: AppTheme.textPrimaryOf(context),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    ...lesson.commonMistakes.map(
                      (mistake) => Padding(
                        padding: const EdgeInsets.only(bottom: 6),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Icon(Icons.warning_amber_rounded, size: 14, color: AppTheme.pythonYellow),
                            const SizedBox(width: 6),
                            Expanded(
                              child: Text(
                                mistake,
                                style: GoogleFonts.inter(
                                  fontSize: 13,
                                  color: AppTheme.textSecondaryOf(context),
                                  height: 1.4,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
            ],

            // Live Code Example Section
            Row(
              children: [
                const Icon(Icons.code_rounded, color: AppTheme.pythonYellow, size: 20),
                const SizedBox(width: 8),
                Text(
                  'Interactive Example',
                  style: GoogleFonts.outfit(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.textPrimaryOf(context),
                  ),
                ),
                const Spacer(),
                ElevatedButton.icon(
                  onPressed: _isRunningExample ? null : _runExample,
                  icon: _isRunningExample
                      ? const SizedBox(
                          width: 14,
                          height: 14,
                          child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                        )
                      : const Icon(Icons.play_arrow_rounded, size: 16),
                  label: Text(_isRunningExample ? 'Running' : 'Run Example'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.pythonBlue,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),

            // Code Preview Box
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppTheme.darkTerminalBg,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: AppTheme.darkBorder),
              ),
              child: SelectableText(
                lesson.codeExample,
                style: AppTheme.codeStyle,
              ),
            ),

            // Output of example if run
            if (_exampleRunResult != null) ...[
              const SizedBox(height: 10),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: const Color(0xFF0C1420),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: _exampleRunResult!.isSuccess
                        ? AppTheme.accentGreen.withValues(alpha: 0.6)
                        : AppTheme.errorRed.withValues(alpha: 0.6),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _exampleRunResult!.isSuccess ? 'EXECUTION SUCCESSFUL:' : 'EXECUTION NOTICE:',
                      style: GoogleFonts.jetBrainsMono(
                        color: _exampleRunResult!.isSuccess ? AppTheme.accentGreen : AppTheme.errorRed,
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 6),
                    SelectableText(
                      _exampleRunResult!.stdout.isNotEmpty
                          ? _exampleRunResult!.stdout
                          : (_exampleRunResult!.stderr ?? 'Executed with return code 0'),
                      style: GoogleFonts.jetBrainsMono(
                        color: const Color(0xFFE2E8F0),
                        fontSize: 12.5,
                      ),
                    ),
                  ],
                ),
              ),
            ],

            const SizedBox(height: 28),

            // Hands-On Coding Challenge
            Row(
              children: [
                const Icon(Icons.fitness_center_rounded, color: AppTheme.accentCyan, size: 20),
                const SizedBox(width: 8),
                Text(
                  'Hands-On Exercise',
                  style: GoogleFonts.outfit(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.textPrimaryOf(context),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              lesson.exercisePrompt,
              style: GoogleFonts.inter(fontSize: 14, color: AppTheme.textSecondaryOf(context)),
            ),
            const SizedBox(height: 12),

            // Exercise Code Editor Area
            Container(
              decoration: BoxDecoration(
                color: const Color(0xFF0D1424),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: AppTheme.borderOf(context)),
              ),
              child: Column(
                children: [
                  TextField(
                    controller: _exerciseController,
                    maxLines: 8,
                    style: AppTheme.codeStyle,
                    decoration: const InputDecoration(
                      contentPadding: EdgeInsets.all(14),
                      border: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      fillColor: Colors.transparent,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: const BoxDecoration(
                      color: Color(0xFF131D30),
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(13),
                        bottomRight: Radius.circular(13),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        TextButton.icon(
                          onPressed: () => setState(() => _showSolution = !_showSolution),
                          icon: Icon(
                            _showSolution ? Icons.visibility_off : Icons.lightbulb_outline,
                            size: 16,
                            color: AppTheme.pythonYellow,
                          ),
                          label: Text(
                            _showSolution ? 'Hide Solution' : 'Reveal Solution',
                            style: GoogleFonts.outfit(color: AppTheme.pythonYellow, fontSize: 13),
                          ),
                        ),
                        ElevatedButton.icon(
                          onPressed: _isRunningExercise ? null : _runExercise,
                          icon: _isRunningExercise
                              ? const SizedBox(
                                  width: 14,
                                  height: 14,
                                  child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                                )
                              : const Icon(Icons.play_arrow_rounded, size: 16),
                          label: const Text('Test Solution'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF10B981),
                            foregroundColor: Colors.black,
                            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            if (_exerciseRunResult != null) ...[
              const SizedBox(height: 10),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: const Color(0xFF0C1420),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: _exerciseRunResult!.isSuccess ? AppTheme.accentGreen : AppTheme.errorRed,
                  ),
                ),
                child: SelectableText(
                  _exerciseRunResult!.stdout.isNotEmpty
                      ? _exerciseRunResult!.stdout
                      : (_exerciseRunResult!.stderr ?? 'Executed'),
                  style: GoogleFonts.jetBrainsMono(
                    color: _exerciseRunResult!.isSuccess ? const Color(0xFFE2E8F0) : const Color(0xFFF87171),
                    fontSize: 12.5,
                  ),
                ),
              ),
            ],

            if (_runnerErrorMessage != null) ...[
              const SizedBox(height: 10),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppTheme.errorRed.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: AppTheme.errorRed),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.error_outline_rounded, color: AppTheme.errorRed, size: 18),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        _runnerErrorMessage!,
                        style: GoogleFonts.inter(color: AppTheme.errorRed, fontSize: 13),
                      ),
                    ),
                  ],
                ),
              ),
            ],

            if (_showSolution) ...[
              const SizedBox(height: 12),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: cardColor,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppTheme.pythonYellow.withValues(alpha: 0.4)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Official Reference Solution:',
                      style: GoogleFonts.outfit(
                        color: AppTheme.pythonYellow,
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                      ),
                    ),
                    const SizedBox(height: 6),
                    SelectableText(
                      lesson.solutionCode,
                      style: GoogleFonts.jetBrainsMono(
                        fontSize: 13,
                        color: AppTheme.textPrimaryOf(context),
                      ),
                    ),
                  ],
                ),
              ),
            ],

            const SizedBox(height: 30),

            // Completion Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: _isCompleted ? null : _completeLesson,
                icon: Icon(_isCompleted ? Icons.check_circle_rounded : Icons.star_rounded),
                label: Text(
                  _isCompleted
                      ? 'Lesson Completed (+${lesson.xp} XP Earned)'
                      : 'Mark Lesson As Completed (+${lesson.xp} XP)',
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: _isCompleted
                      ? (isDark ? const Color(0xFF1E293B) : const Color(0xFFE2E8F0))
                      : const Color(0xFF7C3AED),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                ),
              ),
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}
