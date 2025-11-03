import 'package:bloc_state_management/model/user_model.dart';


enum LoginStatus { initial, loading, success, failure }

class LoginState {
  final LoginStatus status;
  final String? error;
  final UserModel? user;

  const LoginState({
    this.status = LoginStatus.initial,
    this.error,
    this.user,
  });

  LoginState copyWith({
    LoginStatus? status,
    String? error,
    UserModel? user,
  }) {
    return LoginState(
      status: status ?? this.status,
      error: error,
      user: user ?? this.user,
    );
  }
}
