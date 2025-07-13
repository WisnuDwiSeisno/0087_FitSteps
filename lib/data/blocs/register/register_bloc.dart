import 'package:flutter_bloc/flutter_bloc.dart';
import 'register_event.dart';
import 'register_state.dart';
import '../../services/auth_service.dart';

class RegisterBloc extends Bloc<RegisterEvent, RegisterState> {
  final AuthService authService;

  RegisterBloc({required this.authService}) : super(RegisterInitial()) {
    on<SubmitRegister>(_onSubmit);
  }

  Future<void> _onSubmit(
    SubmitRegister event,
    Emitter<RegisterState> emit,
  ) async {
    emit(RegisterLoading());
    try {
      await authService.register(
        event.name,
        event.email,
        event.password,
        event.confirmPassword,
        event.role,
      );
      emit(RegisterSuccess());
    } catch (e) {
      emit(RegisterFailure(e.toString()));
    }
  }
}
