import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import '../data/python_booklets_data.dart';
import '../theme/app_theme.dart';
import 'playground_screen.dart';

import 'qa_handbook_screen.dart';

class BookletScreen extends StatefulWidget {
  final String? initialBookletId;

  const BookletScreen({super.key, this.initialBookletId});

  @override
  State<BookletScreen> createState() => _BookletScreenState();
}

class _BookletScreenState extends State<BookletScreen> {
  late PythonBooklet _selectedBooklet;
  int _selectedChapterIndex = 0;

  @override
  void initState() {
    super.initState();
    final list = PythonBookletsData.booklets;
    if (widget.initialBookletId != null) {
      _selectedBooklet = list.firstWhere(
        (b) => b.id == widget.initialBookletId,
        orElse: () => list.first,
      );
    } else {
      _selectedBooklet = list.first;
    }
  }

  void _copySnippet(String code) {
    Clipboard.setData(ClipboardData(text: code));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Code snippet copied to clipboard!'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _downloadCurrentNotes() {
    final currentChapter = _selectedBooklet.chapters[_selectedChapterIndex];
    final buffer = StringBuffer();
    buffer.writeln('# ${_selectedBooklet.title}');
    buffer.writeln('**Tag:** ${_selectedBooklet.tag} | **Read Time:** ${_selectedBooklet.readTime}\n');
    buffer.writeln('## ${currentChapter.title}');
    buffer.writeln('### ${currentChapter.subtitle}\n');
    buffer.writeln(currentChapter.content);
    buffer.writeln('\n```python');
    buffer.writeln(currentChapter.codeExample);
    buffer.writeln('```\n');
    buffer.writeln('### Key Takeaways & Memory Rules:');
    for (final takeaway in currentChapter.keyTakeaways) {
      buffer.writeln('- $takeaway');
    }

    Clipboard.setData(ClipboardData(text: buffer.toString()));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Notes for "${currentChapter.title}" downloaded & copied to clipboard!'),
        backgroundColor: const Color(0xFF10B981),
      ),
    );
  }

  void _runInPlayground(String code) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => PlaygroundScreen(initialCode: code),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final booklets = PythonBookletsData.booklets;
    final currentChapter = _selectedBooklet.chapters[_selectedChapterIndex];

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Python Booklets & Notes',
          style: GoogleFonts.outfit(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.help_center_rounded, color: Color(0xFFC89B58)),
            tooltip: 'Interview Q&A Handbook',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const QAHandbookScreen()),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.download_rounded, color: Color(0xFFC89B58)),
            tooltip: 'Download Chapter Notes',
            onPressed: _downloadCurrentNotes,
          ),
          const SizedBox(width: 6),
        ],
      ),
      body: Column(
        children: [
          // Horizontal Booklet Deck Selector
          Container(
            height: 96,
            padding: const EdgeInsets.symmetric(vertical: 8),
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF0F172A) : const Color(0xFFF1F5F9),
              border: Border(
                bottom: BorderSide(
                  color: isDark ? const Color(0xFF1E293B) : const Color(0xFFE2E8F0),
                ),
              ),
            ),
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              scrollDirection: Axis.horizontal,
              itemCount: booklets.length,
              separatorBuilder: (context, index) => const SizedBox(width: 10),
              itemBuilder: (context, index) {
                final b = booklets[index];
                final isSelected = b.id == _selectedBooklet.id;

                return InkWell(
                  borderRadius: BorderRadius.circular(14),
                  onTap: () {
                    HapticFeedback.selectionClick();
                    setState(() {
                      _selectedBooklet = b;
                      _selectedChapterIndex = 0;
                    });
                  },
                  child: Container(
                    width: 200,
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? const Color(0xFF2563EB)
                          : (isDark ? const Color(0xFF1E293B) : Colors.white),
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(
                        color: isSelected
                            ? const Color(0xFF2563EB)
                            : (isDark ? const Color(0xFF334155) : const Color(0xFFCBD5E1)),
                        width: isSelected ? 1.5 : 1,
                      ),
                      boxShadow: isSelected
                          ? [
                              BoxShadow(
                                color: const Color(0xFF2563EB).withValues(alpha: 0.3),
                                blurRadius: 10,
                                offset: const Offset(0, 3),
                              ),
                            ]
                          : null,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          b.tag,
                          style: GoogleFonts.outfit(
                            fontSize: 9,
                            fontWeight: FontWeight.w800,
                            letterSpacing: 1.0,
                            color: isSelected ? Colors.white70 : const Color(0xFF2563EB),
                          ),
                        ),
                        const SizedBox(height: 3),
                        Text(
                          b.title,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.outfit(
                            fontSize: 12.5,
                            fontWeight: FontWeight.bold,
                            color: isSelected ? Colors.white : AppTheme.textPrimaryOf(context),
                          ),
                        ),
                        Text(
                          '${b.chapters.length} Chapters • ${b.readTime}',
                          style: GoogleFonts.inter(
                            fontSize: 10,
                            color: isSelected ? Colors.white60 : AppTheme.textMutedOf(context),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),

          // Chapter Tabs
          if (_selectedBooklet.chapters.length > 1)
            Container(
              height: 42,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF090D16) : Colors.white,
                border: Border(
                  bottom: BorderSide(
                    color: isDark ? const Color(0xFF1E293B) : const Color(0xFFE2E8F0),
                  ),
                ),
              ),
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: _selectedBooklet.chapters.length,
                separatorBuilder: (context, index) => const SizedBox(width: 8),
                itemBuilder: (context, index) {
                  final ch = _selectedBooklet.chapters[index];
                  final isSelected = index == _selectedChapterIndex;

                  return Center(
                    child: InkWell(
                      borderRadius: BorderRadius.circular(8),
                      onTap: () {
                        HapticFeedback.selectionClick();
                        setState(() => _selectedChapterIndex = index);
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? (isDark ? const Color(0xFF1E293B) : const Color(0xFFEFF6FF))
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(8),
                          border: isSelected
                              ? Border.all(color: const Color(0xFF2563EB).withValues(alpha: 0.5))
                              : null,
                        ),
                        child: Text(
                          'Section ${index + 1}: ${ch.title.split(' ').take(3).join(' ')}...',
                          style: GoogleFonts.outfit(
                            fontSize: 11.5,
                            fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                            color: isSelected ? const Color(0xFF2563EB) : AppTheme.textSecondaryOf(context),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),

          // Main Chapter Content Area
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Chapter Header Badge
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: const Color(0xFF2563EB).withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      'BOOKLET HANDBOOK • CHAPTER ${_selectedChapterIndex + 1}',
                      style: GoogleFonts.outfit(
                        fontSize: 10,
                        fontWeight: FontWeight.w800,
                        color: const Color(0xFF2563EB),
                        letterSpacing: 1.0,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),

                  // Chapter Title
                  Text(
                    currentChapter.title,
                    style: GoogleFonts.outfit(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      letterSpacing: -0.4,
                      color: AppTheme.textPrimaryOf(context),
                    ),
                  ),
                  const SizedBox(height: 4),

                  // Subtitle
                  Text(
                    currentChapter.subtitle,
                    style: GoogleFonts.inter(
                      fontSize: 13,
                      color: AppTheme.textSecondaryOf(context),
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                  const SizedBox(height: 18),

                  // Formatted Text Box
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(18),
                    decoration: BoxDecoration(
                      color: isDark ? const Color(0xFF101726) : Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: isDark ? const Color(0xFF1E293B) : const Color(0xFFE2E8F0),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.03),
                          blurRadius: 10,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Text(
                      currentChapter.content,
                      style: GoogleFonts.inter(
                        fontSize: 14,
                        height: 1.6,
                        color: AppTheme.textPrimaryOf(context),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Code Snippet Box Header
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.code_rounded, size: 16, color: Color(0xFF2563EB)),
                          const SizedBox(width: 6),
                          Text(
                            'EXECUTABLE PYTHON SNIPPET',
                            style: GoogleFonts.outfit(
                              fontSize: 11,
                              fontWeight: FontWeight.w800,
                              letterSpacing: 1.0,
                              color: AppTheme.textMutedOf(context),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          IconButton(
                            icon: const Icon(Icons.copy_rounded, size: 16),
                            tooltip: 'Copy Code',
                            onPressed: () => _copySnippet(currentChapter.codeExample),
                          ),
                          IconButton(
                            icon: const Icon(Icons.play_arrow_rounded, size: 20, color: Color(0xFF10B981)),
                            tooltip: 'Run in CPython 3 IDE',
                            onPressed: () => _runInPlayground(currentChapter.codeExample),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),

                  // Code Snippet Container
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: const Color(0xFF0F172A),
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: const Color(0xFF1E293B)),
                    ),
                    child: SelectableText(
                      currentChapter.codeExample,
                      style: GoogleFonts.jetBrainsMono(
                        fontSize: 12.5,
                        color: const Color(0xFF38BDF8),
                        height: 1.5,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Key Takeaways Box
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: (isDark ? const Color(0xFF064E3B) : const Color(0xFFECFDF5)).withValues(alpha: 0.5),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: const Color(0xFF10B981).withValues(alpha: 0.3)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Icon(Icons.lightbulb_outline_rounded, color: Color(0xFF10B981), size: 18),
                            const SizedBox(width: 8),
                            Text(
                              'CORE TAKEAWAYS & MEMORY RULES',
                              style: GoogleFonts.outfit(
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                                color: const Color(0xFF10B981),
                                letterSpacing: 0.8,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        ...currentChapter.keyTakeaways.map(
                          (takeaway) => Padding(
                            padding: const EdgeInsets.only(bottom: 6),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text('• ', style: TextStyle(color: Color(0xFF10B981), fontWeight: FontWeight.bold)),
                                Expanded(
                                  child: Text(
                                    takeaway,
                                    style: GoogleFonts.inter(
                                      fontSize: 12.5,
                                      color: isDark ? Colors.white70 : const Color(0xFF065F46),
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

                  // Bottom Run in Playground Action
                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF2563EB),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      onPressed: () => _runInPlayground(currentChapter.codeExample),
                      icon: const Icon(Icons.terminal_rounded, size: 18, color: Colors.white),
                      label: Text(
                        'Test & Experiment in CPython IDE',
                        style: GoogleFonts.outfit(fontWeight: FontWeight.bold, color: Colors.white),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
