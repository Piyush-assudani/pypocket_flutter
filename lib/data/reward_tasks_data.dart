enum TaskType { externalLink, playStoreReview, inAppAction, socialShare }

class RewardTask {
  final String id;
  final String title;
  final String description;
  final int xpReward;
  final TaskType type;
  final String actionUrl;
  final String actionLabel;
  final String verificationPrompt;

  const RewardTask({
    required this.id,
    required this.title,
    required this.description,
    required this.xpReward,
    required this.type,
    this.actionUrl = '',
    required this.actionLabel,
    required this.verificationPrompt,
  });
}

class RewardTasksData {
  static const List<RewardTask> tasks = [
    RewardTask(
      id: 'task_insta_follow',
      title: 'Follow @assudanigroup on Instagram',
      description: 'Follow the official Assudani Group handle for daily engineering tips and updates.',
      xpReward: 100,
      type: TaskType.externalLink,
      actionUrl: 'https://instagram.com/assudanigroup',
      actionLabel: 'Open Instagram',
      verificationPrompt: 'Did you follow @assudanigroup on Instagram?',
    ),
    RewardTask(
      id: 'task_playstore_review',
      title: 'Rate 5 Stars on Google Play Store',
      description: 'Help other Python developers discover PyPocket by leaving a 5-star review.',
      xpReward: 150,
      type: TaskType.playStoreReview,
      actionUrl: 'https://play.google.com/store/apps/details?id=com.piyush.pypocket1',
      actionLabel: 'Write Play Store Review',
      verificationPrompt: 'Have you submitted your review on the Google Play Store?',
    ),
    RewardTask(
      id: 'task_twitter_follow',
      title: 'Follow PyPocket on X (Twitter)',
      description: 'Get real-time Python release updates, syntax tips, and library spotlights.',
      xpReward: 75,
      type: TaskType.externalLink,
      actionUrl: 'https://x.com/assudanigroup',
      actionLabel: 'Open X',
      verificationPrompt: 'Did you follow @assudanigroup on X?',
    ),
    RewardTask(
      id: 'task_telegram_join',
      title: 'Join Telegram Python Developers Network',
      description: 'Connect with active Pythonistas, discuss algorithms, and ask syntax questions.',
      xpReward: 75,
      type: TaskType.externalLink,
      actionUrl: 'https://t.me/assudanigroup',
      actionLabel: 'Join Telegram',
      verificationPrompt: 'Have you joined the Telegram developer channel?',
    ),
    RewardTask(
      id: 'task_youtube_sub',
      title: 'Subscribe to YouTube Python Masterclasses',
      description: 'Watch video walkthroughs, system design, and competitive coding tutorials.',
      xpReward: 100,
      type: TaskType.externalLink,
      actionUrl: 'https://youtube.com/@assudanigroup',
      actionLabel: 'Open YouTube',
      verificationPrompt: 'Did you subscribe to the YouTube masterclass channel?',
    ),
    RewardTask(
      id: 'task_github_star',
      title: 'Star PyPocket on GitHub',
      description: 'Support open Python education by starring the official PyPocket repository.',
      xpReward: 100,
      type: TaskType.externalLink,
      actionUrl: 'https://github.com/assudani/pypocket',
      actionLabel: 'Star on GitHub',
      verificationPrompt: 'Did you star the GitHub repository?',
    ),
    RewardTask(
      id: 'task_share_colleague',
      title: 'Share PyPocket with a Developer Colleague',
      description: 'Invite a friend or classmate to practice Python coding streaks together.',
      xpReward: 50,
      type: TaskType.socialShare,
      actionLabel: 'Share Link',
      verificationPrompt: 'Did you share the PyPocket download link with a developer?',
    ),
    RewardTask(
      id: 'task_first_code_run',
      title: 'Execute Your First Script in Playground',
      description: 'Run any Python script in the sandboxed CPython 3 IDE.',
      xpReward: 50,
      type: TaskType.inAppAction,
      actionLabel: 'Open IDE',
      verificationPrompt: 'Have you executed Python code in the Playground?',
    ),
    RewardTask(
      id: 'task_daily_quest_solve',
      title: 'Solve Today\'s Coding Quest',
      description: 'Pass all automated test assertions on today\'s algorithm challenge.',
      xpReward: 75,
      type: TaskType.inAppAction,
      actionLabel: 'Go to Daily Quest',
      verificationPrompt: 'Have you completed today\'s Coding Quest?',
    ),
    RewardTask(
      id: 'task_master_flashcards',
      title: 'Master 5 Python Flashcards',
      description: 'Use the spaced repetition hub to master 5 language concepts or dunder methods.',
      xpReward: 50,
      type: TaskType.inAppAction,
      actionLabel: 'Open Flashcards',
      verificationPrompt: 'Have you marked at least 5 flashcards as mastered?',
    ),
  ];
}
