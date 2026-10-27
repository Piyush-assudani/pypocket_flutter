class UserProfile {
  final String userName;
  final String email;
  final String mobileNumber;
  final String avatarId;
  final String bio;
  final String goal;
  final String skillLevel;
  final String githubHandle;
  final int dailyMinutes;
  final int xp;
  final int streakDays;
  final List<String> completedLessonIds;
  final List<String> completedQuizIds;
  final List<String> bookmarkedLessonIds;
  final List<String> claimedTaskIds;

  UserProfile({
    required this.userName,
    required this.email,
    this.mobileNumber = '',
    this.avatarId = 'python_architect',
    this.bio = 'Python Enthusiast & PyPocket Learner',
    this.goal = 'Full-Stack Python & AI',
    this.skillLevel = 'Beginner',
    this.githubHandle = '',
    this.dailyMinutes = 20,
    required this.xp,
    required this.streakDays,
    required this.completedLessonIds,
    required this.completedQuizIds,
    this.bookmarkedLessonIds = const [],
    this.claimedTaskIds = const [],
  });

  int get level => (xp / 100).floor() + 1;
  String get careerGoal => goal;

  String get rankTitle {
    if (xp < 150) return 'Python Novice';
    if (xp < 400) return 'Python Apprentice';
    if (xp < 800) return 'Script Crafter';
    if (xp < 1500) return 'Python Specialist';
    if (xp < 2500) return 'Senior Pythoneer';
    return 'Python Grandmaster';
  }

  double get levelProgress {
    final currentLevelXp = (level - 1) * 100;
    final nextLevelXp = level * 100;
    return ((xp - currentLevelXp) / (nextLevelXp - currentLevelXp)).clamp(0.0, 1.0);
  }

  Map<String, dynamic> toJson() => {
    'user_name': userName,
    'email': email,
    'mobile_number': mobileNumber,
    'avatar_id': avatarId,
    'bio': bio,
    'goal': goal,
    'skill_level': skillLevel,
    'github_handle': githubHandle,
    'daily_minutes': dailyMinutes,
    'xp': xp,
    'streak_days': streakDays,
    'completed_lessons': completedLessonIds,
    'completed_quizzes': completedQuizIds,
    'bookmarked_lessons': bookmarkedLessonIds,
    'claimed_tasks': claimedTaskIds,
  };

  factory UserProfile.fromJson(Map<String, dynamic> json) => UserProfile(
    userName: json['user_name'] as String? ?? 'Python Programmer',
    email: json['email'] as String? ?? '',
    mobileNumber: json['mobile_number'] as String? ?? '',
    avatarId: json['avatar_id'] as String? ?? 'python_architect',
    bio: json['bio'] as String? ?? 'Python Enthusiast & PyPocket Learner',
    goal: json['goal'] as String? ?? 'Full-Stack Python & AI',
    skillLevel: json['skill_level'] as String? ?? 'Beginner',
    githubHandle: json['github_handle'] as String? ?? '',
    dailyMinutes: json['daily_minutes'] as int? ?? 20,
    xp: json['xp'] as int? ?? 0,
    streakDays: json['streak_days'] as int? ?? 1,
    completedLessonIds: List<String>.from(json['completed_lessons'] ?? []),
    completedQuizIds: List<String>.from(json['completed_quizzes'] ?? []),
    bookmarkedLessonIds: List<String>.from(json['bookmarked_lessons'] ?? []),
    claimedTaskIds: List<String>.from(json['claimed_tasks'] ?? []),
  );

  UserProfile copyWith({
    String? userName,
    String? email,
    String? mobileNumber,
    String? avatarId,
    String? bio,
    String? goal,
    String? skillLevel,
    String? githubHandle,
    int? dailyMinutes,
    int? xp,
    int? streakDays,
    List<String>? completedLessonIds,
    List<String>? completedQuizIds,
    List<String>? bookmarkedLessonIds,
    List<String>? claimedTaskIds,
  }) {
    return UserProfile(
      userName: userName ?? this.userName,
      email: email ?? this.email,
      mobileNumber: mobileNumber ?? this.mobileNumber,
      avatarId: avatarId ?? this.avatarId,
      bio: bio ?? this.bio,
      goal: goal ?? this.goal,
      skillLevel: skillLevel ?? this.skillLevel,
      githubHandle: githubHandle ?? this.githubHandle,
      dailyMinutes: dailyMinutes ?? this.dailyMinutes,
      xp: xp ?? this.xp,
      streakDays: streakDays ?? this.streakDays,
      completedLessonIds: completedLessonIds ?? this.completedLessonIds,
      completedQuizIds: completedQuizIds ?? this.completedQuizIds,
      bookmarkedLessonIds: bookmarkedLessonIds ?? this.bookmarkedLessonIds,
      claimedTaskIds: claimedTaskIds ?? this.claimedTaskIds,
    );
  }
}
