import 'package:flutter/material.dart';

import 'login_state.dart';
import 'models/user.dart';
import 'shared_state.dart';

class _MenuOption {
  _MenuOption({this.text, this.onClick});

  String text;
  Function onClick;
}

List<_MenuOption> _menuOptions(SharedState sharedState) {
  List<_MenuOption> options = new List();

  LoginState loginState = sharedState.loginState;
  if (loginState.isLoggedIn()) {
    User user = loginState.getUser();
    options.add(new _MenuOption(
      text: "Hi, " + user.name,
      onClick: (BuildContext context) {},
    ));
    options.add(new _MenuOption(
        text: "Log out, " + user.name,
        onClick: (BuildContext context) {
          loginState.logOut();
          Navigator.pushReplacementNamed(context, "/");
        }
    ));
  } else {
    options.add(new _MenuOption(
        text: "Log in",
        onClick: (BuildContext context) {
          Navigator.pushNamed(context, "/login");
        }
    ));
  }

  return options;
}

AppBar conductorAppBar(BuildContext context,
    SharedState sharedState) {
  return new AppBar(
    title: new Text('Cube Conductor'),
    actions: <Widget>[
      new PopupMenuButton<_MenuOption>(
          onSelected: (_MenuOption option) {
            option.onClick(context);
          },
          itemBuilder: (BuildContext context) {
            return _menuOptions(sharedState).map((_MenuOption option) {
              return new PopupMenuItem<_MenuOption>(
                value: option,
                child: new Text(option.text),
              );
            }
            ).toList();
          }
      ),
    ],
  );
}