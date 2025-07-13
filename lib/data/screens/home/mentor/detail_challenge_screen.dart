import 'package:flutter/material.dart';
import 'package:fitsteps_app/data/models/challenge_model.dart';
import 'package:fitsteps_app/data/services/challenge_service.dart';

class DetailChallengeScreen extends StatefulWidget {
  final Challenge challenge;
  final String token;
  final String role;

  const DetailChallengeScreen({
    super.key,
    required this.challenge,
    required this.token,
    required this.role,
  });

  @override
  State<DetailChallengeScreen> createState() => _DetailChallengeScreenState();
}

class _DetailChallengeScreenState extends State<DetailChallengeScreen> {
  List<Map<String, dynamic>> participants = [];
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    if (widget.role == 'mentor') {
      fetchParticipants();
    }
  }

  Future<void> fetchParticipants() async {
    setState(() => isLoading = true);
    try {
      final data = await ChallengeService().getParticipants(
        widget.token,
        widget.challenge.id,
      );
      setState(() => participants = data);
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Gagal mengambil peserta: $e')));
    } finally {
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final c = widget.challenge;

    return Scaffold(
      appBar: AppBar(title: const Text('Detail Challenge')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            Text(
              c.title,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Text("Deskripsi: ${c.description}"),
            const SizedBox(height: 8),
            Text("Target Langkah: ${c.targetSteps}"),
            const SizedBox(height: 4),
            Text("Durasi Hari: ${c.durationDays}"),
            const SizedBox(height: 16),

            // Tambahan untuk mentor
            if (widget.role == 'mentor') ...[
              const Divider(),
              const Text(
                "Peserta Challenge",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              if (isLoading)
                const Center(child: CircularProgressIndicator())
              else if (participants.isEmpty)
                const Text("Belum ada peserta.")
              else
                ...participants.map(
                  (p) => ListTile(
                    leading: const Icon(Icons.person),
                    title: Text(p['name']),
                    subtitle: Text("${p['email']} • ${p['status']}"),
                    trailing: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text("Mulai: ${p['start_date'] ?? '-'}"),
                        Text("Langkah: ${p['progress_steps']}"),
                      ],
                    ),
                  ),
                ),
            ],
          ],
        ),
      ),
    );
  }
}
