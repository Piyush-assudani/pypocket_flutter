import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/lesson_model.dart';
import '../data/python_lessons_data.dart';
import '../services/storage_service.dart';
import '../theme/app_theme.dart';
import '../widgets/xp_badge.dart';
import '../widgets/three_d_tilt_card.dart';
import 'lesson_detail_screen.dart';

class LessonsScreen extends StatefulWidget {
  const LessonsScreen({super.key});

  @override
  State<LessonsScreen> createState() => _LessonsScreenState();
}

class _LessonsScreenState extends State<LessonsScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _selectedTrack = 'All';
  String _searchQuery = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final profile = StorageService.getUserProfile();
    final allLessons = PythonLessonsData.lessons;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final completedCount = allLessons
        .where((l) => profile.completedLessonIds.contains(l.id))
        .length;
    final progress = allLessons.isEmpty ? 0.0 : completedCount / allLessons.length;

    // Filter lessons based on track and search query
    final filteredLessons = allLessons.where((lesson) {
      final matchesTrack = _selectedTrack == 'All' ||
          (_selectedTrack == 'Bookmarked'
              ? profile.bookmarkedLessonIds.contains(lesson.id)
              : lesson.track == _selectedTrack);

      final matchesSearch = _searchQuery.isEmpty ||
          lesson.title.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          lesson.description.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          lesson.track.toLowerCase().contains(_searchQuery.toLowerCase());

      return matchesTrack && matchesSearch;
    }).toList();

    // Group filtered lessons by track
    final Map<String, List<Lesson>> tracks = {};
    for (final lesson in filteredLessons) {
      tracks.putIfAbsent(lesson.track, () => []).add(lesson);
    }

    final trackFilterOptions = [
      'All',
      'Bookmarked',
      'Foundations',
      'Control Flow',
      'Data Structures',
      'Functions',
      'OOP Mastery',
      'Error Handling',
      'Files & Data',
      'Concurrency',
      'Algorithms',
    ];

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: AppTheme.accentPurple.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(Icons.school_rounded, color: AppTheme.accentPurple, size: 20),
            ),
            const SizedBox(width: 10),
            Text(
              'Python Curriculum',
              style: GoogleFonts.outfit(fontWeight: FontWeight.bold, fontSize: 19),
            ),
          ],
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Hero Progress Card with 3D Depth
            ThreeDTiltCard(
              borderRadius: BorderRadius.circular(18),
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
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(
                    color: isDark ? const Color(0xFF4338CA).withValues(alpha: 0.4) : AppTheme.borderOf(context),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Python Mastery Path',
                            style: GoogleFonts.outfit(
                              color: AppTheme.textPrimaryOf(context),
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '$completedCount of ${allLessons.length} modules completed',
                            style: GoogleFonts.inter(color: AppTheme.textSecondaryOf(context), fontSize: 13),
                          ),
                        ],
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: AppTheme.pythonYellow.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: AppTheme.pythonYellow.withValues(alpha: 0.3)),
                        ),
                        child: Text(
                          '${(progress * 100).toInt()}% Done',
                          style: GoogleFonts.jetBrainsMono(
                            color: AppTheme.pythonYellow,
                            fontWeight: FontWeight.bold,
                            fontSize: 13,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: LinearProgressIndicator(
                      value: progress,
                      minHeight: 8,
                      backgroundColor: isDark ? const Color(0xFF1E293B) : const Color(0xFFE2E8F0),
                      valueColor: const AlwaysStoppedAnimation<Color>(AppTheme.accentGreen),
                    ),
                  ),
                ],
              ),
            ),
            ),
            const SizedBox(height: 16),

            // Search Bar
            TextField(
              controller: _searchController,
              onChanged: (val) => setState(() => _searchQuery = val),
              decoration: InputDecoration(
                hintText: 'Search lessons, topics, algorithms...',
                prefixIcon: const Icon(Icons.search_rounded),
                suffixIcon: _searchQuery.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear_rounded, size: 18),
                        onPressed: () {
                          _searchController.clear();
                          setState(() => _searchQuery = '');
                        },
                      )
                    : null,
              ),
            ),
            const SizedBox(height: 12),

            // Filter Chips Tray
            SizedBox(
              height: 38,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: trackFilterOptions.length,
                separatorBuilder: (_, index) => const SizedBox(width: 8),
                itemBuilder: (context, index) {
                  final opt = trackFilterOptions[index];
                  final isSelected = opt == _selectedTrack;
                  return InkWell(
                    borderRadius: BorderRadius.circular(20),
                    onTap: () => setState(() => _selectedTrack = opt),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? AppTheme.pythonBlue
                            : AppTheme.cardOf(context),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: isSelected ? AppTheme.pythonBlue : AppTheme.borderOf(context),
                        ),
                      ),
                      child: Row(
                        children: [
                          if (opt == 'Bookmarked') ...[
                            Icon(
                              Icons.bookmark_rounded,
                              size: 13,
                              color: isSelected ? Colors.white : AppTheme.pythonYellow,
                            ),
                            const SizedBox(width: 4),
                          ],
                          Text(
                            opt,
                            style: GoogleFonts.outfit(
                              color: isSelected ? Colors.white : AppTheme.textSecondaryOf(context),
                              fontSize: 12,
                              fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 20),

            // Track Sections & Lesson Cards
            if (filteredLessons.isEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 40),
                child: Center(
                  child: Column(
                    children: [
                      Icon(Icons.search_off_rounded, size: 48, color: AppTheme.textMutedOf(context)),
                      const SizedBox(height: 12),
                      Text(
                        'No matching lessons found',
                        style: GoogleFonts.outfit(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.textPrimaryOf(context),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Try searching for another keyword or filter.',
                        style: GoogleFonts.inter(fontSize: 13, color: AppTheme.textMutedOf(context)),
                      ),
                    ],
                  ),
                ),
              )
            else
              ...tracks.entries.map((entry) {
                final trackName = entry.key;
                final lessons = entry.value;

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: Text(
                        trackName.toUpperCase(),
                        style: GoogleFonts.outfit(
                          color: AppTheme.textMutedOf(context),
                          fontSize: 11.5,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 1.2,
                        ),
                      ),
                    ),
                    ...lessons.map((lesson) {
                      final isDone = profile.completedLessonIds.contains(lesson.id);
                      final isBookmarked = profile.bookmarkedLessonIds.contains(lesson.id);

                      return Container(
                        margin: const EdgeInsets.only(bottom: 10),
                        decoration: BoxDecoration(
                          color: AppTheme.cardOf(context),
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(
                            color: isDone
                                ? AppTheme.accentGreen.withValues(alpha: 0.4)
                                : AppTheme.borderOf(context),
                          ),
                        ),
                        child: ListTile(
                          contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                          leading: Container(
                            width: 44,
                            height: 44,
                            decoration: BoxDecoration(
                              color: isDone
                                  ? AppTheme.accentGreen.withValues(alpha: 0.15)
                                  : (isDark ? const Color(0xFF1E293B) : const Color(0xFFEFF6FF)),
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: isDone ? AppTheme.accentGreen : AppTheme.borderOf(context),
                              ),
                            ),
                            child: Icon(
                              isDone ? Icons.check_circle_rounded : Icons.terminal_rounded,
                              color: isDone ? AppTheme.accentGreen : AppTheme.pythonYellow,
                              size: 22,
                            ),
                          ),
                          title: Row(
                            children: [
                              Expanded(
                                child: Text(
                                  lesson.title,
                                  style: GoogleFonts.outfit(
                                    fontWeight: FontWeight.w600,
                                    color: AppTheme.textPrimaryOf(context),
                                    fontSize: 15,
                                  ),
                                ),
                              ),
                              IconButton(
                                icon: Icon(
                                  isBookmarked ? Icons.bookmark_rounded : Icons.bookmark_border_rounded,
                                  size: 19,
                                  color: isBookmarked ? AppTheme.pythonYellow : AppTheme.textMutedOf(context),
                                ),
                                padding: EdgeInsets.zero,
                                constraints: const BoxConstraints(),
                                onPressed: () async {
                                  await StorageService.toggleBookmark(lesson.id);
                                  setState(() {});
                                },
                              ),
                            ],
                          ),
                          subtitle: Padding(
                            padding: const EdgeInsets.only(top: 4),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  lesson.description,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: GoogleFonts.inter(color: AppTheme.textSecondaryOf(context), fontSize: 12.5),
                                ),
                                if (lesson.youtubeVideoId != null) ...[
                                  const SizedBox(height: 6),
                                  Row(
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                                        decoration: BoxDecoration(
                                          color: const Color(0xFFFF0000).withValues(alpha: 0.12),
                                          borderRadius: BorderRadius.circular(6),
                                          border: Border.all(color: const Color(0xFFFF0000).withValues(alpha: 0.3), width: 0.8),
                                        ),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            const Icon(Icons.play_circle_fill_rounded, color: Color(0xFFFF0000), size: 12),
                                            const SizedBox(width: 4),
                                            Text(
                                              'Video Class (${lesson.videoDurationMinutes ?? 15}m)',
                                              style: GoogleFonts.outfit(
                                                color: const Color(0xFFFF0000),
                                                fontSize: 10.5,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ],
                            ),
                          ),
                          trailing: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                decoration: BoxDecoration(
                                  color: Colors.amber.withValues(alpha: 0.15),
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Text(
                                  '+${lesson.xp} XP',
                                  style: GoogleFonts.outfit(
                                    color: AppTheme.pythonYellow,
                                    fontSize: 11,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                lesson.difficulty.name.toUpperCase(),
                                style: GoogleFonts.jetBrainsMono(
                                  color: lesson.difficulty == LessonDifficulty.easy
                                      ? AppTheme.accentGreen
                                      : lesson.difficulty == LessonDifficulty.medium
                                          ? AppTheme.pythonBlue
                                          : AppTheme.accentPurple,
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          onTap: () async {
                            await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => LessonDetailScreen(lesson: lesson),
                              ),
                            );
                            setState(() {});
                          },
                        ),
                      );
                    }),
                    const SizedBox(height: 14),
                  ],
                );
              }),
          ],
        ),
      ),
    );
  }
}
