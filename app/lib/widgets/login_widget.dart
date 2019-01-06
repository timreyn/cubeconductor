import 'package:app/widgets/app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';

class LoginWidget extends StatelessWidget {
  LoginWidget({Key key, @required this.onLoginComplete}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String host = "cube-conductor.appspot.com";
    String url = new Uri(
      scheme: 'https',
      host: host,
      path: '/login',
      queryParameters: {
        'target': '/login_flow_complete',
      },
    ).toString();

    WebviewScaffold webview = new WebviewScaffold(
      url: url,
      appBar: buildAppBar(context, new List<MenuItem>(), "Log In"),
    );
    FlutterWebviewPlugin webviewPlugin = new FlutterWebviewPlugin();
    webviewPlugin.onUrlChanged.listen((String url) async {
      print(url);
      Uri uri = Uri.parse(url);
      if (uri.path != '/login_flow_complete') {
        return;
      }

      String cookie = await webviewPlugin.evalJavascript("document.cookie");

      cookie = cookie
          .replaceAll("\\\"", "")
          .replaceAll("\"", "")
          .replaceAll("\\\\", "\\");

      onLoginComplete(cookie.split(";"));
      webviewPlugin.cleanCookies();
    });

    return webview;
  }

  final ValueChanged<List<String>> onLoginComplete;
}
