abstract class MyChallengeEvent {}

class LoadMyChallenges extends MyChallengeEvent {
  final String token;

  LoadMyChallenges(this.token);
}
