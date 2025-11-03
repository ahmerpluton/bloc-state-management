import 'package:bloc_state_management/repositories/login_repo.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'login_event.dart';
import 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final AuthRepository repo;

  LoginBloc(this.repo) : super(const LoginState()) {
    on<LoginSubmitted>(_onLogin);
  }

  Future<void> _onLogin(LoginSubmitted e, Emitter<LoginState> emit) async {
    emit(state.copyWith(status: LoginStatus.loading, error: null));
    try {
      final user = await repo.login(e.email.trim(), e.password);
      emit(state.copyWith(status: LoginStatus.success, user: user));
    } catch (err) {
      emit(state.copyWith(status: LoginStatus.failure, error: err.toString()));
    }
  }
}
