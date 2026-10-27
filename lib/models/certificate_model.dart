class Certificate {
  final String id;
  final String userName;
  final String title;
  final String track;
  final double score;
  final String grade;
  final DateTime issueDate;
  final String verificationHash;

  Certificate({
    required this.id,
    required this.userName,
    required this.title,
    required this.track,
    required this.score,
    required this.grade,
    required this.issueDate,
    required this.verificationHash,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'user_name': userName,
    'title': title,
    'track': track,
    'score': score,
    'grade': grade,
    'issue_date': issueDate.toIso8601String(),
    'verification_hash': verificationHash,
  };

  factory Certificate.fromJson(Map<String, dynamic> json) => Certificate(
    id: json['id'] as String,
    userName: json['user_name'] as String? ?? 'PyPocket Developer',
    title: json['title'] as String,
    track: json['track'] as String,
    score: (json['score'] as num).toDouble(),
    grade: json['grade'] as String,
    issueDate: DateTime.parse(json['issue_date'] as String),
    verificationHash: json['verification_hash'] as String,
  );
}
