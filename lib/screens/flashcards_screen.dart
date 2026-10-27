import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import '../data/python_flashcards_data.dart';
import '../services/storage_service.dart';
import '../theme/app_theme.dart';
import '../widgets/xp_badge.dart';
import '../widgets/three_d_tilt_card.dart';
import 'playground_screen.dart';

class FlashcardsScreen extends StatefulWidget {
  const FlashcardsScreen({super.key});

  @override
  State<FlashcardsScreen> createState() => _FlashcardsScreenState();
}

class _FlashcardsScreenState extends State<FlashcardsScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _flipController;
  late Animation<double> _flipAnimation;

  String _selectedCategory = 'All';
  int _currentIndex = 0;
  bool _isFlipped = false;

  final List<String> _categories = [
    'All',
    'Foundations',
    'OOP & Dunders',
    'Memory & Internals',
    'Big-O Complexities',
    'Concurrency',
    'Mastered',
  ];

  @override
  void initState() {
    super.initState();
    _flipController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    _flipAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _flipController, curve: Curves.easeInOutCubic),
    );
  }

  @override
  void dispose() {
    _flipController.dispose();
    super.dispose();
  }

  void _flipCard() {
    if (_isFlipped) {
      _flipController.reverse();
    } else {
      _flipController.forward();
    }
    setState(() {
      _isFlipped = !_isFlipped;
    });
  }

  List<PythonFlashcard> _getFilteredCards() {
    final masteredIds = StorageService.getMasteredFlashcardIds();
    final allCards = PythonFlashcardsData.cards;

    if (_selectedCategory == 'All') {
      return allCards;
    } else if (_selectedCategory == 'Mastered') {
      return allCards.where((c) => masteredIds.contains(c.id)).toList();
    } else {
      return allCards.where((c) => c.category == _selectedCategory).toList();
    }
  }

  void _nextCard(int total) {
    if (total == 0) return;
    if (_isFlipped) {
      _flipController.reverse();
      _isFlipped = false;
    }
    setState(() {
      _currentIndex = (_currentIndex + 1) % total;
    });
  }

  void _prevCard(int total) {
    if (total == 0) return;
    if (_isFlipped) {
      _flipController.reverse();
      _isFlipped = false;
    }
    setState(() {
      _currentIndex = (_currentIndex - 1 + total) % total;
    });
  }

  @override
  Widget build(BuildContext context) {
    final profile = StorageService.getUserProfile();
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final masteredIds = StorageService.getMasteredFlashcardIds();
    final allCardsCount = PythonFlashcardsData.cards.length;
    final filteredCards = _getFilteredCards();

    // Guard index out of range
    if (_currentIndex >= filteredCards.length && filteredCards.isNotEmpty) {
      _currentIndex = 0;
    }

    final masteryProgress = allCardsCount > 0
        ? masteredIds.length / allCardsCount
        : 0.0;

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: const Color(0xFFF59E0B).withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(Icons.flash_on_rounded, color: Color(0xFFF59E0B), size: 20),
            ),
            const SizedBox(width: 10),
            Text(
              'Python Flashcards',
              style: GoogleFonts.outfit(fontWeight: FontWeight.bold, fontSize: 18),
            ),
          ],
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: XpBadge(xp: profile.xp, streakDays: profile.streakDays),
          ),
        ],
      ),
      body: Column(
        children: [
          // Mastery Metric Card
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            color: isDark ? const Color(0xFF0F172A) : const Color(0xFFF1F5F9),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Spaced Repetition Mastery',
                      style: GoogleFonts.outfit(
                        fontWeight: FontWeight.w600,
                        fontSize: 13,
                        color: AppTheme.textPrimaryOf(context),
                      ),
                    ),
                    Text(
                      '${masteredIds.length} / $allCardsCount (${(masteryProgress * 100).toInt()}%)',
                      style: GoogleFonts.jetBrainsMono(
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                        color: const Color(0xFFF59E0B),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                ClipRRect(
                  borderRadius: BorderRadius.circular(6),
                  child: LinearProgressIndicator(
                    value: masteryProgress,
                    minHeight: 6,
                    backgroundColor: isDark ? const Color(0xFF1E293B) : const Color(0xFFE2E8F0),
                    valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFFF59E0B)),
                  ),
                ),
              ],
            ),
          ),

          // Categories Filter Row
          Container(
            height: 48,
            padding: const EdgeInsets.symmetric(vertical: 6),
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: _categories.length,
              separatorBuilder: (context, index) => const SizedBox(width: 8),
              itemBuilder: (context, index) {
                final category = _categories[index];
                final isSelected = _selectedCategory == category;
                return ChoiceChip(
                  label: Text(category),
                  selected: isSelected,
                  labelStyle: GoogleFonts.inter(
                    fontSize: 12,
                    fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                    color: isSelected
                        ? Colors.white
                        : AppTheme.textSecondaryOf(context),
                  ),
                  selectedColor: AppTheme.pythonBlue,
                  backgroundColor: isDark ? const Color(0xFF1E293B) : const Color(0xFFE2E8F0),
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                    side: BorderSide(
                      color: isSelected
                          ? AppTheme.pythonBlue
                          : Colors.transparent,
                    ),
                  ),
                  onSelected: (val) {
                    if (val) {
                      setState(() {
                        _selectedCategory = category;
                        _currentIndex = 0;
                        if (_isFlipped) {
                          _flipController.reverse();
                          _isFlipped = false;
                        }
                      });
                    }
                  },
                );
              },
            ),
          ),

          // Main Card Area
          Expanded(
            child: filteredCards.isEmpty
                ? Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.style_outlined, size: 54, color: Color(0xFF64748B)),
                        const SizedBox(height: 12),
                        Text(
                          'No flashcards in "$_selectedCategory"',
                          style: GoogleFonts.outfit(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: AppTheme.textSecondaryOf(context),
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          'Select "All" or master cards to see them here.',
                          style: GoogleFonts.inter(color: AppTheme.textMutedOf(context), fontSize: 13),
                        ),
                      ],
                    ),
                  )
                : SingleChildScrollView(
                    padding: const EdgeInsets.all(16),
                    physics: const BouncingScrollPhysics(),
                    child: Column(
                      children: [
                        // Card Header Counter & Status
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(
                                color: AppTheme.pythonBlue.withValues(alpha: 0.15),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                'Card ${_currentIndex + 1} of ${filteredCards.length}',
                                style: GoogleFonts.jetBrainsMono(
                                  color: AppTheme.pythonBlue,
                                  fontSize: 11.5,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            if (masteredIds.contains(filteredCards[_currentIndex].id))
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                decoration: BoxDecoration(
                                  color: const Color(0xFF10B981).withValues(alpha: 0.15),
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(color: const Color(0xFF10B981).withValues(alpha: 0.3)),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const Icon(Icons.check_circle_rounded, size: 14, color: Color(0xFF10B981)),
                                    const SizedBox(width: 4),
                                    Text(
                                      'Mastered',
                                      style: GoogleFonts.outfit(
                                        color: const Color(0xFF10B981),
                                        fontSize: 11,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                          ],
                        ),
                        const SizedBox(height: 12),

                        // Interactive Flippable 3D Card
                        GestureDetector(
                          onTap: _flipCard,
                          child: AnimatedBuilder(
                            animation: _flipAnimation,
                            builder: (context, child) {
                              final angle = _flipAnimation.value * math.pi;
                              final isUnder = _flipAnimation.value > 0.5;

                              return Transform(
                                transform: Matrix4.identity()
                                  ..setEntry(3, 2, 0.001) // perspective
                                  ..rotateY(angle),
                                alignment: Alignment.center,
                                child: isUnder
                                    ? Transform(
                                        transform: Matrix4.identity()..rotateY(math.pi),
                                        alignment: Alignment.center,
                                        child: _buildBackCard(
                                          context,
                                          filteredCards[_currentIndex],
                                          isDark,
                                        ),
                                      )
                                    : _buildFrontCard(
                                        context,
                                        filteredCards[_currentIndex],
                                        isDark,
                                      ),
                              );
                            },
                          ),
                        ),
                        const SizedBox(height: 16),

                        // Card Actions Row
                        _buildBottomControls(
                          context,
                          filteredCards[_currentIndex],
                          filteredCards.length,
                          masteredIds.contains(filteredCards[_currentIndex].id),
                          isDark,
                        ),
                      ],
                    ),
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildFrontCard(BuildContext context, PythonFlashcard card, bool isDark) {
    return ThreeDTiltCard(
      borderRadius: BorderRadius.circular(22),
      elevation: 6,
      child: Container(
        constraints: const BoxConstraints(minHeight: 330),
        padding: const EdgeInsets.all(22),
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF111827) : Colors.white,
          borderRadius: BorderRadius.circular(22),
          border: Border.all(
            color: isDark ? const Color(0xFF1F2937) : const Color(0xFFE2E8F0),
            width: 1.2,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: isDark ? 0.4 : 0.06),
              blurRadius: 18,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: const Color(0xFF8B5CF6).withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        card.category.toUpperCase(),
                        style: GoogleFonts.jetBrainsMono(
                          color: const Color(0xFF8B5CF6),
                          fontSize: 10.5,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 1.0,
                        ),
                      ),
                    ),
                    const Icon(Icons.touch_app_rounded, size: 18, color: Color(0xFF64748B)),
                  ],
                ),
                const SizedBox(height: 24),
                Text(
                  card.question,
                  style: GoogleFonts.outfit(
                    color: AppTheme.textPrimaryOf(context),
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    height: 1.35,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 40),
            Center(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: AppTheme.pythonBlue.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: AppTheme.pythonBlue.withValues(alpha: 0.25)),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.flip_to_back_rounded, size: 15, color: AppTheme.pythonBlue),
                    const SizedBox(width: 8),
                    Text(
                      'Tap card to reveal answer',
                      style: GoogleFonts.inter(
                        color: AppTheme.pythonBlue,
                        fontWeight: FontWeight.w600,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBackCard(BuildContext context, PythonFlashcard card, bool isDark) {
    return Container(
      constraints: const BoxConstraints(minHeight: 330),
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF0D1525) : const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(
          color: isDark ? const Color(0xFF2563EB).withValues(alpha: 0.4) : const Color(0xFF93C5FD),
          width: 1.2,
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF2563EB).withValues(alpha: isDark ? 0.2 : 0.08),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFF10B981).withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  'EXPLANATION',
                  style: GoogleFonts.jetBrainsMono(
                    color: const Color(0xFF10B981),
                    fontSize: 10.5,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 1.0,
                  ),
                ),
              ),
              const Icon(Icons.check_circle_outline_rounded, size: 18, color: Color(0xFF10B981)),
            ],
          ),
          const SizedBox(height: 14),
          Text(
            card.answer,
            style: GoogleFonts.inter(
              color: AppTheme.textPrimaryOf(context),
              fontSize: 13.5,
              height: 1.5,
            ),
          ),
          if (card.codeExample != null) ...[
            const SizedBox(height: 14),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'PYTHON CODE EXAMPLE',
                  style: GoogleFonts.outfit(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.0,
                    color: const Color(0xFF64748B),
                  ),
                ),
                Row(
                  children: [
                    InkWell(
                      onTap: () {
                        Clipboard.setData(ClipboardData(text: card.codeExample!));
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Code copied to clipboard!'), duration: Duration(seconds: 1)),
                        );
                      },
                      child: const Padding(
                        padding: EdgeInsets.all(4),
                        child: Icon(Icons.copy_rounded, size: 14, color: Color(0xFF2563EB)),
                      ),
                    ),
                    const SizedBox(width: 8),
                    InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => PlaygroundScreen(initialCode: card.codeExample!),
                          ),
                        );
                      },
                      child: const Padding(
                        padding: EdgeInsets.all(4),
                        child: Icon(Icons.play_arrow_rounded, size: 18, color: Color(0xFF10B981)),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 6),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFF090D16),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: const Color(0xFF1E293B)),
              ),
              child: SelectableText(
                card.codeExample!,
                style: GoogleFonts.jetBrainsMono(
                  color: const Color(0xFF38BDF8),
                  fontSize: 11.5,
                  height: 1.35,
                ),
              ),
            ),
          ],
          const SizedBox(height: 14),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: const Color(0xFFF59E0B).withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: const Color(0xFFF59E0B).withValues(alpha: 0.25)),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(Icons.tips_and_updates_rounded, color: Color(0xFFF59E0B), size: 15),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    card.keyInsight,
                    style: GoogleFonts.inter(
                      color: isDark ? const Color(0xFFFCD34D) : const Color(0xFFB45309),
                      fontSize: 11.5,
                      fontWeight: FontWeight.w600,
                      height: 1.35,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomControls(
    BuildContext context,
    PythonFlashcard card,
    int total,
    bool isMastered,
    bool isDark,
  ) {
    return Column(
      children: [
        // Mastery toggle button
        SizedBox(
          width: double.infinity,
          height: 48,
          child: ElevatedButton.icon(
            icon: Icon(
              isMastered ? Icons.check_circle_rounded : Icons.star_border_rounded,
              size: 20,
            ),
            label: Text(
              isMastered ? 'Mastered (Tap to Unmark)' : 'I Know This Concept (+5 XP)',
              style: GoogleFonts.outfit(fontWeight: FontWeight.bold, fontSize: 14),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: isMastered ? const Color(0xFF10B981) : const Color(0xFF2563EB),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
            ),
            onPressed: () async {
              final scaffoldMessenger = ScaffoldMessenger.of(context);
              final nowMastered = await StorageService.toggleFlashcardMastered(card.id);
              if (!mounted) return;
              setState(() {});
              scaffoldMessenger.showSnackBar(
                SnackBar(
                  content: Text(
                    nowMastered
                        ? 'Concept Mastered (+5 XP awarded)'
                        : 'Removed from Mastered list',
                  ),
                  backgroundColor: nowMastered ? const Color(0xFF10B981) : const Color(0xFF64748B),
                  duration: const Duration(seconds: 1),
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 12),

        // Navigation row
        Row(
          children: [
            Expanded(
              child: OutlinedButton.icon(
                icon: const Icon(Icons.arrow_back_rounded, size: 18),
                label: const Text('Previous'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppTheme.textPrimaryOf(context),
                  side: BorderSide(color: AppTheme.borderOf(context)),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
                onPressed: () => _prevCard(total),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: ElevatedButton.icon(
                icon: const Text('Next'),
                label: const Icon(Icons.arrow_forward_rounded, size: 18),
                style: ElevatedButton.styleFrom(
                  backgroundColor: isDark ? const Color(0xFF1E293B) : const Color(0xFFE2E8F0),
                  foregroundColor: AppTheme.textPrimaryOf(context),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
                onPressed: () => _nextCard(total),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
