import 'dart:io';

import 'package:app/api/user.pb.dart';
import 'package:app/util/backend_fetcher.dart';
import 'package:app/util/prefs.dart';
import 'package:app/widgets/app_bar.dart';
import 'package:app/widgets/back_handler.dart';
import 'package:app/widgets/loading_widget.dart';
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

class _MainState extends State<HomeWidget> {
  _MainState();

  User _user;
  _ActiveFlow _activeFlow = _ActiveFlow.HOME;
  BackendFetcher _backendFetcher;
  SharedPreferences _sharedPreferences;
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  BackHandler _backHandler;

  @override
  Widget build(BuildContext context) {
    if (_sharedPreferences == null) {
      SharedPreferences.getInstance().then((SharedPreferences prefs) {
        setState(() {
          _sharedPreferences = prefs;
          _backendFetcher = new BackendFetcher(_sharedPreferences);
          _user =
              getProtoPreference(_sharedPreferences, Prefs.user, new User());
        });
      });
      return loadingWidget(context);
    }

    Widget widget;
    String title = "Cube Conductor";
    List<MenuItem> menuItems = _defaultMenuItems();

    switch (_activeFlow) {
      case _ActiveFlow.HOME:
        widget = _makeScaffold(_mainPageWidget(), menuItems, title);
        _backHandler = null;
        break;
      case _ActiveFlow.LOGIN:
        widget = new LoginWidget(
          onLoginComplete: _onLoginComplete,
          sharedPreferences: _sharedPreferences,
        );
        _backHandler = null;
        break;
      case _ActiveFlow.SETTINGS:
        SettingsWidget settingsWidget = new SettingsWidget(
          defaultMenuItems: _defaultMenuItems(),
          sharedPreferences: _sharedPreferences,
          logOut: _logOut,
          showSnackBar: _showSnackBar,
        );
        _backHandler = null;
        title = settingsWidget.title();
        widget = _makeScaffold(settingsWidget, menuItems, title);
        break;
    }

    return new WillPopScope(
      child: widget,
      onWillPop: () {
        if (_backHandler.onBack()) {
          return;
        }
        if (_activeFlow == _ActiveFlow.HOME) {
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
      items.add(new MenuItem(text: "Log out, " + _user.name, onClick: () => _logOut(context)));
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

  void _onLoginComplete(List<String> cookie) {
    // TODO: make this show a SnackBar.
    // _showSnackBar(new Text("Logged in!"));
    _backendFetcher.setCookie(cookie);
    User user = new User();
    _backendFetcher.get("/api/v0/me", user).then((User user) {
      setState(() {
        _user = user;
        _activeFlow = _ActiveFlow.HOME;
        setProtoPreference(_sharedPreferences, Prefs.user, user);
      });
    });
  }

  void _logOut(BuildContext context) {
    _showSnackBar(new Text("Logged out!"));
    setState(() {
      _user = null;
      removePreference(_sharedPreferences, Prefs.user);
      removePreference(_sharedPreferences, Prefs.cookie);
      _activeFlow = _ActiveFlow.HOME;
    });
  }

  void _showSnackBar(Widget content) {
    if (_scaffoldKey.currentState != null) {
      _scaffoldKey.currentState.showSnackBar(new SnackBar(content: content));
    }
  }
}
