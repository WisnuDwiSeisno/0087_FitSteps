abstract class ChallengeHistoryEvent {}

class LoadChallengeHistory extends ChallengeHistoryEvent {
  final String token;

  LoadChallengeHistory(this.token);
}
