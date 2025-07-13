abstract class ChallengeEvent {}

class LoadChallenges extends ChallengeEvent {
  final String token;

  LoadChallenges(this.token);
}
