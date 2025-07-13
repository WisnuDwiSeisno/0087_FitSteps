import '../../models/challenge_history_model.dart';

abstract class ChallengeHistoryState {}

class ChallengeHistoryInitial extends ChallengeHistoryState {}

class ChallengeHistoryLoading extends ChallengeHistoryState {}

class ChallengeHistoryLoaded extends ChallengeHistoryState {
  final List<ChallengeHistoryModel> challenges;

  ChallengeHistoryLoaded(this.challenges);
}

class ChallengeHistoryError extends ChallengeHistoryState {
  final String message;

  ChallengeHistoryError(this.message);
}
