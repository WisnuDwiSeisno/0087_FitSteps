import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fitsteps_app/data/blocs/tracking/tracking_event.dart';
import 'package:fitsteps_app/data/blocs/tracking/tracking_state.dart';
import 'package:fitsteps_app/data/services/tracking_service.dart';

class TrackingBloc extends Bloc<TrackingEvent, TrackingState> {
  final TrackingService trackingService;

  TrackingBloc(this.trackingService) : super(TrackingInitial()) {
    on<StartTracking>((event, emit) {
      emit(TrackingInProgress(steps: 0, coordinates: []));
    });

    on<UpdateSteps>((event, emit) {
      if (state is TrackingInProgress) {
        final current = state as TrackingInProgress;
        emit(
          TrackingInProgress(
            steps: event.steps,
            coordinates: current.coordinates,
          ),
        );
      }
    });

    on<AddCoordinate>((event, emit) {
      if (state is TrackingInProgress) {
        final current = state as TrackingInProgress;
        final updatedCoords =
            List<Map<String, dynamic>>.from(current.coordinates)..add({
              'latitude': event.latitude,
              'longitude': event.longitude,
              'timestamp': DateTime.now().toIso8601String(),
            });

        emit(
          TrackingInProgress(steps: current.steps, coordinates: updatedCoords),
        );
      }
    });

    on<SaveTracking>((event, emit) async {
      if (state is TrackingInProgress) {
        final current = state as TrackingInProgress;
        try {
          emit(TrackingSaving());

          await trackingService.saveSteps(
            event.token,
            current.steps,
            event.date,
            event.distanceKm,
            event.durationMin,
          );

          await trackingService.saveRoute(
            event.token,
            current.coordinates,
            event.date,
            event.distanceKm ?? 0.0,
            event.durationMin,
          );


          emit(TrackingSaved());
        } catch (e) {
          emit(TrackingError(message: e.toString()));
        }
      }
    });
  }
}
