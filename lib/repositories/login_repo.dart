// lib/data/repositories/auth_repository.dart

import 'package:bloc_state_management/api/login_api.dart';
import 'package:bloc_state_management/model/user_model.dart';
import 'package:bloc_state_management/services/local/local_service.dart';

class AuthRepository {
  final LoginApi api;                 // or AuthApi
  final LocalStorageService storage;  // <-- required

  AuthRepository({required this.api, required this.storage});

  Future<UserModel> login(String email, String password) async {
    final json = await api.login(email: email, password: password) as Map<String, dynamic>;
    final user = UserModel.fromJson(json);
    await storage.saveUserModel(user); // persists token for headers
    return user;
  }
}
