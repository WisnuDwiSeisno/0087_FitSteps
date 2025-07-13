import 'package:fitsteps_app/data/blocs/mychallenge/mychallenge_bloc.dart';
import 'package:fitsteps_app/data/blocs/mychallenge/mychallenge_event.dart';
import 'package:fitsteps_app/data/blocs/mychallenge/mychallenge_state.dart';
import 'package:fitsteps_app/data/blocs/tracking/tracking_bloc.dart';
import 'package:fitsteps_app/data/screens/home/pelari/trackingscreen.dart';
import 'package:fitsteps_app/data/services/tracking_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fitsteps_app/data/services/challenge_service.dart';

class MyChallengeScreen extends StatelessWidget {
  final String token;

  const MyChallengeScreen({super.key, required this.token});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
          MyChallengeBloc(ChallengeService())..add(LoadMyChallenges(token)),
      child: Scaffold(
        appBar: AppBar(title: const Text('My Challenges')),
        body: BlocBuilder<MyChallengeBloc, MyChallengeState>(
          builder: (context, state) {
            if (state is MyChallengeLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is MyChallengeLoaded) {
              final challenges = state.myChallenges;

              if (challenges.isEmpty) {
                return const Center(
                  child: Text('Belum ada challenge yang diikuti'),
                );
              }

              return ListView.builder(
                itemCount: challenges.length,
                itemBuilder: (context, index) {
                  final c = challenges[index];

                  return Card(
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
                              ElevatedButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => BlocProvider(
                                        create: (_) =>
                                            TrackingBloc(TrackingService()),
                                        child: TrackingScreen(),
                                      ),
                                    ),
                                  );
                                },
                                child: const Text('Mulai'),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            } else if (state is MyChallengeError) {
              return Center(child: Text('Error: ${state.message}'));
            } else {
              return const SizedBox.shrink();
            }
          },
        ),
      ),
    );
  }
}
