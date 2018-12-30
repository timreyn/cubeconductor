import 'package:app/api/user.pb.dart';
import 'package:app/prefs.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginState {
  LoginState({this.sharedPreferences});

  bool isLoggedIn() {
    return getCookie() != null && getUser() != null;
  }

  List<String> getCookie() {
    return getStringListPreference(sharedPreferences, Prefs.cookie);
  }

  void setCookie(List<String> cookie) {
    setStringListPreference(sharedPreferences, Prefs.cookie, cookie);
    setIntPreference(sharedPreferences, Prefs.lastLoginTime,
        new DateTime.now().millisecondsSinceEpoch);
  }

  User getUser() {
    return getPreference(sharedPreferences, Prefs.user);
  }

  void setUser(User user) {
    setProtoPreference(sharedPreferences, Prefs.user, user);
  }

  void logOut() {
    FlutterWebviewPlugin webviewPlugin = new FlutterWebviewPlugin();
    webviewPlugin.cleanCookies();
    removePreference(sharedPreferences, Prefs.cookie);
    removePreference(sharedPreferences, Prefs.lastLoginTime);
    removePreference(sharedPreferences, Prefs.user);
  }

  SharedPreferences sharedPreferences;
}
