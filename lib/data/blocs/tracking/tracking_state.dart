import 'package:equatable/equatable.dart';

abstract class TrackingState extends Equatable {
  const TrackingState();

  @override
  List<Object?> get props => [];
}

class TrackingInitial extends TrackingState {}

class TrackingInProgress extends TrackingState {
  final int steps;
  final List<Map<String, dynamic>> coordinates;

  const TrackingInProgress({required this.steps, required this.coordinates});

  @override
  List<Object?> get props => [steps, coordinates];
}

class TrackingSaving extends TrackingState {}

class TrackingSaved extends TrackingState {}

class TrackingError extends TrackingState {
  final String message;

  const TrackingError({required this.message});

  @override
  List<Object?> get props => [message];
}
