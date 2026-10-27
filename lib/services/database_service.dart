import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'storage_service.dart';
import '../models/user_profile_model.dart';
import '../models/certificate_model.dart';

class DatabaseService {
  static SupabaseClient? _client;
  static bool _isInitialized = false;

  static bool get isConfigured => _isInitialized && _client != null;
  static SupabaseClient? get client => _client;

  /// Initializes Supabase using stored credentials if available
  static Future<bool> init() async {
    final url = StorageService.getSupabaseUrl();
    final anonKey = StorageService.getSupabaseAnonKey();

    if (url == null || url.isEmpty || anonKey == null || anonKey.isEmpty) {
      _isInitialized = false;
      _client = null;
      return false;
    }

    try {
      if (Supabase.instance.isInitialized) {
        _client = Supabase.instance.client;
        _isInitialized = true;
        return true;
      }

      await Supabase.initialize(
        url: url,
        // ignore: deprecated_member_use
        anonKey: anonKey,
        debug: kDebugMode,
      );

      _client = Supabase.instance.client;
      _isInitialized = true;
      return true;
    } catch (e) {
      debugPrint('Supabase Init Error: $e');
      _isInitialized = false;
      _client = null;
      return false;
    }
  }

  /// Tests a connection with given URL and Anon Key
  static Future<Map<String, dynamic>> testConnection(String url, String anonKey) async {
    try {
      final tempClient = SupabaseClient(url.trim(), anonKey.trim());
      // Test querying a table or checking auth health
      await tempClient.from('profiles').select().limit(1);
      return {'success': true, 'message': 'Connected to Supabase successfully!'};
    } catch (e) {
      final err = e.toString();
      if (err.contains('does not exist') || err.contains('relation "public.profiles" does not exist')) {
        return {
          'success': true,
          'message': 'Connected! Note: Remember to run the setup SQL to create tables.',
          'needSchema': true,
        };
      }
      return {'success': false, 'message': 'Connection failed: $err'};
    }
  }

  /// Syncs local profile to Supabase database
  static Future<void> syncProfileToCloud(UserProfile profile) async {
    if (!isConfigured || _client == null) return;
    try {
      await _client!.from('profiles').upsert({
        'user_name': profile.userName,
        'email': profile.email,
        'xp': profile.xp,
        'streak_days': profile.streakDays,
        'completed_lessons': profile.completedLessonIds,
        'completed_quizzes': profile.completedQuizIds,
        'updated_at': DateTime.now().toIso8601String(),
      });
    } catch (e) {
      debugPrint('Cloud sync error (profile): $e');
    }
  }

  /// Syncs certificate to Supabase database
  static Future<void> syncCertificateToCloud(Certificate cert) async {
    if (!isConfigured || _client == null) return;
    try {
      await _client!.from('certificates').upsert({
        'id': cert.id,
        'user_name': cert.userName,
        'title': cert.title,
        'track': cert.track,
        'score': cert.score,
        'grade': cert.grade,
        'issue_date': cert.issueDate.toIso8601String(),
        'verification_hash': cert.verificationHash,
      });
    } catch (e) {
      debugPrint('Cloud sync error (cert): $e');
    }
  }

  /// Returns ready-to-run SQL schema for the user's Supabase project
  static String get setupSqlScript => '''
-- PyPocket Database Schema (Run this in Supabase SQL Editor)

-- 1. Profiles Table
CREATE TABLE IF NOT EXISTS public.profiles (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  user_name TEXT NOT NULL,
  email TEXT,
  xp INTEGER DEFAULT 0,
  streak_days INTEGER DEFAULT 1,
  completed_lessons TEXT[] DEFAULT '{}',
  completed_quizzes TEXT[] DEFAULT '{}',
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- 2. Certificates Table
CREATE TABLE IF NOT EXISTS public.certificates (
  id TEXT PRIMARY KEY,
  user_name TEXT NOT NULL,
  title TEXT NOT NULL,
  track TEXT NOT NULL,
  score NUMERIC(5, 2) NOT NULL,
  grade TEXT NOT NULL,
  issue_date TIMESTAMPTZ NOT NULL,
  verification_hash TEXT NOT NULL,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- 3. Saved Snippets Table
CREATE TABLE IF NOT EXISTS public.snippets (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  title TEXT NOT NULL,
  code TEXT NOT NULL,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- Enable Row Level Security (RLS) & Public Access Policies for Quick Setup
ALTER TABLE public.profiles ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.certificates ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.snippets ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Public profiles access" ON public.profiles FOR ALL USING (true) WITH CHECK (true);
CREATE POLICY "Public certificates access" ON public.certificates FOR ALL USING (true) WITH CHECK (true);
CREATE POLICY "Public snippets access" ON public.snippets FOR ALL USING (true) WITH CHECK (true);
''';
}
