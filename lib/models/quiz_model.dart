class QuizQuestion {
  final String id;
  final String category;
  final String question;
  final String? codeSnippet;
  final List<String> options;
  final int correctIndex;
  final String explanation;
  final int xp;

  const QuizQuestion({
    required this.id,
    required this.category,
    required this.question,
    this.codeSnippet,
    required this.options,
    required this.correctIndex,
    required this.explanation,
    this.xp = 20,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'category': category,
    'question': question,
    'codeSnippet': codeSnippet,
    'options': options,
    'correctIndex': correctIndex,
    'explanation': explanation,
    'xp': xp,
  };

  factory QuizQuestion.fromJson(Map<String, dynamic> json) => QuizQuestion(
    id: json['id'] as String,
    category: json['category'] as String,
    question: json['question'] as String,
    codeSnippet: json['codeSnippet'] as String?,
    options: List<String>.from(json['options'] as List),
    correctIndex: json['correctIndex'] as int,
    explanation: json['explanation'] as String,
    xp: json['xp'] as int? ?? 20,
  );
}

class QuizResult {
  final String quizTitle;
  final int totalQuestions;
  final int correctAnswers;
  final int earnedXp;
  final double scorePercentage;
  final DateTime completedAt;
  final bool passed;

  QuizResult({
    required this.quizTitle,
    required this.totalQuestions,
    required this.correctAnswers,
    required this.earnedXp,
    required this.scorePercentage,
    required this.completedAt,
    required this.passed,
  });
}
