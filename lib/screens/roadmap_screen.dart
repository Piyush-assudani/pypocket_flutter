import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import '../data/python_lessons_data.dart';
import '../models/lesson_model.dart';
import '../services/storage_service.dart';
import '../theme/app_theme.dart';
import '../widgets/xp_badge.dart';
import '../widgets/three_d_tilt_card.dart';
import 'lesson_detail_screen.dart';
import 'certificates_screen.dart';

class RoadmapMilestone {
  final int step;
  final String title;
  final String track;
  final String description;
  final IconData icon;
  final List<String> lessonIds;
  final int requiredXp;

  const RoadmapMilestone({
    required this.step,
    required this.title,
    required this.track,
    required this.description,
    required this.icon,
    required this.lessonIds,
    required this.requiredXp,
  });
}

class RoadmapScreen extends StatelessWidget {
  const RoadmapScreen({super.key});

  static const List<RoadmapMilestone> milestones = [
    RoadmapMilestone(
      step: 1,
      title: 'Python Foundations',
      track: 'Foundations',
      description: 'Variables, integers, floats, string manipulation & boolean logic.',
      icon: Icons.terminal_rounded,
      lessonIds: ['py_1', 'py_2', 'py_3'],
      requiredXp: 0,
    ),
    RoadmapMilestone(
      step: 2,
      title: 'Logic & Control Flow',
      track: 'Control Flow',
      description: 'Conditionals, while loops, for-in loops & comprehension syntax.',
      icon: Icons.alt_route_rounded,
      lessonIds: ['py_4', 'py_5'],
      requiredXp: 75,
    ),
    RoadmapMilestone(
      step: 3,
      title: 'Collections & Data Structures',
      track: 'Data Structures',
      description: 'Lists, Tuples, Dictionaries, Sets & memory mutability.',
      icon: Icons.inventory_2_rounded,
      lessonIds: ['py_6', 'py_7'],
      requiredXp: 150,
    ),
    RoadmapMilestone(
      step: 4,
      title: 'Functions & Modularity',
      track: 'Functions',
      description: 'Def, *args, **kwargs, lambda functions, closures & scopes.',
      icon: Icons.bolt_rounded,
      lessonIds: ['py_8', 'py_9'],
      requiredXp: 250,
    ),
    RoadmapMilestone(
      step: 5,
      title: 'Object-Oriented Programming',
      track: 'OOP Mastery',
      description: 'Classes, __init__, dunders, inheritance & polymorphism.',
      icon: Icons.account_tree_rounded,
      lessonIds: ['py_10', 'py_11', 'py_12'],
      requiredXp: 400,
    ),
    RoadmapMilestone(
      step: 6,
      title: 'Error Handling & File I/O',
      track: 'Error Handling',
      description: 'Try/except, custom exceptions, with-statements & JSON parsing.',
      icon: Icons.security_rounded,
      lessonIds: ['py_13', 'py_14', 'py_15'],
      requiredXp: 600,
    ),
    RoadmapMilestone(
      step: 7,
      title: 'Concurrency & Asyncio',
      track: 'Concurrency',
      description: 'Threading, multiprocessing, GIL mechanics, async/await.',
      icon: Icons.speed_rounded,
      lessonIds: ['py_16', 'py_17'],
      requiredXp: 800,
    ),
    RoadmapMilestone(
      step: 8,
      title: 'Algorithms & Complexity',
      track: 'Algorithms',
      description: 'Binary search, sorting, recursion & Big-O efficiency.',
      icon: Icons.psychology_rounded,
      lessonIds: ['py_18', 'py_19', 'py_20'],
      requiredXp: 1050,
    ),
    RoadmapMilestone(
      step: 9,
      title: 'Certification Verification Exam',
      track: 'Certification',
      description: 'Official 100% verified certification exam & credential issuance.',
      icon: Icons.verified_rounded,
      lessonIds: [],
      requiredXp: 1500,
    ),
  ];

  void _downloadRoadmapNotes(BuildContext context) {
    final buffer = StringBuffer();
    buffer.writeln('# PyPocket Complete Python Engineering Roadmap');
    buffer.writeln('Structured Professional Trajectory · From Foundations to Certified Specialist\n');

    for (final m in milestones) {
      buffer.writeln('### Milestone ${m.step}: ${m.title} (${m.track})');
      buffer.writeln('- **Required XP:** ${m.requiredXp} XP');
      buffer.writeln('- **Core Focus:** ${m.description}');
      buffer.writeln('- **Associated Lessons:** ${m.lessonIds.isEmpty ? "Final Certification Evaluation" : m.lessonIds.join(", ")}\n');
    }

    Clipboard.setData(ClipboardData(text: buffer.toString()));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Python Engineering Roadmap downloaded & copied to clipboard!'),
        backgroundColor: Color(0xFF10B981),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final profile = StorageService.getUserProfile();
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final allLessons = PythonLessonsData.lessons;
    final completedCount = allLessons
        .where((l) => profile.completedLessonIds.contains(l.id))
        .length;
    final overallProgress = allLessons.isEmpty
        ? 0.0
        : completedCount / allLessons.length;

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: const Color(0xFF6366F1).withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(Icons.alt_route_rounded, color: Color(0xFF6366F1), size: 20),
            ),
            const SizedBox(width: 10),
            Text(
              'Python Skill Roadmap',
              style: GoogleFonts.outfit(fontWeight: FontWeight.bold, fontSize: 18),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.download_rounded, color: Color(0xFFC89B58)),
            tooltip: 'Download Roadmap Notes',
            onPressed: () => _downloadRoadmapNotes(context),
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
            // Top Progress Banner
            ThreeDTiltCard(
              borderRadius: BorderRadius.circular(20),
              elevation: 6,
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: isDark
                        ? [const Color(0xFF1E1B4B), const Color(0xFF0F172A)]
                        : [const Color(0xFFEEF2FF), Colors.white],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: isDark ? const Color(0xFF4338CA).withValues(alpha: 0.5) : const Color(0xFFC7D2FE),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Career Path Progress',
                          style: GoogleFonts.outfit(
                            fontWeight: FontWeight.bold,
                            fontSize: 17,
                            color: AppTheme.textPrimaryOf(context),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: const Color(0xFF6366F1).withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            '${(overallProgress * 100).toInt()}% Done',
                            style: GoogleFonts.jetBrainsMono(
                              color: const Color(0xFF6366F1),
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Text(
                      '$completedCount of ${allLessons.length} core Python syllabus lessons mastered.',
                      style: GoogleFonts.inter(
                        color: AppTheme.textSecondaryOf(context),
                        fontSize: 12.5,
                      ),
                    ),
                    const SizedBox(height: 14),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: LinearProgressIndicator(
                        value: overallProgress,
                        minHeight: 8,
                        backgroundColor: isDark ? const Color(0xFF1E293B) : const Color(0xFFE2E8F0),
                        valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF6366F1)),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Roadmap Timeline Nodes
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: milestones.length,
              itemBuilder: (context, index) {
                final milestone = milestones[index];
                final isLast = index == milestones.length - 1;

                // Determine node state
                bool isCompleted = false;
                bool isCurrent = false;

                if (milestone.lessonIds.isNotEmpty) {
                  final completedInMilestone = milestone.lessonIds
                      .where((id) => profile.completedLessonIds.contains(id))
                      .length;
                  if (completedInMilestone == milestone.lessonIds.length) {
                    isCompleted = true;
                  } else if (completedInMilestone > 0 || index == 0) {
                    isCurrent = true;
                  }
                } else {
                  // Final certification node
                  isCompleted = profile.completedLessonIds.length >= allLessons.length;
                  if (!isCompleted && completedCount >= allLessons.length - 2) {
                    isCurrent = true;
                  }
                }

                // If previous milestone was completed and this isn't, this is current
                if (index > 0 && !isCompleted && !isCurrent) {
                  final prevMilestone = milestones[index - 1];
                  final prevCompleted = prevMilestone.lessonIds
                      .every((id) => profile.completedLessonIds.contains(id));
                  if (prevCompleted) {
                    isCurrent = true;
                  }
                }

                return _buildRoadmapNode(
                  context,
                  milestone: milestone,
                  isCompleted: isCompleted,
                  isCurrent: isCurrent,
                  isLast: isLast,
                  isDark: isDark,
                  allLessons: allLessons,
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRoadmapNode(
    BuildContext context, {
    required RoadmapMilestone milestone,
    required bool isCompleted,
    required bool isCurrent,
    required bool isLast,
    required bool isDark,
    required List<Lesson> allLessons,
  }) {
    Color nodeColor;
    IconData statusIcon;
    if (isCompleted) {
      nodeColor = const Color(0xFF10B981);
      statusIcon = Icons.check_circle_rounded;
    } else if (isCurrent) {
      nodeColor = const Color(0xFF6366F1);
      statusIcon = Icons.play_arrow_rounded;
    } else {
      nodeColor = const Color(0xFF64748B);
      statusIcon = Icons.lock_outline_rounded;
    }

    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Left Timeline Indicator Column
          Column(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: nodeColor.withValues(alpha: 0.15),
                  border: Border.all(
                    color: nodeColor,
                    width: isCurrent ? 2.2 : 1.5,
                  ),
                  boxShadow: isCurrent
                      ? [
                          BoxShadow(
                            color: nodeColor.withValues(alpha: 0.4),
                            blurRadius: 10,
                            spreadRadius: 1,
                          ),
                        ]
                      : null,
                ),
                child: Center(
                  child: Icon(
                    milestone.icon,
                    color: nodeColor,
                    size: 20,
                  ),
                ),
              ),
              if (!isLast)
                Expanded(
                  child: Container(
                    width: 2.5,
                    margin: const EdgeInsets.symmetric(vertical: 4),
                    color: isCompleted
                        ? const Color(0xFF10B981)
                        : (isDark ? const Color(0xFF1E293B) : const Color(0xFFCBD5E1)),
                  ),
                ),
            ],
          ),
          const SizedBox(width: 14),

          // Right Card
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 20),
              child: InkWell(
                borderRadius: BorderRadius.circular(16),
                onTap: () {
                  if (milestone.lessonIds.isNotEmpty) {
                    final targetLesson = allLessons.firstWhere(
                      (l) => milestone.lessonIds.contains(l.id),
                      orElse: () => allLessons.first,
                    );
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => LessonDetailScreen(lesson: targetLesson),
                      ),
                    );
                  } else {
                    // Open Certification Screen
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const CertificatesScreen(),
                      ),
                    );
                  }
                },
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: isDark ? const Color(0xFF111827) : Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: isCurrent
                          ? const Color(0xFF6366F1).withValues(alpha: 0.6)
                          : (isDark ? const Color(0xFF1F2937) : const Color(0xFFE2E8F0)),
                      width: isCurrent ? 1.5 : 1,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: isDark ? 0.25 : 0.04),
                        blurRadius: 8,
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
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                            decoration: BoxDecoration(
                              color: nodeColor.withValues(alpha: 0.12),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              'STAGE ${milestone.step}',
                              style: GoogleFonts.jetBrainsMono(
                                color: nodeColor,
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          const Spacer(),
                          Icon(statusIcon, size: 16, color: nodeColor),
                          const SizedBox(width: 4),
                          Text(
                            isCompleted
                                ? 'Mastered'
                                : (isCurrent ? 'In Progress' : 'Locked'),
                            style: GoogleFonts.outfit(
                              color: nodeColor,
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        milestone.title,
                        style: GoogleFonts.outfit(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.textPrimaryOf(context),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        milestone.description,
                        style: GoogleFonts.inter(
                          fontSize: 12,
                          color: AppTheme.textSecondaryOf(context),
                          height: 1.4,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
