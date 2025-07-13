class Challenge {
  final int id;
  final String title;
  final String description;
  final int targetSteps;
  final int durationDays;
  final bool isJoined; // ← Tambahkan ini


  Challenge({
    required this.id,
    required this.title,
    required this.description,
    required this.targetSteps,
    required this.durationDays,
    this.isJoined = false, // default false

  });

  factory Challenge.fromJson(Map<String, dynamic> json) {
    return Challenge(
      id: json['id'] ?? 0,
      title: json['title'] ?? 'Tanpa Judul',
      description: json['description'] ?? '-',
      targetSteps: json['target_steps'] ?? 0,
      durationDays: json['duration_days'] ?? 0,
      isJoined:
          json['is_joined'] ??
          false, // harus didukung dari backend atau bisa lokal
    );
  }
}