import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fitsteps_app/data/services/profile_service.dart';
import 'profile_event.dart';
import 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final ProfileService profileService;

  ProfileBloc({required this.profileService}) : super(ProfileInitial()) {
    on<LoadProfile>(_onLoadProfile);
  }

  Future<void> _onLoadProfile(
    LoadProfile event,
    Emitter<ProfileState> emit,
  ) async {
    emit(ProfileLoading());
    try {
      final user = await profileService.getProfile(event.token);
      emit(ProfileLoaded(user));
    } catch (e) {
      emit(ProfileError('Gagal memuat profil: $e'));
    }
  }
}

