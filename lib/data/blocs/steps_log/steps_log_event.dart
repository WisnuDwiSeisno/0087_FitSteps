abstract class StepsLogEvent {}

class SubmitSteps extends StepsLogEvent {
  final String token;
  final int steps;
  final String date;

  SubmitSteps({required this.token, required this.steps, required this.date});
}
