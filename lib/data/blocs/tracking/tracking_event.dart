import 'package:equatable/equatable.dart';

abstract class TrackingEvent extends Equatable {
  const TrackingEvent();

  @override
  List<Object?> get props => [];
}

class StartTracking extends TrackingEvent {}

class UpdateSteps extends TrackingEvent {
  final int steps;

  const UpdateSteps(this.steps);

  @override
  List<Object?> get props => [steps];
}

class AddCoordinate extends TrackingEvent {
  final double latitude;
  final double longitude;

  const AddCoordinate(this.latitude, this.longitude);

  @override
  List<Object?> get props => [latitude, longitude];
}

class SaveTracking extends TrackingEvent {
  final String token;
  final String date;
  final double? distanceKm;
  final int durationMin;

  const SaveTracking({
    required this.token,
    required this.date,
    this.distanceKm,
    required this.durationMin,
  });

  @override
  List<Object?> get props => [token, date, distanceKm, durationMin];
}
