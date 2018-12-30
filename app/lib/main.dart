import 'package:app/app_bar.dart';
import 'package:app/login_flow.dart';
import 'package:app/splash.dart';
import 'package:app/state/shared_state.dart';
import 'package:app/upcoming_competitions.dart';
import 'package:flutter/material.dart';

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
