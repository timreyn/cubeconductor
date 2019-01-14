import 'dart:convert';

import 'package:app/api/user.pb.dart';
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
}

T getPreference<T>(SharedPreferences sharedPreferences, Pref<T> pref) {
  T prefValue = sharedPreferences.get(pref.key);
  if (prefValue == null) {
    return pref.defaultValue;
  } else {
    return prefValue;
  }
}

List<String> getStringListPreference(
    SharedPreferences sharedPreferences, Pref<List<String>> pref) {
  List<String> prefValue = sharedPreferences.getStringList(pref.key);
  if (prefValue == null) {
    return pref.defaultValue;
  } else {
    return prefValue;
  }
}

void setStringPreference(
    SharedPreferences sharedPreferences, Pref<String> pref, String value) {
  sharedPreferences.setString(pref.key, value);
}

void setIntPreference(
    SharedPreferences sharedPreferences, Pref<int> pref, int value) {
  sharedPreferences.setInt(pref.key, value);
}

void setStringListPreference(SharedPreferences sharedPreferences,
    Pref<List<String>> pref, List<String> value) {
  sharedPreferences.setStringList(pref.key, value);
}

void setProtoPreference<T extends GeneratedMessage>(
    SharedPreferences sharedPreferences, Pref<T> pref, T value) {
  sharedPreferences.setString(
      pref.key, new Base64Encoder.urlSafe().convert(value.writeToBuffer()));
}

T getProtoPreference<T extends GeneratedMessage>(
    SharedPreferences sharedPreferences, Pref<T> pref, T value) {
  String raw = sharedPreferences.getString(pref.key);
  if (raw == null) {
    return null;
  } else {
    value.mergeFromBuffer(new Base64Decoder().convert(raw));
    return value;
  }
}

void removePreference<T>(SharedPreferences sharedPreferences, Pref<T> pref) {
  sharedPreferences.remove(pref.key);
}
