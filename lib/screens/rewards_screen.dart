import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';
import '../data/reward_tasks_data.dart';
import '../services/storage_service.dart';
import '../theme/app_theme.dart';
import '../widgets/xp_badge.dart';
import 'playground_screen.dart';
import 'daily_challenge_screen.dart';
import 'flashcards_screen.dart';

class RewardsScreen extends StatefulWidget {
  const RewardsScreen({super.key});

  @override
  State<RewardsScreen> createState() => _RewardsScreenState();
}

class _RewardsScreenState extends State<RewardsScreen> {
  Future<void> _handleTaskAction(RewardTask task) async {
    final isClaimed = StorageService.isTaskClaimed(task.id);
    if (isClaimed) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('You have already claimed this reward!')),
      );
      return;
    }

    // In-app tasks check
    if (task.type == TaskType.inAppAction) {
      _handleInAppTask(task);
      return;
    }

    // Social share task
    if (task.type == TaskType.socialShare) {
      Clipboard.setData(const ClipboardData(
        text: 'Master Python from your phone with PyPocket! Download now: https://play.google.com/store/apps/details?id=com.piyush.pypocket1',
      ));
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('PyPocket invite link copied to clipboard! Share it with a friend.'),
          backgroundColor: Color(0xFF2563EB),
        ),
      );
      _showVerificationModal(task);
      return;
    }

    // External link or Play Store review
    if (task.actionUrl.isNotEmpty) {
      final uri = Uri.parse(task.actionUrl);
      try {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      } catch (_) {
        // Fallback: Copy URL
        Clipboard.setData(ClipboardData(text: task.actionUrl));
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Link copied to clipboard: ${task.actionUrl}')),
          );
        }
      }
      if (mounted) {
        _showVerificationModal(task);
      }
    }
  }

  void _handleInAppTask(RewardTask task) {
    if (task.id == 'task_first_code_run') {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const PlaygroundScreen()),
      ).then((_) => _checkInAppTaskEligibility(task));
    } else if (task.id == 'task_daily_quest_solve') {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const DailyChallengeScreen()),
      ).then((_) => _checkInAppTaskEligibility(task));
    } else if (task.id == 'task_master_flashcards') {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const FlashcardsScreen()),
      ).then((_) => _checkInAppTaskEligibility(task));
    }
  }

  Future<void> _checkInAppTaskEligibility(RewardTask task) async {
    bool eligible = false;
    String feedback = '';

    if (task.id == 'task_first_code_run') {
      eligible = true; // Visiting & running IDE
    } else if (task.id == 'task_daily_quest_solve') {
      final solved = StorageService.getSolvedChallenges();
      eligible = solved.isNotEmpty;
      feedback = 'Solve at least 1 coding quest to claim points.';
    } else if (task.id == 'task_master_flashcards') {
      final mastered = StorageService.getMasteredFlashcardIds();
      eligible = mastered.length >= 5;
      feedback = 'Master at least 5 flashcards (${mastered.length}/5 currently).';
    }

    if (eligible) {
      await _confirmClaim(task);
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(feedback),
            backgroundColor: const Color(0xFFEF4444),
          ),
        );
      }
    }
  }

  void _showVerificationModal(RewardTask task) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppTheme.cardOf(context),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(22)),
      ),
      builder: (ctx) {
        return Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: const Color(0xFF2563EB).withValues(alpha: 0.15),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.verified_user_rounded, color: Color(0xFF2563EB), size: 22),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    'Task Verification',
                    style: GoogleFonts.outfit(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      color: AppTheme.textPrimaryOf(context),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),
              Text(
                task.verificationPrompt,
                style: GoogleFonts.inter(
                  fontSize: 14,
                  color: AppTheme.textSecondaryOf(context),
                  height: 1.45,
                ),
              ),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: const Color(0xFFF59E0B).withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.shield_outlined, size: 14, color: Color(0xFFF59E0B)),
                    const SizedBox(width: 6),
                    Text(
                      'Anti-Cheat Protection: Single Claim Allowed',
                      style: GoogleFonts.jetBrainsMono(
                        fontSize: 11,
                        color: const Color(0xFFF59E0B),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(ctx),
                      style: OutlinedButton.styleFrom(
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                      child: const Text('Not Yet'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    flex: 2,
                    child: ElevatedButton(
                      onPressed: () async {
                        Navigator.pop(ctx);
                        await _confirmClaim(task);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF10B981),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                      child: Text(
                        'Confirm & Claim +${task.xpReward} XP',
                        style: GoogleFonts.outfit(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _confirmClaim(RewardTask task) async {
    final success = await StorageService.claimRewardTask(task.id, task.xpReward);
    if (!mounted) return;

    if (success) {
      HapticFeedback.heavyImpact();
      setState(() {});
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Verified! +${task.xpReward} XP credited to your profile!'),
          backgroundColor: const Color(0xFF10B981),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Task was already claimed.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final profile = StorageService.getUserProfile();
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final allTasks = RewardTasksData.tasks;
    final claimedIds = StorageService.getClaimedTaskIds();

    final claimedCount = allTasks.where((t) => claimedIds.contains(t.id)).length;
    final totalRewardPoints = allTasks.fold<int>(0, (sum, t) => sum + t.xpReward);
    final claimedRewardPoints = allTasks
        .where((t) => claimedIds.contains(t.id))
        .fold<int>(0, (sum, t) => sum + t.xpReward);

    final progress = totalRewardPoints > 0 ? claimedRewardPoints / totalRewardPoints : 0.0;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Bonus Reward Quests',
          style: GoogleFonts.outfit(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        actions: [
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
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: isDark
                      ? [const Color(0xFF1E1B4B), const Color(0xFF0F172A)]
                      : [const Color(0xFFEEF2FF), Colors.white],
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
                        'Developer Rewards Center',
                        style: GoogleFonts.outfit(
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.textPrimaryOf(context),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: const Color(0xFF2563EB).withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          '$claimedRewardPoints / $totalRewardPoints XP',
                          style: GoogleFonts.jetBrainsMono(
                            color: const Color(0xFF2563EB),
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(
                    '$claimedCount of ${allTasks.length} community & engagement quests verified.',
                    style: GoogleFonts.inter(color: AppTheme.textSecondaryOf(context), fontSize: 12.5),
                  ),
                  const SizedBox(height: 14),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(6),
                    child: LinearProgressIndicator(
                      value: progress,
                      minHeight: 7,
                      backgroundColor: isDark ? const Color(0xFF1E293B) : const Color(0xFFE2E8F0),
                      valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF2563EB)),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            Text(
              'ACTIVE COMMUNITY TASKS',
              style: GoogleFonts.jetBrainsMono(
                color: AppTheme.textMutedOf(context),
                fontSize: 11,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.1,
              ),
            ),
            const SizedBox(height: 12),

            // Tasks List
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: allTasks.length,
              separatorBuilder: (context, index) => const SizedBox(height: 10),
              itemBuilder: (context, index) {
                final task = allTasks[index];
                final isClaimed = claimedIds.contains(task.id);

                return Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppTheme.cardOf(context),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: isClaimed
                          ? const Color(0xFF10B981).withValues(alpha: 0.4)
                          : AppTheme.borderOf(context),
                    ),
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: (isClaimed ? const Color(0xFF10B981) : const Color(0xFF2563EB)).withValues(alpha: 0.12),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          isClaimed ? Icons.check_circle_rounded : _getTaskIcon(task.type),
                          color: isClaimed ? const Color(0xFF10B981) : const Color(0xFF2563EB),
                          size: 22,
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              task.title,
                              style: GoogleFonts.outfit(
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                                color: AppTheme.textPrimaryOf(context),
                              ),
                            ),
                            const SizedBox(height: 3),
                            Text(
                              task.description,
                              style: GoogleFonts.inter(
                                fontSize: 11.5,
                                color: AppTheme.textSecondaryOf(context),
                                height: 1.35,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 10),
                      if (isClaimed)
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                          decoration: BoxDecoration(
                            color: const Color(0xFF10B981).withValues(alpha: 0.12),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            'Claimed',
                            style: GoogleFonts.outfit(
                              color: const Color(0xFF10B981),
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        )
                      else
                        ElevatedButton(
                          onPressed: () => _handleTaskAction(task),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF2563EB),
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                          ),
                          child: Text(
                            '+${task.xpReward} XP',
                            style: GoogleFonts.jetBrainsMono(
                              fontWeight: FontWeight.bold,
                              fontSize: 11.5,
                            ),
                          ),
                        ),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  IconData _getTaskIcon(TaskType type) {
    switch (type) {
      case TaskType.playStoreReview:
        return Icons.star_rate_rounded;
      case TaskType.externalLink:
        return Icons.open_in_new_rounded;
      case TaskType.socialShare:
        return Icons.share_rounded;
      case TaskType.inAppAction:
        return Icons.code_rounded;
    }
  }
}
