import 'dart:convert';

import 'package:app/proto/user.pb.dart';
import 'package:protobuf/protobuf.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Pref<T> {
  Pref({this.key, this.defaultValue});

  final String key;
  final T defaultValue;
}

class Prefs {
  static final Pref<String> serverUrl = new Pref<String>(
      key: "PREF_SERVER_URL", defaultValue: "cube-conductor.appspot.com");
  static final Pref<List<String>> cookie = new Pref<List<String>>(
    key: "PREF_COOKIE",
  );
  static final Pref<User> user = new Pref<User>(
    key: "PREF_USER_INFO",
  );

  Prefs(this._sharedPreferences);

  SharedPreferences _sharedPreferences;

  T getPreference<T>(Pref<T> pref) {
    T prefValue = _sharedPreferences.get(pref.key);
    if (prefValue == null) {
      return pref.defaultValue;
    } else {
      return prefValue;
    }
  }

  List<String> getStringListPreference(Pref<List<String>> pref) {
    List<String> prefValue = _sharedPreferences.getStringList(pref.key);
    if (prefValue == null) {
      return pref.defaultValue;
    } else {
      return prefValue;
    }
  }

  void setStringPreference(Pref<String> pref, String value) {
    _sharedPreferences.setString(pref.key, value);
  }

  void setIntPreference(Pref<int> pref, int value) {
    _sharedPreferences.setInt(pref.key, value);
  }

  void setStringListPreference(Pref<List<String>> pref, List<String> value) {
    _sharedPreferences.setStringList(pref.key, value);
  }

  void setProtoPreference<T extends GeneratedMessage>(Pref<T> pref, T value) {
    _sharedPreferences.setString(
        pref.key, new Base64Encoder.urlSafe().convert(value.writeToBuffer()));
  }

  T getProtoPreference<T extends GeneratedMessage>(Pref<T> pref, T value) {
    String raw = _sharedPreferences.getString(pref.key);
    if (raw == null) {
      return null;
    } else {
      value.mergeFromBuffer(new Base64Decoder().convert(raw));
      return value;
    }
  }

  void removePreference<T>(Pref<T> pref) {
    _sharedPreferences.remove(pref.key);
  }
}