import 'package:credentials_manager/credentials_manager.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:get/get.dart';

class StorageService extends GetxService {
  late SharedPreferences _prefs;
  late CredentialsManager _credentialsManager;

  Future<StorageService> init() async {
    _prefs = await SharedPreferences.getInstance();

    _credentialsManager = CredentialsManager(
      storageKey: 'user_login',
      useAndroidEncryptedSharedPreferences: true,
    );
    return this;
  }

  Future<void> saveToken(String token) async {
    await _prefs.setString('token', token);
  }

  String? getToken() {
    return _prefs.getString('token');
  }

  Future<void> saveRefreshToken(String token) async {
    await _prefs.setString('refreshToken', token);
  }

  String? getRefreshToken() {
    return _prefs.getString('refreshToken');
  }

  Future<void> saveUsername(String username) async {
    await _prefs.setString('username', username);
  }

  String? getUsername() {
    return _prefs.getString('username');
  }

  Future<void> clearData() async {
    await _prefs.clear();
  }

  Future<CredentialModel?> getLoginData() async {
    if (_credentialsManager.isBlank == true) return null;
    var d = await _credentialsManager.getSavedCredentials();

    return d.first;
  }

  Future<void> saveLoginData(CredentialModel data) async {
    await _credentialsManager.saveCredential(data);
  }
}