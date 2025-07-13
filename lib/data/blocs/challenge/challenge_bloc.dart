import 'package:fitsteps_app/data/services/challenge_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'challenge_event.dart';
import 'challenge_state.dart';

class ChallengeBloc extends Bloc<ChallengeEvent, ChallengeState> {
  final ChallengeService service;

  ChallengeBloc(this.service) : super(ChallengeInitial()) {
    on<LoadChallenges>((event, emit) async {
      emit(ChallengeLoading());
      try {
        final data = await service.fetchChallenges(event.token);
        emit(ChallengeLoaded(data));
      } catch (e) {
        print('❗ ChallengeBloc Error: $e'); // Ini log penting
        emit(ChallengeError('Gagal mengambil data challenge'));
      }
    });
  }
}
