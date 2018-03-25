import 'package:shared_preferences/shared_preferences.dart';

class LoginState {
  LoginState({SharedPreferences this.preferences});

  bool isLoggedIn() {
    try {
      getCookie();
      return true;
    } catch (e) {
      return false;
    }
  }

  String getCookie() {
    return preferences.getString(_COOKIE_PREFERENCE);
  }

  void setCookie(String cookie) {
    preferences.setString(_COOKIE_PREFERENCE, cookie);
    preferences.setInt(
        _LAST_LOGIN_PREFERENCE,
        new DateTime.now().millisecondsSinceEpoch);
  }

  void logOut() {
    preferences.remove(_COOKIE_PREFERENCE);
    preferences.remove(_LAST_LOGIN_PREFERENCE);
  }

  final String _COOKIE_PREFERENCE = "PREF_COOKIE";
  final String _LAST_LOGIN_PREFERENCE = "PREF_LAST_LOGIN";

  SharedPreferences preferences;
}