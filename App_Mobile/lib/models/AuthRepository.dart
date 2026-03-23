import 'package:shared_preferences/shared_preferences.dart';

class AuthRepository {
  static const PSEUDO_KEY = "user_pseudo";
  static const PASSWORD_KEY = "user_password";
  static const IS_CONNECTED_KEY = "is_connected";

  Future<void> register(String pseudo, String password) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    await sharedPreferences.setString(PSEUDO_KEY, pseudo);
    await sharedPreferences.setString(PASSWORD_KEY, password);
  }

  Future<bool> login(String pseudo, String password) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String? realPseudo = sharedPreferences.getString(PSEUDO_KEY);
    String? realPassword = sharedPreferences.getString(PASSWORD_KEY);

    if (pseudo == realPseudo && password == realPassword) {
      await sharedPreferences.setBool(IS_CONNECTED_KEY, true);
      return true;
    }
    return false;
  }

  Future<List<String>> getUser() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String pseudo = sharedPreferences.getString(PSEUDO_KEY) ?? "";
    String password = sharedPreferences.getString(PASSWORD_KEY) ?? "";
    return [pseudo, password];
  }

  Future<bool> isConnected() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return sharedPreferences.getBool(IS_CONNECTED_KEY) ?? false;
  }

  Future<void> disconnection() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    await sharedPreferences.setBool(IS_CONNECTED_KEY, false);
  }
}