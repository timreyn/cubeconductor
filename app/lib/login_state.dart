import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import 'models/user.dart';
import 'prefs.dart';

class LoginState {
  LoginState({this.sharedPreferences});

  bool isLoggedIn() {
    return getCookie() != null;
  }

  List<String> getCookie() {
    return getStringListPreference(sharedPreferences, Prefs.cookie);
  }

  void setCookie(List<String> cookie) {
    setStringListPreference(sharedPreferences, Prefs.cookie, cookie);
    setIntPreference(
        sharedPreferences, Prefs.lastLoginTime,
        new DateTime.now().millisecondsSinceEpoch);
  }

  User getUser() {
    Map userDict = json.decode(
        getPreference(sharedPreferences, Prefs.userInfo));
    return User(userDict);
  }

  void setLoginInfo(String loginInfo) {
    setStringPreference(sharedPreferences, Prefs.userInfo, loginInfo);
  }

  void logOut() {
    removePreference(sharedPreferences, Prefs.cookie);
    removePreference(sharedPreferences, Prefs.lastLoginTime);
    removePreference(sharedPreferences, Prefs.userInfo);
  }

  SharedPreferences sharedPreferences;
}