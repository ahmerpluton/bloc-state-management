import 'package:bloc_state_management/services/local/local_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'splash_event.dart';
import 'splash_state.dart';

class SplashBloc extends Bloc<SplashEvent, SplashState> {
  final LocalStorageService storage;

  SplashBloc(this.storage) : super(const SplashState()) {
    on<SplashCheckRequested>(_onCheck);
  }

  Future<void> _onCheck(
    SplashCheckRequested event,
    Emitter<SplashState> emit,
  ) async {
    emit(state.copyWith(status: SplashStatus.checking, error: null));
    try {
      final user = await storage.getUserModel();
      if (user != null && (user.accessToken ?? '').isNotEmpty) {
        emit(state.copyWith(status: SplashStatus.authenticated));
      } else {
        emit(state.copyWith(status: SplashStatus.unauthenticated));
      }
    } catch (e) {
      emit(state.copyWith(status: SplashStatus.failure, error: e.toString()));
    }
  }
}
