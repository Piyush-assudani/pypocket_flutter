import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import '../data/python_cheatsheet_data.dart';
import '../theme/app_theme.dart';
import '../widgets/three_d_tilt_card.dart';
import 'playground_screen.dart';

class CheatSheetScreen extends StatefulWidget {
  const CheatSheetScreen({super.key});

  @override
  State<CheatSheetScreen> createState() => _CheatSheetScreenState();
}

class _CheatSheetScreenState extends State<CheatSheetScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _selectedCategory = 'All';
  String _searchQuery = '';

  final List<String> _categories = [
    'All',
    'Strings',
    'Lists',
    'Dictionaries',
    'Built-ins',
    'OOP',
    'Async',
    'Big-O',
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardColor = AppTheme.cardOf(context);
    final borderColor = AppTheme.borderOf(context);

    final filteredItems = PythonCheatSheetData.items.where((item) {
      final matchesCategory = _selectedCategory == 'All' || item.category == _selectedCategory;
      final q = _searchQuery.toLowerCase();
      final matchesQuery = q.isEmpty ||
          item.title.toLowerCase().contains(q) ||
          item.syntax.toLowerCase().contains(q) ||
          item.explanation.toLowerCase().contains(q) ||
          item.category.toLowerCase().contains(q);
      return matchesCategory && matchesQuery;
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: const Color(0xFF06B6D4).withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(Icons.bookmark_outline_rounded, color: Color(0xFF06B6D4), size: 20),
            ),
            const SizedBox(width: 10),
            Text(
              'Python Syntax Hub',
              style: GoogleFonts.outfit(fontWeight: FontWeight.bold, fontSize: 19),
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          // Search & Filter Header
          Container(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
            color: Theme.of(context).scaffoldBackgroundColor,
            child: Column(
              children: [
                // Search Input
                TextField(
                  controller: _searchController,
                  onChanged: (val) => setState(() => _searchQuery = val),
                  style: GoogleFonts.inter(fontSize: 14),
                  decoration: InputDecoration(
                    hintText: 'Search syntax, dunder methods, slicing, big-O...',
                    hintStyle: GoogleFonts.inter(color: AppTheme.textMutedOf(context), fontSize: 13.5),
                    prefixIcon: const Icon(Icons.search_rounded, size: 20),
                    suffixIcon: _searchQuery.isNotEmpty
                        ? IconButton(
                            icon: const Icon(Icons.clear_rounded, size: 18),
                            onPressed: () {
                              _searchController.clear();
                              setState(() => _searchQuery = '');
                            },
                          )
                        : null,
                    filled: true,
                    fillColor: isDark ? const Color(0xFF131B2A) : const Color(0xFFF1F5F9),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: BorderSide(color: borderColor),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: BorderSide(color: borderColor),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: const BorderSide(color: Color(0xFF06B6D4), width: 1.5),
                    ),
                  ),
                ),
                const SizedBox(height: 12),

                // Category Chips
                SizedBox(
                  height: 36,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: _categories.length,
                    separatorBuilder: (_, _) => const SizedBox(width: 8),
                    itemBuilder: (context, idx) {
                      final cat = _categories[idx];
                      final isSelected = cat == _selectedCategory;
                      return InkWell(
                        onTap: () => setState(() => _selectedCategory = cat),
                        borderRadius: BorderRadius.circular(18),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 180),
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? const Color(0xFF06B6D4)
                                : (isDark ? const Color(0xFF131B2A) : Colors.white),
                            borderRadius: BorderRadius.circular(18),
                            border: Border.all(
                              color: isSelected ? const Color(0xFF06B6D4) : borderColor,
                            ),
                          ),
                          child: Center(
                            child: Text(
                              cat,
                              style: GoogleFonts.outfit(
                                fontSize: 12.5,
                                fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                                color: isSelected ? Colors.black : AppTheme.textSecondaryOf(context),
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

          // Cards List
          Expanded(
            child: filteredItems.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.search_off_rounded, size: 48, color: AppTheme.textMutedOf(context)),
                        const SizedBox(height: 12),
                        Text(
                          'No matching syntax patterns found',
                          style: GoogleFonts.outfit(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: AppTheme.textPrimaryOf(context),
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          'Try searching for another keyword like "slicing", "zip", or "OOP".',
                          style: GoogleFonts.inter(fontSize: 13, color: AppTheme.textMutedOf(context)),
                        ),
                      ],
                    ),
                  )
                : ListView.separated(
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
                    itemCount: filteredItems.length,
                    separatorBuilder: (_, _) => const SizedBox(height: 16),
                    itemBuilder: (context, index) {
                      final item = filteredItems[index];

                      return ThreeDTiltCard(
                        borderRadius: BorderRadius.circular(18),
                        elevation: 6,
                        child: Container(
                          padding: const EdgeInsets.all(18),
                          decoration: BoxDecoration(
                            color: cardColor,
                            borderRadius: BorderRadius.circular(18),
                            border: Border.all(color: borderColor),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Top Badges & Title
                              Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFF06B6D4).withValues(alpha: 0.15),
                                      borderRadius: BorderRadius.circular(6),
                                      border: Border.all(
                                        color: const Color(0xFF06B6D4).withValues(alpha: 0.3),
                                        width: 0.8,
                                      ),
                                    ),
                                    child: Text(
                                      item.category.toUpperCase(),
                                      style: GoogleFonts.jetBrainsMono(
                                        color: const Color(0xFF06B6D4),
                                        fontSize: 10,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  Expanded(
                                    child: Text(
                                      item.title,
                                      style: GoogleFonts.outfit(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                        color: AppTheme.textPrimaryOf(context),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 10),

                              // Syntax Formula Pill
                              Container(
                                width: double.infinity,
                                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                decoration: BoxDecoration(
                                  color: isDark ? const Color(0xFF070B12) : const Color(0xFFF8FAFC),
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(
                                    color: isDark ? const Color(0xFF1E293B) : const Color(0xFFE2E8F0),
                                  ),
                                ),
                                child: Text(
                                  item.syntax,
                                  style: GoogleFonts.jetBrainsMono(
                                    fontSize: 12.5,
                                    fontWeight: FontWeight.bold,
                                    color: AppTheme.pythonYellow,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 10),

                              // Explanation
                              Text(
                                item.explanation,
                                style: GoogleFonts.inter(
                                  fontSize: 13,
                                  color: AppTheme.textSecondaryOf(context),
                                  height: 1.45,
                                ),
                              ),
                              const SizedBox(height: 14),

                              // Code Preview Snippet
                              Container(
                                width: double.infinity,
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: const Color(0xFF090E1A),
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(color: const Color(0xFF1E293B)),
                                ),
                                child: SelectableText(
                                  item.executableExample.trim(),
                                  style: GoogleFonts.jetBrainsMono(
                                    fontSize: 12,
                                    height: 1.4,
                                    color: const Color(0xFFE2E8F0),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 14),

                              // Actions Row
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  // Copy Snippet Button
                                  OutlinedButton.icon(
                                    onPressed: () {
                                      Clipboard.setData(ClipboardData(text: item.executableExample));
                                      HapticFeedback.lightImpact();
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(
                                          content: Text('Copied "${item.title}" to clipboard!'),
                                          duration: const Duration(seconds: 1),
                                          behavior: SnackBarBehavior.floating,
                                        ),
                                      );
                                    },
                                    icon: const Icon(Icons.copy_rounded, size: 14),
                                    label: const Text('Copy'),
                                    style: OutlinedButton.styleFrom(
                                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                      textStyle: GoogleFonts.outfit(fontSize: 12, fontWeight: FontWeight.w600),
                                    ),
                                  ),
                                  const SizedBox(width: 8),

                                  // Run in Playground Button
                                  ElevatedButton.icon(
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (_) => PlaygroundScreen(initialCode: item.executableExample),
                                        ),
                                      );
                                    },
                                    icon: const Icon(Icons.play_arrow_rounded, size: 16),
                                    label: const Text('Run in Playground'),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: const Color(0xFF2563EB),
                                      foregroundColor: Colors.white,
                                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                      textStyle: GoogleFonts.outfit(fontSize: 12.5, fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ],
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
    );
  }
}
