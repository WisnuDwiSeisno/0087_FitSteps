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
        backgroundColor: Colors.grey[50],
        appBar: AppBar(
          title: Text(
            widget.role == 'mentor' ? 'Kelola Challenge' : 'Tantangan Tersedia',
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
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
          actions: [
            if (widget.role == 'mentor')
              Container(
                margin: const EdgeInsets.only(right: 12),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: IconButton(
                  icon: const Icon(Icons.add, color: Colors.white),
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
              ),
            if (widget.role == 'pelari')
              Container(
                margin: const EdgeInsets.only(right: 12),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: IconButton(
                  icon: const Icon(Icons.list_alt, color: Colors.white),
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
              ),
          ],
        ),
        body: BlocBuilder<ChallengeBloc, ChallengeState>(
          builder: (context, state) {
            if (state is ChallengeLoading) {
              return const Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF667eea)),
                ),
              );
            } else if (state is ChallengeLoaded) {
              final challenges = state.challenges;

              if (challenges.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(32),
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(50),
                        ),
                        child: Icon(
                          Icons.track_changes,
                          size: 64,
                          color: Colors.grey[400],
                        ),
                      ),
                      const SizedBox(height: 24),
                      Text(
                        'Tidak ada challenge tersedia',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                          color: Colors.grey[600],
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        widget.role == 'mentor'
                            ? 'Buat challenge pertama untuk peserta'
                            : 'Belum ada challenge yang dibuat mentor',
                        style: TextStyle(fontSize: 14, color: Colors.grey[500]),
                      ),
                    ],
                  ),
                );
              }

              return RefreshIndicator(
                onRefresh: () async {
                  context.read<ChallengeBloc>().add(
                    LoadChallenges(widget.token),
                  );
                },
                child: ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: challenges.length,
                  itemBuilder: (context, index) {
                    final c = challenges[index];

                    return Container(
                      margin: const EdgeInsets.only(bottom: 16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.08),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: InkWell(
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
                        borderRadius: BorderRadius.circular(16),
                        child: Padding(
                          padding: const EdgeInsets.all(20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(12),
                                    decoration: BoxDecoration(
                                      gradient: const LinearGradient(
                                        colors: [
                                          Color(0xFF667eea),
                                          Color(0xFF764ba2),
                                        ],
                                      ),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: const Icon(
                                      Icons.emoji_events,
                                      color: Colors.white,
                                      size: 20,
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          c.title,
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 18,
                                            color: Color(0xFF2d3436),
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          c.description,
                                          style: TextStyle(
                                            fontSize: 14,
                                            color: Colors.grey[600],
                                          ),
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),

                              const SizedBox(height: 16),

                              // Challenge Info Cards
                              Row(
                                children: [
                                  Expanded(
                                    child: Container(
                                      padding: const EdgeInsets.all(12),
                                      decoration: BoxDecoration(
                                        color: const Color(
                                          0xFF00b894,
                                        ).withOpacity(0.1),
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: Column(
                                        children: [
                                          Icon(
                                            Icons.directions_walk,
                                            color: const Color(0xFF00b894),
                                            size: 20,
                                          ),
                                          const SizedBox(height: 4),
                                          Text(
                                            '${c.targetSteps}',
                                            style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16,
                                              color: Color(0xFF00b894),
                                            ),
                                          ),
                                          const Text(
                                            'Target Steps',
                                            style: TextStyle(
                                              fontSize: 12,
                                              color: Color(0xFF00b894),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Container(
                                      padding: const EdgeInsets.all(12),
                                      decoration: BoxDecoration(
                                        color: const Color(
                                          0xFF6c5ce7,
                                        ).withOpacity(0.1),
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: Column(
                                        children: [
                                          Icon(
                                            Icons.schedule,
                                            color: const Color(0xFF6c5ce7),
                                            size: 20,
                                          ),
                                          const SizedBox(height: 4),
                                          Text(
                                            '${c.durationDays}',
                                            style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16,
                                              color: Color(0xFF6c5ce7),
                                            ),
                                          ),
                                          const Text(
                                            'Hari',
                                            style: TextStyle(
                                              fontSize: 12,
                                              color: Color(0xFF6c5ce7),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),

                              const SizedBox(height: 16),

                              // Action Buttons
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  if (widget.role == 'mentor')
                                    Row(
                                      children: [
                                        Container(
                                          decoration: BoxDecoration(
                                            color: Colors.blue[50],
                                            borderRadius: BorderRadius.circular(
                                              10,
                                            ),
                                          ),
                                          child: IconButton(
                                            icon: Icon(
                                              Icons.edit,
                                              color: Colors.blue[600],
                                              size: 20,
                                            ),
                                            onPressed: () async {
                                              final result =
                                                  await Navigator.push(
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
                                                context
                                                    .read<ChallengeBloc>()
                                                    .add(
                                                      LoadChallenges(
                                                        widget.token,
                                                      ),
                                                    );
                                              }
                                            },
                                          ),
                                        ),
                                        const SizedBox(width: 8),
                                        Container(
                                          decoration: BoxDecoration(
                                            color: Colors.red[50],
                                            borderRadius: BorderRadius.circular(
                                              10,
                                            ),
                                          ),
                                          child: IconButton(
                                            icon: Icon(
                                              Icons.delete,
                                              color: Colors.red[600],
                                              size: 20,
                                            ),
                                            onPressed: () async {
                                              final confirm = await showDialog<bool>(
                                                context: context,
                                                builder: (_) => AlertDialog(
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                          16,
                                                        ),
                                                  ),
                                                  title: const Text(
                                                    'Konfirmasi Hapus',
                                                    style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                  content: const Text(
                                                    'Yakin ingin menghapus challenge ini? Tindakan ini tidak dapat dibatalkan.',
                                                  ),
                                                  actions: [
                                                    TextButton(
                                                      onPressed: () =>
                                                          Navigator.pop(
                                                            context,
                                                            false,
                                                          ),
                                                      child: const Text(
                                                        'Batal',
                                                      ),
                                                    ),
                                                    ElevatedButton(
                                                      onPressed: () =>
                                                          Navigator.pop(
                                                            context,
                                                            true,
                                                          ),
                                                      style: ElevatedButton.styleFrom(
                                                        backgroundColor:
                                                            Colors.red,
                                                        foregroundColor:
                                                            Colors.white,
                                                        shape: RoundedRectangleBorder(
                                                          borderRadius:
                                                              BorderRadius.circular(
                                                                8,
                                                              ),
                                                        ),
                                                      ),
                                                      child: const Text(
                                                        'Hapus',
                                                      ),
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
                                                  context
                                                      .read<ChallengeBloc>()
                                                      .add(
                                                        LoadChallenges(
                                                          widget.token,
                                                        ),
                                                      );
                                                  ScaffoldMessenger.of(
                                                    context,
                                                  ).showSnackBar(
                                                    SnackBar(
                                                      content: const Row(
                                                        children: [
                                                          Icon(
                                                            Icons.check_circle,
                                                            color: Colors.white,
                                                          ),
                                                          SizedBox(width: 8),
                                                          Text(
                                                            'Challenge berhasil dihapus',
                                                          ),
                                                        ],
                                                      ),
                                                      backgroundColor:
                                                          Colors.green,
                                                      behavior: SnackBarBehavior
                                                          .floating,
                                                      shape: RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius.circular(
                                                              10,
                                                            ),
                                                      ),
                                                    ),
                                                  );
                                                } catch (e) {
                                                  ScaffoldMessenger.of(
                                                    context,
                                                  ).showSnackBar(
                                                    SnackBar(
                                                      content: Row(
                                                        children: [
                                                          const Icon(
                                                            Icons.error,
                                                            color: Colors.white,
                                                          ),
                                                          const SizedBox(
                                                            width: 8,
                                                          ),
                                                          Expanded(
                                                            child: Text(
                                                              'Gagal hapus: $e',
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                      backgroundColor:
                                                          Colors.red,
                                                      behavior: SnackBarBehavior
                                                          .floating,
                                                      shape: RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius.circular(
                                                              10,
                                                            ),
                                                      ),
                                                    ),
                                                  );
                                                }
                                              }
                                            },
                                          ),
                                        ),
                                      ],
                                    ),
                                  if (widget.role == 'pelari') const Spacer(),
                                  if (widget.role == 'pelari')
                                    ElevatedButton(
                                      onPressed: () async {
                                        try {
                                          await ChallengeService()
                                              .joinChallenge(
                                                token: widget.token,
                                                challengeId: c.id,
                                              );
                                          ScaffoldMessenger.of(
                                            context,
                                          ).showSnackBar(
                                            SnackBar(
                                              content: const Row(
                                                children: [
                                                  Icon(
                                                    Icons.check_circle,
                                                    color: Colors.white,
                                                  ),
                                                  SizedBox(width: 8),
                                                  Text(
                                                    'Berhasil mengikuti challenge',
                                                  ),
                                                ],
                                              ),
                                              backgroundColor: Colors.green,
                                              behavior:
                                                  SnackBarBehavior.floating,
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                              ),
                                            ),
                                          );
                                        } catch (e) {
                                          ScaffoldMessenger.of(
                                            context,
                                          ).showSnackBar(
                                            SnackBar(
                                              content: Row(
                                                children: [
                                                  const Icon(
                                                    Icons.error,
                                                    color: Colors.white,
                                                  ),
                                                  const SizedBox(width: 8),
                                                  Expanded(
                                                    child: Text(
                                                      'Gagal mengikuti challenge: $e',
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              backgroundColor: Colors.red,
                                              behavior:
                                                  SnackBarBehavior.floating,
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                              ),
                                            ),
                                          );
                                        }
                                      },
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.transparent,
                                        shadowColor: Colors.transparent,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                            12,
                                          ),
                                        ),
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 24,
                                          vertical: 12,
                                        ),
                                      ),
                                      child: Ink(
                                        decoration: BoxDecoration(
                                          gradient: const LinearGradient(
                                            colors: [
                                              Color(0xFF667eea),
                                              Color(0xFF764ba2),
                                            ],
                                          ),
                                          borderRadius: BorderRadius.circular(
                                            12,
                                          ),
                                        ),
                                        child: Container(
                                          alignment: Alignment.center,
                                          child: const Text(
                                            'Ikuti Challenge',
                                            style: TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              );
            } else if (state is ChallengeError) {
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
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () {
                        context.read<ChallengeBloc>().add(
                          LoadChallenges(widget.token),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF667eea),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text('Coba Lagi'),
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
