class TipModel {
  final int id;
  final String title;
  final String content;
  final String createdAt;
  final String? mentorName;

  TipModel({
    required this.id,
    required this.title,
    required this.content,
    required this.createdAt,
    this.mentorName,
  });

  factory TipModel.fromJson(Map<String, dynamic> json) {
    return TipModel(
      id: json['id'],
      title: json['title'],
      content: json['content'],
      createdAt: json['created_at'],
      mentorName: json['creator']?['name'], // relasi optional
    );
  }
}
