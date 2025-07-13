class ChallengeHistoryModel {
  final int id;
  final String title;
  final String description;
  final String createdAt;

  ChallengeHistoryModel({
    required this.id,
    required this.title,
    required this.description,
    required this.createdAt,
  });

  factory ChallengeHistoryModel.fromJson(Map<String, dynamic> json) {
    final challenge = json['challenge'];
    return ChallengeHistoryModel(
      id: challenge?['id'] ?? 0,
      title: challenge?['title'] ?? '-',
      description: challenge?['description'] ?? '',
      createdAt: challenge?['created_at'] ?? '',
    );
  }
}
