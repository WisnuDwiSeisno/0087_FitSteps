import 'package:fitsteps_app/data/blocs/mychallenge/mychallenge_event.dart';
import 'package:fitsteps_app/data/blocs/mychallenge/mychallenge_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fitsteps_app/data/services/challenge_service.dart';

class MyChallengeBloc extends Bloc<MyChallengeEvent, MyChallengeState> {
  final ChallengeService challengeService;

  MyChallengeBloc(this.challengeService) : super(MyChallengeInitial()) {
    on<LoadMyChallenges>((event, emit) async {
      emit(MyChallengeLoading());
      try {
        final challenges = await challengeService.fetchMyChallenges(
          event.token,
        );
        emit(MyChallengeLoaded(challenges));
      } catch (e) {
        emit(MyChallengeError(e.toString()));
      }
    });
  }
}
