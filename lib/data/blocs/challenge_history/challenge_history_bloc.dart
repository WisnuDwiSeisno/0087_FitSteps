import 'package:flutter_bloc/flutter_bloc.dart';
import 'challenge_history_event.dart';
import 'challenge_history_state.dart';
import '../../services/challenge_service.dart';

class ChallengeHistoryBloc
    extends Bloc<ChallengeHistoryEvent, ChallengeHistoryState> {
  final ChallengeService service;

  ChallengeHistoryBloc(this.service) : super(ChallengeHistoryInitial()) {
    on<LoadChallengeHistory>((event, emit) async {
      emit(ChallengeHistoryLoading());
      try {
        final data = await service.getHistory(event.token);
        emit(ChallengeHistoryLoaded(data));
      } catch (e) {
        emit(ChallengeHistoryError(e.toString()));
      }
    });
  }
}
