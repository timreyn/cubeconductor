import 'package:app/state/shared_state.dart';
import 'package:flutter/material.dart';

import 'app_bar.dart';
import 'login_flow.dart';
import 'splash.dart';
import 'upcoming_competitions.dart';

void main() => runApp(new CubeConductorApp());

class CubeConductorApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SharedState sharedState = new SharedState();

    return new MaterialApp(
      title: 'Cube Conductor',
      theme: new ThemeData(
        primarySwatch: Colors.blue,
      ),
      routes: {
        "/": (_) => new SplashWidget(sharedState),
        "/home": (_) => new HomeWidget(sharedState),
        "/login": (_) => new LoginFlowWidget(sharedState),
        "/upcoming": (_) => new UpcomingCompetitionsWidget(sharedState),
      },
    );
  }
}

class HomeWidget extends StatefulWidget {
  HomeWidget(this._sharedState, {Key key}) : super(key: key);

  final SharedState _sharedState;

  @override
  _HomeState createState() => new _HomeState(_sharedState);
}

class _HomeState extends State<HomeWidget> {
  _HomeState(this._sharedState);

  final SharedState _sharedState;

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: conductorAppBar(context, _sharedState, "Cube Conductor"),
      body: new Center(
        child: new Text(
          'Welcome to Cube Conductor!!!',
        ),
      ),
    );
  }
}
