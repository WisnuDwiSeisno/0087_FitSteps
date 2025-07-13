abstract class StepsStatState {}

class StepsStatInitial extends StepsStatState {}

class StepsStatLoading extends StepsStatState {}

class StepsStatLoaded extends StepsStatState {
  final Map<String, int> stats;
  StepsStatLoaded(this.stats);
}

class StepsStatError extends StepsStatState {
  final String message;
  StepsStatError(this.message);
}
