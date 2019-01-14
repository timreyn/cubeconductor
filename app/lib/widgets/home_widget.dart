import 'dart:io';

import 'package:app/api/shared_api.dart';
import 'package:app/proto/user.pb.dart';
import 'package:app/util/backend_fetcher.dart';
import 'package:app/util/prefs.dart';
import 'package:app/widgets/app_bar.dart';
import 'package:app/widgets/loading_widget.dart';
import 'package:app/widgets/logged_in_widget.dart';
import 'package:app/widgets/login_widget.dart';
import 'package:app/widgets/settings_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeWidget extends StatefulWidget {
  HomeWidget({Key key}) : super(key: key);

  @override
  _MainState createState() => new _MainState();
}

enum _ActiveFlow {
  HOME,
  LOGIN,
  SETTINGS,
}

class _MainState extends State<HomeWidget> implements SharedApi {
  _MainState();

  User _user;
  _ActiveFlow _activeFlow = _ActiveFlow.HOME;
  BackendFetcher _backendFetcher;
  Prefs _prefs;
  Function() _onBack;

  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    _onBack = null;

    String title = "Cube Conductor";
    List<MenuItem> menuItems = _defaultMenuItems();

    if (_prefs == null) {
      SharedPreferences.getInstance().then((SharedPreferences prefs) {
        setState(() {
          _prefs = new Prefs(prefs);
          _backendFetcher = new BackendFetcher(_prefs);
          _user = _prefs.getProtoPreference(Prefs.user, new User());
        });
      });
      return _makeScaffold(loadingWidget(context), menuItems, title);
    }

    Widget widget;

    switch (_activeFlow) {
      case _ActiveFlow.HOME:
        if (_user == null) {
          widget = _makeScaffold(_mainPageWidget(), menuItems, title);
        } else {
          LoggedInWidget loggedInWidget = new LoggedInWidget(this, _user);
          widget = _makeScaffold(loggedInWidget, menuItems, title);
        }
        break;
      case _ActiveFlow.LOGIN:
        widget = new LoginWidget(this);
        break;
      case _ActiveFlow.SETTINGS:
        SettingsWidget settingsWidget = new SettingsWidget(this);
        title = settingsWidget.title();
        widget = _makeScaffold(settingsWidget, menuItems, title);
        break;
    }

    return new WillPopScope(
      child: widget,
      onWillPop: () {
        if (_onBack != null) {
          _onBack();
        } else if (_activeFlow == _ActiveFlow.HOME) {
          exit(0);
        } else {
          setState(() {
            _activeFlow = _ActiveFlow.HOME;
          });
        }
      },
    );
  }

  Widget _mainPageWidget() {
    return new Center(
      child: new Text(
        'Welcome to Cube Conductor!!!',
      ),
    );
  }

  Widget _makeScaffold(Widget body, List<MenuItem> menuItems, String title) {
    return new Scaffold(
      key: _scaffoldKey,
      appBar: buildAppBar(context, menuItems, title),
      body: Builder(
        builder: (context) => body,
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
      items.add(new MenuItem(text: "Log out, " + _user.name, onClick: () => logOut(context)));
    }
    items.add(new MenuItem(
        text: "Settings",
        onClick: () {
          setState(() {
            _activeFlow = _ActiveFlow.SETTINGS;
          });
        }));
    return items;
  }

  // SharedApi implementation.
  @override
  BackendFetcher backendFetcher() {
    return _backendFetcher;
  }

  @override
  Prefs prefs() {
    return _prefs;
  }

  @override
  void onBack(Function() onBack) {
    this._onBack = onBack;
  }


  @override
  void onLoginComplete(List<String> cookie) {
    // TODO: make this show a SnackBar.
    // _showSnackBar(new Text("Logged in!"));
    _backendFetcher.setCookie(cookie);
    User user = new User();
    _backendFetcher.get("/api/v0/me", user).then((User user) {
      setState(() {
        _user = user;
        _activeFlow = _ActiveFlow.HOME;
        _prefs.setProtoPreference(Prefs.user, user);
      });
    });
  }

  @override
  void logOut(BuildContext context) {
    showSnackBar(new Text("Logged out!"));
    setState(() {
      _user = null;
      _prefs.removePreference(Prefs.user);
      _prefs.removePreference(Prefs.cookie);
      _activeFlow = _ActiveFlow.HOME;
    });
  }

  @override
  void showSnackBar(Widget content) {
    if (_scaffoldKey.currentState != null) {
      _scaffoldKey.currentState.showSnackBar(new SnackBar(content: content));
    }
  }
}
