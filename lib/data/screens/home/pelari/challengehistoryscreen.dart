import 'package:fitsteps_app/data/blocs/challenge_history/challenge_history_bloc.dart';
import 'package:fitsteps_app/data/blocs/challenge_history/challenge_history_event.dart';
import 'package:fitsteps_app/data/blocs/challenge_history/challenge_history_state.dart';
import 'package:fitsteps_app/data/screens/home/pelari/UploadPhotoPage.dart';
import 'package:fitsteps_app/data/services/challenge_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ChallengeHistoryScreen extends StatelessWidget {
  final String token;

  const ChallengeHistoryScreen({super.key, required this.token});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
          ChallengeHistoryBloc(ChallengeService())
            ..add(LoadChallengeHistory(token)),
      child: Scaffold(
        appBar: AppBar(title: const Text('Riwayat Tantangan')),
        body: BlocBuilder<ChallengeHistoryBloc, ChallengeHistoryState>(
          builder: (context, state) {
            if (state is ChallengeHistoryLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is ChallengeHistoryLoaded) {
              if (state.challenges.isEmpty) {
                return const Center(child: Text('Belum ada riwayat.'));
              }
              return ListView.builder(
                itemCount: state.challenges.length,
                itemBuilder: (context, index) {
                  final challenge = state.challenges[index];
                  return ListTile(
                    title: Text(challenge.title),
                    subtitle: Text(challenge.description),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          challenge.createdAt.split('T').first,
                          style: const TextStyle(fontSize: 12),
                        ),
                        const SizedBox(width: 8),
                        IconButton(
                          icon: const Icon(Icons.upload_file),
                          tooltip: 'Upload Bukti',
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => UploadPhotoPage(token: token),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  );
                },
              );
            } else if (state is ChallengeHistoryError) {
              return Center(child: Text('Error: ${state.message}'));
            }
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }
}
