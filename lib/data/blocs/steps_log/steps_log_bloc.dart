import 'package:fitsteps_app/data/services/steps_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'steps_log_event.dart';
import 'steps_log_state.dart';

class StepsLogBloc extends Bloc<StepsLogEvent, StepsLogState> {
  final StepsService service;

  StepsLogBloc({required this.service}) : super(StepsInitial()) {
    on<SubmitSteps>((event, emit) async {
      emit(StepsSubmitting());
      try {
        await service.submitSteps(event.token, event.steps, event.date);
        emit(StepsSuccess());
      } catch (e) {
        emit(StepsFailure(e.toString()));
      }
    });
  }
}
