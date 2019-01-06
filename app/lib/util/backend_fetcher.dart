import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:protobuf/protobuf.dart';

class BackendFetcher {
  BackendFetcher();

  void setCookie(List<String> cookie) {
    this._cookie = cookie;
  }

  Future<T> get<T extends GeneratedMessage>(String path, T message,
      [Map<String, String> queryParameters]) async {
    HttpClient httpClient = new HttpClient();
    Uri uri = new Uri.https("cube-conductor.appspot.com", path, queryParameters);
    HttpClientRequest request = await httpClient.getUrl(uri);
    try {
      _cookie.forEach((String segment) {
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

  List<String> _cookie;
}
