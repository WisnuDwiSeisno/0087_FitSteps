import 'package:fitsteps_app/data/models/challenge_model.dart';

abstract class MyChallengeState {}

class MyChallengeInitial extends MyChallengeState {}

class MyChallengeLoading extends MyChallengeState {}

class MyChallengeLoaded extends MyChallengeState {
  final List<Challenge> myChallenges;

  MyChallengeLoaded(this.myChallenges);
}

class MyChallengeError extends MyChallengeState {
  final String message;

  MyChallengeError(this.message);
}
