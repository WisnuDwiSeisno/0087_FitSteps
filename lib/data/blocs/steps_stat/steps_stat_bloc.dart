import 'package:fitsteps_app/data/services/StepsStatService.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'steps_stat_event.dart';
import 'steps_stat_state.dart';

class StepsStatBloc extends Bloc<StepsStatEvent, StepsStatState> {
  final StepsStatService service;

  StepsStatBloc(this.service) : super(StepsStatInitial()) {
    on<LoadWeeklySteps>((event, emit) async {
      emit(StepsStatLoading());
      try {
        final stats = await service.getWeeklyStats(event.token);
        emit(StepsStatLoaded(stats));
      } catch (e) {
        emit(StepsStatError(e.toString()));
      }
    });
  }
}
