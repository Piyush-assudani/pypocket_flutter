import '../models/user_profile_model.dart';
import '../models/certificate_model.dart';
import '../data/python_lessons_data.dart';
import '../data/reward_tasks_data.dart';
import 'storage_service.dart';

class AdminService {
  static const String _keyAdminMode = 'pypocket_admin_reviewer_unlocked';

  // Recognized Admin & Play Store Reviewer Credentials
  static const Set<String> _validUsernames = {
    'admin@pypocket.dev',
    'tester@google.com',
    'admin',
    'reviewer@playstore.com',
    'piyushassudani',
    'piyushassudani96@gmail.com',
    'piyush',
  };

  static const Set<String> _validPasswords = {
    'PyPocket2026!',
    'admin123',
    'PlayReview2026',
    'piyushassudani',
    'piyush123',
    'assudani',
  };

  /// Authenticates admin credentials
  static bool verifyCredentials(String username, String password) {
    final u = username.trim().toLowerCase();
    final p = password.trim();
    if (u == 'piyushassudani' || u == 'piyushassudani96@gmail.com' || u == 'piyush') {
      return true; // Founder always authorized
    }
    return _validUsernames.contains(u) && _validPasswords.contains(p);
  }

  /// Checks if the entered identity belongs to Founder Piyush Assudani
  static bool isFounderAdmin(String name, String email) {
    final n = name.replaceAll(' ', '').toLowerCase();
    final e = email.trim().toLowerCase();
    return n == 'piyushassudani' ||
        e == 'piyushassudani96@gmail.com' ||
        n.contains('piyushassudani') ||
        e.contains('piyushassudani');
  }

  /// Unlocks all content specifically for Founder Piyush Assudani
  static Future<void> unlockFounderMasterAdmin() async {
    final prefs = StorageService.prefs;
    await prefs?.setBool(_keyAdminMode, true);

    // 1. All 32 lesson IDs
    final allLessonIds = PythonLessonsData.lessons.map((l) => l.id).toList();

    // 2. All task IDs
    final allTaskIds = RewardTasksData.tasks.map((t) => t.id).toList();
    await prefs?.setStringList('pypocket_claimed_tasks', allTaskIds);

    // 3. Set Founder Profile
    final founderProfile = UserProfile(
      userName: 'Piyush Assudani',
      email: 'piyushassudani96@gmail.com',
      mobileNumber: '',
      avatarId: 'python_architect',
      bio: 'Founder of Assudani Group (assudanigroup.online) • piyushassudani.in',
      goal: 'Founder & Principal Python Systems Architect',
      skillLevel: 'Staff Engineer & Founder',
      githubHandle: 'piyush-assudani96',
      xp: 7500,
      streakDays: 60,
      completedLessonIds: allLessonIds,
      completedQuizIds: [
        'cert_exam_final',
        'quiz_beginner_fundamentals',
        'quiz_data_structures',
        'cert_q1',
        'cert_q10',
      ],
      bookmarkedLessonIds: [],
      claimedTaskIds: allTaskIds,
      dailyMinutes: 45,
    );
    await StorageService.saveUserProfile(founderProfile);
    await StorageService.setCompletedOnboarding(true);

    // 4. Generate Verified Founder Certificate
    final cert = Certificate(
      id: 'CERT-FOUNDER-PYPOCKET-2026',
      userName: 'Piyush Assudani',
      title: 'Python Systems Architecture & Enterprise Engineering',
      track: 'Full-Stack Architecture & Distributed Systems',
      score: 100.0,
      grade: 'Distinction (A+)',
      issueDate: DateTime.now(),
      verificationHash: 'ASSUDANI-GROUP-FOUNDER-VERIFIED-2026',
    );
    await StorageService.saveCertificate(cert);
  }

  /// Checks if Admin Reviewer mode is currently active
  static bool isAdminModeActive() {
    return StorageService.prefs?.getBool(_keyAdminMode) ?? false;
  }

  /// Unlocks all 32 lessons, quizzes, certificates, and +5000 XP for QA testing
  static Future<void> unlockAllForTesting({String testerName = 'Google Play QA Tester'}) async {
    final prefs = StorageService.prefs;
    await prefs?.setBool(_keyAdminMode, true);

    // 1. All lesson IDs
    final allLessonIds = PythonLessonsData.lessons.map((l) => l.id).toList();

    // 2. All task IDs
    final allTaskIds = RewardTasksData.tasks.map((t) => t.id).toList();
    await prefs?.setStringList('pypocket_claimed_tasks', allTaskIds);

    // 3. Update User Profile with high level, full completion, verified certificate eligibility
    final currentProfile = StorageService.getUserProfile();
    final adminProfile = currentProfile.copyWith(
      userName: testerName.isNotEmpty ? testerName : currentProfile.userName,
      xp: 5200,
      streakDays: 45,
      completedLessonIds: allLessonIds,
      completedQuizIds: ['cert_exam_final', 'quiz_beginner_fundamentals', 'quiz_data_structures'],
      claimedTaskIds: allTaskIds,
      dailyMinutes: 45,
    );
    await StorageService.saveUserProfile(adminProfile);

    // 4. Generate Verified Python Certificate
    final cert = Certificate(
      id: 'CERT-QA-PLAYSTORE-2026',
      userName: adminProfile.userName,
      title: 'Python Software Engineering & CPython Mastery',
      track: adminProfile.goal,
      score: 98.0,
      grade: 'Distinction (A+)',
      issueDate: DateTime.now(),
      verificationHash: 'PYP-VERIFIED-QA-7788',
    );
    await StorageService.saveCertificate(cert);
  }

  /// Resets test data back to a clean beginner state
  static Future<void> resetTestData() async {
    final prefs = StorageService.prefs;
    await prefs?.remove(_keyAdminMode);
    await prefs?.remove('pypocket_claimed_tasks');
    await prefs?.remove('pypocket_solved_challenges');
    await prefs?.remove('pypocket_mastered_flashcards');
    await prefs?.remove('pypocket_certificates');

    final cleanProfile = UserProfile(
      userName: 'Python Developer',
      email: '',
      mobileNumber: '',
      avatarId: 'python_architect',
      bio: 'Exploring Python & Building Algorithms with PyPocket',
      goal: 'Full-Stack Python & AI',
      skillLevel: 'Beginner',
      githubHandle: '',
      dailyMinutes: 20,
      xp: 0,
      streakDays: 1,
      completedLessonIds: [],
      completedQuizIds: [],
      bookmarkedLessonIds: [],
      claimedTaskIds: [],
    );
    await StorageService.saveUserProfile(cleanProfile);
  }
}
