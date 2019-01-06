import 'package:app/api/user.pb.dart';
import 'package:app/util/backend_fetcher.dart';
import 'package:app/widgets/app_bar.dart';
import 'package:app/widgets/login_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class HomeWidget extends StatefulWidget {
  HomeWidget({Key key}) : super(key: key);

  @override
  _MainState createState() => new _MainState();
}

enum _ActiveFlow {
  HOME,
  LOGIN,
}

class _MainState extends State<HomeWidget> {
  _MainState();

  User _user;
  _ActiveFlow _activeFlow = _ActiveFlow.HOME;
  BackendFetcher _backendFetcher = new BackendFetcher();

  @override
  Widget build(BuildContext context) {
    switch (_activeFlow) {
      case _ActiveFlow.HOME:
        return _mainPageWidget();
      case _ActiveFlow.LOGIN:
        return new LoginWidget(
          onLoginComplete: _onLoginComplete,
        );
    }
    return null;
  }

  Widget _mainPageWidget() {
    return new Scaffold(
      appBar: buildAppBar(context, _defaultMenuItems(), "Cube Conductor"),
      body: new Center(
        child: new Text(
          'Welcome to Cube Conductor!!!',
        ),
      ),
    );
  }

  List<MenuItem> _defaultMenuItems() {
    var items = new List<MenuItem>();
    if (_user == null) {
      items.add(new MenuItem(
          text: "Log in",
          onClick: () {
            setState(() {
            _activeFlow = _ActiveFlow.LOGIN;
            });
          }));
    } else {
      items.add(new MenuItem(
          text: "Log out, " + _user.name,
          onClick: () {
            setState(() {
              _user = null;
            });
          }));
    }
    return items;
  }

  void _onLoginComplete(List<String> cookie) {
    _backendFetcher.setCookie(cookie);
    User user = new User();
    _backendFetcher.get("/api/v0/me", user).then((User user) {
      setState(() {
        _user = user;
        _activeFlow = _ActiveFlow.HOME;
      });
    });
  }
}
