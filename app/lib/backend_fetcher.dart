import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:shared_preferences/shared_preferences.dart';

import 'prefs.dart';
import 'shared_state.dart';

class BackendFetcher {
  BackendFetcher({this.sharedState});

  Future<String> get(String path, [Map<String, String> queryParameters]) async {
    SharedPreferences sharedPreferences = sharedState.sharedPreferences;

    HttpClient httpClient = new HttpClient();
    Uri uri = new Uri.https(
      getPreference(sharedPreferences, Prefs.serverUrl),
      path, queryParameters);
    HttpClientRequest request = await httpClient.getUrl(uri);
    try {
      getPreference(sharedPreferences, Prefs.cookie).forEach((String segment) {
        var segmentSplit = segment.split("=");
        request.cookies.add(
            Cookie(segmentSplit[0], segmentSplit[1].replaceAll("\\075", "=")));
      });
    } catch (e) {
      print(e.toString());
    }
    HttpClientResponse response = await request.close();
    return response.transform(utf8.decoder).join();
  }

  final SharedState sharedState;
}