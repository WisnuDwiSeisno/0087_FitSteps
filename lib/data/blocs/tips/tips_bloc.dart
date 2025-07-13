import 'package:flutter_bloc/flutter_bloc.dart';
import '../../services/tip_service.dart';
import 'tips_event.dart';
import 'tips_state.dart';

class TipsBloc extends Bloc<TipsEvent, TipsState> {
  final TipService service;

  TipsBloc(this.service) : super(TipsInitial()) {
    on<LoadTips>((event, emit) async {
      emit(TipsLoading());
      try {
        final tips = await service.getTips(event.token);
        emit(TipsLoaded(tips));
      } catch (e) {
        emit(TipsError(e.toString()));
      }
    });

    on<AddTip>((event, emit) async {
      emit(TipAdding());
      try {
        await service.addTip(event.token, event.title, event.content);
        emit(TipAdded());
      } catch (e) {
        emit(TipAddError(e.toString()));
      }
    });
    on<UpdateTip>((event, emit) async {
      emit(TipUpdating());
      try {
        await service.updateTip(
          event.token,
          event.id,
          event.title,
          event.content,
        );
        emit(TipUpdated());
        // Optional: Reload list after update
        final tips = await service.getTips(event.token);
        emit(TipsLoaded(tips));
      } catch (e) {
        emit(TipUpdateError(e.toString()));
      }
    });

    on<DeleteTip>((event, emit) async {
      emit(TipDeleting());
      try {
        await service.deleteTip(event.token, event.id);
        emit(TipDeleted());
        // Optional: Reload list after delete
        final tips = await service.getTips(event.token);
        emit(TipsLoaded(tips));
      } catch (e) {
        emit(TipDeleteError(e.toString()));
      }
    });

  }
}
