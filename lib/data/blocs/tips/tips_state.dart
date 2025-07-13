import '../../models/tip_model.dart';

abstract class TipsState {}

class TipsInitial extends TipsState {}

class TipsLoading extends TipsState {}

class TipsLoaded extends TipsState {
  final List<TipModel> tips;
  TipsLoaded(this.tips);
}

class TipsError extends TipsState {
  final String message;
  TipsError(this.message);
}

class TipAdding extends TipsState {}

class TipAdded extends TipsState {}

class TipAddError extends TipsState {
  final String message;
  TipAddError(this.message);
}

class TipUpdating extends TipsState {}

class TipUpdated extends TipsState {}

class TipUpdateError extends TipsState {
  final String message;
  TipUpdateError(this.message);
}

class TipDeleting extends TipsState {}

class TipDeleted extends TipsState {}

class TipDeleteError extends TipsState {
  final String message;
  TipDeleteError(this.message);
}
