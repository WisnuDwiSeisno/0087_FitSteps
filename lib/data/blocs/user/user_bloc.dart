import 'package:fitsteps_app/data/services/auth_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'user_event.dart';
import 'user_state.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  UserBloc() : super(UserInitial()) {
    on<LoadUserProfile>((event, emit) async {
      emit(UserLoading());
      try {
        final user = await AuthService().getProfile(event.token);
        emit(UserLoaded(user));
      } catch (e) {
        emit(UserError('Gagal memuat data user'));
      }
    });
  }
}
