import 'package:app/api/user.pb.dart';
import 'package:flutter/material.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:semaphore/semaphore.dart';

import 'app_bar.dart';
import 'backend_fetcher.dart';
import 'prefs.dart';
import 'state/login_state.dart';
import 'state/shared_state.dart';

class LoginFlowWidget extends StatefulWidget {
  LoginFlowWidget(this.sharedState, {Key key}) : super(key: key);

  final SharedState sharedState;

  @override
  State createState() => new LoginFlowState(sharedState);
}

class LoginFlowState extends State<LoginFlowWidget> {
  LoginFlowState(this.sharedState) {
    this._hasCompletedLoginFlow = false;
    _semaphore = new LocalSemaphore(1);
  }

  SharedState sharedState;

  bool _hasCompletedLoginFlow;
  LocalSemaphore _semaphore;

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

    WebviewScaffold webview = new WebviewScaffold(
      url: url,
      appBar: conductorAppBar(context, sharedState, "Login"),
    );
    FlutterWebviewPlugin webviewPlugin = new FlutterWebviewPlugin();
    webviewPlugin.onUrlChanged.listen((String url) async {
      Uri uri = Uri.parse(url);
      if (uri.path != '/login_flow_complete') {
        return;
      }

      // This code can only be passed once.  We get multiple onUrlChanged
      // events, but we don't want all of them to cause us to update the login
      // state.
      try {
        await _semaphore.acquire();
        if (_hasCompletedLoginFlow) {
          return;
        }
        _hasCompletedLoginFlow = true;
      } finally {
        _semaphore.release();
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

      BackendFetcher fetcher = new BackendFetcher(sharedState);
      loginState.setUser(await fetcher.get("/api/v0/me", new User()));
      sharedState.competitionState.updateMyCompetitionsData().then((_) {
        Navigator.pushReplacementNamed(context, "/upcoming");
      });
    });

    return webview;
  }
}
