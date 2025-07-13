import 'package:fitsteps_app/data/screens/ChallengeScreen.dart';
import 'package:fitsteps_app/data/screens/TipsPage.dart';
import 'package:fitsteps_app/data/screens/home/pelari/AddStepsPage.dart';
import 'package:fitsteps_app/data/screens/home/pelari/challengehistoryscreen.dart';
import 'package:fitsteps_app/data/screens/home/pelari/steps_stat_page.dart';
import 'package:fitsteps_app/data/screens/profile_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../blocs/user/user_bloc.dart';
import '../../../blocs/user/user_state.dart';
import '../../../blocs/user/user_event.dart';

class HomePelariScreen extends StatelessWidget {
  final String token;
  const HomePelariScreen({super.key, required this.token});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => UserBloc()..add(LoadUserProfile(token)),
      child: Scaffold(
        appBar: AppBar(title: const Text('Dashboard Pelari')),
        body: BlocBuilder<UserBloc, UserState>(
          builder: (context, state) {
            if (state is UserLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is UserLoaded) {
              final name = state.user['name'] ?? 'Pelari';
              return Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Halo, $name!',
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    const Text('Yuk mulai tantangan hari ini!'),
                    const SizedBox(height: 20),
                    Expanded(
                      child: GridView.count(
                        crossAxisCount: 2,
                        crossAxisSpacing: 12,
                        mainAxisSpacing: 12,
                        children: [
                          _MenuCard(
                            title: 'Tantangan',
                            icon: Icons.directions_run,
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => ChallengeScreen(
                                    token: token,
                                    role: 'pelari',
                                  ),
                                ),
                              );
                            },
                          ),
                          _MenuCard(
                            title: 'Langkahku',
                            icon: Icons.directions_walk,
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => AddStepsPage(token: token),
                                ),
                              );
                            },
                          ),
                          _MenuCard(
                            title: 'Tips Latihan',
                            icon: Icons.lightbulb,
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => TipsPage(
                                    token: token, // ganti sesuai variabelmu
                                    role: 'pelari',
                                  ),
                                ),
                              );
                            },
                          ),
                          _MenuCard(
                            title: 'Profil Saya',
                            icon: Icons.person,
                            onTap: () {
                              final state = context.read<UserBloc>().state;
                              if (state is UserLoaded) {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => ProfilePage(token: token),
                                  ),
                                );
                              }
                            },
                          ),
                          _MenuCard(
                            title: 'Riwayat Tantangan',
                            icon: Icons.history,
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) =>
                                      ChallengeHistoryScreen(token: token),
                                ),
                              );
                            },
                          ),
                          _MenuCard(
                            title: 'Statistik Langkah',
                            icon: Icons.bar_chart,
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => StepsStatPage(token: token),
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            } else if (state is UserError) {
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

class _MenuCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final VoidCallback? onTap;

  const _MenuCard({required this.title, required this.icon, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: onTap,
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 40),
              const SizedBox(height: 10),
              Text(title, textAlign: TextAlign.center),
            ],
          ),
        ),
      ),
    );
  }
}
