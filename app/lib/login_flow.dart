import 'package:flutter/material.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:semaphore/semaphore.dart';

import 'app_bar.dart';
import 'backend_fetcher.dart';
import 'login_state.dart';
import 'prefs.dart';
import 'shared_state.dart';

class LoginFlowWidget extends StatefulWidget {
  LoginFlowWidget(this.sharedState, {Key key}) : super(key: key);

  final SharedState sharedState;

  @override
  State createState() => new LoginFlowState(sharedState);
}

class LoginFlowState extends State<LoginFlowWidget> {
  LoginFlowState(this.sharedState);

  SharedState sharedState;

  @override
  Widget build(BuildContext context) {
    String host = getPreference(sharedState.sharedPreferences, Prefs.serverUrl);
    String url = new Uri(
      scheme: 'https',
      host: host,
      path: '/login',
      queryParameters: {
        'target': '/login_flow_complete',
      },
    ).toString();

    // Only allow one update to the login state.
    var semaphore = new LocalSemaphore(1);
    bool hasCompletedLoginFlow = false;

    WebviewScaffold webview = new WebviewScaffold(
      url: url,
      appBar: conductorAppBar(context, sharedState),
    );
    FlutterWebviewPlugin webviewPlugin = new FlutterWebviewPlugin();
    webviewPlugin.onUrlChanged.listen((String url) async {
      Uri uri = Uri.parse(url);
      if (uri.path != '/login_flow_complete') {
        return;
      }

      // This code can only be passed once per call to build().  We get multiple
      // onUrlChanged events, but we don't want all of them to cause us to
      // update the login state.
      try {
        await semaphore.acquire();
        if (hasCompletedLoginFlow) {
          return;
        }
        hasCompletedLoginFlow = true;
      } finally {
        semaphore.release();
      }

      LoginState loginState = sharedState.loginState;
      if (loginState.isLoggedIn()) {
        return;
      }

      String cookie = await webviewPlugin.evalJavascript("document.cookie");

      cookie = cookie
          .replaceAll("\\\"", "")
          .replaceAll("\"", "")
          .replaceAll("\\\\", "\\");
      loginState.setCookie(cookie.split(";"));

      BackendFetcher fetcher =
      new BackendFetcher(sharedState);
      loginState.setLoginInfo(await fetcher.get("/api/v0/me"));

      //webviewPlugin.dispose();
      Navigator.pop(context, 1);
    });

    return webview;
  }
}