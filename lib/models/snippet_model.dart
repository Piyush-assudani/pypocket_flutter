class CodeSnippet {
  final String id;
  final String title;
  final String code;
  final String category;
  final DateTime createdAt;
  final DateTime updatedAt;

  CodeSnippet({
    required this.id,
    required this.title,
    required this.code,
    this.category = 'General',
    required this.createdAt,
    required this.updatedAt,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'code': code,
    'category': category,
    'created_at': createdAt.toIso8601String(),
    'updated_at': updatedAt.toIso8601String(),
  };

  factory CodeSnippet.fromJson(Map<String, dynamic> json) => CodeSnippet(
    id: json['id'] as String,
    title: json['title'] as String,
    code: json['code'] as String,
    category: json['category'] as String? ?? 'General',
    createdAt: DateTime.parse(json['created_at'] as String),
    updatedAt: DateTime.parse(json['updated_at'] as String),
  );
}
