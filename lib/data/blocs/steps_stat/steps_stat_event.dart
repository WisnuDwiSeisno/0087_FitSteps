abstract class StepsStatEvent {}

class LoadWeeklySteps extends StepsStatEvent {
  final String token;
  LoadWeeklySteps(this.token);
}
