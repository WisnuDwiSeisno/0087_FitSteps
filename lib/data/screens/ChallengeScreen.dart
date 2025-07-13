import 'package:fitsteps_app/data/screens/home/mentor/EditChallengeScreen.dart';
import 'package:fitsteps_app/data/screens/home/mentor/add_challenge_screen.dart';
import 'package:fitsteps_app/data/screens/home/mentor/detail_challenge_screen.dart';
import 'package:fitsteps_app/data/screens/home/pelari/my_challenge_screen.dart';
import 'package:fitsteps_app/data/services/challenge_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fitsteps_app/data/blocs/challenge/challenge_bloc.dart';
import 'package:fitsteps_app/data/blocs/challenge/challenge_event.dart';
import 'package:fitsteps_app/data/blocs/challenge/challenge_state.dart';

class ChallengeScreen extends StatefulWidget {
  final String token;
  final String role;

  const ChallengeScreen({super.key, required this.token, required this.role});

  @override
  State<ChallengeScreen> createState() => _ChallengeScreenState();
}

class _ChallengeScreenState extends State<ChallengeScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
          ChallengeBloc(ChallengeService())..add(LoadChallenges(widget.token)),
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            widget.role == 'mentor' ? 'Kelola Challenge' : 'Tantangan Tersedia',
          ),
          actions: [
            if (widget.role == 'mentor')
              IconButton(
                icon: const Icon(Icons.add),
                onPressed: () async {
                  final result = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => AddChallengeScreen(token: widget.token),
                    ),
                  );
                  if (result == 'refresh') {
                    context.read<ChallengeBloc>().add(
                      LoadChallenges(widget.token),
                    );
                  }
                },
              ),
            if (widget.role == 'pelari')
              IconButton(
                icon: const Icon(Icons.list_alt),
                tooltip: 'My Challenge',
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => MyChallengeScreen(token: widget.token),
                    ),
                  );
                },
              ),
          ],
        ),
        body: BlocBuilder<ChallengeBloc, ChallengeState>(
          builder: (context, state) {
            if (state is ChallengeLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is ChallengeLoaded) {
              final challenges = state.challenges;

              if (challenges.isEmpty) {
                return const Center(
                  child: Text('Tidak ada challenge tersedia'),
                );
              }

              return ListView.builder(
                itemCount: challenges.length,
                itemBuilder: (context, index) {
                  final c = challenges[index];

                  return InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => DetailChallengeScreen(
                            challenge: c,
                            token: widget.token,
                            role: widget.role,
                          ),
                        ),
                      );
                    },
                    child: Card(
                      margin: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              c.title,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(c.description),
                            const SizedBox(height: 8),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('Target Langkah: ${c.targetSteps}'),
                                    Text('Durasi Hari: ${c.durationDays}'),
                                  ],
                                ),
                                if (widget.role == 'mentor')
                                  Row(
                                    children: [
                                      IconButton(
                                        icon: const Icon(Icons.edit),
                                        onPressed: () async {
                                          final result = await Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (_) =>
                                                  EditChallengeScreen(
                                                    token: widget.token,
                                                    challenge: c,
                                                  ),
                                            ),
                                          );
                                          if (result == 'refresh') {
                                            context.read<ChallengeBloc>().add(
                                              LoadChallenges(widget.token),
                                            );
                                          }
                                        },
                                      ),
                                      IconButton(
                                        icon: const Icon(
                                          Icons.delete,
                                          color: Colors.red,
                                        ),
                                        onPressed: () async {
                                          final confirm = await showDialog<bool>(
                                            context: context,
                                            builder: (_) => AlertDialog(
                                              title: const Text('Konfirmasi'),
                                              content: const Text(
                                                'Yakin ingin menghapus challenge ini?',
                                              ),
                                              actions: [
                                                TextButton(
                                                  onPressed: () =>
                                                      Navigator.pop(
                                                        context,
                                                        false,
                                                      ),
                                                  child: const Text('Batal'),
                                                ),
                                                TextButton(
                                                  onPressed: () =>
                                                      Navigator.pop(
                                                        context,
                                                        true,
                                                      ),
                                                  child: const Text('Hapus'),
                                                ),
                                              ],
                                            ),
                                          );
                                          if (confirm == true &&
                                              context.mounted) {
                                            try {
                                              await ChallengeService()
                                                  .deleteChallenge(
                                                    token: widget.token,
                                                    id: c.id,
                                                  );
                                              context.read<ChallengeBloc>().add(
                                                LoadChallenges(widget.token),
                                              );
                                            } catch (e) {
                                              ScaffoldMessenger.of(
                                                context,
                                              ).showSnackBar(
                                                SnackBar(
                                                  content: Text(
                                                    'Gagal hapus: $e',
                                                  ),
                                                ),
                                              );
                                            }
                                          }
                                        },
                                      ),
                                    ],
                                  ),
                                if (widget.role == 'pelari')
                                  ElevatedButton(
                                    onPressed: () async {
                                      try {
                                        await ChallengeService().joinChallenge(
                                          token: widget.token,
                                          challengeId: c.id,
                                        );
                                        ScaffoldMessenger.of(
                                          context,
                                        ).showSnackBar(
                                          const SnackBar(
                                            content: Text(
                                              'Berhasil mengikuti challenge',
                                            ),
                                          ),
                                        );
                                      } catch (e) {
                                        ScaffoldMessenger.of(
                                          context,
                                        ).showSnackBar(
                                          SnackBar(
                                            content: Text(
                                              'Gagal mengikuti challenge: $e',
                                            ),
                                          ),
                                        );
                                      }
                                    },
                                    child: const Text('Ikuti'),
                                  ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              );
            } else if (state is ChallengeError) {
              return Center(child: Text(state.message));
            } else {
              return const SizedBox.shrink();
            }
          },
        ),
      ),
    );
  }
}
