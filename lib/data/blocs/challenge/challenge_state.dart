import '../../models/challenge_model.dart';

abstract class ChallengeState {}

class ChallengeInitial extends ChallengeState {}

class ChallengeLoading extends ChallengeState {}

class ChallengeLoaded extends ChallengeState {
  final List<Challenge> challenges;

  ChallengeLoaded(this.challenges);
}

class ChallengeError extends ChallengeState {
  final String message;

  ChallengeError(this.message);
}
