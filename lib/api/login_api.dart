import 'package:bloc_state_management/services/network/network_service.dart';


class LoginApi {
  final NetworkService _ns;
  LoginApi(this._ns);

  Future<dynamic> login({
    required String email,
    required String password,
  }) {
    return _ns.postRawJson<dynamic>(
      'api/user-login',
      {'identifier': email, 'password': password},
      // no parser → returns handled JSON body (envelope-safe)
    );
  }
}
