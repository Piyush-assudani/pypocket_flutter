import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user_profile_model.dart';
import '../models/certificate_model.dart';
import '../models/snippet_model.dart';
import '../theme/app_theme.dart';

class StorageService {
  static const String _keyProfile = 'pypocket_user_profile';
  static const String _keyCertificates = 'pypocket_certificates';
  static const String _keySnippets = 'pypocket_snippets_list';
  static const String _keySupabaseUrl = 'pypocket_supabase_url';
  static const String _keySupabaseKey = 'pypocket_supabase_key';
  static const String _keyPlaygroundCode = 'pypocket_current_code';
  static const String _keyThemeMode = 'pypocket_theme_mode';
  static const String _keyHasCompletedOnboarding = 'pypocket_has_onboarded';
  static const String _keySolvedChallenges = 'pypocket_solved_challenges';
  static const String _keyMasteredFlashcards = 'pypocket_mastered_flashcards';
  static const String _keyActivityDates = 'pypocket_activity_dates';
  static const String _keyClaimedTasks = 'pypocket_claimed_tasks';

  static SharedPreferences? _prefs;
  static SharedPreferences? get prefs => _prefs;

  static bool hasCompletedOnboarding() {
    return _prefs?.getBool(_keyHasCompletedOnboarding) ?? false;
  }

  static Future<void> setCompletedOnboarding(bool value) async {
    await _prefs?.setBool(_keyHasCompletedOnboarding, value);
  }


  static Future<void> init() async {
    _prefs ??= await SharedPreferences.getInstance();
    // Load saved theme mode (defaults to light mode)
    final savedTheme = _prefs?.getString(_keyThemeMode);
    if (savedTheme != null) {
      if (savedTheme == 'dark') {
        AppTheme.themeModeNotifier.value = ThemeMode.dark;
      } else {
        AppTheme.themeModeNotifier.value = ThemeMode.light;
      }
    } else {
      AppTheme.themeModeNotifier.value = ThemeMode.light;
    }
  }

  // --- Theme Mode ---
  static Future<void> setThemeMode(ThemeMode mode) async {
    AppTheme.themeModeNotifier.value = mode;
    String val = 'light';
    if (mode == ThemeMode.dark) val = 'dark';
    if (mode == ThemeMode.light) val = 'light';
    await _prefs?.setString(_keyThemeMode, val);
  }

  static ThemeMode getThemeMode() {
    final saved = _prefs?.getString(_keyThemeMode);
    if (saved == 'dark') return ThemeMode.dark;
    return ThemeMode.light; // Default to Light theme as requested
  }

  // --- Profile Management ---
  static UserProfile getUserProfile() {
    final raw = _prefs?.getString(_keyProfile);
    if (raw != null) {
      try {
        return UserProfile.fromJson(jsonDecode(raw));
      } catch (_) {}
    }
    return UserProfile(
      userName: 'Python Developer',
      email: '',
      avatarId: 'python_architect',
      bio: 'Exploring Python & Building Algorithms with PyPocket',
      goal: 'Full-Stack Python & AI',
      skillLevel: 'Beginner',
      githubHandle: '',
      xp: 0,
      streakDays: 1,
      completedLessonIds: [],
      completedQuizIds: [],
      bookmarkedLessonIds: [],
    );
  }

  static Future<void> saveUserProfile(UserProfile profile) async {
    await _prefs?.setString(_keyProfile, jsonEncode(profile.toJson()));
  }

  static Future<void> addXp(int amount) async {
    final profile = getUserProfile();
    final updated = profile.copyWith(xp: profile.xp + amount);
    await saveUserProfile(updated);
  }

  static Future<void> markLessonCompleted(String lessonId, int xp) async {
    final profile = getUserProfile();
    if (!profile.completedLessonIds.contains(lessonId)) {
      final updatedList = List<String>.from(profile.completedLessonIds)..add(lessonId);
      final updated = profile.copyWith(
        xp: profile.xp + xp,
        completedLessonIds: updatedList,
      );
      await saveUserProfile(updated);
      await recordTodayActivity();
    }
  }

  static Future<void> markQuizCompleted(String quizId, int xp) async {
    final profile = getUserProfile();
    if (!profile.completedQuizIds.contains(quizId)) {
      final updatedList = List<String>.from(profile.completedQuizIds)..add(quizId);
      final updated = profile.copyWith(
        xp: profile.xp + xp,
        completedQuizIds: updatedList,
      );
      await saveUserProfile(updated);
      await recordTodayActivity();
    }
  }

  static Future<void> toggleBookmark(String lessonId) async {
    final profile = getUserProfile();
    final list = List<String>.from(profile.bookmarkedLessonIds);
    if (list.contains(lessonId)) {
      list.remove(lessonId);
    } else {
      list.add(lessonId);
    }
    final updated = profile.copyWith(bookmarkedLessonIds: list);
    await saveUserProfile(updated);
  }

  // --- Daily Coding Challenges ---
  static List<String> getSolvedChallenges() {
    return _prefs?.getStringList(_keySolvedChallenges) ?? [];
  }

  static bool isChallengeSolved(String challengeId) {
    return getSolvedChallenges().contains(challengeId);
  }

  static Future<void> markChallengeSolved(String challengeId, int xp) async {
    final list = List<String>.from(getSolvedChallenges());
    if (!list.contains(challengeId)) {
      list.add(challengeId);
      await _prefs?.setStringList(_keySolvedChallenges, list);
      await addXp(xp);
      await recordTodayActivity();
    }
  }

  // --- Bonus Reward Tasks & Anti-Cheat System ---
  static List<String> getClaimedTaskIds() {
    return _prefs?.getStringList(_keyClaimedTasks) ?? [];
  }

  static bool isTaskClaimed(String taskId) {
    return getClaimedTaskIds().contains(taskId);
  }

  static Future<bool> claimRewardTask(String taskId, int xp) async {
    final list = List<String>.from(getClaimedTaskIds());
    if (list.contains(taskId)) {
      return false; // Prevent double claim
    }
    list.add(taskId);
    await _prefs?.setStringList(_keyClaimedTasks, list);
    await addXp(xp);
    await recordTodayActivity();
    return true;
  }

  // --- Python Flashcards (Spaced Repetition) ---
  static List<String> getMasteredFlashcardIds() {
    return _prefs?.getStringList(_keyMasteredFlashcards) ?? [];
  }

  static bool isFlashcardMastered(String cardId) {
    return getMasteredFlashcardIds().contains(cardId);
  }

  static Future<bool> toggleFlashcardMastered(String cardId) async {
    final list = List<String>.from(getMasteredFlashcardIds());
    bool nowMastered = false;
    if (list.contains(cardId)) {
      list.remove(cardId);
      nowMastered = false;
    } else {
      list.add(cardId);
      nowMastered = true;
      await addXp(5);
      await recordTodayActivity();
    }
    await _prefs?.setStringList(_keyMasteredFlashcards, list);
    return nowMastered;
  }

  // --- 7-Day Habit Activity Tracker ---
  static Future<void> recordTodayActivity() async {
    final now = DateTime.now();
    final todayStr = '${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}';
    final list = _prefs?.getStringList(_keyActivityDates) ?? [];
    if (!list.contains(todayStr)) {
      final updated = List<String>.from(list)..add(todayStr);
      await _prefs?.setStringList(_keyActivityDates, updated);
    }
  }

  static Set<int> getWeeklyActiveWeekdays() {
    final now = DateTime.now();
    final monday = now.subtract(Duration(days: now.weekday - 1));
    final activeWeekdays = <int>{};
    final list = _prefs?.getStringList(_keyActivityDates) ?? [];

    // Always include today if user is actively engaging
    activeWeekdays.add(now.weekday);

    for (int i = 0; i < 7; i++) {
      final day = monday.add(Duration(days: i));
      final dayStr = '${day.year}-${day.month.toString().padLeft(2, '0')}-${day.day.toString().padLeft(2, '0')}';
      if (list.contains(dayStr)) {
        activeWeekdays.add(day.weekday);
      }
    }
    return activeWeekdays;
  }

  // --- Snippet Library Management ---
  static List<CodeSnippet> getSnippets() {
    final rawList = _prefs?.getStringList(_keySnippets);
    if (rawList == null || rawList.isEmpty) return [];
    return rawList
        .map((s) {
          try {
            return CodeSnippet.fromJson(jsonDecode(s));
          } catch (_) {
            return null;
          }
        })
        .whereType<CodeSnippet>()
        .toList();
  }

  static Future<void> saveSnippet(CodeSnippet snippet) async {
    final list = getSnippets();
    list.removeWhere((s) => s.id == snippet.id);
    list.insert(0, snippet);
    final strList = list.map((s) => jsonEncode(s.toJson())).toList();
    await _prefs?.setStringList(_keySnippets, strList);
  }

  static Future<void> deleteSnippet(String snippetId) async {
    final list = getSnippets();
    list.removeWhere((s) => s.id == snippetId);
    final strList = list.map((s) => jsonEncode(s.toJson())).toList();
    await _prefs?.setStringList(_keySnippets, strList);
  }

  // --- Certificates ---
  static List<Certificate> getCertificates() {
    final raw = _prefs?.getStringList(_keyCertificates);
    if (raw == null || raw.isEmpty) return [];
    return raw
        .map((e) {
          try {
            return Certificate.fromJson(jsonDecode(e));
          } catch (_) {
            return null;
          }
        })
        .whereType<Certificate>()
        .toList();
  }

  static Future<void> saveCertificate(Certificate cert) async {
    final list = getCertificates();
    list.removeWhere((c) => c.id == cert.id);
    list.insert(0, cert);
    final strList = list.map((c) => jsonEncode(c.toJson())).toList();
    await _prefs?.setStringList(_keyCertificates, strList);
  }

  // --- Playground State ---
  static String? getLastPlaygroundCode() {
    return _prefs?.getString(_keyPlaygroundCode);
  }

  static Future<void> savePlaygroundCode(String code) async {
    await _prefs?.setString(_keyPlaygroundCode, code);
  }

  // --- Database Settings ---
  static String? getSupabaseUrl() {
    return _prefs?.getString(_keySupabaseUrl);
  }

  static String? getSupabaseAnonKey() {
    return _prefs?.getString(_keySupabaseKey);
  }

  static Future<void> saveSupabaseCredentials(String url, String key) async {
    await _prefs?.setString(_keySupabaseUrl, url.trim());
    await _prefs?.setString(_keySupabaseKey, key.trim());
  }

  static Future<void> clearSupabaseCredentials() async {
    await _prefs?.remove(_keySupabaseUrl);
    await _prefs?.remove(_keySupabaseKey);
  }

  // --- Backdoor / QA Testing Methods for Play Store Review & Debugging ---
  static Future<void> markAllLessonsCompleted(List<String> allLessonIds) async {
    final profile = getUserProfile();
    final updated = profile.copyWith(
      completedLessonIds: allLessonIds,
      xp: profile.xp < 1500 ? 2500 : profile.xp,
    );
    await saveUserProfile(updated);
  }

  static Future<Certificate> issueTestCertificate(String studentName, {int score = 95}) async {
    final cert = Certificate(
      id: 'PY-VERIFIED-${DateTime.now().millisecondsSinceEpoch.toString().substring(7)}',
      userName: studentName.isNotEmpty ? studentName : 'QA Verified Developer',
      title: 'PyPocket Certified Python Specialist',
      track: 'Full Curriculum Master',
      score: score.toDouble(),
      grade: score >= 90 ? 'Distinction (A+)' : 'Pass (B)',
      issueDate: DateTime.now(),
      verificationHash: 'PY-HASH-${DateTime.now().millisecondsSinceEpoch}',
    );
    await saveCertificate(cert);
    return cert;
  }

  static Future<void> setTesterStats({int xp = 3500, int streak = 30}) async {
    final profile = getUserProfile();
    final updated = profile.copyWith(xp: xp, streakDays: streak);
    await saveUserProfile(updated);
  }

  static Future<void> resetAllProgress() async {
    final profile = getUserProfile();
    final reset = profile.copyWith(
      completedLessonIds: [],
      completedQuizIds: [],
      xp: 0,
      streakDays: 1,
    );
    await saveUserProfile(reset);
    await _prefs?.remove(_keyCertificates);
  }
}

