abstract class StepsLogState {}

class StepsInitial extends StepsLogState {}

class StepsSubmitting extends StepsLogState {}

class StepsSuccess extends StepsLogState {}

class StepsFailure extends StepsLogState {
  final String message;
  StepsFailure(this.message);
}
