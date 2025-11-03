enum SplashStatus { initial, checking, authenticated, unauthenticated, failure }

class SplashState {
  final SplashStatus status;
  final String? error;

  const SplashState({
    this.status = SplashStatus.initial,
    this.error,
  });

  SplashState copyWith({
    SplashStatus? status,
    String? error,
  }) {
    return SplashState(
      status: status ?? this.status,
      error: error,
    );
  }
}
