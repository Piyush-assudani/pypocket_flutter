import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import '../data/python_qa_data.dart';
import 'playground_screen.dart';

class QAHandbookScreen extends StatefulWidget {
  const QAHandbookScreen({super.key});

  @override
  State<QAHandbookScreen> createState() => _QAHandbookScreenState();
}

class _QAHandbookScreenState extends State<QAHandbookScreen> {
  String _selectedCategory = 'All Categories';
  String _searchQuery = '';
  final Set<String> _expandedIds = {};

  List<PythonQAItem> get _filteredItems {
    return PythonQAData.items.where((item) {
      final matchesCategory = _selectedCategory == 'All Categories' ||
          item.category == _selectedCategory;
      final q = _searchQuery.toLowerCase().trim();
      final matchesSearch = q.isEmpty ||
          item.question.toLowerCase().contains(q) ||
          item.answer.toLowerCase().contains(q) ||
          item.keyInsight.toLowerCase().contains(q);
      return matchesCategory && matchesSearch;
    }).toList();
  }

  void _downloadHandbookNotes() {
    final buffer = StringBuffer();
    buffer.writeln('# PyPocket Python Engineering Handbook & Q&A');
    buffer.writeln('Generated from PyPocket Developer Suite');
    buffer.writeln('Total Questions: ${PythonQAData.items.length}\n');

    for (final item in PythonQAData.items) {
      buffer.writeln('## [${item.difficulty}] ${item.question}');
      buffer.writeln('**Category:** ${item.category}');
      buffer.writeln('**Key Takeaway:** ${item.keyInsight}\n');
      buffer.writeln('### Detailed Technical Explanation:');
      buffer.writeln(item.answer);
      buffer.writeln('\n```python');
      buffer.writeln(item.codeExample);
      buffer.writeln('```\n');
      buffer.writeln('---\n');
    }

    Clipboard.setData(ClipboardData(text: buffer.toString()));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Complete Python Q&A Handbook downloaded & copied to clipboard!'),
        backgroundColor: Color(0xFF10B981),
        duration: Duration(seconds: 3),
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
    final surfaceColor = isDark ? const Color(0xFF0F172A) : const Color(0xFFFAF7F2);
    final cardBg = isDark ? const Color(0xFF161F33) : Colors.white;
    final borderColor = isDark ? const Color(0xFF23304B) : const Color(0xFFE8DFD0);
    final textPrimary = isDark ? Colors.white : const Color(0xFF17191C);
    final textSecondary = isDark ? const Color(0xFF94A3B8) : const Color(0xFF5A6372);

    final filtered = _filteredItems;

    return Scaffold(
      backgroundColor: surfaceColor,
      appBar: AppBar(
        backgroundColor: surfaceColor,
        elevation: 0,
        title: Text(
          'Python Handbook & Q&A',
          style: GoogleFonts.outfit(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: textPrimary,
          ),
        ),
        actions: [
          TextButton.icon(
            onPressed: _downloadHandbookNotes,
            icon: const Icon(Icons.download_rounded, size: 18, color: Color(0xFFC89B58)),
            label: Text(
              'Download',
              style: GoogleFonts.outfit(
                color: const Color(0xFFC89B58),
                fontWeight: FontWeight.bold,
                fontSize: 13,
              ),
            ),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: Column(
        children: [
          // Search & Filter Header
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 4, 16, 12),
            child: TextField(
              onChanged: (val) => setState(() => _searchQuery = val),
              decoration: InputDecoration(
                hintText: 'Search Python questions, algorithms, concepts...',
                hintStyle: GoogleFonts.inter(color: textSecondary, fontSize: 13.5),
                prefixIcon: const Icon(Icons.search_rounded, color: Color(0xFFC89B58)),
                filled: true,
                fillColor: cardBg,
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide(color: borderColor),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide(color: borderColor),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: const BorderSide(color: Color(0xFFC89B58), width: 1.5),
                ),
              ),
            ),
          ),

          // Category Chips
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            physics: const BouncingScrollPhysics(),
            child: Row(
              children: PythonQAData.categories.map((cat) {
                final isSelected = _selectedCategory == cat;
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: FilterChip(
                    label: Text(cat),
                    selected: isSelected,
                    onSelected: (_) => setState(() => _selectedCategory = cat),
                    labelStyle: GoogleFonts.outfit(
                      fontSize: 12,
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                      color: isSelected
                          ? Colors.white
                          : (isDark ? Colors.white70 : const Color(0xFF334155)),
                    ),
                    backgroundColor: cardBg,
                    selectedColor: const Color(0xFFC89B58),
                    checkmarkColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                      side: BorderSide(
                        color: isSelected ? const Color(0xFFC89B58) : borderColor,
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
          const SizedBox(height: 12),

          // Questions List
          Expanded(
            child: filtered.isEmpty
                ? Center(
                    child: Text(
                      'No questions match your filter.',
                      style: GoogleFonts.inter(color: textSecondary),
                    ),
                  )
                : ListView.separated(
                    padding: const EdgeInsets.fromLTRB(16, 4, 16, 24),
                    physics: const BouncingScrollPhysics(),
                    itemCount: filtered.length,
                    separatorBuilder: (context, index) => const SizedBox(height: 12),
                    itemBuilder: (context, index) {
                      final item = filtered[index];
                      final isExpanded = _expandedIds.contains(item.id);

                      Color diffColor;
                      if (item.difficulty == 'Junior') {
                        diffColor = const Color(0xFF10B981);
                      } else if (item.difficulty == 'Mid-Level') {
                        diffColor = const Color(0xFF3B82F6);
                      } else {
                        diffColor = const Color(0xFF8B5CF6);
                      }

                      return AnimatedContainer(
                        duration: const Duration(milliseconds: 250),
                        decoration: BoxDecoration(
                          color: cardBg,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: isExpanded ? const Color(0xFFC89B58) : borderColor,
                            width: isExpanded ? 1.5 : 1.0,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.03),
                              blurRadius: 8,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: Column(
                          children: [
                            // Question Header
                            InkWell(
                              borderRadius: BorderRadius.circular(16),
                              onTap: () {
                                setState(() {
                                  if (isExpanded) {
                                    _expandedIds.remove(item.id);
                                  } else {
                                    _expandedIds.add(item.id);
                                  }
                                });
                              },
                              child: Padding(
                                padding: const EdgeInsets.all(16),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                      decoration: BoxDecoration(
                                        color: diffColor.withValues(alpha: 0.15),
                                        borderRadius: BorderRadius.circular(6),
                                      ),
                                      child: Text(
                                        item.difficulty.toUpperCase(),
                                        style: GoogleFonts.jetBrainsMono(
                                          fontSize: 10,
                                          fontWeight: FontWeight.bold,
                                          color: diffColor,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            item.question,
                                            style: GoogleFonts.outfit(
                                              fontSize: 15,
                                              fontWeight: FontWeight.bold,
                                              color: textPrimary,
                                              height: 1.3,
                                            ),
                                          ),
                                          const SizedBox(height: 4),
                                          Text(
                                            item.category,
                                            style: GoogleFonts.inter(
                                              fontSize: 12,
                                              color: const Color(0xFFC89B58),
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Icon(
                                      isExpanded
                                          ? Icons.keyboard_arrow_up_rounded
                                          : Icons.keyboard_arrow_down_rounded,
                                      color: textSecondary,
                                    ),
                                  ],
                                ),
                              ),
                            ),

                            // Expandable Content
                            if (isExpanded) ...[
                              const Divider(height: 1),
                              Padding(
                                padding: const EdgeInsets.all(16),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // Detailed Answer
                                    Text(
                                      'Technical Explanation:',
                                      style: GoogleFonts.outfit(
                                        fontSize: 13,
                                        fontWeight: FontWeight.bold,
                                        color: const Color(0xFFC89B58),
                                      ),
                                    ),
                                    const SizedBox(height: 6),
                                    Text(
                                      item.answer,
                                      style: GoogleFonts.inter(
                                        fontSize: 13.5,
                                        color: isDark ? const Color(0xFFCBD5E1) : const Color(0xFF334155),
                                        height: 1.5,
                                      ),
                                    ),
                                    const SizedBox(height: 14),

                                    // Key Insight
                                    Container(
                                      padding: const EdgeInsets.all(12),
                                      decoration: BoxDecoration(
                                        color: const Color(0xFFC89B58).withValues(alpha: 0.1),
                                        borderRadius: BorderRadius.circular(10),
                                        border: Border.all(
                                          color: const Color(0xFFC89B58).withValues(alpha: 0.3),
                                        ),
                                      ),
                                      child: Row(
                                        children: [
                                          const Icon(Icons.lightbulb_outline_rounded,
                                              color: Color(0xFFC89B58), size: 18),
                                          const SizedBox(width: 8),
                                          Expanded(
                                            child: Text(
                                              item.keyInsight,
                                              style: GoogleFonts.outfit(
                                                fontSize: 12.5,
                                                fontWeight: FontWeight.w600,
                                                color: const Color(0xFFC89B58),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(height: 14),

                                    // Code Box
                                    Container(
                                      width: double.infinity,
                                      padding: const EdgeInsets.all(12),
                                      decoration: BoxDecoration(
                                        color: isDark ? const Color(0xFF090C12) : const Color(0xFF0F172A),
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                'CODE DEMONSTRATION',
                                                style: GoogleFonts.jetBrainsMono(
                                                  fontSize: 10,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.white54,
                                                ),
                                              ),
                                              IconButton(
                                                icon: const Icon(Icons.copy_rounded, size: 16, color: Colors.white70),
                                                padding: EdgeInsets.zero,
                                                constraints: const BoxConstraints(),
                                                onPressed: () {
                                                  Clipboard.setData(ClipboardData(text: item.codeExample));
                                                  ScaffoldMessenger.of(context).showSnackBar(
                                                    const SnackBar(content: Text('Code copied to clipboard!')),
                                                  );
                                                },
                                              ),
                                            ],
                                          ),
                                          const SizedBox(height: 8),
                                          Text(
                                            item.codeExample,
                                            style: GoogleFonts.jetBrainsMono(
                                              fontSize: 12,
                                              color: const Color(0xFF38BDF8),
                                              height: 1.4,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(height: 14),

                                    // Action buttons
                                    Row(
                                      children: [
                                        Expanded(
                                          child: OutlinedButton.icon(
                                            onPressed: () => _runInPlayground(item.codeExample),
                                            icon: const Icon(Icons.terminal_rounded, size: 16),
                                            label: const Text('Test in Sandbox'),
                                            style: OutlinedButton.styleFrom(
                                              foregroundColor: const Color(0xFFC89B58),
                                              side: const BorderSide(color: Color(0xFFC89B58)),
                                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                            ),
                                          ),
                                        ),
                                        const SizedBox(width: 10),
                                        Expanded(
                                          child: ElevatedButton.icon(
                                            onPressed: () {
                                              Clipboard.setData(ClipboardData(text: "${item.question}\n\n${item.answer}\n\n${item.codeExample}"));
                                              ScaffoldMessenger.of(context).showSnackBar(
                                                const SnackBar(content: Text('Full Q&A copied to clipboard!')),
                                              );
                                            },
                                            icon: const Icon(Icons.copy_rounded, size: 16),
                                            label: const Text('Copy Solution'),
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor: isDark ? const Color(0xFF23304B) : const Color(0xFF17191C),
                                              foregroundColor: Colors.white,
                                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ],
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
