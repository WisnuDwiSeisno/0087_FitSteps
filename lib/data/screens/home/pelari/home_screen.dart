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
        backgroundColor: Colors.grey[50],
        appBar: AppBar(
          title: const Text(
            'Dashboard Pelari',
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
          ),
          backgroundColor: Colors.transparent,
          elevation: 0,
          flexibleSpace: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0xFF667eea), Color(0xFF764ba2)],
              ),
            ),
          ),
        ),
        body: BlocBuilder<UserBloc, UserState>(
          builder: (context, state) {
            if (state is UserLoading) {
              return const Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF667eea)),
                ),
              );
            } else if (state is UserLoaded) {
              final name = state.user['name'] ?? 'Pelari';
              return SingleChildScrollView(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Welcome Section
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(24.0),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [Color(0xFF667eea), Color(0xFF764ba2)],
                        ),
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 15,
                            offset: const Offset(0, 8),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Halo, $name! 👋',
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            'Yuk mulai tantangan hari ini!',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.white70,
                            ),
                          ),
                          const SizedBox(height: 16),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 8,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: const Text(
                              '🏃 Tetap semangat bergerak!',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 30),

                    // Menu Section
                    const Text(
                      'Menu Utama',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF2d3436),
                      ),
                    ),
                    const SizedBox(height: 16),

                    GridView.count(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      crossAxisCount: 2,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                      childAspectRatio: 1.1,
                      children: [
                        _MenuCard(
                          title: 'Tantangan',
                          icon: Icons.directions_run,
                          gradient: const LinearGradient(
                            colors: [Color(0xFF667eea), Color(0xFF764ba2)],
                          ),
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
                          gradient: const LinearGradient(
                            colors: [Color(0xFF00b894), Color(0xFF00cec9)],
                          ),
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
                          gradient: const LinearGradient(
                            colors: [Color(0xFFfdcb6e), Color(0xFFe17055)],
                          ),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) =>
                                    TipsPage(token: token, role: 'pelari'),
                              ),
                            );
                          },
                        ),
                        _MenuCard(
                          title: 'Profil Saya',
                          icon: Icons.person,
                          gradient: const LinearGradient(
                            colors: [Color(0xFF6c5ce7), Color(0xFFa29bfe)],
                          ),
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
                          gradient: const LinearGradient(
                            colors: [Color(0xFF81ecec), Color(0xFF74b9ff)],
                          ),
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
                          gradient: const LinearGradient(
                            colors: [Color(0xFFff7675), Color(0xFFfd79a8)],
                          ),
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

                    const SizedBox(height: 20),
                  ],
                ),
              );
            } else if (state is UserError) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.error_outline, size: 64, color: Colors.red[400]),
                    const SizedBox(height: 16),
                    Text(
                      state.message,
                      style: TextStyle(fontSize: 16, color: Colors.red[600]),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              );
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
  final Gradient gradient;

  const _MenuCard({
    required this.title,
    required this.icon,
    required this.gradient,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: gradient,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(20),
          child: Container(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Icon(icon, size: 32, color: Colors.white),
                ),
                const SizedBox(height: 12),
                Text(
                  title,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
