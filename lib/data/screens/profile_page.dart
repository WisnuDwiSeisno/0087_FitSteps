import 'package:fitsteps_app/data/blocs/profile/profile_bloc.dart';
import 'package:fitsteps_app/data/blocs/profile/profile_event.dart';
import 'package:fitsteps_app/data/blocs/profile/profile_state.dart';
import 'package:fitsteps_app/data/screens/EditProfilePage.dart';
import 'package:fitsteps_app/data/screens/auth/login_screen.dart';
import 'package:fitsteps_app/data/services/auth_service.dart';
import 'package:fitsteps_app/data/services/profile_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfilePage extends StatelessWidget {
  final String token;

  const ProfilePage({super.key, required this.token});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
          ProfileBloc(profileService: ProfileService())
            ..add(LoadProfile(token)),
      child: Scaffold(
        appBar: AppBar(title: const Text('Profil Saya'), centerTitle: true),
        body: BlocBuilder<ProfileBloc, ProfileState>(
          builder: (context, state) {
            if (state is ProfileLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is ProfileLoaded) {
              final user = state.user;
              return Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(
                      Icons.account_circle,
                      size: 100,
                      color: Colors.grey,
                    ),
                    const SizedBox(height: 20),
                    Text('Nama:', style: _labelStyle),
                    Text(user.name, style: _valueStyle),
                    const SizedBox(height: 10),
                    Text('Email:', style: _labelStyle),
                    Text(user.email, style: _valueStyle),
                    const SizedBox(height: 10),
                    Text('Peran:', style: _labelStyle),
                    Text(
                      user.role == 'mentor' ? 'Mentor' : 'Pelari',
                      style: _valueStyle,
                    ),
                    Center(
                      child: ElevatedButton.icon(
                        onPressed: () async {
                          final newName = await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => EditProfilePage(
                                token: token,
                                currentName: user.name,
                              ),
                            ),
                          );
                          // Kalau berhasil diubah, reload profil
                          if (newName != null && context.mounted) {
                            context.read<ProfileBloc>().add(LoadProfile(token));
                          }
                        },
                        icon: const Icon(Icons.edit),
                        label: const Text('Edit Profil'),
                      ),
                    ),
                    const SizedBox(height: 10),

                    Center(
                      child: ElevatedButton.icon(
                        onPressed: () async {
                          final prefs = await SharedPreferences.getInstance();
                          final token = prefs.getString('token');

                          if (token != null) {
                            try {
                              await AuthService().logout(
                                token,
                              ); // Panggil API logout
                            } catch (e) {
                              // Log error kalau mau
                            }
                          }

                          // Hapus token lokal dan redirect ke login
                          await prefs.remove('token');

                          if (context.mounted) {
                            Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const LoginScreen(),
                              ),
                              (route) => false,
                            );
                          }
                        },
                        icon: const Icon(Icons.logout),
                        label: const Text('Logout'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                          foregroundColor: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            } else if (state is ProfileError) {
              return Center(
                child: Text(state.message, style: TextStyle(color: Colors.red)),
              );
            }
            return const SizedBox();
          },
        ),
      ),
    );
  }

  TextStyle get _labelStyle => const TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.bold,
    color: Colors.grey,
  );

  TextStyle get _valueStyle =>
      const TextStyle(fontSize: 18, fontWeight: FontWeight.w600);
}
