enum LessonDifficulty { easy, medium, hard }

class Lesson {
  final String id;
  final String track;
  final String title;
  final String description;
  final String content;
  final String codeExample;
  final String expectedOutput;
  final String exercisePrompt;
  final String starterCode;
  final String solutionCode;
  final int xp;
  final LessonDifficulty difficulty;
  final String? youtubeVideoId;
  final String? videoTitle;
  final int? videoDurationMinutes;
  final List<String> keyConcepts;
  final List<String> commonMistakes;

  const Lesson({
    required this.id,
    required this.track,
    required this.title,
    required this.description,
    required this.content,
    required this.codeExample,
    required this.expectedOutput,
    required this.exercisePrompt,
    required this.starterCode,
    required this.solutionCode,
    required this.xp,
    required this.difficulty,
    this.youtubeVideoId,
    this.videoTitle,
    this.videoDurationMinutes,
    this.keyConcepts = const [],
    this.commonMistakes = const [],
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'track': track,
    'title': title,
    'description': description,
    'content': content,
    'codeExample': codeExample,
    'expectedOutput': expectedOutput,
    'exercisePrompt': exercisePrompt,
    'starterCode': starterCode,
    'solutionCode': solutionCode,
    'xp': xp,
    'difficulty': difficulty.name,
    'youtubeVideoId': youtubeVideoId,
    'videoTitle': videoTitle,
    'videoDurationMinutes': videoDurationMinutes,
    'keyConcepts': keyConcepts,
    'commonMistakes': commonMistakes,
  };

  factory Lesson.fromJson(Map<String, dynamic> json) => Lesson(
    id: json['id'] as String,
    track: json['track'] as String,
    title: json['title'] as String,
    description: json['description'] as String,
    content: json['content'] as String,
    codeExample: json['codeExample'] as String,
    expectedOutput: json['expectedOutput'] as String,
    exercisePrompt: json['exercisePrompt'] as String,
    starterCode: json['starterCode'] as String,
    solutionCode: json['solutionCode'] as String,
    xp: json['xp'] as int? ?? 50,
    difficulty: LessonDifficulty.values.firstWhere(
      (d) => d.name == json['difficulty'],
      orElse: () => LessonDifficulty.easy,
    ),
    youtubeVideoId: json['youtubeVideoId'] as String?,
    videoTitle: json['videoTitle'] as String?,
    videoDurationMinutes: json['videoDurationMinutes'] as int?,
    keyConcepts: List<String>.from(json['keyConcepts'] ?? []),
    commonMistakes: List<String>.from(json['commonMistakes'] ?? []),
  );
}
