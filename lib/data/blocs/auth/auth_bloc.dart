import 'package:bloc/bloc.dart';
import 'package:fitsteps_app/data/blocs/auth/auth_event.dart';
import 'package:fitsteps_app/data/blocs/auth/auth_state.dart';
import '../../services/auth_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthService authService;

  AuthBloc(this.authService) : super(AuthInitial()) {
    on<AuthLoginRequested>(_onLoginRequested);
    on<AuthLogoutRequested>(_onLogoutRequested);
  }

  Future<void> _onLoginRequested(
    AuthLoginRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    try {
      final token = await authService.login(event.email, event.password);
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('token', token);
      emit(AuthAuthenticated(token));
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  Future<void> _onLogoutRequested(
    AuthLogoutRequested event,
    Emitter<AuthState> emit,
  ) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
    emit(AuthInitial());
  }
}
