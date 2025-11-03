// lib/services.dart

import 'package:bloc_state_management/api/login_api.dart';
import 'package:bloc_state_management/repositories/login_repo.dart';
import 'package:bloc_state_management/services/local/local_service.dart';
import 'package:bloc_state_management/services/network/network_service.dart';

class Services {
  static const String baseUrl = 'http://159.203.35.6:5004/'; // TODO
  static final LocalStorageService storage = LocalStorageService();
  static final NetworkService network = NetworkService(baseUrl: baseUrl, storage: storage);
  static final LoginApi authApi = LoginApi(network);
  static final AuthRepository authRepo = AuthRepository(api: authApi, storage: storage);
}
