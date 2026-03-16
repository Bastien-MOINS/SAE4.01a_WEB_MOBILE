import 'package:shared_preferences/shared_preferences.dart';

class SettingRepository {
  static const NAME_KEY = "user_name";

  registerName(String name) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setString(NAME_KEY, name);
  }

  Future<String> getName() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return sharedPreferences.getString(NAME_KEY) ?? "user_name";
  }
}