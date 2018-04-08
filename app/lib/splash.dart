import 'package:flutter/material.dart';
import 'shared_state.dart';

class SplashWidget extends StatelessWidget {
  SplashWidget(this.sharedState, {Key key}) : super(key: key);

  final SharedState sharedState;

  @override
  Widget build(BuildContext context) {
    sharedState.awaitReady().then((_) =>
      Navigator.pushReplacementNamed(context, "/home"));
    return new Scaffold(
      body: new Center(
        child: new Text(
          'Loading...',
        ),
      ),
    );
  }
}