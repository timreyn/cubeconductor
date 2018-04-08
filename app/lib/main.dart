import 'package:flutter/material.dart';
import 'app_bar.dart';
import 'login_flow.dart';
import 'shared_state.dart';
import 'splash.dart';

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
      appBar: conductorAppBar(context, _sharedState),
      body: new Center(
        child: new Text(
          'Welcome to Cube Conductor!!!',
        ),
      ),
    );
  }
}
