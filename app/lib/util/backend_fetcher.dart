import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:app/util/prefs.dart';
import 'package:protobuf/protobuf.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BackendFetcher {
  BackendFetcher(this._sharedPreferences);

  void setCookie(List<String> cookie) {
    setStringListPreference(_sharedPreferences, Prefs.cookie, cookie);
  }

  Future<T> get<T extends GeneratedMessage>(String path, T message,
      [Map<String, String> queryParameters]) async {
    HttpClient httpClient = new HttpClient();
    Uri uri = new Uri.https(getPreference(_sharedPreferences, Prefs.serverUrl),
        path, queryParameters);
    HttpClientRequest request = await httpClient.getUrl(uri);
    try {
      getStringListPreference(_sharedPreferences, Prefs.cookie)
          .forEach((String segment) {
        var segmentSplit = segment.split("=");
        request.cookies.add(
            Cookie(segmentSplit[0], segmentSplit[1].replaceAll("\\075", "=")));
      });
    } catch (e) {
      print(e.toString());
    }
    var response = await request.close();
    var responseBody = response.transform(utf8.decoder).join();

    message.mergeFromBuffer(new Base64Decoder().convert(await responseBody));
    return message;
  }

  SharedPreferences _sharedPreferences;
}
