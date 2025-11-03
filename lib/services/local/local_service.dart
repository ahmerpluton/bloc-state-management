import 'dart:convert';
import 'package:bloc_state_management/model/user_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocalStorageService {
  static const _kUserModel = 'user_model_json';

  Future<void> saveUserModel(UserModel model) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_kUserModel, jsonEncode(model.toJson()));
  }

  Future<UserModel?> getUserModel() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_kUserModel);
    if (raw == null || raw.isEmpty) return null;
    return UserModel.fromJson(json.decode(raw));
  }

  Future<void> clearUser() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_kUserModel);
  }
}
