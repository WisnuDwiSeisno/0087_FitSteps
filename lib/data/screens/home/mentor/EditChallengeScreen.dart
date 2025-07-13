import 'package:fitsteps_app/data/models/challenge_model.dart';
import 'package:fitsteps_app/data/services/challenge_service.dart';
import 'package:flutter/material.dart';

class EditChallengeScreen extends StatefulWidget {
  final String token;
  final Challenge challenge;

  const EditChallengeScreen({
    super.key,
    required this.token,
    required this.challenge,
  });

  @override
  State<EditChallengeScreen> createState() => _EditChallengeScreenState();
}

class _EditChallengeScreenState extends State<EditChallengeScreen> {
  late TextEditingController titleController;
  late TextEditingController descController;
  late TextEditingController stepsController;
  late TextEditingController durationController;

  @override
  void initState() {
    super.initState();
    titleController = TextEditingController(text: widget.challenge.title);
    descController = TextEditingController(text: widget.challenge.description);
    stepsController = TextEditingController(
      text: widget.challenge.targetSteps.toString(),
    );
    durationController = TextEditingController(
      text: widget.challenge.durationDays.toString(),
    );
  }

  @override
  void dispose() {
    titleController.dispose();
    descController.dispose();
    stepsController.dispose();
    durationController.dispose();
    super.dispose();
  }

  Future<void> _submitUpdate() async {
    try {
      await ChallengeService().updateChallenge(
        token: widget.token,
        id: widget.challenge.id,
        title: titleController.text,
        description: descController.text,
        targetSteps: int.parse(stepsController.text),
        durationDays: int.parse(durationController.text),
      );
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Challenge berhasil diupdate')),
        );
        Navigator.pop(context, 'refresh');
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Gagal update challenge: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Edit Challenge')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            TextFormField(
              controller: titleController,
              decoration: const InputDecoration(labelText: 'Judul'),
              validator: (value) => value!.isEmpty ? 'Judul wajib diisi' : null,
            ),
            TextFormField(
              controller: descController,
              decoration: const InputDecoration(labelText: 'Deskripsi'),
              validator: (value) =>
                  value!.isEmpty ? 'Deskripsi wajib diisi' : null,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: stepsController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Target Langkah'),
              validator: (value) =>
                  value!.isEmpty ? 'Target langkah wajib diisi' : null,
            ),
            TextFormField(
              controller: durationController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Durasi (hari)'),
              validator: (value) =>
                  value!.isEmpty ? 'Durasi wajib diisi' : null,
            ),
            const SizedBox(height: 20),
            // TextFields same as AddChallengeScreen
            ElevatedButton(
              onPressed: _submitUpdate,
              child: const Text('Update'),
            ),
          ],
        ),
      ),
    );
  }
}
